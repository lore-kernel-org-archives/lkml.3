Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaENUXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:23:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaENUXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:23:14 -0400
Date: Wed, 14 May 2014 13:23:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: NULL ptr deref handling mmaping of special mappings
Message-Id: <20140514132312.573e5d3cf99276c3f0b82980@linux-foundation.org>
In-Reply-To: <53739201.6080604@oracle.com>
References: <53739201.6080604@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014 11:55:45 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following spew:
> 
> [ 1634.969408] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [ 1634.970538] IP: special_mapping_fault (mm/mmap.c:2961)
> [ 1634.971420] PGD 3334fc067 PUD 3334cf067 PMD 0
> [ 1634.972081] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 1634.972913] Dumping ftrace buffer:
> [ 1634.975493]    (ftrace buffer empty)
> [ 1634.977470] Modules linked in:
> [ 1634.977513] CPU: 6 PID: 29578 Comm: trinity-c269 Not tainted 3.15.0-rc5-next-20140513-sasha-00020-gebce144-dirty #461
> [ 1634.977513] task: ffff880333158000 ti: ffff88033351e000 task.ti: ffff88033351e000
> [ 1634.977513] RIP: special_mapping_fault (mm/mmap.c:2961)

Somebody's gone and broken the x86 oops output.  It used to say
"special_mapping_fault+0x30/0x120" but the offset info has now
disappeared.  That was useful for guesstimating whereabouts in the
function it died.

The line number isn't very useful as it's not possible (or at least,
not convenient) for others to reliably reproduce your kernel.

<scrabbles with git for a while>

: static int special_mapping_fault(struct vm_area_struct *vma,
: 				struct vm_fault *vmf)
: {
: 	pgoff_t pgoff;
: 	struct page **pages;
: 
: 	/*
: 	 * special mappings have no vm_file, and in that case, the mm
: 	 * uses vm_pgoff internally. So we have to subtract it from here.
: 	 * We are allowed to do this because we are the mm; do not copy
: 	 * this code into drivers!
: 	 */
: 	pgoff = vmf->pgoff - vma->vm_pgoff;
: 
: 	for (pages = vma->vm_private_data; pgoff && *pages; ++pages)
: 		pgoff--;
: 
: 	if (*pages) {
: 		struct page *page = *pages;
: 		get_page(page);
: 		vmf->page = page;
: 		return 0;
: 	}
: 
: 	return VM_FAULT_SIGBUS;
: }

OK so it might be the "if (*pages)".  So vma->vm_private_data was NULL
and pgoff was zero.  As usual, I can't imagine what race would cause
that :(

