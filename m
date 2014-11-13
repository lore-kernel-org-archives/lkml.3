Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbaKMCHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:07:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:60944 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740AbaKMCFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:05:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,372,1413270000"; 
   d="scan'208";a="636113989"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/10] tools, perf: Add asprintf replacement
Date: Wed, 12 Nov 2014 18:05:28 -0800
Message-Id: <1415844328-4884-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

asprintf corrupts memory on some older glibc versions.
Provide a replacement. This fixes various segfaults
with --branch-history on older Fedoras.

v2: Remove bogus hunk.
    Support arbitrary size (Geert Uytterhoeven)
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Makefile.perf    |  1 +
 tools/perf/builtin-report.c |  1 +
 tools/perf/util/asprintf.c  | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)
 create mode 100644 tools/perf/util/asprintf.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index aecf61dc..9db4ff1 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -395,6 +395,7 @@ LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
+LIB_OBJS += $(OUTPUT)util/asprintf.o
 LIB_OBJS += $(OUTPUT)util/data.o
 LIB_OBJS += $(OUTPUT)util/tsc.o
 LIB_OBJS += $(OUTPUT)util/cloexec.o
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fb272ff..493f011 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -762,6 +762,7 @@ repeat:
 	}
 	if (branch_call_mode) {
 		callchain_param.branch_callstack = 1;
+		callchain_param.key = CCKEY_ADDRESS;
 		symbol_conf.use_callchain = true;
 		callchain_register_param(&callchain_param);
 		if (sort_order == NULL)
diff --git a/tools/perf/util/asprintf.c b/tools/perf/util/asprintf.c
new file mode 100644
index 0000000..6177ee8
--- /dev/null
+++ b/tools/perf/util/asprintf.c
@@ -0,0 +1,34 @@
+/* Replacement for asprintf as it's buggy in older glibc versions */
+#include <stdio.h>
+#include <stdarg.h>
+#include <stdlib.h>
+#include <string.h>
+
+int vasprintf(char **str, const char *fmt, va_list ap)
+{
+	va_list ao;
+	char buf[1024];
+	int len;
+
+	va_copy(ao, ap);
+	len = vsnprintf(buf, sizeof(buf), fmt, ap);
+	*str = malloc(len + 1);
+	if (!*str)
+		return -1;
+	if ((size_t)len < sizeof(buf)) {
+		strcpy(*str, buf);
+		return len;
+	}
+	return vsnprintf(*str, len + 1, fmt, ao);
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

