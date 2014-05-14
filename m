Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaENUly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:41:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30476 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaENUlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:41:53 -0400
Message-ID: <5373D509.7090207@oracle.com>
Date: Wed, 14 May 2014 16:41:45 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: NULL ptr deref handling mmaping of special mappings
References: <53739201.6080604@oracle.com> <20140514132312.573e5d3cf99276c3f0b82980@linux-foundation.org>
In-Reply-To: <20140514132312.573e5d3cf99276c3f0b82980@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 04:23 PM, Andrew Morton wrote:
> On Wed, 14 May 2014 11:55:45 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> Hi all,
>>
>> While fuzzing with trinity inside a KVM tools guest running the latest -next
>> kernel I've stumbled on the following spew:
>>
>> [ 1634.969408] BUG: unable to handle kernel NULL pointer dereference at           (null)
>> [ 1634.970538] IP: special_mapping_fault (mm/mmap.c:2961)
>> [ 1634.971420] PGD 3334fc067 PUD 3334cf067 PMD 0
>> [ 1634.972081] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> [ 1634.972913] Dumping ftrace buffer:
>> [ 1634.975493]    (ftrace buffer empty)
>> [ 1634.977470] Modules linked in:
>> [ 1634.977513] CPU: 6 PID: 29578 Comm: trinity-c269 Not tainted 3.15.0-rc5-next-20140513-sasha-00020-gebce144-dirty #461
>> [ 1634.977513] task: ffff880333158000 ti: ffff88033351e000 task.ti: ffff88033351e000
>> [ 1634.977513] RIP: special_mapping_fault (mm/mmap.c:2961)
> 
> Somebody's gone and broken the x86 oops output.  It used to say
> "special_mapping_fault+0x30/0x120" but the offset info has now
> disappeared.  That was useful for guesstimating whereabouts in the
> function it died.

I'm the one who "broke" the oops output, but I thought I'm helping people
read that output instead of making it harder...

What happened before is that due to my rather complex .config, the offsets
didn't make sense to anyone who didn't build the kernel with my .config,
so I had to repeatedly send it out to folks who attempted to get basic
things like line numbers.

> The line number isn't very useful as it's not possible (or at least,
> not convenient) for others to reliably reproduce your kernel.

I don't understand that part. I'm usually stating in the beginning of my
mails that I run my testing on the latest -next kernel. And indeed if
you look at today's -next, that line number would point to:

        for (pages = vma->vm_private_data; pgoff && *pages; ++pages) <=== HERE
                pgoff--;

So I'm not sure how replacing the offset with line numbers is making things
worse? previously offsets were useless for people who tried to debug these
spews so that's why I switched it to line numbers in the first place.

> <scrabbles with git for a while>
> 
> : static int special_mapping_fault(struct vm_area_struct *vma,
> : 				struct vm_fault *vmf)
> : {
> : 	pgoff_t pgoff;
> : 	struct page **pages;
> : 
> : 	/*
> : 	 * special mappings have no vm_file, and in that case, the mm
> : 	 * uses vm_pgoff internally. So we have to subtract it from here.
> : 	 * We are allowed to do this because we are the mm; do not copy
> : 	 * this code into drivers!
> : 	 */
> : 	pgoff = vmf->pgoff - vma->vm_pgoff;
> : 
> : 	for (pages = vma->vm_private_data; pgoff && *pages; ++pages)
> : 		pgoff--;
> : 
> : 	if (*pages) {
> : 		struct page *page = *pages;
> : 		get_page(page);
> : 		vmf->page = page;
> : 		return 0;
> : 	}
> : 
> : 	return VM_FAULT_SIGBUS;
> : }
> 
> OK so it might be the "if (*pages)".  So vma->vm_private_data was NULL
> and pgoff was zero.  As usual, I can't imagine what race would cause
> that :(

Yup, it's the *pages part in the 'for' loop above that. I did find the
following in the vdso code:

        vma = _install_special_mapping(mm,
                                       addr + image->size,
                                       image->sym_end_mapping - image->size,
                                       VM_READ,
                                       NULL);

Which installs a mapping with a NULL ptr for pages (if I understand that
correctly), but that code has been there for a while now.


Thanks,
Sasha
been there
