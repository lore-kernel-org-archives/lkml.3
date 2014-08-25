Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600AbaHYVvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:51:32 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34643 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933438AbaHYVva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:51:30 -0400
Date: Mon, 25 Aug 2014 14:49:45 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ipc/shm: fix the historical/wrong mm->start_stack
 check
In-Reply-To: <20140825191207.GA26106@redhat.com>
Message-ID: <alpine.LSU.2.11.1408251303220.25799@eggly.anvils>
References: <20140823144246.GA6281@redhat.com> <20140825191207.GA26106@redhat.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2014, Oleg Nesterov wrote:

> The ->start_stack check in do_shmat() looks ugly and simply wrong.
> 
> 1. ->start_stack is only valid right after exec(), the application
>    can switch to another stack and even unmap this area. Or a stack
>    can simply grow, ->start_stack won't even notice this.
> 
> 2. The reason for this check is not clear at all. The application
>    should know what it does. And why 4 pages? And why in fact it
>    requires 5 pages? Plus "start_stack - size - PAGE_SIZE * 5" can
>    underflow although this is minor.
> 
>    As Hugh pointed out, we actually need to require the additional
>    guard page, but this code was written before linux had it.
> 
> 3. This wrongly assumes that the stack can only grown down.
> 
> Personally I think we should simply kill this check, but I did not
> dare to do this. So the patch only fixes the 1st problem (mostly to
> avoid the usage of mm->start_stack) and ignores the VM_GROWSUP case.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Sorry, I cannot ack this, because your comment below "at least 4 pages
plus a guard page enforced by check_stack_guard_page()" makes no sense
to me as an explanation for the 5.  The guard page (gap) enforced by
check_stack_guard_page() is already at vma->vm_start (and I just
verified that, though wasted some time on it not behaving as I had
expected, until I found show_map_vma()'s start += PAGE_SIZE hides it).

But in the course of trying to understand what I saw in /proc/<pid>/maps,
I did come across 2.6.34's 128k stack_expand inherited from 2.6.11's
20 page EXTRA_STACK_VM_PAGES.  With Linus's guard page enforcing a
page gap since 2.6.36.

This shmat() 4 or 5 page gap dates from long before all of those
were added.  That, together with your preference, and our difficulty
in communicating a sensible way of updating and describing the test,
now drives me to agree with you.  Please just rip out the start_stack
test and the comment defending it.

Hugh

> ---
>  ipc/shm.c |   26 ++++++++++++++++----------
>  1 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 7fc9f9f..9a322f5 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -1166,19 +1166,25 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
>  
>  	down_write(&current->mm->mmap_sem);
>  	if (addr && !(shmflg & SHM_REMAP)) {
> -		err = -EINVAL;
> -		if (addr + size < addr)
> -			goto invalid;
> +		struct vm_area_struct *vma;
>  
> -		if (find_vma_intersection(current->mm, addr, addr + size))
> -			goto invalid;
> +		err = -EINVAL;
>  		/*
> -		 * If shm segment goes below stack, make sure there is some
> -		 * space left for the stack to grow (at least 4 pages).
> +		 * Ensure this segment doesn't overlap with the next vma.
> +		 * If it is stack, make sure there is some space left for
> +		 * the stack to grow, at least 4 pages plus a guard page
> +		 * enforced by check_stack_guard_page(). (Why?)
>  		 */
> -		if (addr < current->mm->start_stack &&
> -		    addr > current->mm->start_stack - size - PAGE_SIZE * 5)
> -			goto invalid;
> +		vma = find_vma(current->mm, addr);
> +		if (vma) {
> +			unsigned long end = addr + size;
> +
> +			if (vma->vm_flags & VM_GROWSDOWN)
> +				end += PAGE_SIZE * 5;
> +
> +			if (end < addr || end > vma->vm_start)
> +				goto invalid;
> +		}
>  	}
>  
>  	addr = do_mmap_pgoff(file, addr, size, prot, flags, 0, &populate);
> -- 
> 1.5.5.1
