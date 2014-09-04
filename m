Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaIDQkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:40:35 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:52357 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754372AbaIDQke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:40:34 -0400
X-Yandex-Uniq: 0a8dd9c0-4c04-48a2-b016-7de2eafc6b00
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 14/19] smart: smart-related sysctl's
Date: Thu,  4 Sep 2014 20:31:00 +0400
Message-Id: <1409848265-17150-14-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

This patch introduces sysctl interface for smart configuration (default
values are given in brackets):
sched_smart_enable (1) - enable/disable smart globally
sched_smart_prio (10) - rt priority of tasks in a cgroup with smart set
sched_smart_gathering (1) - enable/disable smart gathering
sched_smart_throttle (1) - enable/disable throttling of CFS tasks

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 kernel/sched/rt.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c   | 39 ++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index ff7751a..21ffe09 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2247,6 +2247,82 @@ void print_rt_stats(struct seq_file *m, int cpu)
 #endif /* CONFIG_SCHED_DEBUG */
 
 #ifdef CONFIG_SMART
+int proc_smart_enable(struct ctl_table *table, int write,
+		      void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int enable = static_key_enabled(&__smart_enabled);
+	int ret;
+
+	build_smart_topology();
+
+	mutex_lock(&smart_mutex);
+
+	if (write && !static_key_false(&__smart_initialized)) {
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	table->data = &enable;
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (ret)
+		goto exit;
+
+	if (write) {
+		if (enable && !static_key_enabled(&__smart_enabled)) {
+			static_key_slow_inc(&__smart_enabled);
+			smart_update_globally();
+		}
+
+		if (!enable && static_key_enabled(&__smart_enabled)) {
+			static_key_slow_dec(&__smart_enabled);
+			smart_update_globally();
+		}
+	}
+
+exit:
+	mutex_unlock(&smart_mutex);
+
+	return ret;
+}
+
+int proc_smart_static_key(struct ctl_table *table, int write,
+			  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct static_key *key;
+	int enable;
+	int ret;
+	static DEFINE_MUTEX(mutex);
+
+	mutex_lock(&mutex);
+
+	key = table->data;
+	enable = static_key_enabled(key);
+
+	if (write && !static_key_false(&__smart_initialized)) {
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	table->data = &enable;
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (ret)
+		goto exit;
+
+	if (write) {
+		if (enable && !static_key_enabled(key))
+			static_key_slow_inc(key);
+
+		if (!enable && static_key_enabled(key))
+			static_key_slow_dec(key);
+	}
+
+exit:
+	table->data = key;
+	mutex_unlock(&mutex);
+
+	return ret;
+}
+
 int check_smart_data(void)
 {
 	int cpu, core;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index a1e71e9..27eb548 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -128,6 +128,7 @@ static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
 static int __maybe_unused three = 3;
 static unsigned long one_ul = 1;
+static int ninety_eight = 98;
 static int one_hundred = 100;
 #ifdef CONFIG_PRINTK
 static int ten_thousand = 10000;
@@ -178,6 +179,13 @@ extern int no_unaligned_warning;
 #ifdef CONFIG_SMART
 struct static_key smart_cfs_gather = STATIC_KEY_INIT_TRUE;
 struct static_key smart_cfs_throttle = STATIC_KEY_INIT_TRUE;
+
+extern int sched_smart_prio;
+
+int proc_smart_static_key(struct ctl_table *table, int write,
+			  void __user *buffer, size_t *lenp, loff_t *ppos);
+int proc_smart_enable(struct ctl_table *table, int write,
+		      void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
 #ifdef CONFIG_PROC_SYSCTL
@@ -446,6 +454,37 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &one,
 	},
 #endif
+#ifdef CONFIG_SMART
+	{
+		.procname	= "sched_smart_enable",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_smart_enable,
+	},
+	{
+		.procname	= "sched_smart_prio",
+		.data		= &sched_smart_prio,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+		.extra2		= &ninety_eight,
+	},
+	{
+		.procname	= "sched_smart_gathering",
+		.data		= &smart_cfs_gather,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_smart_static_key,
+	},
+	{
+		.procname	= "sched_smart_throttle",
+		.data		= &smart_cfs_throttle,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_smart_static_key,
+	},
+#endif
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.procname	= "prove_locking",
-- 
1.9.3

