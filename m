Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaCKGne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:43:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:35916 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbaCKGnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:43:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,629,1389772800"; 
   d="scan'208";a="470010151"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] tools, perf: Add asprintf replacement
Date: Mon, 10 Mar 2014 23:43:24 -0700
Message-Id: <1394520204-22613-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

asprintf corrupts memory on some older glibc versions.
Provide a replacement. This fixes various segfaults
with --branch-history on older Fedoras.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Makefile.perf   |  1 +
 tools/perf/util/asprintf.c | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)
 create mode 100644 tools/perf/util/asprintf.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 1f7ec48..5174fb9 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -373,6 +373,7 @@ LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
+LIB_OBJS += $(OUTPUT)util/asprintf.o
 LIB_OBJS += $(OUTPUT)util/data.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
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
1.8.5.3

