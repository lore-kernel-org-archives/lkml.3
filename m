Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3DUWMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 18:12:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46555 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab3DUWMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 18:12:41 -0400
Date: Mon, 22 Apr 2013 00:12:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        tiwai@suse.de
Subject: Re: irq 16: nobody cared
Message-ID: <20130421221242.GB4593@pd.tnic>
References: <20130421103403.GA4594@pd.tnic>
 <20130421163002.GB3509@linux.vnet.ibm.com>
 <20130421165653.GA4623@pd.tnic>
 <20130421181035.GC4559@pd.tnic>
 <20130421185609.GD3509@linux.vnet.ibm.com>
 <20130421190655.GA5807@pd.tnic>
 <20130421203447.GE3509@linux.vnet.ibm.com>
 <20130421205139.GC5807@pd.tnic>
 <20130421214241.GA4593@pd.tnic>
 <20130421220015.GF3509@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130421220015.GF3509@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 03:00:15PM -0700, Paul E. McKenney wrote:
> Cool!!!  Note that there is no need for expediting TINY_RCU because
> its grace periods are already maximally expedited.  There is only one
> CPU, so if you are following the rules, when you call synchronize_rcu(),
> by definition there is a zero-length grace period.  ;-)
>
> So all you need is rcutree.c.

Ok, even better :-).

> Looking forward to the section-mismatch-free version!

Yeah, here it is. Please sanity-check the commit message whether I'm
making sense.

I've just pulled -rc8 and tip/master + this patch and a couple of other
fixes and will run it the coming week to make sure there are no other
issues.

Thanks!

--
>From 3c155e9a22036839c09d98a4acbc7e17a5a3783c Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@suse.de>
Date: Sun, 21 Apr 2013 23:56:15 +0200
Subject: [PATCH] RCU: Expedite grace periods during suspend/resume

Paul says CONFIG_RCU_FAST_NO_HZ can increase grace-period durations by a
factor of four. This, in turn, can change timings during suspend and can
delay interrupts handling, leading to "IRQ XX: nobody cared" splats and
the machine disabling those interrupt lines for no sensible reason.

Thus, we want to temporarily switch to expedited grace periods when
suspending the box and return to normal settings when resuming. This
patch does exactly that.

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 kernel/rcutree.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 986d1d3a34f5..9e9aeb38b7a2 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -53,6 +53,7 @@
 #include <linux/delay.h>
 #include <linux/stop_machine.h>
 #include <linux/random.h>
+#include <linux/suspend.h>
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -3097,6 +3098,22 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
+static int rcu_pm_notify(struct notifier_block *self,
+			 unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case PM_HIBERNATION_PREPARE:
+		rcu_expedited = 1;
+		break;
+	case PM_POST_RESTORE:
+		rcu_expedited = 0;
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
 /*
  * Spawn the kthread that handles this RCU flavor's grace periods.
  */
@@ -3323,6 +3340,7 @@ void __init rcu_init(void)
 	 * or the scheduler are operational.
 	 */
 	cpu_notifier(rcu_cpu_notify, 0);
+	pm_notifier(rcu_pm_notify, 0);
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
 }
-- 
1.8.2.135.g7b592fa


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
