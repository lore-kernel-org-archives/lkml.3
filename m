Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaGaRXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:23:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:11686 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbaGaRXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:23:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,773,1400050800"; 
   d="scan'208";a="551935823"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        mingo@kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 9/9] tools, perf: Add asprintf replacement
Date: Thu, 31 Jul 2014 10:17:09 -0700
Message-Id: <1406827029-7991-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406827029-7991-1-git-send-email-andi@firstfloor.org>
References: <1406827029-7991-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

asprintf corrupts memory on some older glibc versions.
Provide a replacement. This fixes various segfaults
with --branch-history on older Fedoras.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Makefile.perf    |  1 +
 tools/perf/builtin-report.c |  3 ++-
 tools/perf/util/asprintf.c  | 28 ++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/util/asprintf.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 2240974..9a6f2a6 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -374,6 +374,7 @@ LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
+LIB_OBJS += $(OUTPUT)util/asprintf.o
 LIB_OBJS += $(OUTPUT)util/data.o
 LIB_OBJS += $(OUTPUT)util/tsc.o
 LIB_OBJS += $(OUTPUT)util/cloexec.o
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c2dc8f27..2f1ac37 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -742,7 +742,8 @@ repeat:
 		callchain_param.branch_callstack = 1;
 		callchain_param.key = CCKEY_ADDRESS;
 		symbol_conf.use_callchain = true;
-		callchain_register_param(&callchain_param);
+		if (callchain_register_param(&callchain_param) < 0)
+			pr_err("Cannot register callchain parameters");
 		if (sort_order == default_sort_order)
 			sort_order = "srcline,symbol,dso";
 		branch_mode = 0;
diff --git a/tools/perf/util/asprintf.c b/tools/perf/util/asprintf.c
new file mode 100644
index 0000000..9aafaca
--- /dev/null
+++ b/tools/perf/util/asprintf.c
@@ -0,0 +1,28 @@
+/* Replacement for asprintf as it's buggy in older glibc versions */
+#include <stdio.h>
+#include <stdarg.h>
+#include <stdlib.h>
+#include <string.h>
+
+int vasprintf(char **str, const char *fmt, va_list ap)
+{
+	char buf[1024];
+	int len = vsnprintf(buf, sizeof buf, fmt, ap);
+
+	*str = malloc(len + 1);
+	if (!*str)
+		return -1;
+	strcpy(*str, buf);
+	return len;
+}
+
+int asprintf(char **str, const char *fmt, ...)
+{
+	va_list ap;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = vasprintf(str, fmt, ap);
+	va_end(ap);
+	return ret;
+}
-- 
1.9.3

