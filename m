Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaHZUaC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 16:30:02 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43904 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaHZUaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 16:30:00 -0400
Date: Tue, 26 Aug 2014 13:28:15 -0700 (PDT)
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
Subject: Re: [PATCH v3] ipc/shm: kill the historical/wrong mm->start_stack
 check
In-Reply-To: <20140826193145.GA26576@redhat.com>
Message-ID: <alpine.LSU.2.11.1408261316560.19965@eggly.anvils>
References: <20140823144246.GA6281@redhat.com> <20140826193145.GA26576@redhat.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Oleg Nesterov wrote:

> do_shmat() is the only user of ->start_stack (proc just reports its
> value), and this check looks ugly and wrong.
> 
> The reason for this check is not clear at all, and it wrongly assumes
> that the stack can only grow down.
> 
> But the main problem is that in general mm->start_stack has nothing
> to do with stack_vma->vm_start. Not only the application can switch
> to another stack and even unmap this area, setup_arg_pages() expands
> the stack without updating mm->start_stack during exec(). This means
> that in the likely case "addr > start_stack - size - PAGE_SIZE * 5"
> is simply impossible after find_vma_intersection() == F, or the stack
> can't grow anyway because of RLIMIT_STACK.
> 
> Many thanks to Hugh for his explanations.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Hugh Dickins <hughd@google.com>

But you're much too generous to me: I never even noticed how exec's
expand_stack() comes *after* setting start_stack, so that the shmat()
check is nowadays utterly irrelevant.  Thank you for persisting and
observing that and finally nailing down this coffin!

> ---
>  ipc/shm.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 7fc9f9f..0145479 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -1172,13 +1172,6 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
>  
>  		if (find_vma_intersection(current->mm, addr, addr + size))
>  			goto invalid;
> -		/*
> -		 * If shm segment goes below stack, make sure there is some
> -		 * space left for the stack to grow (at least 4 pages).
> -		 */
> -		if (addr < current->mm->start_stack &&
> -		    addr > current->mm->start_stack - size - PAGE_SIZE * 5)
> -			goto invalid;
>  	}
>  
>  	addr = do_mmap_pgoff(file, addr, size, prot, flags, 0, &populate);
> -- 
> 1.5.5.1
