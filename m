Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3BDSRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:17:23 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:64845 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab3BDSRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:17:21 -0500
Date: Mon, 4 Feb 2013 19:17:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU fixes
Message-ID: <20130204181716.GB10022@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   HEAD: d36b7b9643faca8aab8cee8d824f75c800b337ac Merge branch 'rcu/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/urgent

Two small fixlets.

 Thanks,

	Ingo

------------------>
Paul Gortmaker (2):
      rcu: Prevent soft-lockup complaints about no-CBs CPUs
      rcu: Make rcu_nocb_poll an early_param instead of module_param


 Documentation/kernel-parameters.txt |  2 +-
 kernel/rcutree_plugin.h             | 13 ++++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 363e348..6c72381 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2438,7 +2438,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			real-time workloads.  It can also improve energy
 			efficiency for asymmetric multiprocessors.
 
-	rcu_nocbs_poll	[KNL,BOOT]
+	rcu_nocb_poll	[KNL,BOOT]
 			Rather than requiring that offloaded CPUs
 			(specified by rcu_nocbs= above) explicitly
 			awaken the corresponding "rcuoN" kthreads,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f6e5ec2..c1cc7e1 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -40,8 +40,7 @@
 #ifdef CONFIG_RCU_NOCB_CPU
 static cpumask_var_t rcu_nocb_mask; /* CPUs to have callbacks offloaded. */
 static bool have_rcu_nocb_mask;	    /* Was rcu_nocb_mask allocated? */
-static bool rcu_nocb_poll;	    /* Offload kthread are to poll. */
-module_param(rcu_nocb_poll, bool, 0444);
+static bool __read_mostly rcu_nocb_poll;    /* Offload kthread are to poll. */
 static char __initdata nocb_buf[NR_CPUS * 5];
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
@@ -2159,6 +2158,13 @@ static int __init rcu_nocb_setup(char *str)
 }
 __setup("rcu_nocbs=", rcu_nocb_setup);
 
+static int __init parse_rcu_nocb_poll(char *arg)
+{
+	rcu_nocb_poll = 1;
+	return 0;
+}
+early_param("rcu_nocb_poll", parse_rcu_nocb_poll);
+
 /* Is the specified CPU a no-CPUs CPU? */
 static bool is_nocb_cpu(int cpu)
 {
@@ -2366,10 +2372,11 @@ static int rcu_nocb_kthread(void *arg)
 	for (;;) {
 		/* If not polling, wait for next batch of callbacks. */
 		if (!rcu_nocb_poll)
-			wait_event(rdp->nocb_wq, rdp->nocb_head);
+			wait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
 		list = ACCESS_ONCE(rdp->nocb_head);
 		if (!list) {
 			schedule_timeout_interruptible(1);
+			flush_signals(current);
 			continue;
 		}
 
