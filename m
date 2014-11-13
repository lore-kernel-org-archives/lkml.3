Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbaKMXUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:20:18 -0500
Received: from mga03.intel.com ([134.134.136.65]:28312 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934388AbaKMXT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:19:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,380,1413270000"; 
   d="scan'208";a="607539368"
From: Andi Kleen <andi@firstfloor.org>
To: lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] Support PCU power metrics in turbostat
Date: Thu, 13 Nov 2014 15:19:49 -0800
Message-Id: <1415920790-23163-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support for reading PCU power metrics on Sandy Bridge / Ivy Bridge EP
and Haswell Server in turbostat. This is done using the perf ABI,
using the perf uncore driver. This requires the kernel to
have uncore perf driver support.

The PCU has a large number of events, but only allows to monitor
four of them at the same time. We always need the PCU cycles
event, so this leaves three events per event group.

The user has to specify the event group using a new -x option. All
more sensible option characters were already taken. When -x is
not specified no behavior changes.

perf in principle supports time based multi-plexing, which
allows monitoring multiple group at the same time, but support for
that is not implemented in the tool so far. It would
also require enabling an potentially idle-disturbing timer.
So right now we don't multiplex.

I modeled the event groups after the proven ones in
pcm-power in the PCM (Intel Performance Counter Monitor) tool.
That is where the numbers come from.

However unlike PCM this uses the perf interfaces, instead
of directly accessing the hardware.

The current groups are:

0: This should 3 monitor frequency bands. It could give more
accurate information than the average frequency from turbostat,
as it can keep multiple buckets.

However this currently runs into a problem with the uncore
driver that only makes us able to monitor a single band.
Disabled until this is fixed.

1: C-state residencies. Already covered in turbostat and not
implemented.

2/3/4:  Various reasons for frequency limits.

5: Number of frequency transitions and time of PCU transition duration.
(note this is not the full time of the transition)

Other power metrics could be added later using the same frame work.
For example it would be possible to implement the memory power saving
metrics from pcm-power, which would output power state statistics per
channel. This would definitely need a new output format,
as it won't fit into any terminal with the current one.

Custom user metrics would be also possible.

The event resolution code is derived from the jevents library
(parts of pmu-tools, http://github.com/andikleen/pmu-tools)
and is BSD licensed.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/power/x86/turbostat/Makefile    |  11 +-
 tools/power/x86/turbostat/resolve.c   | 233 ++++++++++++++++++++++++++++++++++
 tools/power/x86/turbostat/resolve.h   |   2 +
 tools/power/x86/turbostat/turbostat.8 |   5 +
 tools/power/x86/turbostat/turbostat.c | 206 +++++++++++++++++++++++++++++-
 5 files changed, 449 insertions(+), 8 deletions(-)
 create mode 100644 tools/power/x86/turbostat/resolve.c
 create mode 100644 tools/power/x86/turbostat/resolve.h

diff --git a/tools/power/x86/turbostat/Makefile b/tools/power/x86/turbostat/Makefile
index d1b3a36..745af06 100644
--- a/tools/power/x86/turbostat/Makefile
+++ b/tools/power/x86/turbostat/Makefile
@@ -3,17 +3,20 @@ BUILD_OUTPUT	:= $(PWD)
 PREFIX		:= /usr
 DESTDIR		:=
 
-turbostat : turbostat.c
+turbostat : turbostat.o resolve.o
+	@mkdir -p $(BUILD_OUTPUT)
+	$(CC) $(LDFLAGS) $^ -o $(BUILD_OUTPUT)/$@
+
 CFLAGS +=	-Wall
 CFLAGS +=	-DMSRHEADER='"../../../../arch/x86/include/uapi/asm/msr-index.h"'
 
-%: %.c
+%.o: %.c
 	@mkdir -p $(BUILD_OUTPUT)
-	$(CC) $(CFLAGS) $< -o $(BUILD_OUTPUT)/$@
+	$(CC) $(CFLAGS) $< -c -o $(BUILD_OUTPUT)/$@
 
 .PHONY : clean
 clean :
-	@rm -f $(BUILD_OUTPUT)/turbostat
+	@rm -f $(BUILD_OUTPUT)/turbostat turbostat.o resolve.o
 
 install : turbostat
 	install -d  $(DESTDIR)$(PREFIX)/bin
diff --git a/tools/power/x86/turbostat/resolve.c b/tools/power/x86/turbostat/resolve.c
new file mode 100644
index 0000000..ad53159
--- /dev/null
+++ b/tools/power/x86/turbostat/resolve.c
@@ -0,0 +1,233 @@
+/* Resolve perf style event descriptions to attr */
+/*
+ * Copyright (c) 2014, Intel Corporation
+ * Author: Andi Kleen
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright notice,
+ * this list of conditions and the following disclaimer.
+ *
+ * 2. Redistributions in binary form must reproduce the above copyright
+ * notice, this list of conditions and the following disclaimer in the
+ * documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+
+#define _GNU_SOURCE 1
+#include "resolve.h"
+#include <linux/perf_event.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdarg.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <sys/fcntl.h>
+#include <err.h>
+
+#define MAXFILE 4096
+
+static int read_file(char **val, const char *fmt, ...)
+{
+	char *fn;
+	va_list ap;
+	int fd;
+	int ret = -1;
+	int len;
+
+	*val = malloc(MAXFILE);
+	if (!*val)
+		err(1, "out of memory");
+	va_start(ap, fmt);
+	vasprintf(&fn, fmt, ap);
+	va_end(ap);
+	fd = open(fn, O_RDONLY);
+	free(fn);
+	if (fd >= 0) {
+		if ((len = read(fd, *val, MAXFILE - 1)) > 0) {
+			ret = 0;
+			(*val)[len] = 0;
+		}
+		close(fd);
+	}
+	if (ret < 0) {
+		free(*val);
+		*val = NULL;
+	}
+	return ret;
+}
+
+#define BITS(x) ((1U << (x)) - 1)
+
+static bool try_parse(char *format, char *fmt, __u64 val, __u64 *config)
+{
+	int start, end;
+	int n = sscanf(format, fmt, &start, &end);
+	if (n == 1)
+		end = start + 1;
+	if (n == 0)
+		return false;
+	*config |= (val & BITS(end - start + 1)) << start;
+	return true;
+}
+
+static int read_qual(char *qual, struct perf_event_attr *attr)
+{
+	while (*qual) {
+		switch (*qual) {
+		case 'p':
+			attr->precise_ip++;
+			break;
+		case 'k':
+			attr->exclude_user = 1;
+			break;
+		case 'u':
+			attr->exclude_kernel = 1;
+			break;
+		case 'h':
+			attr->exclude_guest = 1;
+			break;
+		/* XXX more */
+		default:
+			fprintf(stderr, "Unknown modifier %c at end\n", *qual);
+			return -1;
+		}
+		qual++;
+	}
+	return 0;
+}
+
+static bool special_attr(char *name, int val, struct perf_event_attr *attr)
+{
+	if (!strcmp(name, "period")) {
+		attr->sample_period = val;
+		return true;
+	}
+	if (!strcmp(name, "freq")) {
+		attr->sample_freq = val;
+		attr->freq = 1;
+		return true;
+	}
+	return false;
+}
+
+static int parse_terms(char *pmu, char *config, struct perf_event_attr *attr, int recur)
+{
+	char *format = NULL;
+	char *term;
+
+	char *newl = strchr(config, '\n');
+	if (newl)
+		*newl = 0;
+
+	while ((term = strsep(&config, ",")) != NULL) {
+		char name[30];
+		int n, val = 1;
+
+		n = sscanf(term, "%30[^=]=%i", name, &val);
+		if (n < 1)
+			break;
+		if (special_attr(name, val, attr))
+			continue;
+		free(format);
+		if (read_file(&format, "/sys/devices/%s/format/%s", pmu, name) < 0) {
+			char *alias = NULL;
+
+			if (recur == 0 &&
+			    read_file(&alias, "/sys/devices/%s/events/%s", pmu, name) == 0) {
+				if (parse_terms(pmu, alias, attr, 1) < 0) {
+					free(alias);
+					fprintf(stderr, "Cannot parse kernel event alias %s\n", name);
+					break;
+				}
+				free(alias);
+				continue;
+			}
+			fprintf(stderr, "Cannot parse qualifier %s\n", name);
+			break;
+		}
+		bool ok = try_parse(format, "config:%d-%d", val, &attr->config) ||
+			try_parse(format, "config:%d", val, &attr->config) ||
+			try_parse(format, "config1:%d-%d", val, &attr->config1) ||
+			try_parse(format, "config1:%d", val, &attr->config1) ||
+			try_parse(format, "config2:%d-%d", val, &attr->config2) ||
+			try_parse(format, "config2:%d", val, &attr->config2);
+		if (!ok) {
+			fprintf(stderr, "Cannot parse kernel format %s: %s\n",
+					name, format);
+			break;
+		}
+	}
+	free(format);
+	if (term)
+		return -1;
+	return 0;
+}
+
+
+/* Resolve perf new style event descriptor to perf ATTR. User must initialize
+ * attr->sample_type and attr->read_format as needed after this call,
+ * and possibly other fields.
+ */
+int tjevent_name_to_attr(char *str, struct perf_event_attr *attr)
+{
+	char pmu[30], config[200];
+	int qual_off;
+
+	memset(attr, 0, sizeof(struct perf_event_attr));
+	attr->size = PERF_ATTR_SIZE_VER1;
+
+	if (sscanf(str, "%30[^/]/%200[^/]/%n", pmu, config, &qual_off) < 2)
+		return -1;
+	char *type = NULL;
+	if (read_file(&type, "/sys/devices/%s/type", pmu) < 0)
+		return -1;
+	attr->type = atoi(type);
+	free(type);
+	if (parse_terms(pmu, config, attr, 0) < 0)
+		return -1;
+	if (read_qual(str + qual_off, attr) < 0)
+		return -1;
+	return 0;
+}
+
+#ifdef TEST
+#include <asm/unistd.h>
+int main(int ac, char **av)
+{
+	struct perf_event_attr attr =  { 0 };
+	int ret = 1;
+
+	if (!av[1]) {
+		printf("Usage: ... perf-event-to-parse\n");
+		exit(1);
+	}
+	while (*++av) {
+		if (jevent_name_to_attr(*av, &attr) < 0)
+			printf("cannot parse %s\n", *av);
+		printf("config %llx config1 %llx\n", attr.config, attr.config1);
+		int fd;
+		if ((fd = syscall(__NR_perf_event_open, &attr, 0, -1, -1, 0)) < 0)
+			perror("perf_event_open");
+		else
+			ret = 0;
+		close(fd);
+	}
+	return ret;
+}
+#endif
diff --git a/tools/power/x86/turbostat/resolve.h b/tools/power/x86/turbostat/resolve.h
new file mode 100644
index 0000000..286e798
--- /dev/null
+++ b/tools/power/x86/turbostat/resolve.h
@@ -0,0 +1,2 @@
+struct perf_event_attr;
+int tjevent_name_to_attr(char *str, struct perf_event_attr *attr);
diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index 56bfb52..e91d837 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -42,6 +42,11 @@ The \fB-M MSR#\fP option includes the the specified 64-bit MSR value.
 The \fB-i interval_sec\fP option prints statistics every \fiinterval_sec\fP seconds.
 The default is 5 seconds.
 .PP
+The \fB-x GROUP\fP option enables PCU event group monitoring. Valid groups are
+2 for thermal frequency limits, 3 and 4 for other frequency limits,
+5 for frequency transitions statistics. Requires the kernel
+to support the perf uncore driver for this platform.
+.PP
 The \fBcommand\fP parameter forks \fBcommand\fP and upon its exit,
 displays the statistics gathered since it was forked.
 .PP
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 5b1b807..5c23f00 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -38,6 +38,9 @@
 #include <ctype.h>
 #include <sched.h>
 #include <cpuid.h>
+#include <sys/syscall.h>
+#include <linux/perf_event.h>
+#include "resolve.h"
 
 char *proc_stat = "/proc/stat";
 unsigned int interval_sec = 5;	/* set with -i interval_sec */
@@ -81,6 +84,11 @@ unsigned int tcc_activation_temp;
 unsigned int tcc_activation_temp_override;
 double rapl_power_units, rapl_energy_units, rapl_time_units;
 double rapl_joule_counter_range;
+int do_pcu_group = -1;
+int is_jkt;
+int is_ivt;
+int is_hsx;
+int max_package_id;
 
 #define RAPL_PKG		(1 << 0)
 					/* 0x610 MSR_PKG_POWER_LIMIT */
@@ -159,7 +167,7 @@ struct pkg_data {
 	unsigned int rapl_pkg_perf_status;	/* MSR_PKG_PERF_STATUS */
 	unsigned int rapl_dram_perf_status;	/* MSR_DRAM_PERF_STATUS */
 	unsigned int pkg_temp_c;
-
+	unsigned long long pcu0, pcu1, pcu2, pcu3;
 } *package_even, *package_odd;
 
 #define ODD_COUNTERS thread_odd, core_odd, package_odd
@@ -264,6 +272,8 @@ int get_msr(int cpu, off_t offset, unsigned long long *msr)
 	return 0;
 }
 
+static char *pcu_group_titles[][3];
+
 /*
  * Example Format w/ field column widths:
  *
@@ -353,6 +363,12 @@ void print_header(void)
 		outp += sprintf(outp, "   time");
 
 	}
+	if (do_pcu_group >= 0) {
+		outp += sprintf(outp, " %-12s", pcu_group_titles[do_pcu_group][0]);
+		outp += sprintf(outp, " %-12s", pcu_group_titles[do_pcu_group][1]);
+		if (pcu_group_titles[do_pcu_group][2][0])
+			outp += sprintf(outp, " %-8s", pcu_group_titles[do_pcu_group][2]);
+	}
 	outp += sprintf(outp, "\n");
 }
 
@@ -406,6 +422,11 @@ int dump_counters(struct thread_data *t, struct core_data *c,
 		outp += sprintf(outp, "Throttle RAM: %0X\n",
 			p->rapl_dram_perf_status);
 		outp += sprintf(outp, "PTM: %dC\n", p->pkg_temp_c);
+
+		outp += sprintf(outp, "PCU0: %0llX\n", p->pcu0);
+		outp += sprintf(outp, "PCU1: %0llX\n", p->pcu1);
+		outp += sprintf(outp, "PCU2: %0llX\n", p->pcu2);
+		outp += sprintf(outp, "PCU3: %0llX\n", p->pcu3);
 	}
 
 	outp += sprintf(outp, "\n");
@@ -413,6 +434,13 @@ int dump_counters(struct thread_data *t, struct core_data *c,
 	return 0;
 }
 
+static int add_percent(char *outp, unsigned long long val, double cycles)
+{
+	if (val == 0)
+		return sprintf(outp, "%12s", "");
+	return sprintf(outp, " %12.2f", 100.0 * (val / cycles));
+}
+
 /*
  * column formatting convention & formats
  */
@@ -581,6 +609,17 @@ int format_counters(struct thread_data *t, struct core_data *c,
 	outp += sprintf(outp, fmt8, interval_float);
 
 	}
+
+	if (do_pcu_group >= 0) {
+		double pcu_cycles = p->pcu0;
+
+		if (do_pcu_group == 5)
+			outp += sprintf(outp, " %12llu", p->pcu1);
+		else
+			outp += add_percent(outp, p->pcu2, pcu_cycles);
+		outp += add_percent(outp, p->pcu2, pcu_cycles);
+		outp += add_percent(outp, p->pcu3, pcu_cycles);
+	}
 done:
 	outp += sprintf(outp, "\n");
 
@@ -635,6 +674,10 @@ delta_package(struct pkg_data *new, struct pkg_data *old)
 	old->pc9 = new->pc9 - old->pc9;
 	old->pc10 = new->pc10 - old->pc10;
 	old->pkg_temp_c = new->pkg_temp_c;
+	old->pcu0 = new->pcu0;
+	old->pcu1 = new->pcu1;
+	old->pcu2 = new->pcu2;
+	old->pcu3 = new->pcu3;
 
 	DELTA_WRAP32(new->energy_pkg, old->energy_pkg);
 	DELTA_WRAP32(new->energy_cores, old->energy_cores);
@@ -783,6 +826,10 @@ void clear_counters(struct thread_data *t, struct core_data *c, struct pkg_data
 	p->rapl_pkg_perf_status = 0;
 	p->rapl_dram_perf_status = 0;
 	p->pkg_temp_c = 0;
+	p->pcu0 = 0;
+	p->pcu1 = 0;
+	p->pcu2 = 0;
+	p->pcu3 = 0;
 }
 int sum_counters(struct thread_data *t, struct core_data *c,
 	struct pkg_data *p)
@@ -826,6 +873,11 @@ int sum_counters(struct thread_data *t, struct core_data *c,
 
 	average.packages.rapl_pkg_perf_status += p->rapl_pkg_perf_status;
 	average.packages.rapl_dram_perf_status += p->rapl_dram_perf_status;
+
+	average.packages.pcu0 += p->pcu0;
+	average.packages.pcu1 += p->pcu1;
+	average.packages.pcu2 += p->pcu2;
+	average.packages.pcu3 += p->pcu3;
 	return 0;
 }
 /*
@@ -872,6 +924,137 @@ static unsigned long long rdtsc(void)
 	return low | ((unsigned long long)high) << 32;
 }
 
+/* Get PCU statistics:
+
+   We can only measure three events at a time
+   (4 counters in the PCU, and one for the clock ticks event)
+
+   To generate new events use the ucevent tool in pmu-tools
+   FORCECPU=cpu ucevent.py --resolve EVENT-NAME */
+
+static char *pcu_groups[][5] = {
+	/* Runs into problems with the uncore driver with the filters for now. */
+	[0] = { NULL },
+	/* group 1 is covered already */
+	[1] = { NULL },
+	[2] = { "uncore_pcu/event=0x0/", /* PCU.CLOCKTICKS */
+		"uncore_pcu/event=0x9/", /* PCU.PROCHOT_EXTERNAL_CYCLES */
+		"uncore_pcu/event=0xa/", /* PCU.PROCHOT_INTERNAL_CYCLES */
+		"uncore_pcu/event=0x4/", /* PCU.FREQ_MAX_LIMIT_THERMAL_CYCLES */
+		NULL },
+	[3] = { "uncore_pcu/event=0x0/", /* PCU.CLOCKTICKS */
+		"uncore_pcu/event=0x4/", /* PCU.FREQ_MAX_LIMIT_THERMAL_CYCLES */
+		"uncore_pcu/event=0x5/", /* PCU.FREQ_MAX_POWER_CYCLES */
+		"uncore_pcu/event=0x7/", /* PCU.FREQ_MAX_CURRENT_CYCLES */
+		NULL },
+	[4] = { "uncore_pcu/event=0x0/", /* PCU.CLOCKTICKS */
+		"uncore_pcu/event=0x6/", /* PCU.FREQ_MAX_OS_CYCLES */
+		"uncore_pcu/event=0x5/", /* PCU.FREQ_MAX_POWER_CYCLES */
+		"uncore_pcu/event=0x7/", /* PCU.FREQ_MAX_CURRENT_CYCLES */
+		NULL },
+	[5] = { "uncore_pcu/event=0x0/", /* PCU.CLOCKTICKS */
+		"uncore_pcu/event=0x60,edge=1/", /* PCU.FREQ_TRANS_CYCLES,edge */
+		"uncore_pcu/event=0x60/", /* PCU.FREQ_TRANS_CYCLES */
+		NULL },
+};
+
+static char *pcu_group_titles[][3] = {
+	[0] = { "", "", "" },
+	[1] = { "", "", "" },
+	[2] = { "ProcHot-ext%", "ProcHot-int%", "Therm-Lim%" },
+	[3] = { "Therm-Lim%", "Power-Lim%", "Current-Lim%" },
+	[4] = { "OS-Limit%", "Power-Limit%", "Current-Lim%" },
+	[5] = { "Num-Freq-Trans", "Freq-Trans%", "" }
+};
+
+#define NUM_COUNTER 4
+
+static void pcu_fixup_tables(void)
+{
+	/* Table is for IVT. Fix up deltas to other CPUs */
+	if (is_hsx) {
+		pcu_groups[4][3] = NULL; /* No PCU.FREQ_MAX_CURRENT_CYCLES */
+		pcu_groups[3][3] = NULL;
+		pcu_group_titles[4][3] = NULL;
+		pcu_group_titles[3][3] = NULL;
+	} else if (is_jkt) {
+		pcu_groups[5][1] = "uncore_pcu/event=0x200000,edge=1/"; /* PCU.FREQ_TRANS_CYCLES */
+		pcu_groups[5][2] = "uncore_pcu/event=0x200000/";
+	}
+}
+
+static int pcu_perf_init(int group, int cpu, int *pcu_fd)
+{
+	int i;
+	char **evnames = pcu_groups[group];
+	pcu_fd[0] = -1;
+
+	for (i = 0; evnames[i]; i++) {
+		struct perf_event_attr attr;
+		char *ev = evnames[i];
+
+		if (tjevent_name_to_attr(ev, &attr) < 0) {
+			fprintf(stderr, "Cannot resolve %s\n", ev);
+			goto fallback;
+		}
+		attr.read_format = PERF_FORMAT_GROUP;
+		pcu_fd[i] = syscall(__NR_perf_event_open,
+				 &attr,
+				 -1,
+				 cpu,
+				 pcu_fd[0],
+				 i == 0 ? PERF_FLAG_FD_OUTPUT : 0);
+		if (pcu_fd[i] < 0) {
+			fprintf(stderr, "cannot open perf event %s\n", ev);
+			goto fallback;
+		}
+		if (ev != evnames[i])
+			free(ev);
+	}
+	return 0;
+fallback:
+	/* Don't error out */
+	do_pcu_group = -1;
+	while (--i >= 0) {
+		close(pcu_fd[i]);
+		pcu_fd[i] = -1;
+	}
+	return -1;
+}
+
+int get_pcu_data(struct pkg_data *p)
+{
+	static int **pcu_fds;
+	int *pcu_fd;
+	unsigned long long val[NUM_COUNTER + 3];
+
+	if (!pcu_fds)  {
+		pcu_fds = calloc(max_package_id + 1, sizeof(void *));
+		if (!pcu_fds)
+			err(1, "no memory");
+		pcu_fds[p->package_id] = calloc(NUM_COUNTER, sizeof(void *));
+		if (!pcu_fds[p->package_id])
+			err(1, "no memory");
+	}
+	pcu_fd = pcu_fds[p->package_id];
+	if (!pcu_fd[0]) {
+		if (pcu_perf_init(do_pcu_group, p->package_id, pcu_fd) < 0)
+			return 0;
+		if (!pcu_fd[0])
+			return 0;
+	}
+
+	memset(val, 0, sizeof(val));
+	read(pcu_fd[0], val, sizeof(val));
+
+	/* XXX scale by run time for multiplexing */
+	p->pcu0 = val[1 + 0];
+	p->pcu1 = val[1 + 1];
+	p->pcu2 = val[1 + 2];
+	p->pcu3 = val[1 + 3];
+
+	return 0;
+}
 
 /*
  * get_counters(...)
@@ -1011,6 +1194,10 @@ int get_counters(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 			return -17;
 		p->pkg_temp_c = tcc_activation_temp - ((msr >> 16) & 0x7F);
 	}
+	if (do_pcu_group >= 0) {
+		if (get_pcu_data(p))
+			return -18;
+	}
 	return 0;
 }
 
@@ -2070,6 +2257,9 @@ void check_cpuid()
 	do_c8_c9_c10 = has_c8_c9_c10(family, model);
 	do_slm_cstates = is_slm(family, model);
 	bclk = discover_bclk(family, model);
+	is_jkt = genuine_intel && model == 45;
+	is_ivt = genuine_intel && model == 62;
+	is_hsx = genuine_intel && model == 63;
 
 	do_nehalem_turbo_ratio_limit = has_nehalem_turbo_ratio_limit(family, model);
 	do_ivt_turbo_ratio_limit = has_ivt_turbo_ratio_limit(family, model);
@@ -2081,7 +2271,7 @@ void check_cpuid()
 
 void usage()
 {
-	errx(1, "%s: [-v][-R][-T][-p|-P|-S][-c MSR#][-C MSR#][-m MSR#][-M MSR#][-i interval_sec | command ...]\n",
+	errx(1, "%s: [-v][-R][-T][-p|-P|-S][-c MSR#][-C MSR#][-m MSR#][-M MSR#] [-xPCUGROUP] [-i interval_sec | command ...]\n",
 	     progname);
 }
 
@@ -2107,7 +2297,6 @@ void topology_probe()
 {
 	int i;
 	int max_core_id = 0;
-	int max_package_id = 0;
 	int max_siblings = 0;
 	struct cpu_topology {
 		int core_id;
@@ -2319,6 +2508,10 @@ void turbostat_init()
 
 	if (verbose)
 		for_all_cpus(print_thermal, ODD_COUNTERS);
+
+	pcu_fixup_tables();
+	if (!is_ivt && !is_jkt && is_hsx)
+		do_pcu_group = -1;
 }
 
 int fork_it(char **argv)
@@ -2388,7 +2581,7 @@ void cmdline(int argc, char **argv)
 
 	progname = argv[0];
 
-	while ((opt = getopt(argc, argv, "+pPsSvi:c:C:m:M:RJT:")) != -1) {
+	while ((opt = getopt(argc, argv, "+pPsSvi:c:C:m:M:RJT:x:")) != -1) {
 		switch (opt) {
 		case 'p':
 			show_core_only++;
@@ -2429,6 +2622,11 @@ void cmdline(int argc, char **argv)
 		case 'J':
 			rapl_joules++;
 			break;
+		case 'x':
+			sscanf(optarg, "%d", &do_pcu_group);
+			if (do_pcu_group < 0 || do_pcu_group > 5)
+				usage();
+			break;
 
 		default:
 			usage();
-- 
1.9.3

