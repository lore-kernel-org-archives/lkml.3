Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934764AbaKNBSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:18:04 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:43207 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934904AbaKNBOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:14:15 -0500
Message-Id: <20141114011411.530216306@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 13 Nov 2014 20:12:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [RFC][PATCH 09/23 v4] tracing/probes: Do not use return value of trace_seq_printf()
References: <20141114011244.256115061@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0009-tracing-probes-Do-not-use-return-value-of-trace_seq_.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The functions trace_seq_printf() and friends will soon not have a return
value and will only be a void function. Use trace_seq_has_overflowed()
instead to know if the trace_seq operations succeeded or not.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_probe.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index d4b9fc22cd27..b983b2fd2ca1 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -40,7 +40,8 @@ const char *reserved_field_names[] = {
 int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s, const char *name,	\
 				void *data, void *ent)			\
 {									\
-	return trace_seq_printf(s, " %s=" fmt, name, *(type *)data);	\
+	trace_seq_printf(s, " %s=" fmt, name, *(type *)data);		\
+	return !trace_seq_has_overflowed(s);				\
 }									\
 const char PRINT_TYPE_FMT_NAME(type)[] = fmt;				\
 NOKPROBE_SYMBOL(PRINT_TYPE_FUNC_NAME(type));
@@ -61,10 +62,11 @@ int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s, const char *name,
 	int len = *(u32 *)data >> 16;
 
 	if (!len)
-		return trace_seq_printf(s, " %s=(fault)", name);
+		trace_seq_printf(s, " %s=(fault)", name);
 	else
-		return trace_seq_printf(s, " %s=\"%s\"", name,
-					(const char *)get_loc_data(data, ent));
+		trace_seq_printf(s, " %s=\"%s\"", name,
+				 (const char *)get_loc_data(data, ent));
+	return !trace_seq_has_overflowed(s);
 }
 NOKPROBE_SYMBOL(PRINT_TYPE_FUNC_NAME(string));
 
-- 
2.1.1


