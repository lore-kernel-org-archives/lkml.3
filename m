Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaENDZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:25:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18808 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaENDZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:25:37 -0400
Message-ID: <5372E20A.1020707@oracle.com>
Date: Tue, 13 May 2014 23:24:58 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: mm: shmem: NULL ptr deref in shmem_fault
References: <5370DA09.7020801@oracle.com> <20140512141238.3a0673b3f1a2ee5d47498719@linux-foundation.org> <53713A01.3050502@oracle.com> <alpine.LSU.2.11.1405131442260.22181@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1405131442260.22181@eggly.anvils>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 06:20 PM, Hugh Dickins wrote:
> I haven't delved into the perf_even_mmap d_path (fs/dcache.c:2947) one,
> but the Sys_mremap one on file->f_op->f_unmapped_area sounds like what
> we have here: struct file has been freed.
> 
> I believe Al is innocent: I point a quivering finger at... Kirill.
> 
> Just guessing, but we know how fond trinity is of remap_file_pages(),
> and comparing old and new emulations shows that interesting
> 
> 	struct file *file = get_file(vma->vm_file);
>         addr = mmap_region(...);
> 	fput(file);
> 
> in mm/fremap.c's old emulation, but no get_file() and fput() around 
> the do_mmap_pgoff() in mm/mmap.c's new emulation.
> 
> Before it puts in the new, do_mmap_pgoff() might unmap the last reference
> to vma->vm_file, so emulation needs to take its own reference.  I'm not
> sure how that plays out nowadays with Al's deferred fput, but it does
> look suspicious to me.

I've tested it by reverting the remap_file_pages() patch, and the problem
seems to have disappeared.

Then, I've added it back again, wrapping the do_mmap_pgoff() call with
get_file() and fput(), and the problem is still gone.

Seems like that was the issue all along. I'll send a patch...


Thanks,
Sasha
