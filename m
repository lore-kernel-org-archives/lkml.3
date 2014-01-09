Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaAIOBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:01:41 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35559 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaAIOBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:01:19 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/8] tools include: Move perf's bug.h to a generic place
Date: Thu,  9 Jan 2014 23:00:54 +0900
Message-Id: <1389276059-8829-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1389276059-8829-1-git-send-email-namhyung@kernel.org>
References: <1389276059-8829-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that it can be shared with others like libtraceevent.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/include/asm/bug.h           |   23 +++++++++++++++++++++++
 tools/perf/Makefile.perf          |    2 +-
 tools/perf/util/include/asm/bug.h |   22 ----------------------
 3 files changed, 24 insertions(+), 23 deletions(-)
 create mode 100644 tools/include/asm/bug.h
 delete mode 100644 tools/perf/util/include/asm/bug.h

diff --git a/tools/include/asm/bug.h b/tools/include/asm/bug.h
new file mode 100644
index 000000000000..eca78df7b8f2
--- /dev/null
+++ b/tools/include/asm/bug.h
@@ -0,0 +1,23 @@
+#ifndef _TOOLS_ASM_BUG_H
+#define _TOOLS_ASM_BUG_H
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
+#endif /* _TOOLS_ASM_BUG_H */
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 6be06767da7b..87d7726cee2d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -226,7 +226,7 @@ LIB_H += util/include/linux/string.h
 LIB_H += util/include/linux/types.h
 LIB_H += util/include/linux/linkage.h
 LIB_H += util/include/asm/asm-offsets.h
-LIB_H += util/include/asm/bug.h
+LIB_H += ../include/asm/bug.h
 LIB_H += util/include/asm/byteorder.h
 LIB_H += util/include/asm/hweight.h
 LIB_H += util/include/asm/swab.h
diff --git a/tools/perf/util/include/asm/bug.h b/tools/perf/util/include/asm/bug.h
deleted file mode 100644
index 7fcc6810adc2..000000000000
--- a/tools/perf/util/include/asm/bug.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef _PERF_ASM_GENERIC_BUG_H
-#define _PERF_ASM_GENERIC_BUG_H
-
-#define __WARN_printf(arg...)	do { fprintf(stderr, arg); } while (0)
-
-#define WARN(condition, format...) ({		\
-	int __ret_warn_on = !!(condition);	\
-	if (unlikely(__ret_warn_on))		\
-		__WARN_printf(format);		\
-	unlikely(__ret_warn_on);		\
-})
-
-#define WARN_ONCE(condition, format...)	({	\
-	static int __warned;			\
-	int __ret_warn_once = !!(condition);	\
-						\
-	if (unlikely(__ret_warn_once))		\
-		if (WARN(!__warned, format)) 	\
-			__warned = 1;		\
-	unlikely(__ret_warn_once);		\
-})
-#endif
-- 
1.7.9.2

