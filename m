Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3LKMn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:43:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:55397 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab3LKMnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:43:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="422887647"
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
Subject: [PATCH v0 67/71] perf tools: Add Intel PT instruction decoder
Date: Wed, 11 Dec 2013 14:37:19 +0200
Message-Id: <1386765443-26966-68-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add support for decoding instructions for Intel
Processor Trace.  The kernel x86 instruction
decoder is used for this.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Makefile.perf                           |  18 +-
 .../util/intel-pt-decoder/intel-pt-insn-decoder.c  | 224 +++++++++++++++++++++
 .../util/intel-pt-decoder/intel-pt-insn-decoder.h  |  67 ++++++
 3 files changed, 308 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
 create mode 100644 tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index a006fac..77310c0 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -85,6 +85,7 @@ INSTALL = install
 FLEX    = flex
 BISON   = bison
 STRIP   = strip
+AWK     = awk
 
 LK_DIR          = $(srctree)/tools/lib/lk/
 TRACE_EVENT_DIR = $(srctree)/tools/lib/traceevent/
@@ -295,6 +296,7 @@ LIB_H += util/vdso.h
 LIB_H += util/tsc.h
 LIB_H += util/itrace.h
 LIB_H += util/intel-pt-decoder/intel-pt-pkt-decoder.h
+LIB_H += util/intel-pt-decoder/intel-pt-insn-decoder.h
 LIB_H += ui/helpline.h
 LIB_H += ui/progress.h
 LIB_H += ui/util.h
@@ -376,6 +378,7 @@ LIB_OBJS += $(OUTPUT)util/data.o
 LIB_OBJS += $(OUTPUT)util/tsc.o
 LIB_OBJS += $(OUTPUT)util/itrace.o
 LIB_OBJS += $(OUTPUT)util/intel-pt-decoder/intel-pt-pkt-decoder.o
+LIB_OBJS += $(OUTPUT)util/intel-pt-decoder/intel-pt-insn-decoder.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
@@ -660,6 +663,18 @@ $(OUTPUT)tests/python-use.o: tests/python-use.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+inat_tables_script = ../../arch/x86/tools/gen-insn-attr-x86.awk
+inat_tables_maps = ../../arch/x86/lib/x86-opcode-map.txt
+
+$(OUTPUT)util/intel-pt-decoder/inat-tables.c: $(inat_tables_script) $(inat_tables_maps)
+	$(QUIET_GEN)$(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
+
+$(OUTPUT)util/intel-pt-decoder/inat.c:
+	$(QUIET_GEN)cp ../../arch/x86/lib/inat.c $(OUTPUT)util/intel-pt-decoder/inat.c
+
+$(OUTPUT)util/intel-pt-decoder/intel-pt-insn-decoder.o: util/intel-pt-decoder/intel-pt-insn-decoder.c ../../arch/x86/include/asm/insn.h ../../arch/x86/lib/insn.c $(OUTPUT)util/intel-pt-decoder/inat.c $(OUTPUT)util/intel-pt-decoder/inat-tables.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -I../../arch/x86/include -I$(OUTPUT)util/intel-pt-decoder -I../../arch/x86/lib $<
+
 $(OUTPUT)ui/setup.o: ui/setup.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DLIBDIR='"$(libdir_SQ)"' $<
 
@@ -885,7 +900,8 @@ config-clean:
 clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean config-clean
 	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf
-	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
+	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex* \
+		$(OUTPUT)util/intel-pt-decoder/inat.c $(OUTPUT)util/intel-pt-decoder/inat-tables.c
 	$(call QUIET_CLEAN, Documentation)
 	@$(MAKE) -C Documentation O=$(OUTPUT) clean >/dev/null
 	$(python-clean)
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
new file mode 100644
index 0000000..3a3c378
--- /dev/null
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
@@ -0,0 +1,224 @@
+/*
+ * intel_pt_insn_decoder.c: Intel Processor Trace support
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
+#include <string.h>
+#include <endian.h>
+#include <byteswap.h>
+
+#define unlikely(cond) (cond)
+
+#include <asm/insn.h>
+
+#include "inat.c"
+#include <insn.c>
+
+#include "intel-pt-insn-decoder.h"
+
+/* Based on branch_type() from perf_event_intel_lbr.c */
+static void intel_pt_insn_decoder(struct insn *insn,
+				  struct intel_pt_insn *intel_pt_insn)
+{
+	enum intel_pt_insn_op op = INTEL_PT_OP_OTHER;
+	enum intel_pt_insn_branch branch = INTEL_PT_BR_NO_BRANCH;
+	int ext;
+
+	if (insn_is_avx(insn)) {
+		intel_pt_insn->op = INTEL_PT_OP_OTHER;
+		intel_pt_insn->branch = INTEL_PT_BR_NO_BRANCH;
+		intel_pt_insn->length = insn->length;
+		return;
+	}
+
+	switch (insn->opcode.bytes[0]) {
+	case 0xf:
+		switch (insn->opcode.bytes[1]) {
+		case 0x05: /* syscall */
+		case 0x34: /* sysenter */
+			op = INTEL_PT_OP_SYSCALL;
+			branch = INTEL_PT_BR_INDIRECT;
+			break;
+		case 0x07: /* sysret */
+		case 0x35: /* sysexit */
+			op = INTEL_PT_OP_SYSRET;
+			branch = INTEL_PT_BR_INDIRECT;
+			break;
+		case 0x80 ... 0x8f: /* jcc */
+			op = INTEL_PT_OP_JCC;
+			branch = INTEL_PT_BR_CONDITIONAL;
+			break;
+		default:
+			break;
+		}
+		break;
+	case 0x70 ... 0x7f: /* jcc */
+		op = INTEL_PT_OP_JCC;
+		branch = INTEL_PT_BR_CONDITIONAL;
+		break;
+	case 0xc2: /* near ret */
+	case 0xc3: /* near ret */
+	case 0xca: /* far ret */
+	case 0xcb: /* far ret */
+		op = INTEL_PT_OP_RET;
+		branch = INTEL_PT_BR_INDIRECT;
+		break;
+	case 0xcf: /* iret */
+		op = INTEL_PT_OP_IRET;
+		branch = INTEL_PT_BR_INDIRECT;
+		break;
+	case 0xcc ... 0xce: /* int */
+		op = INTEL_PT_OP_INT;
+		branch = INTEL_PT_BR_INDIRECT;
+		break;
+	case 0xe8: /* call near rel */
+		op = INTEL_PT_OP_CALL;
+		branch = INTEL_PT_BR_UNCONDITIONAL;
+		break;
+	case 0x9a: /* call far absolute */
+		op = INTEL_PT_OP_CALL;
+		branch = INTEL_PT_BR_INDIRECT;
+		break;
+	case 0xe0 ... 0xe2: /* loop */
+		op = INTEL_PT_OP_LOOP;
+		branch = INTEL_PT_BR_CONDITIONAL;
+		break;
+	case 0xe3: /* jcc */
+		op = INTEL_PT_OP_JCC;
+		branch = INTEL_PT_BR_CONDITIONAL;
+		break;
+	case 0xe9: /* jmp */
+	case 0xeb: /* jmp */
+		op = INTEL_PT_OP_JMP;
+		branch = INTEL_PT_BR_UNCONDITIONAL;
+		break;
+	case 0xea: /* far jmp */
+		op = INTEL_PT_OP_JMP;
+		branch = INTEL_PT_BR_INDIRECT;
+		break;
+	case 0xff: /* call near absolute, call far absolute ind */
+		ext = (insn->modrm.bytes[0] >> 3) & 0x7;
+		switch (ext) {
+		case 2: /* near ind call */
+		case 3: /* far ind call */
+			op = INTEL_PT_OP_CALL;
+			branch = INTEL_PT_BR_INDIRECT;
+			break;
+		case 4:
+		case 5:
+			op = INTEL_PT_OP_JMP;
+			branch = INTEL_PT_BR_INDIRECT;
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+
+	intel_pt_insn->op = op;
+	intel_pt_insn->branch = branch;
+	intel_pt_insn->length = insn->length;
+
+	if (branch == INTEL_PT_BR_CONDITIONAL ||
+	    branch == INTEL_PT_BR_UNCONDITIONAL) {
+#if __BYTE_ORDER == __BIG_ENDIAN
+		switch (insn->immediate.nbytes) {
+		case 1:
+			intel_pt_insn->rel = insn->immediate.value;
+			break;
+		case 2:
+			intel_pt_insn->rel =
+					bswap_16((short)insn->immediate.value);
+			break;
+		case 4:
+			intel_pt_insn->rel = bswap_32(insn->immediate.value);
+			break;
+		}
+#else
+		intel_pt_insn->rel = insn->immediate.value;
+#endif
+	}
+}
+
+int intel_pt_get_insn(const unsigned char *buf, size_t len, int x86_64,
+		      struct intel_pt_insn *intel_pt_insn)
+{
+	struct insn insn;
+	unsigned char sbuf[MAX_INSN_SIZE];
+
+	if (len < MAX_INSN_SIZE) {
+		memset(sbuf, 0, MAX_INSN_SIZE);
+		memcpy(sbuf, buf, len);
+		buf = sbuf;
+	}
+	insn_init(&insn, buf, x86_64);
+	insn_get_length(&insn);
+	if (!insn_complete(&insn) || insn.length > len)
+		return -1;
+	intel_pt_insn_decoder(&insn, intel_pt_insn);
+	if (insn.length < INTEL_PT_INSN_DBG_BUF_SZ)
+		memcpy(intel_pt_insn->buf, buf, insn.length);
+	else
+		memcpy(intel_pt_insn->buf, buf, INTEL_PT_INSN_DBG_BUF_SZ);
+	return 0;
+}
+
+const char *branch_name[] = {
+	[INTEL_PT_OP_OTHER]	= "Other",
+	[INTEL_PT_OP_CALL]	= "Call",
+	[INTEL_PT_OP_RET]	= "Ret",
+	[INTEL_PT_OP_JCC]	= "Jcc",
+	[INTEL_PT_OP_JMP]	= "Jmp",
+	[INTEL_PT_OP_LOOP]	= "Loop",
+	[INTEL_PT_OP_IRET]	= "IRet",
+	[INTEL_PT_OP_INT]	= "Int",
+	[INTEL_PT_OP_SYSCALL]	= "Syscall",
+	[INTEL_PT_OP_SYSRET]	= "Sysret",
+};
+
+const char *intel_pt_insn_name(enum intel_pt_insn_op op)
+{
+	return branch_name[op];
+}
+
+int intel_pt_insn_desc(const struct intel_pt_insn *intel_pt_insn, char *buf,
+		       size_t buf_len)
+{
+	switch (intel_pt_insn->branch) {
+	case INTEL_PT_BR_CONDITIONAL:
+	case INTEL_PT_BR_UNCONDITIONAL:
+		return snprintf(buf, buf_len, "%s %s%d",
+				intel_pt_insn_name(intel_pt_insn->op),
+				intel_pt_insn->rel > 0 ? "+" : "",
+				intel_pt_insn->rel);
+	case INTEL_PT_BR_NO_BRANCH:
+	case INTEL_PT_BR_INDIRECT:
+		return snprintf(buf, buf_len, "%s",
+				intel_pt_insn_name(intel_pt_insn->op));
+	default:
+		break;
+	}
+	return 0;
+}
+
+size_t intel_pt_insn_max_size(void)
+{
+	return MAX_INSN_SIZE;
+}
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.h b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.h
new file mode 100644
index 0000000..593ab37
--- /dev/null
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.h
@@ -0,0 +1,67 @@
+/*
+ * intel_pt_insn_decoder.h: Intel Processor Trace support
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
+#ifndef INCLUDE__INTEL_PT_INSN_DECODER_H__
+#define INCLUDE__INTEL_PT_INSN_DECODER_H__
+
+#include <stddef.h>
+#include <stdint.h>
+
+#define INTEL_PT_INSN_DESC_MAX		32
+#define INTEL_PT_INSN_DBG_BUF_SZ	16
+
+enum intel_pt_insn_op {
+	INTEL_PT_OP_OTHER,
+	INTEL_PT_OP_CALL,
+	INTEL_PT_OP_RET,
+	INTEL_PT_OP_JCC,
+	INTEL_PT_OP_JMP,
+	INTEL_PT_OP_LOOP,
+	INTEL_PT_OP_IRET,
+	INTEL_PT_OP_INT,
+	INTEL_PT_OP_SYSCALL,
+	INTEL_PT_OP_SYSRET,
+};
+
+enum intel_pt_insn_branch {
+	INTEL_PT_BR_NO_BRANCH,
+	INTEL_PT_BR_INDIRECT,
+	INTEL_PT_BR_CONDITIONAL,
+	INTEL_PT_BR_UNCONDITIONAL,
+};
+
+struct intel_pt_insn {
+	enum intel_pt_insn_op		op;
+	enum intel_pt_insn_branch	branch;
+	int				length;
+	int32_t				rel;
+	unsigned char			buf[INTEL_PT_INSN_DBG_BUF_SZ];
+};
+
+int intel_pt_get_insn(const unsigned char *buf, size_t len, int x86_64,
+		      struct intel_pt_insn *intel_pt_insn);
+
+const char *intel_pt_insn_name(enum intel_pt_insn_op op);
+
+int intel_pt_insn_desc(const struct intel_pt_insn *intel_pt_insn, char *buf,
+		       size_t buf_len);
+
+size_t intel_pt_insn_max_size(void);
+
+#endif
-- 
1.8.5.1

