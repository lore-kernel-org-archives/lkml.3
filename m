Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab3DVTAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 15:00:03 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:54053 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab3DVS77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 14:59:59 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 03/10] perf: New helper to prevent full dynticks CPUs from stopping tick
Date: Mon, 22 Apr 2013 20:59:39 +0200
Message-Id: <1366657186-20556-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
References: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a new helper that help full dynticks CPUs to prevent
from stopping their tick in case there are events in the local
rotation list.

This way we make sure that perf_event_task_tick() is serviced
on demand.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/perf_event.h |    6 ++++++
 kernel/events/core.c       |   10 ++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e47ee46..0140830 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -799,6 +799,12 @@ static inline int __perf_event_disable(void *info)			{ return -1; }
 static inline void perf_event_task_tick(void)				{ }
 #endif
 
+#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_NO_HZ_FULL)
+extern bool perf_event_can_stop_tick(void);
+#else
+static inline bool perf_event_can_stop_tick(void)			{ return true; }
+#endif
+
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
 
 /*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 75b58bb..ddb993b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2560,6 +2560,16 @@ done:
 		list_del_init(&cpuctx->rotation_list);
 }
 
+#ifdef CONFIG_NO_HZ_FULL
+bool perf_event_can_stop_tick(void)
+{
+	if (list_empty(&__get_cpu_var(rotation_list)))
+		return true;
+	else
+		return false;
+}
+#endif
+
 void perf_event_task_tick(void)
 {
 	struct list_head *head = &__get_cpu_var(rotation_list);
-- 
1.7.5.4

