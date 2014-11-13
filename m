Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbaKML0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:26:42 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:57439 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbaKML0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:26:39 -0500
Date: Thu, 13 Nov 2014 11:26:34 +0000
From: Will Deacon <will.deacon@arm.com>
To: Chanho Min <chanho.min@lge.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jon Medhurst <tixy@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gunho Lee <gunho.lee@lge.com>, HyoJun Im <hyojun.im@lge.com>,
        Jongsung Kim <neidhard.kim@lge.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        mtk.manpages@gmail.com
Subject: Re: [PATCH] ARM: cacheflush: disallow pending signals during
 cacheflush
Message-ID: <20141113112633.GE13350@arm.com>
References: <1415863793-6219-1-git-send-email-chanho.min@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415863793-6219-1-git-send-email-chanho.min@lge.com>
Thread-Topic: [PATCH] ARM: cacheflush: disallow pending signals during
 cacheflush
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[adding linux-api, linux-man]

On Thu, Nov 13, 2014 at 07:29:53AM +0000, Chanho Min wrote:
> Since commit 28256d612726 ("ARM: cacheflush: split user cache-flushing
> into interruptible chunks"), cacheflush can be interrupted by signal.
> 
> But, cacheflush doesn't resume from where we left off if process has
> user-defined signal handlers. It returns -EINTR then cacheflush
> should be re-invoked from the start of address until cache-flushing
> of whole address ranges is completed (restart_syscall isn't available
> in userspace). It may cause regression. So I suggest to disallow
> pending signals during cacheflush.
> 
> This partially reverts commit 28256d612726a28a8b9d3c49f2b74198c4423d6a.

Whilst I don't think this is the correct solution, I agree that there's
a potential issue here. We could change the restart return value to
-ERESTARTNOINTR instead, but I can imagine something like a periodic
SIGALRM which could prevent a large cacheflush from ever completing.
Do we actually care about making forward progress in such a scenario?

It is interesting to note that this change has been in mainline since
May last year without any reported issues. That could be down to a number
of reasons:

  (1) People are using old kernels on ARM

  (2) Code doesn't check the return value from the cacheflush system call,
      because it historically always returned 0

  (3) People are getting lucky with timing, as this is likely difficult
      to hit

Related to (2) is that a `man cacheflush' invocation returns something
about the MIPs system call, that doesn't match what we do for ARM. The
(relatively recent) history of the system call on ARM is:

  < v3.5 [*]

    - Always returns 0
    - Restricts virtual address range to a single VMA
    - Page-aligns the region limits (over flushing for smaller ranges)
    - Terminates on the first fault
    - Flags are ignored but must "ALWAYS be passed as ZERO"

  v3.5 - v3.12
    - Returns -EINVAL if flags is set or if end < start
    - Returns -EINVAL if we couldn't find a vma
    - Terminates on the first fault and returns -EFAULT

  v3.12 - HEAD

    - No longer page-aligns region
    - Removes VMA checking as this had a deadlock bug with mmap_sem
      and we could handle faults by this point anyway
    - Returns -EINVAL if !access_ok for the range
    - Splits the range into PAGE_SIZE chunks, checking for reschedule
      and pending signals to avoid DoSing the system (the hardware can
      only clean by cacheline). This is where the -ERESTART_RESTARTBLOCK
      behaviour came in, potentially returning -EINTR to userspace.

This leaves me with the following questions:

  - Has this change been shown to break anything in practice?
  - Can we change the internal return value to -ERESTARTNOINTR?
  - What do we do about kernels that *do* return -EINTR? (>=3.12?)
  - Can we get a manpage put together to describe this mess?

Cheers,

Will

[*] rmk may have some more ancient history kicking around, if you like!

> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index abd2fc0..275e086 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -521,25 +521,6 @@ __do_cache_op(unsigned long start, unsigned long end)
>  	do {
>  		unsigned long chunk = min(PAGE_SIZE, end - start);
>  
> -		if (signal_pending(current)) {
> -			struct thread_info *ti = current_thread_info();
> -
> -			ti->restart_block = (struct restart_block) {
> -				.fn	= do_cache_op_restart,
> -			};
> -
> -			ti->arm_restart_block = (struct arm_restart_block) {
> -				{
> -					.cache = {
> -						.start	= start,
> -						.end	= end,
> -					},
> -				},
> -			};
> -
> -			return -ERESTART_RESTARTBLOCK;
> -		}
> -
>  		ret = flush_cache_user_range(start, start + chunk);
>  		if (ret)
>  			return ret;
> -- 
> 1.7.9.5
> 
> 
