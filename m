Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab3HLPrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:47:31 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:30727 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947Ab3HLPr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:47:28 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 1/2] CPU hotplug: Export cpu_hotplug_begin() interface
Date: Mon, 12 Aug 2013 09:45:53 -0600
Message-Id: <1376322354-13026-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376322354-13026-1-git-send-email-toshi.kani@hp.com>
References: <1376322354-13026-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_hotplug_begin() and cpu_hotplug_done() are the interfaces to
acquire the writer lock of the cpu_hotplug.lock.  The interfaces are
used along with cpu_maps_update_begin() / cpu_maps_update_done() to
serialize the updates to the system cpu maps, such as cpu_online_mask
and cpu_present_mask.

cpu_present_mask is updated by the ACPI processor handler.  Therefore,
this patch changes the interfaces to global, and exports them in cpu.h.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 include/linux/cpu.h |    4 ++++
 kernel/cpu.c        |    9 +++------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ab0eade..956c0a1 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -172,6 +172,8 @@ extern struct bus_type cpu_subsys;
 #ifdef CONFIG_HOTPLUG_CPU
 /* Stop CPUs going up and down. */
 
+extern void cpu_hotplug_begin(void);
+extern void cpu_hotplug_done(void);
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
 extern void cpu_hotplug_disable(void);
@@ -197,6 +199,8 @@ static inline void cpu_hotplug_driver_unlock(void)
 
 #else		/* CONFIG_HOTPLUG_CPU */
 
+static inline void cpu_hotplug_begin(void) {}
+static inline void cpu_hotplug_done(void) {}
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
 #define cpu_hotplug_disable()	do { } while (0)
diff --git a/kernel/cpu.c b/kernel/cpu.c
index b2b227b..d7f07a2 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -113,7 +113,7 @@ EXPORT_SYMBOL_GPL(put_online_cpus);
  * get_online_cpus() not an api which is called all that often.
  *
  */
-static void cpu_hotplug_begin(void)
+void cpu_hotplug_begin(void)
 {
 	cpu_hotplug.active_writer = current;
 
@@ -127,7 +127,7 @@ static void cpu_hotplug_begin(void)
 	}
 }
 
-static void cpu_hotplug_done(void)
+void cpu_hotplug_done(void)
 {
 	cpu_hotplug.active_writer = NULL;
 	mutex_unlock(&cpu_hotplug.lock);
@@ -154,10 +154,7 @@ void cpu_hotplug_enable(void)
 	cpu_maps_update_done();
 }
 
-#else /* #if CONFIG_HOTPLUG_CPU */
-static void cpu_hotplug_begin(void) {}
-static void cpu_hotplug_done(void) {}
-#endif	/* #else #if CONFIG_HOTPLUG_CPU */
+#endif	/* CONFIG_HOTPLUG_CPU */
 
 /* Need to know about CPUs going up/down? */
 int __ref register_cpu_notifier(struct notifier_block *nb)
