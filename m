Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbaAGDBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:01:30 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42663 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612AbaAGDAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:00:17 -0500
X-AuditID: 9c930179-b7c89ae000006438-b7-52cb6dbd06f6
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/5] tools lib traceevent: Add WARN and WARN_ONCE macros
Date: Tue,  7 Jan 2014 12:00:08 +0900
Message-Id: <1389063612-18173-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
References: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They're copied from the perf code and will be used to print error
message during trace_seq_printf() and friends.

Suggested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-utils.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/lib/traceevent/event-utils.h b/tools/lib/traceevent/event-utils.h
index e76c9acb92cd..5dc0aec5ab50 100644
--- a/tools/lib/traceevent/event-utils.h
+++ b/tools/lib/traceevent/event-utils.h
@@ -38,6 +38,28 @@ void __vdie(const char *fmt, ...);
 void __vwarning(const char *fmt, ...);
 void __vpr_stat(const char *fmt, ...);
 
+#define likely(x)	__builtin_expect(!!(x), 1)
+#define unlikely(x)	__builtin_expect(!!(x), 0)
+
+#define __WARN_printf(arg...)	do { fprintf(stderr, arg); } while (0)
+
+#define WARN(condition, format...) ({		\
+	int __ret_warn_on = !!(condition);	\
+	if (unlikely(__ret_warn_on))		\
+		__WARN_printf(format);		\
+	unlikely(__ret_warn_on);		\
+})
+
+#define WARN_ONCE(condition, format...)	({	\
+	static int __warned;			\
+	int __ret_warn_once = !!(condition);	\
+						\
+	if (unlikely(__ret_warn_once))		\
+		if (WARN(!__warned, format)) 	\
+			__warned = 1;		\
+	unlikely(__ret_warn_once);		\
+})
+
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\
 	typeof(y) _min2 = (y);			\
-- 
1.7.11.7

