Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaIDQdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:33:33 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:35882 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754395AbaIDQbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:31:20 -0400
X-Yandex-Uniq: 9899eb80-0475-4073-9a42-545eb1d29de4
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 03/19] smart: introduce smart_enabled()
Date: Thu,  4 Sep 2014 20:30:49 +0400
Message-Id: <1409848265-17150-3-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

This patch introduces __smart_enabled static key and smart_enabled()
function, which will be used to check if smart functionality
is enabled.
An ability to turn it on/off will be added later.
By default, __smart_enabled is set to true.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 kernel/sched/rt.c    |  4 ++++
 kernel/sched/sched.h | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index fed3992..c71b9a3 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -11,6 +11,7 @@
 #include <linux/jump_label.h>
 
 struct static_key __smart_initialized = STATIC_KEY_INIT_FALSE;
+struct static_key __smart_enabled = STATIC_KEY_INIT_TRUE;
 DEFINE_MUTEX(smart_mutex);
 
 DEFINE_PER_CPU_SHARED_ALIGNED(struct smart_core_data, smart_core_data);
@@ -2202,6 +2203,9 @@ void build_smart_topology(void)
 	int cpu;
 	int was_initialized;
 
+	if (!static_key_enabled(&__smart_enabled))
+		return;
+
 	mutex_lock(&smart_mutex);
 
 	was_initialized = static_key_enabled(&__smart_initialized);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 357736b..7e26454 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -6,6 +6,7 @@
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
 #include <linux/tick.h>
+#include <linux/jump_label.h>
 
 #include "cpupri.h"
 #include "cpuacct.h"
@@ -1390,6 +1391,7 @@ struct smart_core_data {
 } ____cacheline_aligned_in_smp;
 
 extern struct static_key __smart_initialized;
+extern struct static_key __smart_enabled;
 
 DECLARE_PER_CPU_SHARED_ALIGNED(struct smart_core_data, smart_core_data);
 
@@ -1400,6 +1402,12 @@ static inline int cpu_core_id(int cpu)
 
 #define smart_data(cpu) per_cpu(smart_core_data, cpu_core_id(cpu))
 
+static inline bool smart_enabled(void)
+{
+	return static_key_false(&__smart_initialized) &&
+		static_key_true(&__smart_enabled);
+}
+
 static inline int core_node_sibling(int cpu)
 {
 	return smart_data(cpu).core_node_sibling;
@@ -1417,4 +1425,9 @@ static inline void build_smart_topology(void)
 {
 }
 
+static inline bool smart_enabled(void)
+{
+	return false;
+}
+
 #endif /* CONFIG_SMART */
-- 
1.9.3

