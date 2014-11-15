Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaKOFGL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 00:06:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:4037 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750815AbaKOFGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 00:06:03 -0500
Message-Id: <20141115050601.107102597@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 23:58:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 03/26 v5] blktrace/tracing: Use trace_seq_has_overflowed() helper function
References: <20141115045847.712848224@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-blktrace-tracing-Use-trace_seq_has_overflowed-helper.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Checking the return code of every trace_seq_printf() operation and having
to return early if it overflowed makes the code messy.

Using the new trace_seq_has_overflowed() and trace_handle_return() functions
allows us to clean up the code.

In the future, trace_seq_printf() and friends will be turning into void
functions and not returning a value. The trace_seq_has_overflowed() is to
be used instead. This cleanup allows that change to take place.

Cc: Jens Axboe <axboe@fb.com>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/blktrace.c | 148 +++++++++++++++++++++---------------------------
 1 file changed, 66 insertions(+), 82 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c1bd4ada2a04..11b9cb36092b 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1142,9 +1142,9 @@ static void get_pdu_remap(const struct trace_entry *ent,
 	r->sector_from = be64_to_cpu(sector_from);
 }
 
-typedef int (blk_log_action_t) (struct trace_iterator *iter, const char *act);
+typedef void (blk_log_action_t) (struct trace_iterator *iter, const char *act);
 
-static int blk_log_action_classic(struct trace_iterator *iter, const char *act)
+static void blk_log_action_classic(struct trace_iterator *iter, const char *act)
 {
 	char rwbs[RWBS_LEN];
 	unsigned long long ts  = iter->ts;
@@ -1154,33 +1154,33 @@ static int blk_log_action_classic(struct trace_iterator *iter, const char *act)
 
 	fill_rwbs(rwbs, t);
 
-	return trace_seq_printf(&iter->seq,
-				"%3d,%-3d %2d %5d.%09lu %5u %2s %3s ",
-				MAJOR(t->device), MINOR(t->device), iter->cpu,
-				secs, nsec_rem, iter->ent->pid, act, rwbs);
+	trace_seq_printf(&iter->seq,
+			 "%3d,%-3d %2d %5d.%09lu %5u %2s %3s ",
+			 MAJOR(t->device), MINOR(t->device), iter->cpu,
+			 secs, nsec_rem, iter->ent->pid, act, rwbs);
 }
 
-static int blk_log_action(struct trace_iterator *iter, const char *act)
+static void blk_log_action(struct trace_iterator *iter, const char *act)
 {
 	char rwbs[RWBS_LEN];
 	const struct blk_io_trace *t = te_blk_io_trace(iter->ent);
 
 	fill_rwbs(rwbs, t);
-	return trace_seq_printf(&iter->seq, "%3d,%-3d %2s %3s ",
-				MAJOR(t->device), MINOR(t->device), act, rwbs);
+	trace_seq_printf(&iter->seq, "%3d,%-3d %2s %3s ",
+			 MAJOR(t->device), MINOR(t->device), act, rwbs);
 }
 
-static int blk_log_dump_pdu(struct trace_seq *s, const struct trace_entry *ent)
+static void blk_log_dump_pdu(struct trace_seq *s, const struct trace_entry *ent)
 {
 	const unsigned char *pdu_buf;
 	int pdu_len;
-	int i, end, ret;
+	int i, end;
 
 	pdu_buf = pdu_start(ent);
 	pdu_len = te_blk_io_trace(ent)->pdu_len;
 
 	if (!pdu_len)
-		return 1;
+		return;
 
 	/* find the last zero that needs to be printed */
 	for (end = pdu_len - 1; end >= 0; end--)
@@ -1188,119 +1188,107 @@ static int blk_log_dump_pdu(struct trace_seq *s, const struct trace_entry *ent)
 			break;
 	end++;
 
-	if (!trace_seq_putc(s, '('))
-		return 0;
+	trace_seq_putc(s, '(');
 
 	for (i = 0; i < pdu_len; i++) {
 
-		ret = trace_seq_printf(s, "%s%02x",
-				       i == 0 ? "" : " ", pdu_buf[i]);
-		if (!ret)
-			return ret;
+		trace_seq_printf(s, "%s%02x",
+				 i == 0 ? "" : " ", pdu_buf[i]);
 
 		/*
 		 * stop when the rest is just zeroes and indicate so
 		 * with a ".." appended
 		 */
-		if (i == end && end != pdu_len - 1)
-			return trace_seq_puts(s, " ..) ");
+		if (i == end && end != pdu_len - 1) {
+			trace_seq_puts(s, " ..) ");
+			return;
+		}
 	}
 
-	return trace_seq_puts(s, ") ");
+	trace_seq_puts(s, ") ");
 }
 
-static int blk_log_generic(struct trace_seq *s, const struct trace_entry *ent)
+static void blk_log_generic(struct trace_seq *s, const struct trace_entry *ent)
 {
 	char cmd[TASK_COMM_LEN];
 
 	trace_find_cmdline(ent->pid, cmd);
 
 	if (t_action(ent) & BLK_TC_ACT(BLK_TC_PC)) {
-		int ret;
-
-		ret = trace_seq_printf(s, "%u ", t_bytes(ent));
-		if (!ret)
-			return 0;
-		ret = blk_log_dump_pdu(s, ent);
-		if (!ret)
-			return 0;
-		return trace_seq_printf(s, "[%s]\n", cmd);
+		trace_seq_printf(s, "%u ", t_bytes(ent));
+		blk_log_dump_pdu(s, ent);
+		trace_seq_printf(s, "[%s]\n", cmd);
 	} else {
 		if (t_sec(ent))
-			return trace_seq_printf(s, "%llu + %u [%s]\n",
+			trace_seq_printf(s, "%llu + %u [%s]\n",
 						t_sector(ent), t_sec(ent), cmd);
-		return trace_seq_printf(s, "[%s]\n", cmd);
+		else
+			trace_seq_printf(s, "[%s]\n", cmd);
 	}
 }
 
-static int blk_log_with_error(struct trace_seq *s,
+static void blk_log_with_error(struct trace_seq *s,
 			      const struct trace_entry *ent)
 {
 	if (t_action(ent) & BLK_TC_ACT(BLK_TC_PC)) {
-		int ret;
-
-		ret = blk_log_dump_pdu(s, ent);
-		if (ret)
-			return trace_seq_printf(s, "[%d]\n", t_error(ent));
-		return 0;
+		blk_log_dump_pdu(s, ent);
+		trace_seq_printf(s, "[%d]\n", t_error(ent));
 	} else {
 		if (t_sec(ent))
-			return trace_seq_printf(s, "%llu + %u [%d]\n",
-						t_sector(ent),
-						t_sec(ent), t_error(ent));
-		return trace_seq_printf(s, "%llu [%d]\n",
-					t_sector(ent), t_error(ent));
+			trace_seq_printf(s, "%llu + %u [%d]\n",
+					 t_sector(ent),
+					 t_sec(ent), t_error(ent));
+		else
+			trace_seq_printf(s, "%llu [%d]\n",
+					 t_sector(ent), t_error(ent));
 	}
 }
 
-static int blk_log_remap(struct trace_seq *s, const struct trace_entry *ent)
+static void blk_log_remap(struct trace_seq *s, const struct trace_entry *ent)
 {
 	struct blk_io_trace_remap r = { .device_from = 0, };
 
 	get_pdu_remap(ent, &r);
-	return trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
-				t_sector(ent), t_sec(ent),
-				MAJOR(r.device_from), MINOR(r.device_from),
-				(unsigned long long)r.sector_from);
+	trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
+			 t_sector(ent), t_sec(ent),
+			 MAJOR(r.device_from), MINOR(r.device_from),
+			 (unsigned long long)r.sector_from);
 }
 
-static int blk_log_plug(struct trace_seq *s, const struct trace_entry *ent)
+static void blk_log_plug(struct trace_seq *s, const struct trace_entry *ent)
 {
 	char cmd[TASK_COMM_LEN];
 
 	trace_find_cmdline(ent->pid, cmd);
 
-	return trace_seq_printf(s, "[%s]\n", cmd);
+	trace_seq_printf(s, "[%s]\n", cmd);
 }
 
-static int blk_log_unplug(struct trace_seq *s, const struct trace_entry *ent)
+static void blk_log_unplug(struct trace_seq *s, const struct trace_entry *ent)
 {
 	char cmd[TASK_COMM_LEN];
 
 	trace_find_cmdline(ent->pid, cmd);
 
-	return trace_seq_printf(s, "[%s] %llu\n", cmd, get_pdu_int(ent));
+	trace_seq_printf(s, "[%s] %llu\n", cmd, get_pdu_int(ent));
 }
 
-static int blk_log_split(struct trace_seq *s, const struct trace_entry *ent)
+static void blk_log_split(struct trace_seq *s, const struct trace_entry *ent)
 {
 	char cmd[TASK_COMM_LEN];
 
 	trace_find_cmdline(ent->pid, cmd);
 
-	return trace_seq_printf(s, "%llu / %llu [%s]\n", t_sector(ent),
-				get_pdu_int(ent), cmd);
+	trace_seq_printf(s, "%llu / %llu [%s]\n", t_sector(ent),
+			 get_pdu_int(ent), cmd);
 }
 
-static int blk_log_msg(struct trace_seq *s, const struct trace_entry *ent)
+static void blk_log_msg(struct trace_seq *s, const struct trace_entry *ent)
 {
-	int ret;
 	const struct blk_io_trace *t = te_blk_io_trace(ent);
 
-	ret = trace_seq_putmem(s, t + 1, t->pdu_len);
-	if (ret)
-		return trace_seq_putc(s, '\n');
-	return ret;
+	trace_seq_putmem(s, t + 1, t->pdu_len);
+	trace_seq_putc(s, '\n');
 }
 
 /*
@@ -1339,7 +1327,7 @@ static void blk_tracer_reset(struct trace_array *tr)
 
 static const struct {
 	const char *act[2];
-	int	   (*print)(struct trace_seq *s, const struct trace_entry *ent);
+	void	   (*print)(struct trace_seq *s, const struct trace_entry *ent);
 } what2act[] = {
 	[__BLK_TA_QUEUE]	= {{  "Q", "queue" },	   blk_log_generic },
 	[__BLK_TA_BACKMERGE]	= {{  "M", "backmerge" },  blk_log_generic },
@@ -1364,7 +1352,6 @@ static enum print_line_t print_one_line(struct trace_iterator *iter,
 	struct trace_seq *s = &iter->seq;
 	const struct blk_io_trace *t;
 	u16 what;
-	int ret;
 	bool long_act;
 	blk_log_action_t *log_action;
 
@@ -1374,21 +1361,18 @@ static enum print_line_t print_one_line(struct trace_iterator *iter,
 	log_action = classic ? &blk_log_action_classic : &blk_log_action;
 
 	if (t->action == BLK_TN_MESSAGE) {
-		ret = log_action(iter, long_act ? "message" : "m");
-		if (ret)
-			ret = blk_log_msg(s, iter->ent);
-		goto out;
+		log_action(iter, long_act ? "message" : "m");
+		blk_log_msg(s, iter->ent);
 	}
 
 	if (unlikely(what == 0 || what >= ARRAY_SIZE(what2act)))
-		ret = trace_seq_printf(s, "Unknown action %x\n", what);
+		trace_seq_printf(s, "Unknown action %x\n", what);
 	else {
-		ret = log_action(iter, what2act[what].act[long_act]);
-		if (ret)
-			ret = what2act[what].print(s, iter->ent);
+		log_action(iter, what2act[what].act[long_act]);
+		what2act[what].print(s, iter->ent);
 	}
-out:
-	return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+
+	return trace_handle_return(s);
 }
 
 static enum print_line_t blk_trace_event_print(struct trace_iterator *iter,
@@ -1397,7 +1381,7 @@ static enum print_line_t blk_trace_event_print(struct trace_iterator *iter,
 	return print_one_line(iter, false);
 }
 
-static int blk_trace_synthesize_old_trace(struct trace_iterator *iter)
+static void blk_trace_synthesize_old_trace(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	struct blk_io_trace *t = (struct blk_io_trace *)iter->ent;
@@ -1407,18 +1391,18 @@ static int blk_trace_synthesize_old_trace(struct trace_iterator *iter)
 		.time     = iter->ts,
 	};
 
-	if (!trace_seq_putmem(s, &old, offset))
-		return 0;
-	return trace_seq_putmem(s, &t->sector,
-				sizeof(old) - offset + t->pdu_len);
+	trace_seq_putmem(s, &old, offset);
+	trace_seq_putmem(s, &t->sector,
+			 sizeof(old) - offset + t->pdu_len);
 }
 
 static enum print_line_t
 blk_trace_event_print_binary(struct trace_iterator *iter, int flags,
 			     struct trace_event *event)
 {
-	return blk_trace_synthesize_old_trace(iter) ?
-			TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+	blk_trace_synthesize_old_trace(iter);
+
+	return trace_handle_return(&iter->seq);
 }
 
 static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
-- 
2.1.1


