Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3EINcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:32:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab3EINcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:32:51 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/9] perf tools: Add precise object to interface sysfs precise
Date: Thu,  9 May 2013 15:32:17 +0200
Message-Id: <1368106344-23383-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding precise util object to get maximum value for
perf_event_attr::precise_ip. The value is exported
via sysfs file '/sys/devices/cpu/precise'.

The interface is:
  int perf_precise__get(void)

Returns:
  maximum value allowed for perf_event_attr::precise_ip
  -1 if we failed to read the sysfs attribute or
     sysfs attribute is not found (supported)

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile       |  1 +
 tools/perf/util/precise.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/util.h    |  3 +++
 3 files changed, 48 insertions(+)
 create mode 100644 tools/perf/util/precise.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 55b42b2..477e7bf 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -361,6 +361,7 @@ LIB_OBJS += $(OUTPUT)util/rblist.o
 LIB_OBJS += $(OUTPUT)util/intlist.o
 LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
+LIB_OBJS += $(OUTPUT)util/precise.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/util/precise.c b/tools/perf/util/precise.c
new file mode 100644
index 0000000..70fcba0
--- /dev/null
+++ b/tools/perf/util/precise.c
@@ -0,0 +1,44 @@
+
+#include <linux/kernel.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <stdio.h>
+#include "sysfs.h"
+#include "util.h"
+
+/*
+ * Returns maximum value allowed for
+ * perf_event_attr::precise_ip, and:
+ * -1 if we failed to read the sysfs attribute or
+ *    sysfs attribute is not found (supported)
+ */
+int perf_precise__get(void)
+{
+	static int precise = -1;
+	struct stat st;
+	char path[PATH_MAX];
+
+	if (precise != -1)
+		return precise;
+
+	scnprintf(path, PATH_MAX, "%s/devices/cpu/precise",
+		  sysfs_find_mountpoint());
+
+	if (!lstat(path, &st)) {
+		FILE *file;
+
+		file = fopen(path, "r");
+		if (!file)
+			return -1;
+
+		if (1 != fscanf(file, "%d", &precise))
+			pr_debug("failed to read precise info\n");
+
+		fclose(file);
+	} else
+		/* Return -1 if there's no sysfs precise support. */
+		return -1;
+
+	return precise;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7a484c9..deeeb54 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -276,4 +276,7 @@ extern unsigned int page_size;
 
 struct winsize;
 void get_term_dimensions(struct winsize *ws);
+
+int perf_precise__get(void);
+
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.7.11.7

