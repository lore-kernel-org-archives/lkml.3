Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbaF3X4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 19:56:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38423 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaF3X4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 19:56:43 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] clk: Add tracepoints for hardware operations
Date: Mon, 30 Jun 2014 16:56:39 -0700
Message-Id: <1404172599-10171-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's useful to have tracepoints around operations that change the
hardware state so that we can debug clock hardware performance
and operations. Three basic types of events are supported: on/off
events for enable, disable, prepare, unprepare that only record
an event and a clock name, rate changing events for
clk_set_rate() and parent changing events for clk_set_parent().

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

I see that there are tracepoints for clock_enable/clock_set_rate
in events/power.h but those look to be unused and they also
take cpu_id which seems odd. I'd rather we just make a new set of
events for the common clock framework instead and add the "_complete"
set of events so we know when things have completed.

 drivers/clk/clk.c          |  28 ++++++++
 include/trace/events/clk.h | 165 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 193 insertions(+)
 create mode 100644 include/trace/events/clk.h

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8b73edef151d..f8bf69df3210 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -21,6 +21,9 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/clk.h>
+
 #include "clk.h"
 
 static DEFINE_SPINLOCK(enable_lock);
@@ -483,10 +486,12 @@ static void clk_unprepare_unused_subtree(struct clk *clk)
 		return;
 
 	if (__clk_is_prepared(clk)) {
+		trace_clk_unprepare(clk);
 		if (clk->ops->unprepare_unused)
 			clk->ops->unprepare_unused(clk->hw);
 		else if (clk->ops->unprepare)
 			clk->ops->unprepare(clk->hw);
+		trace_clk_unprepare_complete(clk);
 	}
 }
 
@@ -516,10 +521,12 @@ static void clk_disable_unused_subtree(struct clk *clk)
 	 * back to .disable
 	 */
 	if (__clk_is_enabled(clk)) {
+		trace_clk_disable(clk);
 		if (clk->ops->disable_unused)
 			clk->ops->disable_unused(clk->hw);
 		else if (clk->ops->disable)
 			clk->ops->disable(clk->hw);
+		trace_clk_disable_complete(clk);
 	}
 
 unlock_out:
@@ -802,9 +809,13 @@ void __clk_unprepare(struct clk *clk)
 
 	WARN_ON(clk->enable_count > 0);
 
+	trace_clk_unprepare(clk);
+
 	if (clk->ops->unprepare)
 		clk->ops->unprepare(clk->hw);
 
+	trace_clk_unprepare_complete(clk);
+
 	__clk_unprepare(clk->parent);
 }
 
@@ -842,6 +853,8 @@ int __clk_prepare(struct clk *clk)
 		if (ret)
 			return ret;
 
+		trace_clk_prepare(clk);
+
 		if (clk->ops->prepare) {
 			ret = clk->ops->prepare(clk->hw);
 			if (ret) {
@@ -849,6 +862,8 @@ int __clk_prepare(struct clk *clk)
 				return ret;
 			}
 		}
+
+		trace_clk_prepare_complete(clk);
 	}
 
 	clk->prepare_count++;
@@ -891,9 +906,13 @@ static void __clk_disable(struct clk *clk)
 	if (--clk->enable_count > 0)
 		return;
 
+	trace_clk_disable(clk);
+
 	if (clk->ops->disable)
 		clk->ops->disable(clk->hw);
 
+	trace_clk_disable_complete(clk);
+
 	__clk_disable(clk->parent);
 }
 
@@ -938,6 +957,7 @@ static int __clk_enable(struct clk *clk)
 		if (ret)
 			return ret;
 
+		trace_clk_enable(clk);
 		if (clk->ops->enable) {
 			ret = clk->ops->enable(clk->hw);
 			if (ret) {
@@ -945,6 +965,7 @@ static int __clk_enable(struct clk *clk)
 				return ret;
 			}
 		}
+		trace_clk_enable_complete(clk);
 	}
 
 	clk->enable_count++;
@@ -1241,6 +1262,8 @@ static struct clk *__clk_set_parent_before(struct clk *clk, struct clk *parent)
 	unsigned long flags;
 	struct clk *old_parent = clk->parent;
 
+	trace_clk_set_parent(clk, parent);
+
 	/*
 	 * Migrate prepare state between parents and prevent race with
 	 * clk_enable().
@@ -1285,6 +1308,7 @@ static void __clk_set_parent_after(struct clk *clk, struct clk *parent,
 		__clk_unprepare(old_parent);
 	}
 
+	trace_clk_set_parent_complete(clk, parent);
 	/* update debugfs with new clk tree topology */
 	clk_debug_reparent(clk, parent);
 }
@@ -1507,6 +1531,8 @@ static void clk_change_rate(struct clk *clk)
 	else if (clk->parent)
 		best_parent_rate = clk->parent->rate;
 
+	trace_clk_set_rate(clk, clk->new_rate);
+
 	if (clk->new_parent && clk->new_parent != clk->parent) {
 		old_parent = __clk_set_parent_before(clk, clk->new_parent);
 
@@ -1525,6 +1551,8 @@ static void clk_change_rate(struct clk *clk)
 	if (!skip_set_rate && clk->ops->set_rate)
 		clk->ops->set_rate(clk->hw, clk->new_rate, best_parent_rate);
 
+	trace_clk_set_rate_complete(clk, clk->new_rate);
+
 	clk->rate = clk_recalc(clk, best_parent_rate);
 
 	if (clk->notifier_count && old_rate != clk->rate)
diff --git a/include/trace/events/clk.h b/include/trace/events/clk.h
new file mode 100644
index 000000000000..8523adce0f73
--- /dev/null
+++ b/include/trace/events/clk.h
@@ -0,0 +1,165 @@
+/*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM clk
+
+#if !defined(_TRACE_CLK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_CLK_H
+
+#include <linux/tracepoint.h>
+
+struct clk;
+
+DECLARE_EVENT_CLASS(clk,
+
+	TP_PROTO(struct clk *clk),
+
+	TP_ARGS(clk),
+
+	TP_STRUCT__entry(
+		__string(        name,           __clk_get_name(clk)       )
+	),
+
+	TP_fast_assign(
+		__assign_str(name, __clk_get_name(clk));
+	),
+
+	TP_printk("%s", __get_str(name))
+);
+
+DEFINE_EVENT(clk, clk_enable,
+
+	TP_PROTO(struct clk *clk),
+
+	TP_ARGS(clk)
+);
+
+DEFINE_EVENT(clk, clk_enable_complete,
+
+	TP_PROTO(struct clk *clk),
+
+	TP_ARGS(clk)
+);
+
+DEFINE_EVENT(clk, clk_disable,
+
+	TP_PROTO(struct clk *clk),
+
+	TP_ARGS(clk)
+);
+
+DEFINE_EVENT(clk, clk_disable_complete,
+
+	TP_PROTO(struct clk *clk),
+
+	TP_ARGS(clk)
+);
+
+DEFINE_EVENT(clk, clk_prepare,
+
+	TP_PROTO(struct clk *clk),
+
+	TP_ARGS(clk)
+);
+
+DEFINE_EVENT(clk, clk_prepare_complete,
+
+	TP_PROTO(struct clk *clk),
+
+	TP_ARGS(clk)
+);
+
+DEFINE_EVENT(clk, clk_unprepare,
+
+	TP_PROTO(struct clk *clk),
+
+	TP_ARGS(clk)
+);
+
+DEFINE_EVENT(clk, clk_unprepare_complete,
+
+	TP_PROTO(struct clk *clk),
+
+	TP_ARGS(clk)
+);
+
+DECLARE_EVENT_CLASS(clk_rate,
+
+	TP_PROTO(struct clk *clk, unsigned long rate),
+
+	TP_ARGS(clk, rate),
+
+	TP_STRUCT__entry(
+		__string(        name,           __clk_get_name(clk)       )
+		__field(unsigned long,           rate                      )
+	),
+
+	TP_fast_assign(
+		__assign_str(name, __clk_get_name(clk));
+		__entry->rate = rate;
+	),
+
+	TP_printk("%s %lu", __get_str(name), (unsigned long)__entry->rate)
+);
+
+DEFINE_EVENT(clk_rate, clk_set_rate,
+
+	TP_PROTO(struct clk *clk, unsigned long rate),
+
+	TP_ARGS(clk, rate)
+);
+
+DEFINE_EVENT(clk_rate, clk_set_rate_complete,
+
+	TP_PROTO(struct clk *clk, unsigned long rate),
+
+	TP_ARGS(clk, rate)
+);
+
+DECLARE_EVENT_CLASS(clk_parent,
+
+	TP_PROTO(struct clk *clk, struct clk *parent),
+
+	TP_ARGS(clk, parent),
+
+	TP_STRUCT__entry(
+		__string(        name,           __clk_get_name(clk)       )
+		__string(        pname,          __clk_get_name(parent)    )
+	),
+
+	TP_fast_assign(
+		__assign_str(name, __clk_get_name(clk));
+		__assign_str(pname, __clk_get_name(parent));
+	),
+
+	TP_printk("%s %s", __get_str(name), __get_str(pname))
+);
+
+DEFINE_EVENT(clk_parent, clk_set_parent,
+
+	TP_PROTO(struct clk *clk, struct clk *parent),
+
+	TP_ARGS(clk, parent)
+);
+
+DEFINE_EVENT(clk_parent, clk_set_parent_complete,
+
+	TP_PROTO(struct clk *clk, struct clk *parent),
+
+	TP_ARGS(clk, parent)
+);
+
+#endif /* _TRACE_CLK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

