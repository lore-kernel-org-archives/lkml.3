Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab3ELLcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 07:32:08 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40307 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3ELLcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 07:32:05 -0400
Date: Sun, 12 May 2013 04:31:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Bisected post-3.9 regression: Resume takes 5 times as much time
 as with v3.9
Message-ID: <20130512113157.GG3648@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <87r4hdjsu5.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r4hdjsu5.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051211-3620-0000-0000-00000270FEB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 08:04:50PM +0200, Bjørn Mork wrote:
> Hello,
> 
> resuming from system suspend is intolerably slow in current mainline. I
> am not the most patient person around, and I actually started out
> bisecting this believing it was hanging...  Turned out it wasn't really
> hanging.  It just took 15 seconds to wake up from suspend-to-ram.
> Timing v3.9 I found that it used less than 3 seconds on this ancient
> laptop I'm using.
> 
> Bisecting it ended up pointing to
> 
> commit c0f4dfd4f90f1667d234d21f15153ea09a2eaa66
> Author: Paul E. McKenney <paul.mckenney@linaro.org>
> Date:   Fri Dec 28 11:30:36 2012 -0800
> 
>     rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks
>     
>     Because RCU callbacks are now associated with the number of the grace
>     period that they must wait for, CPUs can now take advance callbacks
>     corresponding to grace periods that ended while a given CPU was in
>     dyntick-idle mode.  This eliminates the need to try forcing the RCU
>     state machine while entering idle, thus reducing the CPU intensiveness
>     of RCU_FAST_NO_HZ, which should increase its energy efficiency.
>     
>     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> 
> 
> Being a big patch, I'm pretty sure that the problem is some minor
> issue. But rather than trying to userstand this, just tried reverting
> it on top of the current mainline and can confirm that this fixes the
> regression.  I'll leave the understanding to you :)
> 
> I'm attaching the revert patch as I had to fix a conflict, and may have
> done something wrong there.  I'm also attaching my .config.
> 
> Let me know if you need more information, or want me to try out proposed
> fixes.

We don't want to back out the RCU_FAST_NO_HZ changes due to their
energy-efficiency benefits.  So could you please try out Borislav's
patch below?  He ran into the same issue a few weeks ago, and this
one fixed it for him.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Expedite grace periods during suspend/resume

CONFIG_RCU_FAST_NO_HZ can increase grace-period durations by up to
a factor of four, which can result in long suspend and resume times.
Thus, this commit temporarily switches to expedited grace periods when
suspending the box and return to normal settings when resuming.

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a9610d1..d9604a4 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -53,6 +53,7 @@
 #include <linux/delay.h>
 #include <linux/stop_machine.h>
 #include <linux/random.h>
+#include <linux/suspend.h>
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -3003,6 +3004,22 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
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
@@ -3243,6 +3260,7 @@ void __init rcu_init(void)
 	 * or the scheduler are operational.
 	 */
 	cpu_notifier(rcu_cpu_notify, 0);
+	pm_notifier(rcu_pm_notify, 0);
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
 }

