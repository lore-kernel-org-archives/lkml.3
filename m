Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbaIPAUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:20:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:23844 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758995AbaIPAT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:19:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,531,1406617200"; 
   d="scan'208";a="600070665"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 8/8] tools, perf: Add asprintf replacement
Date: Mon, 15 Sep 2014 16:54:33 -0700
Message-Id: <1410825273-7054-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410825273-7054-1-git-send-email-andi@firstfloor.org>
References: <1410825273-7054-1-git-send-email-andi@firstfloor.org>
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
index 95e832b..255fe0b 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -376,6 +376,7 @@ LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
+LIB_OBJS += $(OUTPUT)util/asprintf.o
 LIB_OBJS += $(OUTPUT)util/data.o
 LIB_OBJS += $(OUTPUT)util/tsc.o
 LIB_OBJS += $(OUTPUT)util/cloexec.o
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f72a6c4..9bb6194 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -754,7 +754,8 @@ repeat:
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

