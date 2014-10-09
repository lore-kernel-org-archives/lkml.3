Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbaJIQgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:36:38 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37281 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387AbaJIQg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:36:28 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v2 10/12] watchdog: add watchdog enable/disable all functions
Date: Thu,  9 Oct 2014 18:34:44 +0200
Message-Id: <1412872486-2930-11-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412872486-2930-1-git-send-email-eranian@google.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two new functions to enable/disable
the watchdog across all CPUs.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/watchdog.h |  3 +++
 kernel/watchdog.c        | 28 ++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 2a3038e..b89b414 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -142,4 +142,7 @@ extern int watchdog_init_timeout(struct watchdog_device *wdd,
 extern int watchdog_register_device(struct watchdog_device *);
 extern void watchdog_unregister_device(struct watchdog_device *);
 
+void watchdog_nmi_disable_all(void);
+void watchdog_nmi_enable_all(void);
+
 #endif  /* ifndef _LINUX_WATCHDOG_H */
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 8759d0b..6aa5b8f 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -514,9 +514,37 @@ static void watchdog_nmi_disable(unsigned int cpu)
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

