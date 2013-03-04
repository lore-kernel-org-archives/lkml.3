Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3CDKNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:13:17 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:6281 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3CDKNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:13:16 -0500
Message-ID: <51347359.80709@huawei.com>
Date: Mon, 4 Mar 2013 18:11:37 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] printk/tracing: rework console tracing
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0a2bd3ad03fc9acd125f4eeb585a1e09027a182a Mon Sep 17 00:00:00 2001
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Date: Mon, 4 Mar 2013 17:45:10 +0800
Subject: [PATCH] printk/tracing: rework console tracing

commit 7ff9554bb(printk: convert byte-buffer to variable-length record buffer)
removed start and end parameters in call_console_drivers,
but those parameters still exists in include/trace/events/printk.h.

Without start and end parameters handling, printk tracing became more simple as:
    trace_console(text, len);

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 include/trace/events/printk.h |   25 ++++++-------------------
 kernel/printk.c               |    2 +-
 2 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/include/trace/events/printk.h b/include/trace/events/printk.h
index 94ec79c..c008bc9 100644
--- a/include/trace/events/printk.h
+++ b/include/trace/events/printk.h
@@ -6,31 +6,18 @@

 #include <linux/tracepoint.h>

-TRACE_EVENT_CONDITION(console,
-	TP_PROTO(const char *log_buf, unsigned start, unsigned end,
-		 unsigned log_buf_len),
+TRACE_EVENT(console,
+	TP_PROTO(const char *text, size_t len),

-	TP_ARGS(log_buf, start, end, log_buf_len),
-
-	TP_CONDITION(start != end),
+	TP_ARGS(text, len),

 	TP_STRUCT__entry(
-		__dynamic_array(char, msg, end - start + 1)
+		__dynamic_array(char, msg, len + 1)
 	),

 	TP_fast_assign(
-		if ((start & (log_buf_len - 1)) > (end & (log_buf_len - 1))) {
-			memcpy(__get_dynamic_array(msg),
-			       log_buf + (start & (log_buf_len - 1)),
-			       log_buf_len - (start & (log_buf_len - 1)));
-			memcpy((char *)__get_dynamic_array(msg) +
-			       log_buf_len - (start & (log_buf_len - 1)),
-			       log_buf, end & (log_buf_len - 1));
-		} else
-			memcpy(__get_dynamic_array(msg),
-			       log_buf + (start & (log_buf_len - 1)),
-			       end - start);
-		((char *)__get_dynamic_array(msg))[end - start] = 0;
+		memcpy(__get_dynamic_array(msg), text, len);
+		((char *)__get_dynamic_array(msg))[len] = 0;
 	),

 	TP_printk("%s", __get_str(msg))
diff --git a/kernel/printk.c b/kernel/printk.c
index 0b31715..e1c687d 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1266,7 +1266,7 @@ static void call_console_drivers(int level, const char *text, size_t len)
 {
 	struct console *con;

-	trace_console(text, 0, len, len);
+	trace_console(text, len);

 	if (level >= console_loglevel && !ignore_loglevel)
 		return;
-- 
1.7.9.7


