Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3EIOmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:42:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab3EIOmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:42:39 -0400
Date: Thu, 09 May 2013 10:42:31 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, davidlohr.bueso@hp.com,
        riel@redhat.com, viro@zeniv.linux.org.uk
Message-ID: <1368110551-vhgsegi9-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <518B4B5F.9040900@huawei.com>
References: <20130509043532.GA28235@redhat.com>
 <518B4B5F.9040900@huawei.com>
Subject: Re: SHM oops in newseg()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <518B4B5F.9040900@huawei.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 03:08:15PM +0800, Li Zefan wrote:
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> 
> On 2013/5/9 12:35, Dave Jones wrote:
> > Just saw this on v3.9-11789-ge0fd9af while fuzz-testing.
> > 
> > [  163.917836] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> > [  163.918984] IP: [<ffffffff812c48ed>] newseg+0x10d/0x390
> 
> The patch below should fix it.
> 
> ===========================
> 
> [PATCH] shm: fix null pointer deref when userspace specifies invalid hugepage size
> 
> Dave reported an oops triggered by trinity:
> 
> [  163.917836] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [  163.918984] IP: [<ffffffff812c48ed>] newseg+0x10d/0x390
> [  163.919705] PGD cf8c1067 PUD cf8c2067 PMD 0
> [  163.920326] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  163.929949] CPU: 2 PID: 7636 Comm: trinity-child2 Not tainted 3.9.0+#67
> ...
> [  163.953629] Call Trace:
> [  163.957706]  [<ffffffff812be322>] ipcget+0x182/0x380
> [  163.962123]  [<ffffffff810b99a5>] ?trace_hardirqs_on_caller+0x115/0x1e0
> [  163.966752]  [<ffffffff812c559a>] SyS_shmget+0x5a/0x60
> [  163.971163]  [<ffffffff812c47e0>] ? shm_close+0x140/0x140
> [  163.975590]  [<ffffffff812c3e60>] ? shm_release+0x50/0x50
> [  163.979991]  [<ffffffff812c3df0>] ? shm_get_unmapped_area+0x20/0x20
> [  163.984499]  [<ffffffff816caa14>] tracesys+0xdd/0xe2
> 
> This bug was introduced by commit af73e4d9506d3b797509f3c030e7dcd554f7d9c4
> ("hugetlbfs: fix mmap failure in unaligned size request").
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Li Zefan <lizfan@huawei.com>

Thank you.
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
> 
> Previously it would return -ENODEV, but seems -EINVAL is more appropriate.

Agreed.

Thanks,
Naoya

> ---
>  ipc/shm.c | 8 +++++++-
>  mm/mmap.c | 8 ++++++--
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 34af1fe..7e199fa 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -493,7 +493,13 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>  	if (shmflg & SHM_HUGETLB) {
>  		struct hstate *hs = hstate_sizelog((shmflg >> SHM_HUGE_SHIFT)
>  						& SHM_HUGE_MASK);
> -		size_t hugesize = ALIGN(size, huge_page_size(hs));
> +		size_t hugesize;
> +
> +		if (!hs) {
> +			error = -EINVAL;
> +			goto no_file;
> +		}
> +		hugesize = ALIGN(size, huge_page_size(hs));
>  
>  		/* hugetlb_file_setup applies strict accounting */
>  		if (shmflg & SHM_NORESERVE)
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 1ae21d6..f681e18 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1367,9 +1367,13 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
>  			len = ALIGN(len, huge_page_size(hstate_file(file)));
>  	} else if (flags & MAP_HUGETLB) {
>  		struct user_struct *user = NULL;
> +		struct hstate *hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) &
> +						   SHM_HUGE_MASK);
>  
> -		len = ALIGN(len, huge_page_size(hstate_sizelog(
> -			(flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK)));
> +		if (!hs)
> +			return -EINVAL;
> +
> +		len = ALIGN(len, huge_page_size(hs));
>  		/*
>  		 * VM_NORESERVE is used because the reservations will be
>  		 * taken when vm_ops->mmap() is called
> -- 
> 1.8.0.2
> 
> 
>
