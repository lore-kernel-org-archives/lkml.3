Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaAMUyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:54:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40402 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaAMUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 27/38] tools include: Move perf's bug.h to a generic place
Date: Mon, 13 Jan 2014 17:47:28 -0300
Message-Id: <1389646059-24881-28-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

So that it can be shared with others like libtraceevent.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389276059-8829-4-git-send-email-namhyung@kernel.org
[ Added the new header to tools/perf/MANIFEST ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/asm/bug.h           | 23 +++++++++++++++++++++++
 tools/perf/MANIFEST               |  1 +
 tools/perf/Makefile.perf          |  2 +-
 tools/perf/util/include/asm/bug.h | 22 ----------------------
 4 files changed, 25 insertions(+), 23 deletions(-)
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
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 285f28f7f821..4e535354f162 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -4,6 +4,7 @@ tools/lib/traceevent
 tools/lib/lk
 tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
+tools/include/asm/bug.h
 tools/include/linux/compiler.h
 include/linux/const.h
 include/linux/perf_event.h
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
1.8.1.4

