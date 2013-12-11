Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab3LKMnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:43:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:23006 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab3LKMn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:43:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442370268"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 68/71] perf tools: Add Intel PT log
Date: Wed, 11 Dec 2013 14:37:20 +0200
Message-Id: <1386765443-26966-69-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a facility to log Intel Processor Trace
decoding.  The log is intended for debugging
purposes only.  If the log file exists, then
logging proceeds otherwise there is no
logging.

The log file name is "intel_pt.log" and is
opened in the current directory.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Makefile.perf                        |   2 +
 tools/perf/util/intel-pt-decoder/intel-pt-log.c | 119 ++++++++++++++++++++++++
 tools/perf/util/intel-pt-decoder/intel-pt-log.h |  52 +++++++++++
 3 files changed, 173 insertions(+)
 create mode 100644 tools/perf/util/intel-pt-decoder/intel-pt-log.c
 create mode 100644 tools/perf/util/intel-pt-decoder/intel-pt-log.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 77310c0..e4faac1 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -297,6 +297,7 @@ LIB_H += util/tsc.h
 LIB_H += util/itrace.h
 LIB_H += util/intel-pt-decoder/intel-pt-pkt-decoder.h
 LIB_H += util/intel-pt-decoder/intel-pt-insn-decoder.h
+LIB_H += util/intel-pt-decoder/intel-pt-log.h
 LIB_H += ui/helpline.h
 LIB_H += ui/progress.h
 LIB_H += ui/util.h
@@ -379,6 +380,7 @@ LIB_OBJS += $(OUTPUT)util/tsc.o
 LIB_OBJS += $(OUTPUT)util/itrace.o
 LIB_OBJS += $(OUTPUT)util/intel-pt-decoder/intel-pt-pkt-decoder.o
 LIB_OBJS += $(OUTPUT)util/intel-pt-decoder/intel-pt-insn-decoder.o
+LIB_OBJS += $(OUTPUT)util/intel-pt-decoder/intel-pt-log.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-log.c b/tools/perf/util/intel-pt-decoder/intel-pt-log.c
new file mode 100644
index 0000000..b47d6c1
--- /dev/null
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-log.c
@@ -0,0 +1,119 @@
+/*
+ * intel_pt_log.c: Intel Processor Trace support
+ * Copyright (c) 2013, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+#include <inttypes.h>
+#include <stdarg.h>
+#include <string.h>
+
+#include "intel-pt-log.h"
+#include "intel-pt-insn-decoder.h"
+
+#include "intel-pt-pkt-decoder.h"
+
+#define MAX_LOG_NAME 256
+
+static FILE *f;
+static char log_name[MAX_LOG_NAME];
+
+void intel_pt_log_set_name(const char *name)
+{
+	strncpy(log_name, name, MAX_LOG_NAME - 5);
+	strcat(log_name, ".log");
+}
+
+static void intel_pt_print_data(const unsigned char *buf, int len, uint64_t pos,
+				int indent)
+{
+	int i;
+
+	for (i = 0; i < indent; i++)
+		fprintf(f, " ");
+
+	fprintf(f, "  %08" PRIx64 ": ", pos);
+	for (i = 0; i < len; i++)
+		fprintf(f, " %02x", buf[i]);
+	for (; i < 16; i++)
+		fprintf(f, "   ");
+	fprintf(f, " ");
+}
+
+static int intel_pt_log_open(void)
+{
+	if (f)
+		return 0;
+
+	if (!log_name[0])
+		return -1;
+
+	f = fopen(log_name, "r");
+	if (!f)
+		return -1;
+
+	fclose(f);
+
+	f = fopen(log_name, "w+");
+	if (!f)
+		return -1;
+
+	return 0;
+}
+
+void intel_pt_log_packet(const struct intel_pt_pkt *packet, int pkt_len,
+			 uint64_t pos, const unsigned char *buf)
+{
+	char desc[INTEL_PT_PKT_DESC_MAX];
+
+	if (intel_pt_log_open())
+		return;
+
+	intel_pt_print_data(buf, pkt_len, pos, 0);
+	intel_pt_pkt_desc(packet, desc, INTEL_PT_PKT_DESC_MAX);
+	fprintf(f, "%s\n", desc);
+}
+
+void intel_pt_log_insn(struct intel_pt_insn *intel_pt_insn, uint64_t ip)
+{
+	char desc[INTEL_PT_INSN_DESC_MAX];
+	size_t len = intel_pt_insn->length;
+
+	if (intel_pt_log_open())
+		return;
+
+	if (len > INTEL_PT_INSN_DBG_BUF_SZ)
+		len = INTEL_PT_INSN_DBG_BUF_SZ;
+	intel_pt_print_data(intel_pt_insn->buf, len, ip, 8);
+	if (intel_pt_insn_desc(intel_pt_insn, desc, INTEL_PT_INSN_DESC_MAX) > 0)
+		fprintf(f, "%s\n", desc);
+	else
+		fprintf(f, "Bad instruction!\n");
+}
+
+void intel_pt_log(const char *fmt, ...)
+{
+	va_list args;
+
+	if (intel_pt_log_open())
+		return;
+
+	va_start(args, fmt);
+	vfprintf(f, fmt, args);
+	va_end(args);
+}
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-log.h b/tools/perf/util/intel-pt-decoder/intel-pt-log.h
new file mode 100644
index 0000000..58c72c9
--- /dev/null
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-log.h
@@ -0,0 +1,52 @@
+/*
+ * intel_pt_log.h: Intel Processor Trace support
+ * Copyright (c) 2013, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#ifndef INCLUDE__INTEL_PT_LOG_H__
+#define INCLUDE__INTEL_PT_LOG_H__
+
+#include <stdint.h>
+#include <inttypes.h>
+
+struct intel_pt_pkt;
+
+void intel_pt_log_set_name(const char *name);
+
+void intel_pt_log_packet(const struct intel_pt_pkt *packet, int pkt_len,
+			 uint64_t pos, const unsigned char *buf);
+
+struct intel_pt_insn;
+
+void intel_pt_log_insn(struct intel_pt_insn *intel_pt_insn, uint64_t ip);
+
+__attribute__((format(printf, 1, 2)))
+void intel_pt_log(const char *fmt, ...);
+
+#define x64_fmt "0x%" PRIx64
+
+static inline void intel_pt_log_at(const char *msg, uint64_t u)
+{
+	intel_pt_log("%s at " x64_fmt "\n", msg, u);
+}
+
+static inline void intel_pt_log_to(const char *msg, uint64_t u)
+{
+	intel_pt_log("%s to " x64_fmt "\n", msg, u);
+}
+
+#endif
-- 
1.8.5.1

