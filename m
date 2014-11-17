Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaKQTIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:08:39 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:53668 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaKQTIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:08:35 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v3 11/13] watchdog: add watchdog enable/disable all functions
Date: Mon, 17 Nov 2014 20:07:03 +0100
Message-Id: <1416251225-17721-12-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416251225-17721-1-git-send-email-eranian@google.com>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two new functions to enable/disable
the watchdog across all CPUs.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/watchdog.h |  8 ++++++++
 kernel/watchdog.c        | 28 ++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 395b70e..a746bf5 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -137,4 +137,12 @@ extern int watchdog_init_timeout(struct watchdog_device *wdd,
 extern int watchdog_register_device(struct watchdog_device *);
 extern void watchdog_unregister_device(struct watchdog_device *);
 
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+void watchdog_nmi_disable_all(void);
+void watchdog_nmi_enable_all(void);
+#else
+static inline void watchdog_nmi_disable_all(void) {}
+static inline void watchdog_nmi_enable_all(void) {}
+#endif
+
 #endif  /* ifndef _LINUX_WATCHDOG_H */
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 70bf118..aa27a20 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -567,9 +567,37 @@ static void watchdog_nmi_disable(unsigned int cpu)
 		cpu0_err = 0;
 	}
 }
+
+void watchdog_nmi_enable_all(void)
+{
+	int cpu;
+
+	if (!watchdog_user_enabled)
+		return;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		watchdog_nmi_enable(cpu);
+	put_online_cpus();
+}
+
+void watchdog_nmi_disable_all(void)
+{
+	int cpu;
+
+	if (!watchdog_running)
+		return;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		watchdog_nmi_disable(cpu);
+	put_online_cpus();
+}
 #else
 static int watchdog_nmi_enable(unsigned int cpu) { return 0; }
 static void watchdog_nmi_disable(unsigned int cpu) { return; }
+void watchdog_nmi_enable_all(void) {}
+void watchdog_nmi_disable_all(void) {}
 #endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
 static struct smp_hotplug_thread watchdog_threads = {
-- 
1.9.1

