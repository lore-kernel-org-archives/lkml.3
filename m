Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3DVTAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 15:00:00 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51553 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3DVS75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 14:59:57 -0400
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
Subject: [PATCH 02/10] perf: Kick full dynticks CPU if events rotation is needed
Date: Mon, 22 Apr 2013 20:59:38 +0200
Message-Id: <1366657186-20556-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
References: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kick the current CPU's tick by sending it a self IPI when
an event is queued on the rotation list and it is the first
element inserted. This makes sure that perf_event_task_tick()
works on full dynticks CPUs.

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
 kernel/events/core.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0cd865..75b58bb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -18,6 +18,7 @@
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/hash.h>
+#include <linux/tick.h>
 #include <linux/sysfs.h>
 #include <linux/dcache.h>
 #include <linux/percpu.h>
@@ -655,8 +656,12 @@ static void perf_pmu_rotate_start(struct pmu *pmu)
 
 	WARN_ON(!irqs_disabled());
 
-	if (list_empty(&cpuctx->rotation_list))
+	if (list_empty(&cpuctx->rotation_list)) {
+		int was_empty = list_empty(head);
 		list_add(&cpuctx->rotation_list, head);
+		if (was_empty)
+			tick_nohz_full_kick();
+	}
 }
 
 static void get_ctx(struct perf_event_context *ctx)
-- 
1.7.5.4

