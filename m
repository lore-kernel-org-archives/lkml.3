Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3AaMMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:12:03 -0500
Received: from www.linutronix.de ([62.245.132.108]:56188 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab3AaMLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:45 -0500
Message-Id: <20130131120744.117676862@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Richard Weinberger <richard@nod.at>
Subject: [patch 39/40] relayfs: Convert to hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=0005-cpu-hotplug-convert-relayfs.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpuhotplug.h |    7 +++++
 kernel/cpu.c               |    4 +++
 kernel/relay.c             |   59 ++++++++++-----------------------------------
 3 files changed, 25 insertions(+), 45 deletions(-)

Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -18,6 +18,7 @@ enum cpuhp_states {
 	CPUHP_PROFILE_PREPARE,
 	CPUHP_X2APIC_PREPARE,
 	CPUHP_SMPCFD_PREPARE,
+	CPUHP_RELAY_PREPARE,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,
 	CPUHP_CLOCKEVENTS_DEAD,
@@ -204,4 +205,10 @@ int profile_online_cpu(unsigned int cpu)
 int smpcfd_prepare_cpu(unsigned int cpu);
 int smpcfd_dead_cpu(unsigned int cpu);
 
+#ifdef CONFIG_RELAY
+int relay_prepare_cpu(unsigned int cpu);
+#else
+#define relay_prepare_cpu	NULL
+#endif
+
 #endif
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -768,6 +768,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = smpcfd_prepare_cpu,
 		.teardown = smpcfd_dead_cpu,
 	},
+	[CPUHP_RELAY_PREPARE] = {
+		.startup = relay_prepare_cpu,
+		.teardown = NULL,
+	},
 	[CPUHP_NOTIFY_PREPARE] = {
 		.startup = notify_prepare,
 		.teardown = NULL,
Index: linux-2.6/kernel/relay.c
===================================================================
--- linux-2.6.orig/kernel/relay.c
+++ linux-2.6/kernel/relay.c
@@ -508,46 +508,24 @@ static void setup_callbacks(struct rchan
 	chan->cb = cb;
 }
 
-/**
- * 	relay_hotcpu_callback - CPU hotplug callback
- * 	@nb: notifier block
- * 	@action: hotplug action to take
- * 	@hcpu: CPU number
- *
- * 	Returns the success/failure of the operation. (%NOTIFY_OK, %NOTIFY_BAD)
- */
-static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
-				unsigned long action,
-				void *hcpu)
+int __cpuinit relay_prepare_cpu(unsigned int cpu)
 {
-	unsigned int hotcpu = (unsigned long)hcpu;
 	struct rchan *chan;
 
-	switch(action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		mutex_lock(&relay_channels_mutex);
-		list_for_each_entry(chan, &relay_channels, list) {
-			if (chan->buf[hotcpu])
-				continue;
-			chan->buf[hotcpu] = relay_open_buf(chan, hotcpu);
-			if(!chan->buf[hotcpu]) {
-				printk(KERN_ERR
-					"relay_hotcpu_callback: cpu %d buffer "
-					"creation failed\n", hotcpu);
-				mutex_unlock(&relay_channels_mutex);
-				return notifier_from_errno(-ENOMEM);
-			}
-		}
-		mutex_unlock(&relay_channels_mutex);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		/* No need to flush the cpu : will be flushed upon
-		 * final relay_flush() call. */
-		break;
+	mutex_lock(&relay_channels_mutex);
+	list_for_each_entry(chan, &relay_channels, list) {
+		if (chan->buf[cpu])
+			continue;
+		chan->buf[cpu] = relay_open_buf(chan, cpu);
+		if(!chan->buf[cpu]) {
+			pr_err("relay: cpu %d buffer creation failed\n", cpu);
+			mutex_unlock(&relay_channels_mutex);
+			return -ENOMEM;
+ 		}
 	}
-	return NOTIFY_OK;
+
+	mutex_unlock(&relay_channels_mutex);
+	return 0;
 }
 
 /**
@@ -1355,12 +1333,3 @@ const struct file_operations relay_file_
 	.splice_read	= relay_file_splice_read,
 };
 EXPORT_SYMBOL_GPL(relay_file_operations);
-
-static __init int relay_init(void)
-{
-
-	hotcpu_notifier(relay_hotcpu_callback, 0);
-	return 0;
-}
-
-early_initcall(relay_init);


