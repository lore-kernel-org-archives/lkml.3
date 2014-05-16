Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbaEPRFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:05:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:64303 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400AbaEPRFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:05:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1068,1389772800"; 
   d="scan'208";a="540329418"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 9/9] tools, perf: Add asprintf replacement
Date: Fri, 16 May 2014 10:05:38 -0700
Message-Id: <1400259938-3436-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400259938-3436-1-git-send-email-andi@firstfloor.org>
References: <1400259938-3436-1-git-send-email-andi@firstfloor.org>
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
index 2baf61c..55a315b 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -372,6 +372,7 @@ LIB_OBJS += $(OUTPUT)util/vdso.o
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
1.9.0

