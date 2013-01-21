Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3AULTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 06:19:31 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:41617 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3AULT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:19:29 -0500
Message-ID: <50FD2432.8010201@synopsys.com>
Date: Mon, 21 Jan 2013 16:49:14 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Frederic Weisbecker" <fweisbec@gmail.com>
Subject: Re: [PATCH v2 17/76] ARC: Process-creation/scheduling/idle-loop
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-18-git-send-email-vgupta@synopsys.com> <201301181435.15491.arnd@arndb.de>
In-Reply-To: <201301181435.15491.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013 08:05 PM, Arnd Bergmann wrote:
> On Friday 18 January 2013, Vineet Gupta wrote:
>> +void cpu_idle(void)
>> +{
>> +       /* Since we SLEEP in idle loop, TIF_POLLING_NRFLAG can't be set */
>> +
>> +       /* endless idle loop with no priority at all */
>> +       while (1) {
>> +               tick_nohz_idle_enter();
>> +               rcu_idle_enter();
>> +
>> +               while (!need_resched())
>> +                       arch_idle();
>> +
>> +               rcu_idle_exit();
>> +               tick_nohz_idle_exit();
>> +
>> +               schedule_preempt_disabled();
>> +       }
>> +}
> Unless I'm mistaken, you have introduced the classic sleep race
> here, where an interrupt can happen between the check for
> need_resched() and the sleep instruction in arch_idle().

Hmm... there is indeed a race - so we could end up missing a reschedule
opportunity, for until next interrupt (so next tick, if NOHZ is not enabled, and
indefinitely if system has no other interrupting sources).


> To avoid that, you need to disable interrupts around
> the inner loop. The sleep instruction should return with
> interrupts implicitly enabled if ARC behaves like most
> other architectures doing this.
>
> 	Arnd

Indeed sleep has option to turn on interrupts before it commits - so this is
certainly doable.

 static inline void arch_idle(void)
 {
-       __asm__("sleep");
+       /* sleep, but enable all interrupts before committing */
+       __asm__("sleep 0x3");
 }


-               while (!need_resched())
+doze:
+               local_irq_disable();
+               if (!need_resched()) {
                        arch_idle();
+                       goto doze;
+               } else {
+                       local_irq_enable();
+               }


Thx,
-Vineet
