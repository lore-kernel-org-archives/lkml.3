Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3LZKDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 05:03:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57219 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3LZKDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 05:03:42 -0500
Message-ID: <1388052212.5420.4.camel@marge.simpson.net>
Subject: Re: [PATCH] rcu: Eliminate softirq processing from rcutree
From: Mike Galbraith <bitbucket@online.de>
To: paulmck@linux.vnet.ibm.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 26 Dec 2013 11:03:32 +0100
In-Reply-To: <1387940854.5373.8.camel@marge.simpson.net>
References: <20131221193900.GA8427@linutronix.de>
	 <1387681647.5412.25.camel@marge.simpson.net>
	 <1387702631.5412.101.camel@marge.simpson.net>
	 <1387773533.5369.16.camel@marge.simpson.net>
	 <20131224193636.GD19211@linux.vnet.ibm.com>
	 <1387940854.5373.8.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:rZ0xzbSWWPKjgvPyzW0WZ1C9GSUUbJ0n3qdeLY15bG4
 uGrd9h29PmiYDeMlqOZ1KSLKa3xibc27PbZLkSR20GsAV25wPc
 g0i/C/8BupbXr5kB5LJzhxhK93040m2rouYLwGMl2Bvpxcio1W
 3GULcvuPDxb5Ch1km3YHWH/DlfD1+sGmqoQFomaCtirtxxAoJT
 diVyh76qDEmpmAaKT8MrwdxSuy46/4wMVpjy5NMpErDDLVh7ed
 gTBI1Jlt344oLOO2neyWDRTj2nG1CgDrRZJEeQfFi3Vrc1jGy7
 3ti6OvzBTAvo5Wb30mpFXljEq8+rugsUNblrSSIFKz6hpLFRCk
 iCRTyBt+/+r/sb3vIeXHlsW2zeCGgAiz3T4yN+XcKsUsCEjj6Z
 ZIaOIC73jaFNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-25 at 04:07 +0100, Mike Galbraith wrote:
> On Tue, 2013-12-24 at 11:36 -0800, Paul E. McKenney wrote: 

> > So which code do you think deserves the big lump of coal?  ;-)
> 
> Sebastian's NO_HZ_FULL locking fixes.

Whack-a-mole hasn't yet dug up any new moles.

---
 kernel/timer.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -764,7 +764,9 @@ __mod_timer(struct timer_list *timer, un
 	timer_stats_timer_set_start_info(timer);
 	BUG_ON(!timer->function);
 
+	local_irq_disable_rt();
 	base = lock_timer_base(timer, &flags);
+	local_irq_enable_rt();
 
 	ret = detach_if_pending(timer, base, false);
 	if (!ret && pending_only)
@@ -1198,7 +1200,9 @@ static inline void __run_timers(struct t
 {
 	struct timer_list *timer;
 
+	local_irq_disable_rt();
 	spin_lock_irq(&base->lock);
+	local_irq_enable_rt();
 	while (time_after_eq(jiffies, base->timer_jiffies)) {
 		struct list_head work_list;
 		struct list_head *head = &work_list;
---
 kernel/time/tick-sched.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -216,7 +216,9 @@ void __tick_nohz_full_check(void)
 
 static void nohz_full_kick_work_func(struct irq_work *work)
 {
+	local_irq_disable_rt();
 	__tick_nohz_full_check();
+	local_irq_enable_rt();
 }
 
 static DEFINE_PER_CPU(struct irq_work, nohz_full_kick_work) = {



