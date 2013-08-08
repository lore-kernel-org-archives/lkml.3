Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab3HHEFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 00:05:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58413 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3HHEFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 00:05:53 -0400
Message-ID: <1375934704.5403.60.camel@marge.simpson.net>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ethan Zhao <ethan.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        johlstei@codeaurora.org, Yinghai Lu <yinghai@kernel.org>,
        Jin Feng <joe.jin@oracle.com>, Youquan Song <youquan.song@intel.com>,
        LenBrown <len.brown@intel.com>
Date: Thu, 08 Aug 2013 06:05:04 +0200
In-Reply-To: <1375863939.12157.27.camel@marge.simpson.net>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com>
	 <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de>
	 <CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com>
	 <20130730093519.GP3008@twins.programming.kicks-ass.net>
	 <1375774140.5412.9.camel@marge.simpson.net>
	 <1375863939.12157.27.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:QjmhOedxadKGL+XWNbFtJRisR3gD8DHLZ378+AIso4m
 kqp2nILLWE4xhjcImcRIwTxN/5a1itOV36IMIffrSFv0X4OtcS
 HGil7Orlf/2xA33bNESoDTVbqHmFnKMHw0EaNiHN60QjJYd6V9
 Sune8Fly20SejkCbeQwcHvPpe1q/1ckRFf3PT4zxGkCnXoKn6D
 JupAx1+lBmHa5FZXuSrSuXDi7Nei9DU+M8C9oX9m5mPLkfaIDj
 gVff1z8o6e/TWvQ45t170GKfRE8CJ8hXywcCmNustbcHl27jqO
 WBeQVo/4Xb53KwhkhalCsBxRfAfsE91dZ05ocaoxjp/BvcOawR
 P7rOv7+RTrsDcOMBIsVrEfaXoR7iLkDPteYZaQ7cHU+iLquhVC
 8iQ3Jb39Jaj+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 10:25 +0200, Mike Galbraith wrote:

> E5620 (2.4 GHz Westmere) throttle
> 
>     v3.11-rc4-27-ge4ef108                       v3.11-rc4-27-ge4ef108+peterz
>     6.76%  [k] __schedule                       7.68%  [k] reschedule_interrupt  (find this little bastard)
                                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 5.90%  [k] reschedule_interrupt             7.18%  [k] __schedule
>     4.12%  [k] __switch_to                      4.52%  [k] __switch_to
>     3.58%  [k] resched_tas                      4.24%  [k] cpuidle_enter_state
>     3.24%  [k] cpuidle_enter_state              2.96%  [k] cpu_idle_loop
>     3.01%  [k] _raw_spin_lock_irqsave           2.96%  [k] resched_task
>     2.67%  [k] cpu_idle_loop                    2.79%  [k] _raw_spin_lock_irqsave
>     2.49%  [k] task_waking_fair                 2.45%  [k] ktime_get
>     2.38%  [k] copy_user_generic_string         2.34%  [k] copy_user_generic_string
>     2.27%  [k] mutex_lock                       2.32%  [k] get_typical_interval

7d1a941731fabf27e5fb6edbebb79fe856edb4e5 is the first bad commit
commit 7d1a941731fabf27e5fb6edbebb79fe856edb4e5
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Mar 21 22:50:03 2013 +0100

    x86: Use generic idle loop


So, in summary, seems we need to forget all about scheduling anything
remotely fast cross core these days, even on core2 with its lovely
shared L2, as otherwise we'll beat it all up.  Boxen with no nohz
throttle maybe don't notice how bad all this progress hurt because
they're used to being in agony.  Your patch (modulo any bustage, haven't
run any testsuite, only ran for regression hunt/test purposes) should
make smiles for those who notice large chunk of that pain going away.

My beloved ole Q6600 is currently not particularly happy, and that's
best case, shared L2, where nearly any dinky overlap used to be
reclaimable.  Even with your patch, we'll still be losers at network
fast movers across the board on any box methinks.

-Mike

