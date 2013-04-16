Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965000Ab3DPRFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:05:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:51429 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935825Ab3DPRFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:05:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,487,1363158000"; 
   d="scan'208";a="319143220"
Message-ID: <516D84D8.6090407@linux.intel.com>
Date: Tue, 16 Apr 2013 10:05:28 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: zhang.yi20@zte.com.cn
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] futex: bugfix for robust futex deadlock when waking only
 one thread in handle_futex_death
References: <OF9EFE848A.BEC7D34A-ON48257B4F.00105687-48257B4F.0010C79B@zte.com.cn>
In-Reply-To: <OF9EFE848A.BEC7D34A-ON48257B4F.00105687-48257B4F.0010C79B@zte.com.cn>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 08:02 PM, zhang.yi20@zte.com.cn wrote:
> From: Zhang Yi <zhang.yi20@zte.com.cn>
>
> Hello,

Hi Zhang,

I think you've attempted to address this with your second futex patch,
but please use plain text email on LKML, especially for patches. Ensure
to linewrap your plain text email and avoid mid-line breaks as it makes
the message very difficult to read.

(my mailer can't seem to be forced into replying in plain text mode for this
particular email, not sure what is special about this one).

> The function handle_futex_death just wakes one thread, which may be not
> enough when the owner process is dead. Think about this scene£º
> 1. A robust futex is shared for two processes, each process has multi
> threads try to get the lock.
> 2. One of the threads gets the lock, and the others are waiting and sorted
> in order of priority.
> 3. The process to which the lock owner thread belongs is dying£¬and
> handle_futex_death is called to wake the first waiter
> 4. When the first waiter belongs to the same process£¬it has no chance to
> return to the userspace to get the lock and will not call
> handle_futex_death any
> more£¬and then the rest threads of the other process will never be waked,
> and
> will block forever.

A simple functional testcase of this would be really nice to add to
futextest:

https://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/

It would also be good for validating the fix and avoiding regressions.

>
> This patch wakes all the waiters when lock owner is in group-exit, letting
>
> all the waiters return to userspace and try to get the lock again.
>
>
> Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
> Tested-by: Ma Chenggong <ma.chenggong@zte.com.cn>
> Reviewed-by: Liu Dong <liu.dong3@zte.com.cn>
> Reviewed-by: Cui Yunfeng <cui.yunfeng@zte.com.cn>
> Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
> Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>
>
>
> --- orig/linux-3.9-rc7/kernel/futex.c   2013-04-15 00:45:16.000000000
> +0000
> +++ new/linux-3.9-rc7/kernel/futex.c    2013-04-16 10:17:46.264597000
> +0000
> @@ -2545,8 +2545,11 @@ retry:
>                  * Wake robust non-PI futexes here. The wakeup of
>                  * PI futexes happens in exit_pi_state():
>                  */
> -               if (!pi && (uval & FUTEX_WAITERS))
> -                       futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
> +               if (!pi && (uval & FUTEX_WAITERS)) {
> +                       int nr = signal_group_exit(current->signal)
> +                                           ? INT_MAX : 1;
> +                       futex_wake(uaddr, 1, nr, FUTEX_BITSET_MATCH_ANY);
> +               }
>         }
>         return 0;
>  }

Performance isn't an issue here as this is an error path. The question
is if the
changed behavior will constitute a problem for existing applications. Rather
than a serialized cascading wake, we have them all wake at once. If an
application depended on the first waker after owner death to do some cleanup
before the rest came along, I could imagine some potential for failure
there.

One possible alternative would be to wake waiters for a different
process group
when OWNER_DEAD is set, and leave it as a single wake.

Peter, Ingo - do you think there is any concern over the wake_all versus
wake_one? I suspect it should be fine, but we obviously need to be
careful when changing the behavior of syscalls.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
