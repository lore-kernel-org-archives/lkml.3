Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaEBSih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 14:38:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:43693 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaEBSif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 14:38:35 -0400
Date: Fri, 2 May 2014 20:38:24 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stanislav Meduna <stano@meduna.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: spinlock trylock failure on UP, i.MX28 3.12.15-rt25
Message-ID: <20140502183824.GH9178@linutronix.de>
References: <534C3606.7010206@meduna.org>
 <534C731F.1050406@meduna.org>
 <534DADF1.6060608@meduna.org>
 <20140422115439.GA20669@linutronix.de>
 <20140422094657.5b6ca1e2@gandalf.local.home>
 <53569E05.8010600@linutronix.de>
 <20140422134802.73fc1fa4@gandalf.local.home>
 <20140422141650.7f43d5ba@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140422141650.7f43d5ba@gandalf.local.home>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2014-04-22 14:16:50 [-0400]:

>On Tue, 22 Apr 2014 13:48:02 -0400
>Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> I need to take a deeper look into the actual code. But as trylocks on
>> UP are nops (always succeed), and if it expects to be able to do
>> something in a critical section that is protected by spinlocks (again
>> nops on UP), this would be broken for UP.
>
>Reading the code, I see it's broken. We should add something like this:
>
>Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>---
>diff --git a/kernel/timer.c b/kernel/timer.c
>index cc34e42..a03164a 100644
>--- a/kernel/timer.c
>+++ b/kernel/timer.c
>@@ -1447,6 +1447,12 @@ static void run_timer_softirq(struct softirq_action *h)
> 		__run_timers(base);
> }
> 
>+#ifdef CONFIG_SMP
>+#define timer_should_raise_softirq(lock)	!spin_do_trylock(lock)
>+#else
>+#define timer_should_raise_softirq(lock)	1
>+#endif
>+
> /*
>  * Called by the local, per-CPU timer interrupt on SMP.
>  */
>@@ -1467,7 +1473,7 @@ void run_local_timers(void)
> 		return;
> 	}
> 
>-	if (!spin_do_trylock(&base->lock)) {
>+	if (timer_should_raise_softirq(&base->lock)) {
> 		raise_softirq(TIMER_SOFTIRQ);
> 		return;
> 	}

Okay. So Peter said that it is okay to apply this since FULL_NO_HZ users
wouldn't complain on UP. I still wouldn't say it is broken but that is a
different story.
We have two users of this trylock. run_local_timers() which pops up
quite often (and you patched here) and the other is
get_next_timer_interrupt(). What do you suggest we do here? It is
basically the same thing.

Sebastian
