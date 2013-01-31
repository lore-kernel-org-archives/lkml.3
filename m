Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3AaODe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 09:03:34 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54086 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab3AaOD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 09:03:28 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 2/2] perf: add new perf uncore command
Date: Thu, 31 Jan 2013 14:54:39 +0100
Message-Id: <1359640479-5289-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359640479-5289-1-git-send-email-eranian@google.com>
References: <1359640479-5289-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf uncore command measures key metrics at the processor
socket level for select Intel processors. It operates like
perf stat, except it prints metrics directly instead of raw
event values. The metrics are printed at regular time intervals.

The defined metrics are:
  - memory bandwidth (Nehalem, Westmere, SandyBridge-EP)
  - PCIe bandwidth (SandyBridge-EP)
  - QPI bandwidth (SandyBridge-EP)
  - C-state residency (SandyBridge-EP)

Running perf uncore requires root pivilege as all the measurements
are done in system-wide mode. Note that metrics are collected
at the socket-level and at all privilege level.

The command provides options to modify the unit of the metrics
(default: MB/s for bandwidth).

Example on Nehalem:
 # perf uncore
 #------------------------------
 #           Socket0           |
 #------------------------------
 #        RAM Bandwidth        |
 #            Wr             Rd|
 #          MB/s           MB/s|
 #------------------------------
         4954.99       14897.29
         4953.97       14894.56
         4947.52       14874.97

To make plotting easier, the output can be augmented with a timestamp:

 # perf uncore -T
 #----------------------------------------
 #         |           Socket0           |
 #         |------------------------------
 #   Time  |        RAM Bandwidth        |
 #    in   |            Wr             Rd|
 #   secs  |          MB/s           MB/s|
 #----------------------------------------
          1        4952.50       14890.49
          2        4955.55       14900.19
          3        4949.13       14879.60
          4        4954.66       14896.26

The code is split between generic layer (builtin-uncore.c) and
an arch specific layer (arch/*/util/uncore.c). All events are
hardcoded because they don't change for a given processor and
metric computation requires combining multiple events.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-uncore.txt |   88 ++++
 tools/perf/Makefile                      |    1 +
 tools/perf/arch/x86/Makefile             |    1 +
 tools/perf/arch/x86/util/uncore.c        |  539 ++++++++++++++++++++++
 tools/perf/builtin-uncore.c              |  739 ++++++++++++++++++++++++++++++
 tools/perf/builtin.h                     |    1 +
 tools/perf/command-list.txt              |    1 +
 tools/perf/perf.c                        |    1 +
 tools/perf/util/uncore.h                 |   56 +++
 9 files changed, 1427 insertions(+)
 create mode 100644 tools/perf/Documentation/perf-uncore.txt
 create mode 100644 tools/perf/arch/x86/util/uncore.c
 create mode 100644 tools/perf/builtin-uncore.c
 create mode 100644 tools/perf/util/uncore.h

diff --git a/tools/perf/Documentation/perf-uncore.txt b/tools/perf/Documentation/perf-uncore.txt
new file mode 100644
index 0000000..f87f86b
--- /dev/null
+++ b/tools/perf/Documentation/perf-uncore.txt
@@ -0,0 +1,88 @@
+perf-uncore(1)
+===============
+
+NAME
+----
+perf-uncore - Collect processor socket-level metrics
+
+SYNOPSIS
+--------
+[verse]
+'perf uncore' [-M metrics] [-m unit] [-L] <command>
+
+DESCRIPTION
+-----------
+This command runs a binary and gathers system-wide socket-level performance counter
+statistics. Depending on the perf_event security settings, it may be required to
+have super user privliege to run this command as it operates in system-wide monitoring
+mode.  This command may not work on all processors.
+
+The list of predefined metrics is dependent on the host processor. Use the -L option
+to list the metrics available. By default all the metrics are measured across all the
+processor sockets. It is possible to restrict the certain metrics using the -M option.
+
+The output operates in a way similar to vmstat. One line of output per second. The
+interval can be adjusted with the -I option.
+
+It is possible to add a Time column to make it easier to plot the values later on.
+The -T option enables the Time column.
+
+OPTIONS
+-------
+<command>...::
+	Any command you can specify in a shell. To control the duration of the
+	measurement without influencing too much, the sleep command can be used.
+
+-M::
+--metrics metrics[, metrics]::
+        Comma separated list of metrics to measure. Metrics' name can be obtained
+	via the -L option.
+-m::
+--mem-unit unit::
+        Modify the bandwidth metric unit. The default bandwidth metric is Megabytes
+        (1000*1000 bytes). Bytes (B) and bits (b) metrics are supported.  The available
+        metrics are: KB, MB, GB, KiB, MiB, GiB, Kb, Mb, Gb, Kib, Mib, Gib.
+        The metrics are obviously case sensitive.
+
+-T::
+--time::
+        Add a Time column expressed in seconds (default: off).
+
+-v::
+--verbose::
+        be more verbose (show counter open errors, etc)
+
+-o file::
+--output file::
+	Print the output into the designated file.
+
+--append::
+	Append to the output file designated with the -o option. Ignored if -o is not specified.
+
+--log-fd::
+	Log output to fd, instead of stderr.  Complementary to --output, and mutually exclusive
+	with it.  --append may be used here.  Examples:
+	3>results  perf stat --log-fd 3          -- $cmd
+	3>>results perf stat --log-fd 3 --append -- $cmd
+
+EXAMPLES
+--------
+
+[verse]
+$ perf uncore -T sleep 5
+#----------------------------------------
+#         |           Socket0           |
+#         |------------------------------
+#   Time  |        RAM Bandwidth        |
+#    in   |            Wr             Rd|
+#   secs  |          MB/s           MB/s|
+#----------------------------------------
+         1        1254.23        3781.76
+         2        1265.19        3813.70
+         3        1261.62        3803.81
+         4        1265.28        3814.09
+         5        1253.54        3780.13
+
+SEE ALSO
+--------
+linkperf:perf-stat[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a84021a..cd1f9fa 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -520,6 +520,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
+BUILTIN_OBJS += $(OUTPUT)builtin-uncore.o
 
 PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 815841c..597303d 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -6,3 +6,4 @@ ifndef NO_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/uncore.o
diff --git a/tools/perf/arch/x86/util/uncore.c b/tools/perf/arch/x86/util/uncore.c
new file mode 100644
index 0000000..b720d74
--- /dev/null
+++ b/tools/perf/arch/x86/util/uncore.c
@@ -0,0 +1,539 @@
+/*
+ * builtin-uncore.c: measure key metrics at processor socket level
+ *
+ * Contributed by: Stephane Eranian <eranian@google.com>
+ *
+ * Released under the GPL v2
+ */
+#include "../../perf.h"
+#include "../../util/util.h"
+#include "../../util/event.h"
+#include "../../util/evlist.h"
+#include "../../util/evsel.h"
+#include "../../util/uncore.h"
+
+extern int uncore_init_metrics(void);
+
+static int x86_family;
+static int x86_model;
+
+static void
+print_bw_hdr(FILE *output, const struct uncore_metric *m, int line,
+	     const char *type)
+{
+	int len = hdr_width(m);
+	int f, r;
+	int mlen;
+
+	len--;
+
+	switch (line) {
+		case 2:
+			mlen = strlen(type);
+			f = (len - 10 - mlen) / 2;
+			r = (len - 10 - mlen) % 2;
+			fprintf(output, "%*s Bandwidth%*s",
+				mlen + f, type,
+				f+1+r, "|");
+			break;
+		case 3:
+			f = (len - 6*2 - 1) / 2;
+			fprintf(output, "%*s %*s|",
+				6 + f, "Wr",
+				6 + f, "Rd");
+			break;
+		case 4:
+			/* use 7 instead of 5 to align with values */
+			f = (len - 5*2 -1) / 2;
+			fprintf(output, "%*s/s %*s/s|",
+				3 + f, uncore_cfg.mem_unit->name,
+				3 + f, uncore_cfg.mem_unit->name);
+			break;
+		default:
+			fprintf(output, "%*s", len, "|");
+	}
+}
+
+/*
+ * nrd = number of events for read bw
+ * nwr = number of events for write bw
+ * csize = event unit size (e.g., cacheline size)
+ */
+static void
+print_bw(FILE *output, const struct uncore_metric *m,
+	 int cpu, int nrd, int nwr, int csize)
+{
+	struct uncore_metric_event *e;
+	struct perf_evsel *evsel;
+	double rd_bw = 0, wr_bw = 0;
+	uint64_t rd, wr;
+	uint64_t unit;
+	int i, f, r;
+	int len = hdr_width(m);
+
+	evsel = &m->evts[0].evsel;
+
+	unit = uncore_cfg.mem_unit->num_bits;
+	/* events here are all counting bytes */
+	unit >>= 3;
+
+	/*
+	 * len is inclusive of border
+	 * no column marker for values, so cut short by 1
+	 * to keep alignment
+	 */
+	len--;
+
+	/*
+	 * 7 = .00 + .00
+	 */
+	f = (len - 6 - 1) / 2;
+	r = (len - 6 - 1) % 2;
+
+	e = m->evts;
+	rd = wr = 0;
+	for (i = 0; i < nrd; i++) {
+		evsel = &e[i].evsel;
+		rd += evsel->counts->cpu[cpu].val;
+	}
+	for (i = nrd; i < (nrd + nwr); i++) {
+		evsel = &e[i].evsel;
+		wr += evsel->counts->cpu[cpu].val;
+	}
+
+	if (uncore_cfg.interval) {
+		wr_bw = (double)wr * csize / (uncore_cfg.interval * unit);
+		rd_bw = (double)rd * csize / (uncore_cfg.interval * unit);
+	}
+
+	fprintf(output, "%*.2f ", 3+f, wr_bw);
+	fprintf(output, "%*.2f %*s", 3+f, rd_bw, r, r ? " " : "");
+}
+
+
+/* cannot be const attr.type modified */
+static struct uncore_metric_event nhm_mem[] = {
+	[0] = CFG(uncore, 0x0163, nhm_unc::UNC_DRAM_READ_CAS:CH0),
+	[1] = CFG(uncore, 0x0463, nhm_unc::UNC_DRAM_READ_CAS:CH1),
+	[2] = CFG(uncore, 0x1063, nhm_unc::UNC_DRAM_READ_CAS:CH2),
+	[3] = CFG(uncore, 0x0164, nhm_unc::UNC_DRAM_WRITE_CAS:CH0),
+	[4] = CFG(uncore, 0x0464, nhm_unc::UNC_DRAM_WRITE_CAS:CH1),
+	[5] = CFG(uncore, 0x1064, nhm_unc::UNC_DRAM_WRITE_CAS:CH2),
+};
+
+static void
+print_nhm_mem_bw_hdr(FILE *output, const struct uncore_metric *m, int line)
+{
+	print_bw_hdr(output, m, line, "RAM");
+}
+
+static void
+print_nhm_mem_bw(FILE *output, const struct uncore_metric *m, int cpu)
+{
+	print_bw(output, m, cpu, 3, 3, 64);
+}
+
+static const struct uncore_metric uncore_nhm_mem_bw = {
+	.name = "mem_bw",
+	.desc = "Nehalem MEM Bandwidth",
+	.print = print_nhm_mem_bw,
+	.print_hdr = print_nhm_mem_bw_hdr,
+	.evts = nhm_mem,
+	.nr_evts = ARRAY_SIZE(nhm_mem),
+	.hdr_width = 30,
+	.num_cols = 2,
+};
+
+/* cannot be const attr.type modified */
+static struct uncore_metric_event snbep_mem[] = {
+	[0] = CFG(uncore_imc_0, 0x0304, snbep_unc_imc0::UNC_M_CAS_COUNT:RD),
+	[1] = CFG(uncore_imc_1, 0x0304, snbep_unc_imc1::UNC_M_CAS_COUNT:RD),
+	[2] = CFG(uncore_imc_0, 0x0c04, snbep_unc_imc0::UNC_M_CAS_COUNT:WR),
+	[3] = CFG(uncore_imc_1, 0x0c04, snbep_unc_imc1::UNC_M_CAS_COUNT:WR),
+};
+
+static void
+print_snbep_mem_bw_hdr(FILE *output, const struct uncore_metric *m, int line)
+{
+	print_bw_hdr(output, m, line, "RAM");
+}
+
+static void
+print_snbep_mem_bw(FILE *output, const struct uncore_metric *m, int cpu)
+{
+	return print_bw(output, m, cpu, 2, 2, 64);
+}
+
+static const struct uncore_metric uncore_snbep_mem_bw = {
+	.name = "mem_bw",
+	.desc = "SNB-EP MEM Bandwidth",
+	.print = print_snbep_mem_bw,
+	.print_hdr = print_snbep_mem_bw_hdr,
+	.evts = snbep_mem,
+	.nr_evts = ARRAY_SIZE(snbep_mem),
+	.hdr_width = 30,
+	.num_cols = 2,
+};
+
+/* cannot be const attr.type modified */
+static struct uncore_metric_event snbep_qpi[] = {
+	[0] = CFG(uncore_qpi_0, 0x0201, snbep_unc_qpi0::UNC_Q_RXL_FLITS_G0:DATA),
+	[1] = CFG(uncore_qpi_1, 0x0201, snbep_unc_qpi1::UNC_Q_RXL_FLITS_G0:DATA),
+	[2] = CFG(uncore_qpi_0, 0x0200, snbep_unc_qpi0::UNC_Q_TXL_FLITS_G0:DATA),
+	[3] = CFG(uncore_qpi_1, 0x0200, snbep_unc_qpi1::UNC_Q_TXL_FLITS_G0:DATA),
+};
+
+static void
+print_snbep_qpi_bw_hdr(FILE *output, const struct uncore_metric *m, int line)
+{
+	print_bw_hdr(output, m, line, "QPI");
+}
+
+static void
+print_snbep_qpi_bw(FILE *output, const struct uncore_metric *m, int cpu)
+{
+	return print_bw(output, m, cpu, 2, 2, 8);
+}
+
+static const struct uncore_metric uncore_snbep_qpi_bw = {
+	.name = "qpi_bw",
+	.desc = "SNB-EP QPI Bandwidth",
+	.print = print_snbep_qpi_bw,
+	.print_hdr = print_snbep_qpi_bw_hdr,
+	.evts = snbep_qpi,
+	.nr_evts = ARRAY_SIZE(snbep_qpi),
+	.hdr_width = 30,
+	.num_cols = 2,
+};
+
+/* cannot be const because attr.type modified */
+static struct uncore_metric_event snbep_pcie[] = {
+	[0]  = CFG(uncore_cbox_0, 0x135, snbep_unc_cbo0::unc_c_tor_inserts:opcode:OPC_PCIRDCUR),
+	[1]  = CFG(uncore_cbox_0, 0x135, snbep_unc_cbo0::unc_c_tor_inserts:opcode:OPC_PCIPRD),
+	[2]  = CFG(uncore_cbox_0, 0x135, snbep_unc_cbo0::unc_c_tor_inserts:opcode:OPC_PCINSRD),
+	[3]  = CFG(uncore_cbox_1, 0x135, snbep_unc_cbo1::unc_c_tor_inserts:opcode:OPC_PCIRDCUR),
+	[4]  = CFG(uncore_cbox_1, 0x135, snbep_unc_cbo1::unc_c_tor_inserts:opcode:OPC_PCIPRD),
+	[5]  = CFG(uncore_cbox_1, 0x135, snbep_unc_cbo1::unc_c_tor_inserts:opcode:OPC_PCINSRD),
+	[6]  = CFG(uncore_cbox_2, 0x135, snbep_unc_cbo2::unc_c_tor_inserts:opcode:OPC_PCIRDCUR),
+	[7]  = CFG(uncore_cbox_2, 0x135, snbep_unc_cbo2::unc_c_tor_inserts:opcode:OPC_PCIPRD),
+	[8]  = CFG(uncore_cbox_2, 0x135, snbep_unc_cbo2::unc_c_tor_inserts:opcode:OPC_PCINSRD),
+	[9]  = CFG(uncore_cbox_3, 0x135, snbep_unc_cbo3::unc_c_tor_inserts:opcode:OPC_PCIRDCUR),
+	[10] = CFG(uncore_cbox_3, 0x135, snbep_unc_cbo3::unc_c_tor_inserts:opcode:OPC_PCIPRD),
+	[11] = CFG(uncore_cbox_3, 0x135, snbep_unc_cbo3::unc_c_tor_inserts:opcode:OPC_PCINSRD),
+	[12] = CFG(uncore_cbox_4, 0x135, snbep_unc_cbo4::unc_c_tor_inserts:opcode:OPC_PCIRDCUR),
+	[13] = CFG(uncore_cbox_4, 0x135, snbep_unc_cbo4::unc_c_tor_inserts:opcode:OPC_PCIPRD),
+	[14] = CFG(uncore_cbox_4, 0x135, snbep_unc_cbo4::unc_c_tor_inserts:opcode:OPC_PCINSRD),
+	[15] = CFG(uncore_cbox_5, 0x135, snbep_unc_cbo5::unc_c_tor_inserts:opcode:OPC_PCIRDCUR),
+	[16] = CFG(uncore_cbox_5, 0x135, snbep_unc_cbo5::unc_c_tor_inserts:opcode:OPC_PCIPRD),
+	[17] = CFG(uncore_cbox_5, 0x135, snbep_unc_cbo5::unc_c_tor_inserts:opcode:OPC_PCINSRD),
+	[18] = CFG(uncore_cbox_6, 0x135, snbep_unc_cbo6::unc_c_tor_inserts:opcode:OPC_PCIRDCUR),
+	[19] = CFG(uncore_cbox_6, 0x135, snbep_unc_cbo6::unc_c_tor_inserts:opcode:OPC_PCIPRD),
+	[20] = CFG(uncore_cbox_6, 0x135, snbep_unc_cbo6::unc_c_tor_inserts:opcode:OPC_PCINSRD),
+	[21] = CFG(uncore_cbox_7, 0x135, snbep_unc_cbo7::unc_c_tor_inserts:opcode:OPC_PCIRDCUR),
+	[22] = CFG(uncore_cbox_7, 0x135, snbep_unc_cbo7::unc_c_tor_inserts:opcode:OPC_PCIPRD),
+	[23] = CFG(uncore_cbox_7, 0x135, snbep_unc_cbo7::unc_c_tor_inserts:opcode:OPC_PCINSRD),
+
+	[24] = CFG(uncore_cbox_0, 0x135, snbep_unc_cbo0::unc_c_tor_inserts:opcode:OPC_PCIITOM),
+	[25] = CFG(uncore_cbox_0, 0x135, snbep_unc_cbo0::unc_c_tor_inserts:opcode:OPC_PCIWILF),
+	[26] = CFG(uncore_cbox_0, 0x135, snbep_unc_cbo0::unc_c_tor_inserts:opcode:OPC_PCINSWR),
+	[27] = CFG(uncore_cbox_1, 0x135, snbep_unc_cbo1::unc_c_tor_inserts:opcode:OPC_PCIITOM),
+	[28] = CFG(uncore_cbox_1, 0x135, snbep_unc_cbo1::unc_c_tor_inserts:opcode:OPC_PCIWILF),
+	[29] = CFG(uncore_cbox_1, 0x135, snbep_unc_cbo1::unc_c_tor_inserts:opcode:OPC_PCINSWR),
+	[30] = CFG(uncore_cbox_2, 0x135, snbep_unc_cbo2::unc_c_tor_inserts:opcode:OPC_PCIITOM),
+	[31] = CFG(uncore_cbox_2, 0x135, snbep_unc_cbo2::unc_c_tor_inserts:opcode:OPC_PCIWILF),
+	[32] = CFG(uncore_cbox_2, 0x135, snbep_unc_cbo2::unc_c_tor_inserts:opcode:OPC_PCINSWR),
+	[33] = CFG(uncore_cbox_3, 0x135, snbep_unc_cbo3::unc_c_tor_inserts:opcode:OPC_PCIITOM),
+	[34] = CFG(uncore_cbox_3, 0x135, snbep_unc_cbo3::unc_c_tor_inserts:opcode:OPC_PCIWILF),
+	[35] = CFG(uncore_cbox_3, 0x135, snbep_unc_cbo3::unc_c_tor_inserts:opcode:OPC_PCINSWR),
+	[36] = CFG(uncore_cbox_4, 0x135, snbep_unc_cbo4::unc_c_tor_inserts:opcode:OPC_PCIITOM),
+	[37] = CFG(uncore_cbox_4, 0x135, snbep_unc_cbo4::unc_c_tor_inserts:opcode:OPC_PCIWILF),
+	[38] = CFG(uncore_cbox_4, 0x135, snbep_unc_cbo4::unc_c_tor_inserts:opcode:OPC_PCINSWR),
+	[39] = CFG(uncore_cbox_5, 0x135, snbep_unc_cbo5::unc_c_tor_inserts:opcode:OPC_PCIITOM),
+	[40] = CFG(uncore_cbox_5, 0x135, snbep_unc_cbo5::unc_c_tor_inserts:opcode:OPC_PCIWILF),
+	[41] = CFG(uncore_cbox_5, 0x135, snbep_unc_cbo5::unc_c_tor_inserts:opcode:OPC_PCINSWR),
+	[42] = CFG(uncore_cbox_6, 0x135, snbep_unc_cbo6::unc_c_tor_inserts:opcode:OPC_PCIITOM),
+	[43] = CFG(uncore_cbox_6, 0x135, snbep_unc_cbo6::unc_c_tor_inserts:opcode:OPC_PCIWILF),
+	[44] = CFG(uncore_cbox_6, 0x135, snbep_unc_cbo6::unc_c_tor_inserts:opcode:OPC_PCINSWR),
+	[45] = CFG(uncore_cbox_7, 0x135, snbep_unc_cbo7::unc_c_tor_inserts:opcode:OPC_PCIITOM),
+	[46] = CFG(uncore_cbox_7, 0x135, snbep_unc_cbo7::unc_c_tor_inserts:opcode:OPC_PCIWILF),
+	[47] = CFG(uncore_cbox_7, 0x135, snbep_unc_cbo7::unc_c_tor_inserts:opcode:OPC_PCINSWR),
+};
+
+/*
+ * see justification for this in the comment for fixup_snbep_pcie_config1()
+ */
+static const uint64_t snbep_pcie_config1[] = {
+	[0]  = 0xcf000000,
+	[1]  = 0xca800000,
+	[2]  = 0xf2000000,
+	[3]  = 0xcf000000,
+	[4]  = 0xca800000,
+	[5]  = 0xf2000000,
+	[6]  = 0xcf000000,
+	[7]  = 0xca800000,
+	[8]  = 0xf2000000,
+	[9]  = 0xcf000000,
+	[10] = 0xca800000,
+	[11] = 0xf2000000,
+	[12] = 0xcf000000,
+	[13] = 0xca800000,
+	[14] = 0xf2000000,
+	[15] = 0xcf000000,
+	[16] = 0xca800000,
+	[17] = 0xf2000000,
+	[18] = 0xcf000000,
+	[19] = 0xca800000,
+	[20] = 0xf2000000,
+	[21] = 0xcf000000,
+	[22] = 0xca800000,
+	[23] = 0xf2000000,
+
+	[24] = 0xce000000,
+	[25] = 0xca000000,
+	[26] = 0xf2800000,
+	[27] = 0xce000000,
+	[28] = 0xca000000,
+	[29] = 0xf2800000,
+	[30] = 0xce000000,
+	[31] = 0xca000000,
+	[32] = 0xf2800000,
+	[33] = 0xce000000,
+	[34] = 0xca000000,
+	[35] = 0xf2800000,
+	[36] = 0xce000000,
+	[37] = 0xca000000,
+	[38] = 0xf2800000,
+	[39] = 0xce000000,
+	[40] = 0xca000000,
+	[41] = 0xf2800000,
+	[42] = 0xce000000,
+	[43] = 0xca000000,
+	[44] = 0xf2800000,
+	[45] = 0xce000000,
+	[46] = 0xca000000,
+	[47] = 0xf2800000,
+};
+
+static void
+print_snbep_pcie_bw_hdr(FILE *output, const struct uncore_metric *m, int line)
+{
+	print_bw_hdr(output, m, line, "PCIe");
+}
+
+static void
+print_snbep_pcie_bw(FILE *output, const struct uncore_metric *m, int cpu)
+{
+	return print_bw(output, m, cpu, 24, 24, 64);
+}
+
+static const struct uncore_metric uncore_snbep_pcie_bw = {
+	.name = "pcie_bw",
+	.desc = "SNB-EP PCIe Bandwidth",
+	.print = print_snbep_pcie_bw,
+	.print_hdr = print_snbep_pcie_bw_hdr,
+	.evts = snbep_pcie,
+	.nr_evts = ARRAY_SIZE(snbep_pcie),
+	.hdr_width = 30,
+	.num_cols = 2,
+};
+
+static struct uncore_metric_event snbep_cstate[] = {
+	[0] = CFG(uncore_pcu, 0x0000, snbep_unc_pcu::unc_p_clockticks),
+	[1] = CFG(uncore_pcu, 0x4080, snbep_unc_pcu::UNC_P_POWER_STATE_OCCUPANCY:CORES_C0),
+	[2] = CFG(uncore_pcu, 0xc080, snbep_unc_pcu::UNC_P_POWER_STATE_OCCUPANCY:CORES_C6),
+	[3] = CFG(uncore_pcu, 0x8080, snbep_unc_pcu::UNC_P_POWER_STATE_OCCUPANCY:CORES_C3),
+};
+
+static void
+print_snbep_cstate_hdr(FILE *output, const struct uncore_metric *m, int line)
+{
+	int len = hdr_width(m);
+	int f, r;
+
+	len--;
+
+	switch (line) {
+	case 2:
+		f = (len - 7) / 2;
+		r = (len - 7) % 2;
+		fprintf(output, "%*s%*s",
+			7 + f, "C-state",
+			f+1+r, "|");
+		break;
+	case 3:
+		f = (len - 5*3) / 3;
+		r = (len - 5*3) % 3;
+		fprintf(output, "%*s%*s%*s %*s",
+			5 + f, "C0",
+			5 + f, "C3",
+			5 + f, "C6",
+			r, "|");
+		break;
+	case 4:
+		f = (len - 5*3) / 3;
+		r = (len - 5*3) % 3;
+		fprintf(output, "%*s%*s%*s %*s",
+			5 + f, "%",
+			5 + f, "%",
+			5 + f, "%",
+			r, "|");
+		break;
+	default:
+		fprintf(output, "%*s", len, "|");
+	}
+}
+
+static void
+print_snbep_cstate(FILE *output, const struct uncore_metric *m, int cpu)
+{
+#define SNBEP_NCORES_PER_SOCKET	8
+
+	struct uncore_metric_event *e;
+	struct perf_evsel *evsel;
+	double c0 = 0.0, c6 = 0.0, c3 = 0.0;
+	uint64_t c[4];
+	int i, f, r;
+	int len = hdr_width(m);
+
+	evsel = &m->evts[0].evsel;
+
+	/*
+	 * len is inclusive of border
+	 * no column marker for values, so cut short by 1
+	 * to keep alignment
+	 */
+	len--;
+
+	f = (len - 5*3) / 3;
+	r = (len - 5*3) % 3;
+
+	e = m->evts;
+	for (i = 0; i < 4; i++) {
+		evsel = &e[i].evsel;
+		c[i] = evsel->counts->cpu[cpu].val;
+	}
+	if (c[0] != 0) {
+		c0 = (double)c[1] * 100.0 / c[0] / SNBEP_NCORES_PER_SOCKET;
+		c3 = (double)c[2] * 100.0 / c[0] / SNBEP_NCORES_PER_SOCKET;
+		c6 = (double)c[3] * 100.0 / c[0] / SNBEP_NCORES_PER_SOCKET;
+	}
+
+	fprintf(output, "%*.2f", 5+f, c0);
+	fprintf(output, "%*.2f", 5+f, c3);
+	fprintf(output, "%*.2f %*s", 5+f, c6, r, r ? " " : "");
+}
+
+static const struct uncore_metric uncore_snbep_cstate = {
+	.name = "cstate",
+	.desc = "SNB-EP C-state residency",
+	.print = print_snbep_cstate,
+	.print_hdr = print_snbep_cstate_hdr,
+	.evts = snbep_cstate,
+	.nr_evts = ARRAY_SIZE(snbep_cstate),
+	.hdr_width = 30,
+	.num_cols = 3,
+};
+
+static const struct uncore_metric *snbep_metrics[]={
+	&uncore_snbep_mem_bw,
+	&uncore_snbep_qpi_bw,
+	&uncore_snbep_pcie_bw,
+	&uncore_snbep_cstate,
+	NULL,
+};
+
+static const struct uncore_metric *nhm_metrics[]={
+	&uncore_nhm_mem_bw,
+	NULL,
+};
+
+/*
+ * Prior to gcc-4.6, it was not possible to statically initialize
+ * member of an anon union inside a bigger struct. This happens
+ * with config1 inside perf_event_attr. Here we implement a workaround
+ * which consists in patching in the config1 values at runtime. This is
+ * not pretty but works across the board
+ */
+static void
+fixup_snbep_pcie_config1(void)
+{
+	int i;
+
+	for (i = 0 ; i < uncore_snbep_pcie_bw.nr_evts; i++)
+		snbep_pcie[i].evsel.attr.config1 = snbep_pcie_config1[i];
+}
+
+static inline void
+cpuid(unsigned int op, unsigned int *a, unsigned int *b, unsigned int *c,
+      unsigned int *d)
+{
+  __asm__ __volatile__ (".byte 0x53\n\tcpuid\n\tmovl %%ebx, %%esi\n\t.byte 0x5b"
+			: "=a" (*a),
+			"=S" (*b),
+			"=c" (*c),
+			"=d" (*d)
+			: "a" (op));
+}
+
+static int
+intel_x86_detect(void)
+{
+	unsigned int a, b, c, d;
+	char buffer[64];
+
+	cpuid(0, &a, &b, &c, &d);
+	strncpy(&buffer[0], (char *)(&b), 4);
+	strncpy(&buffer[4], (char *)(&d), 4);
+	strncpy(&buffer[8], (char *)(&c), 4);
+	buffer[12] = '\0';
+
+	/* must be Intel */
+	if (strcmp(buffer, "GenuineIntel"))
+		return -1;
+
+	cpuid(1, &a, &b, &c, &d);
+
+	x86_family = (a >> 8) & 0xf;  // bits 11 - 8
+	x86_model  = (a >> 4) & 0xf;  // Bits  7 - 4
+
+	/* extended family */
+	if (x86_family == 0xf)
+		x86_family += (a >> 20) & 0xff;
+
+	/* extended model */
+	if (x86_family >= 0x6)
+		x86_model += ((a >> 16) & 0xf) << 4;
+
+	return 0;
+}
+
+int uncore_init_metrics(void)
+{
+	if (intel_x86_detect()) {
+		fprintf(stderr, "uncore: only supported on Intel processors for now\n");
+		return -1;
+	}
+
+	if (x86_family != 6) {
+		fprintf(stderr, "uncore: unsupported processor family %d\n", x86_family);
+		return -1;
+	}
+
+	switch (x86_model) {
+	case 26: /* NHM */
+	case 30: /* NHM */
+	case 37: /* WSM */
+	case 44: /* WSM-EP */
+	case 47: /* WSM E7 */
+		uncore_cfg.uncore_metrics = nhm_metrics;
+		break;
+	case 45: /* SNB-EP */
+		uncore_cfg.uncore_metrics = snbep_metrics;
+		fixup_snbep_pcie_config1();
+		break;
+	default:
+		fprintf(stderr, "uncore: unsupported processor model %d\n", x86_model);
+		return -1;
+	}
+	return 0;
+}
diff --git a/tools/perf/builtin-uncore.c b/tools/perf/builtin-uncore.c
new file mode 100644
index 0000000..b050712
--- /dev/null
+++ b/tools/perf/builtin-uncore.c
@@ -0,0 +1,739 @@
+/*
+ * builtin-stat.c
+ *
+ * Builtin stat command: Give a precise performance counters summary
+ * overview about any workload, CPU or specific PID.
+ */
+
+#include "perf.h"
+#include "builtin.h"
+#include "util/util.h"
+#include "util/parse-options.h"
+#include "util/parse-events.h"
+#include "util/event.h"
+#include "util/evlist.h"
+#include "util/evsel.h"
+#include "util/debug.h"
+#include "util/header.h"
+#include "util/cpumap.h"
+#include "util/pmu.h"
+#include "util/cgroup.h"
+#include "util/uncore.h"
+
+#include <locale.h>
+
+#define DEFAULT_SEPARATOR " "
+
+static const struct uncore_mem_unit mem_units[] = {
+	[0]  = { .name = "Kb" , .num_bits = 1000ULL, },
+	[1]  = { .name = "Mb" , .num_bits = 1000 * 1000ULL, },
+	[2]  = { .name = "Gb" , .num_bits = 1000 * 1000 * 1000ULL, },
+	[3]  = { .name = "Kib", .num_bits = 1024ULL, },
+	[4]  = { .name = "Mib", .num_bits = 1024 * 1024ULL, },
+	[5]  = { .name = "Gib", .num_bits = 1024 * 1024 * 1024ULL, },
+	[6]  = { .name = "KB" , .num_bits = 8 * 1000ULL, },
+	[7]  = { .name = "MB" , .num_bits = 8 * 1000 * 1000ULL, },
+	[8]  = { .name = "GB" , .num_bits = 8 * 1000 * 1000 * 1000ULL, },
+	[9]  = { .name = "KiB", .num_bits = 8 * 1024ULL, },
+	[10] = { .name = "MiB", .num_bits = 8 * 1024 * 1024ULL, },
+	[11] = { .name = "GiB", .num_bits = 8 * 1024 * 1024 * 1024ULL, },
+	[12] = { .name = NULL, }, /* end marker */
+};
+#define UNCORE_DFL_MEM_UNIT	7 /* MB */
+
+struct uncore_config uncore_cfg = {
+	.interval = 1,
+	.nr_socks = 1,
+};
+
+static struct perf_evlist		*evsel_list;
+static pid_t				child_pid;
+static const char			*csv_sep			= NULL;
+static bool				csv_output			= false;
+static bool				time_sample			= false;
+static bool				list_metrics			= false;
+static const char			*output_name			= NULL;
+static FILE				*output				= NULL;
+static int				output_fd;
+static int				total_len			= 0;
+static bool				append_file;
+static volatile int			done				= 0;
+static u64				uncore_metric_active		= ~0; /* all */
+static struct timespec			ref_time;
+
+static inline int metric_active(const struct uncore_metric **m)
+{
+	return uncore_metric_active & (1ULL << (m - uncore_cfg.uncore_metrics));
+}
+
+static inline struct cpu_map *perf_evsel__cpus(struct perf_evsel *evsel)
+{
+	return evsel->cpus ? evsel->cpus : evsel_list->cpus;
+}
+
+static inline int perf_evsel__nr_cpus(struct perf_evsel *evsel)
+{
+	return perf_evsel__cpus(evsel)->nr;
+}
+
+static inline void diff_timespec(struct timespec *r, struct timespec *a, struct timespec *b)
+{
+	r->tv_sec = a->tv_sec - b->tv_sec;
+	if (a->tv_nsec < b->tv_nsec) {
+		r->tv_nsec = a->tv_nsec + 1000000000L - b->tv_nsec;
+		r->tv_sec--;
+	} else {
+		r->tv_nsec = a->tv_nsec - b->tv_nsec ;
+	}
+}
+
+static int create_perf_stat_counter(struct perf_evsel *evsel)
+{
+	struct perf_event_attr *attr = &evsel->attr;
+
+	attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
+			    PERF_FORMAT_TOTAL_TIME_RUNNING;
+
+	return perf_evsel__open_per_cpu(evsel, perf_evsel__cpus(evsel));
+}
+
+static int read_counter(struct perf_evsel *counter)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
+		if (__perf_evsel__read_on_cpu(counter, cpu, 0, 1) < 0)
+			return -1;
+	}
+	return 0;
+}
+
+/*
+ * default catch all uncore_init_metrics
+ */
+int uncore_init_metrics(void) __attribute__((weak));
+int uncore_init_metrics(void)
+{
+	return -1;
+}
+
+static void
+uncore_print_filler(int len)
+{
+	int i;
+
+	for (i  = 0 ; i < len; i++)
+		fputc('-', output);
+}
+
+static void
+uncore_print_time_hdr(int line, int prefix_len)
+{
+	switch (line) {
+	case 2:
+		fprintf(output, "%*s%*s", 4 + (prefix_len - 4)/2, "Time",
+			(prefix_len - 4) / 2, "|");
+		break;
+	case 3:
+		fprintf(output, "%*s%*s", 2 + (prefix_len - 2) / 2, "in",
+			(prefix_len - 2) / 2, "|");
+		break;
+	case 4:
+		fprintf(output, "%*s%*s", 4 + (prefix_len - 4)/2, "secs",
+			(prefix_len - 4) / 2, "|");
+		break;
+	default:
+		fprintf(output, "%*s", prefix_len, "|");
+	}
+}
+
+static void print_header(int nr, int len, int prefix_len)
+{
+	const struct uncore_metric **mp;
+	struct perf_evsel *counter;
+	struct cpu_map *cpus;
+	int hdr_lines = 5;
+	int j, cpu, s;
+	int f, r;
+
+	fputc('#', output);
+
+	uncore_print_filler(prefix_len + nr * len);
+
+	fputc('\n', output);
+	fputc('#', output);
+
+	if (time_sample)
+		uncore_print_time_hdr(0, prefix_len);
+
+	counter = list_first_entry(&evsel_list->entries, typeof(*counter), node);
+
+	cpus = counter->cpus;
+	for (cpu = 0; cpu < cpus->nr; cpu++) {
+		s = cpu_map__get_socket(cpus, cpu);
+		f = (len - 6 - 2) / 2;
+		r = (len - 6 - 2) % 2;
+		fprintf(output, "%*s%-2d%*s", 6 + f, "Socket", s, f + r, "|");
+	}
+	fputc('\n', output);
+	fputc('#', output);
+	if (time_sample)
+		uncore_print_time_hdr(1, prefix_len);
+
+	uncore_print_filler(nr * len);
+	fputc('\n', output);
+
+	for (j = 2; j < hdr_lines; j++) {
+		fputc('#', output);
+
+		if (time_sample)
+			uncore_print_time_hdr(j, prefix_len);
+
+		for (cpu = 0 ; cpu < nr; cpu++) {
+			for_each_uncore_metric(mp) {
+				if (!metric_active(mp))
+					continue;
+				(*mp)->print_hdr(output, *mp, j);
+			}
+		}
+		fputc('\n', output);
+	}
+	fputc('#', output);
+	uncore_print_filler(prefix_len + nr * len);
+	fputc('\n', output);
+}
+
+static void print_interval(void)
+{
+	static int print_count;
+	const struct uncore_metric **mp;
+	struct perf_evsel *counter;
+	char prefix[64] = { 0, };
+	int prefix_len = 0;
+	int cpu;
+
+	list_for_each_entry(counter, &evsel_list->entries, node) {
+		read_counter(counter);
+	}
+
+	if (time_sample) {
+		struct timespec ts, rs;
+		clock_gettime(CLOCK_MONOTONIC, &ts);
+		diff_timespec(&rs, &ts, &ref_time);
+		//prefix_len = sprintf(prefix, "%5lu.%09lu ", rs.tv_sec, rs.tv_nsec);
+		prefix_len = sprintf(prefix, "%9lu ", rs.tv_sec);
+	}
+
+	if (!print_count)
+		print_header(uncore_cfg.nr_socks, total_len, prefix_len);
+
+	fputc(' ', output); /* compensate '#' */
+
+	if (time_sample)
+		fprintf(output, "%s", prefix);
+
+	for (cpu = 0 ; cpu < uncore_cfg.nr_socks; cpu++) {
+		for_each_uncore_metric(mp) {
+			if (!metric_active(mp))
+				continue;
+			if ((*mp)->print)
+				(*mp)->print(output, *mp, cpu);
+		}
+	}
+	fputc('\n', output);
+
+	if (++print_count == 25)
+		print_count = 0;
+}
+
+static int run_perf_uncore(int argc, const char **argv)
+{
+	struct perf_evsel *counter;
+	struct timespec ts;
+	int status = 0, ret;
+	int child_ready_pipe[2], go_pipe[2];
+	const bool forks = (argc > 0);
+	char buf;
+
+	ts.tv_sec  = uncore_cfg.interval;
+	ts.tv_nsec = 0;
+
+	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
+		perror("failed to create pipes");
+		return -1;
+	}
+
+	if (forks) {
+		if ((child_pid = fork()) < 0)
+			perror("failed to fork");
+
+		if (!child_pid) {
+			close(child_ready_pipe[0]);
+			close(go_pipe[1]);
+			fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
+
+			/*
+			 * Do a dummy execvp to get the PLT entry resolved,
+			 * so we avoid the resolver overhead on the real
+			 * execvp call.
+			 */
+			execvp("", (char **)argv);
+
+			/*
+			 * Tell the parent we're ready to go
+			 */
+			close(child_ready_pipe[1]);
+
+			/*
+			 * Wait until the parent tells us to go.
+			 */
+			if (read(go_pipe[0], &buf, 1) == -1)
+				perror("unable to read pipe");
+
+			execvp(argv[0], (char **)argv);
+
+			perror(argv[0]);
+			exit(-1);
+		}
+
+		/*
+		 * Wait for the child to be ready to exec.
+		 */
+		close(child_ready_pipe[1]);
+		close(go_pipe[0]);
+		if (read(child_ready_pipe[0], &buf, 1) == -1)
+			perror("unable to read pipe");
+		close(child_ready_pipe[0]);
+	}
+
+	list_for_each_entry(counter, &evsel_list->entries, node) {
+		if (create_perf_stat_counter(counter) < 0) {
+			/*
+			 * PPC returns ENXIO for HW counters until 2.6.37
+			 * (behavior changed with commit b0a873e).
+			 */
+			if (errno == EINVAL || errno == ENOSYS ||
+			    errno == ENOENT || errno == EOPNOTSUPP ||
+			    errno == ENXIO) {
+				if (verbose)
+					ui__warning("%s event is not supported by the kernel.\n",
+						    perf_evsel__name(counter));
+				counter->supported = false;
+				continue;
+			}
+
+			if (errno == EPERM || errno == EACCES) {
+				error("You may not have permission to collect system-wide stats.\n"
+				      "\t Consider tweaking"
+				      " /proc/sys/kernel/perf_event_paranoid or running as root.");
+			} else {
+				error("open_counter returned with %d (%s) for event %s. "
+				      "/bin/dmesg may provide additional information.\n",
+				       errno, strerror(errno),
+				       perf_evsel__name(counter));
+			}
+			if (child_pid != -1)
+				kill(child_pid, SIGTERM);
+
+			pr_err("Not all events could be opened.\n");
+			return -1;
+		}
+		counter->supported = true;
+	}
+
+	/*
+	 * Enable counters and exec the command:
+	 */
+
+	clock_gettime(CLOCK_MONOTONIC, &ref_time);
+
+	if (forks) {
+		close(go_pipe[1]);
+		if (uncore_cfg.interval) {
+			while (!waitpid(child_pid, &status, WNOHANG)) {
+				ret = clock_nanosleep(CLOCK_MONOTONIC, 0, &ts, NULL);
+				if (ret == 0 && uncore_cfg.interval)
+					print_interval();
+			}
+			wait(&status);
+		} else {
+			ret = wait(&status);
+			if (ret > 0 && WEXITSTATUS(status) == 0) {
+				struct timespec rs;
+				clock_gettime(CLOCK_MONOTONIC, &ts);
+				diff_timespec(&rs, &ts, &ref_time);
+				/*
+				 * stash virtual time in interval, so
+				 * ratios are computed
+				 */
+				uncore_cfg.interval = rs.tv_sec;
+
+				print_interval();
+			}
+		}
+		if (WIFSIGNALED(status))
+			psignal(WTERMSIG(status), argv[0]);
+	} else {
+		while(!done) {
+			ret = clock_nanosleep(CLOCK_MONOTONIC, 0, &ts, NULL);
+			if (ret == 0 && uncore_cfg.interval)
+				print_interval();
+		}
+	}
+
+	list_for_each_entry(counter, &evsel_list->entries, node) {
+		perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter), 1);
+	}
+	return WEXITSTATUS(status);
+}
+
+static volatile int signr = -1;
+
+static void skip_signal(int signo)
+{
+	done = 1;
+
+	signr = signo;
+}
+
+static void sig_atexit(void)
+{
+	if (child_pid != -1)
+		kill(child_pid, SIGTERM);
+
+	if (signr == -1)
+		return;
+
+	signal(signr, SIG_DFL);
+	kill(getpid(), signr);
+}
+
+static const char * const uncore_usage[] = {
+	"perf uncore [<options>] [<command>]",
+	NULL
+};
+
+static int
+uncore_init_pmu_type(void)
+{
+	const struct uncore_metric **mp, *m;
+	struct uncore_metric_event *e;
+	struct perf_pmu *pmu = NULL;
+	int j;
+
+	for_each_uncore_metric(mp) {
+		m = *mp;
+		if (!metric_active(mp))
+			continue;
+		e = m->evts;
+
+		for (j = 0; j < m->nr_evts; j++) {
+			/* try reusing the previous pmu struct */
+			if (j == 0 || strcmp(e[j].pmu_name, e[j-1].pmu_name)) {
+				char *s = strdup(e[j].pmu_name);
+				if (!s) {
+					fprintf(stderr, "cannot allocate memory for PMU name %s\n", e[j].pmu_name);
+					return -1;
+				}
+				pmu = perf_pmu__find(s);
+				free(s);
+				if (!pmu) {
+					fprintf(stderr, "cannot determine type for PMU %s\n", e[j].pmu_name);
+					return -1;
+				}
+			}
+
+			if (pmu->cpus == NULL) {
+				fprintf(stderr, "PMU %s has no cpumask\n", e[j].pmu_name);
+				return -1;
+			}
+
+			e[j].evsel.cpus = pmu->cpus;
+			e[j].evsel.attr.type = pmu->type;
+		}
+	}
+	return 0;
+}
+
+static int
+uncore_add_events(struct perf_evlist *evlist)
+{
+	const struct uncore_metric **mp;
+	struct perf_evsel *evsel;
+	struct uncore_metric_event *e;
+	void *addr;
+	size_t sz;
+	int j, ret = -1;
+
+	for_each_uncore_metric(mp) {
+		if (!metric_active(mp))
+			continue;
+
+		total_len += hdr_width(*mp);
+
+		e = (*mp)->evts;
+		for (j = 0; j < (*mp)->nr_evts; j++) {
+			evsel = &e[j].evsel;
+
+			event_attr_init(&evsel->attr);
+
+			uncore_cfg.nr_socks = perf_evsel__nr_cpus(evsel);
+			evsel->name = strdup(e[j].name);
+
+			sz = sizeof(*evsel->counts)
+			   + (uncore_cfg.nr_socks * sizeof(struct perf_counts_values));
+
+			addr = zalloc(sz);
+			if (!addr)
+				goto error;
+
+			evsel->prev_raw_counts =  addr;
+
+			perf_evlist__add(evlist, evsel);
+		}
+	}
+	ret = 0;
+error:
+	return ret;
+
+}
+
+static int
+uncore_setup_evlist(struct perf_evlist *evlist)
+{
+	if (uncore_init_pmu_type())
+		return -1;
+
+	if (uncore_add_events(evlist))
+		return -1;
+
+	perf_evlist__set_leader(evlist);
+
+	return 0;
+}
+
+static void
+uncore_destroy_evlist(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel, *n;
+
+	list_for_each_entry_safe(evsel, n, &evlist->entries, node) {
+		free(evsel->name);
+
+		/* free both raw_counts and prev_raw_counts */
+		free(evsel->prev_raw_counts);
+
+		list_del_init(&evsel->node);
+
+		perf_evsel__exit(evsel);
+	}
+
+}
+
+static void
+print_metrics(void)
+{
+	const struct uncore_metric **mp;
+
+	for_each_uncore_metric(mp) {
+		printf("%s : %s\n", (*mp)->name, (*mp)->desc);
+	}
+}
+
+static int
+parse_mem_unit(const struct option *opt, const char *str, int unset)
+{
+	const struct uncore_mem_unit **mode = (const struct uncore_mem_unit **)opt->value;
+	const struct uncore_mem_unit *m;
+
+	if (unset)
+		return 0;
+
+	/*
+	 * cannot set it twice, -b + --branch-filter for instance
+	 */
+	if (*mode)
+		return -1;
+
+	if (!str)
+		return 0;
+
+	for (m = mem_units; m->name; m++) {
+		if (!strcmp(m->name, str)) {
+			*mode = m;
+			return 0;
+		}
+	}
+	return -1;
+}
+
+static int
+parse_metrics(const struct option *opt, const char *str, int unset)
+{
+	uint64_t *mask = (uint64_t *)opt->value;
+	const struct uncore_metric **mp;
+	char *s, *os = NULL, *p;
+	int ret = -1;
+
+	if (unset)
+		return 0;
+
+	/* no metric = all metrics */
+	if (!str)
+		return -1;
+
+	/* because str is read-only */
+	s = os = strdup(str);
+	if (!s)
+		return -1;
+
+	*mask = 0;
+	for (;;) {
+		p = strchr(s, ',');
+		if (p)
+			*p = '\0';
+
+		for_each_uncore_metric(mp) {
+			if (!strcasecmp(s, (*mp)->name))
+				break;
+		}
+
+		if (!(*mp)) {
+			fprintf(stderr, "unknown metric %s,"
+				" use perf uncore --list-metrics\n", s);
+			goto error;
+		}
+		/* sanity check for mask */
+		if ((mp - uncore_cfg.uncore_metrics) >= 64) {
+			fprintf(stderr, "perf uncore error: num metrics >= 64\n");
+			goto error;
+		}
+		*mask |= 1ULL << (mp - uncore_cfg.uncore_metrics);
+
+		if (!p)
+			break;
+
+		s = p + 1;
+	}
+	ret = 0;
+error:
+	free(os);
+	return ret;
+}
+
+static const struct option options[] = {
+	OPT_INCR('v', "verbose", &verbose,
+		    "be more verbose (show counter open errors, etc)"),
+	OPT_STRING('o', "output", &output_name, "file",
+		   "output file name"),
+	OPT_BOOLEAN(0, "append", &append_file, "append to the output file"),
+	OPT_INTEGER(0, "log-fd", &output_fd,
+		    "log output to fd, instead of stderr"),
+	OPT_INTEGER('I', "interval", &uncore_cfg.interval,
+		    "print interval in sec (default: 1)"),
+	OPT_BOOLEAN('T', "time", &time_sample, "add timing to each sample"),
+	OPT_CALLBACK('m', "mem-unit", &uncore_cfg.mem_unit, "memory bandwidth unit",
+		     "set memory unit from, [K,M,G][i,][b,B] (default: MB)",
+		     parse_mem_unit),
+	OPT_CALLBACK('M', "metrics", &uncore_metric_active,
+		     "metric[,metric]", "metric to collect (default: all)",
+		     parse_metrics),
+	OPT_BOOLEAN('L', "list-metrics", &list_metrics, "list metrics for host processor"),
+	OPT_END()
+};
+
+int cmd_uncore(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	struct perf_evsel *pos;
+	int status = -ENOMEM;
+	const char *mode;
+
+	if (uncore_init_metrics()) {
+		fprintf(stderr, "Host CPU not supported for uncore measurements\n");
+		return -1;
+	}
+
+	setlocale(LC_ALL, "");
+
+	evsel_list = perf_evlist__new(NULL, NULL);
+	if (evsel_list == NULL)
+		return -ENOMEM;
+
+	argc = parse_options(argc, argv, options, uncore_usage,
+		PARSE_OPT_STOP_AT_NON_OPTION);
+
+	if (list_metrics) {
+		print_metrics();
+		return 0;
+	}
+	output = stderr;
+	if (output_name && strcmp(output_name, "-"))
+		output = NULL;
+
+	if (output_name && output_fd) {
+		fprintf(stderr, "cannot use both --output and --log-fd\n");
+		usage_with_options(uncore_usage, options);
+	}
+
+	if (output_fd < 0) {
+		fprintf(stderr, "argument to --log-fd must be a > 0\n");
+		usage_with_options(uncore_usage, options);
+	}
+
+	if (!output) {
+		struct timespec tm;
+		mode = append_file ? "a" : "w";
+
+		output = fopen(output_name, mode);
+		if (!output) {
+			perror("failed to create output file");
+			return -1;
+		}
+		clock_gettime(CLOCK_REALTIME, &tm);
+		fprintf(output, "# started on %s\n", ctime(&tm.tv_sec));
+	} else if (output_fd > 0) {
+		mode = append_file ? "a" : "w";
+		output = fdopen(output_fd, mode);
+		if (!output) {
+			perror("Failed opening logfd");
+			return -errno;
+		}
+	}
+
+	if (csv_sep) {
+		csv_output = true;
+		if (!strcmp(csv_sep, "\\t"))
+			csv_sep = "\t";
+	} else
+		csv_sep = DEFAULT_SEPARATOR;
+
+	if (!uncore_cfg.mem_unit)
+		uncore_cfg.mem_unit = mem_units + UNCORE_DFL_MEM_UNIT;
+
+	if  (uncore_setup_evlist(evsel_list)) {
+		usage_with_options(uncore_usage, options);
+		return -1;
+	}
+
+	list_for_each_entry(pos, &evsel_list->entries, node) {
+		if (perf_evsel__alloc_counts(pos, perf_evsel__nr_cpus(pos)) < 0)
+			goto out_free_fd;
+	}
+
+	/*
+	 * We dont want to block the signals - that would cause
+	 * child tasks to inherit that and Ctrl-C would not work.
+	 * What we want is for Ctrl-C to work in the exec()-ed
+	 * task, but being ignored by perf stat itself:
+	 */
+	atexit(sig_atexit);
+	signal(SIGINT,  skip_signal);
+	signal(SIGALRM, skip_signal);
+	signal(SIGABRT, skip_signal);
+
+	status = run_perf_uncore(argc, argv);
+out_free_fd:
+	uncore_destroy_evlist(evsel_list);
+
+	return status;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 08143bd..7c05a9b 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -36,6 +36,7 @@ extern int cmd_kvm(int argc, const char **argv, const char *prefix);
 extern int cmd_test(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_inject(int argc, const char **argv, const char *prefix);
+extern int cmd_uncore(int argc, const char **argv, const char *prefix);
 
 extern int find_scripts(char **scripts_array, char **scripts_path_array);
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 3e86bbd..d3f3970 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -24,3 +24,4 @@ perf-kmem			mainporcelain common
 perf-lock			mainporcelain common
 perf-kvm			mainporcelain common
 perf-test			mainporcelain common
+perf-uncore			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 095b882..f895b0d 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -60,6 +60,7 @@ static struct cmd_struct commands[] = {
 	{ "trace",	cmd_trace,	0 },
 #endif
 	{ "inject",	cmd_inject,	0 },
+	{ "uncore",	cmd_uncore,	0 },
 };
 
 struct pager_config {
diff --git a/tools/perf/util/uncore.h b/tools/perf/util/uncore.h
new file mode 100644
index 0000000..f33e68f
--- /dev/null
+++ b/tools/perf/util/uncore.h
@@ -0,0 +1,56 @@
+/*
+ * uncore.h: definitions for perf uncore
+ *
+ * Contributed by: Stephane Eranian <eranian@google.com>
+ *
+ * Released under the GPL v2
+ */
+struct uncore_metric_event {
+	const char *pmu_name;
+	const char *name;
+	struct perf_pmu *pmu;
+	struct perf_evsel evsel;
+	int bit_unit; /* 1 byte => bit_unit = 8, 1 bit => .bit_unit = 1 */
+};
+
+#define CFG(n, a, s) \
+{ .evsel = { .attr = { .config = a,} }, \
+  .name = #s,\
+  .pmu_name = #n,\
+  .bit_unit = 8, \
+}
+
+struct uncore_metric {
+	const char *name;
+	const char *desc;
+	void (*print)(FILE *out, const struct uncore_metric *m, int cpu);
+	void (*print_hdr)(FILE *out, const struct uncore_metric *m, int line);
+	struct uncore_metric_event *evts;
+	int nr_evts;
+	int hdr_width;
+	int num_cols;
+};
+
+struct uncore_config {
+	const struct uncore_metric **uncore_metrics;
+	const struct uncore_mem_unit *mem_unit;
+	int nr_socks;
+	int interval;
+};
+
+#define for_each_uncore_metric(x) \
+	for((x) = uncore_cfg.uncore_metrics; *(x); (x)++)
+
+extern struct uncore_config uncore_cfg;
+
+struct uncore_mem_unit {
+	const char *name;	/* 3 characters max */
+	u64 num_bits;		/* number of bits */
+};
+
+static inline int hdr_width(const struct uncore_metric *m)
+{
+	return m->hdr_width
+	     + (uncore_cfg.mem_unit->num_bits < 8 * 1000 * 1000)
+	     * m->num_cols * 4;
+}
-- 
1.7.10.4

