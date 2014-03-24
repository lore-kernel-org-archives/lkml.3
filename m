Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaCXUGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:06:07 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:45198 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaCXUGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:06:00 -0400
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        rostedt@goodmis.org, daniel.lezcano@linaro.org,
        zoran.markovic@linaro.org
Subject: [RFC PATCH 1/2] power: Add idlestat tool for benchmarking energy-aware scheduler
Date: Mon, 24 Mar 2014 13:05:21 -0700
Message-Id: <1395691522-3561-2-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395691522-3561-1-git-send-email-zoran.markovic@linaro.org>
References: <1395691522-3561-1-git-send-email-zoran.markovic@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the initial snapshot of idlestat tool used to benchmark energy
efficiency of the scheduler. Functionality of this tool is described in
Documentation/power/idlestat.txt.

The code is still undergoing developement. This snapshot is provided for
reveiwers' reference with the intention of soliciting feedback on tool's
features.

Cc: Rob Landley <rob@landley.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 tools/power/idlestat/.gitignore |   50 ++
 tools/power/idlestat/Makefile   |   34 ++
 tools/power/idlestat/idlestat.c | 1229 +++++++++++++++++++++++++++++++++++++++
 tools/power/idlestat/idlestat.h |  106 ++++
 tools/power/idlestat/list.h     |  588 +++++++++++++++++++
 tools/power/idlestat/topology.c |  503 ++++++++++++++++
 tools/power/idlestat/topology.h |   77 +++
 tools/power/idlestat/trace.c    |   87 +++
 tools/power/idlestat/trace.h    |   43 ++
 tools/power/idlestat/utils.c    |  115 ++++
 tools/power/idlestat/utils.h    |   35 ++
 11 files changed, 2867 insertions(+)
 create mode 100644 tools/power/idlestat/.gitignore
 create mode 100644 tools/power/idlestat/Makefile
 create mode 100644 tools/power/idlestat/idlestat.c
 create mode 100644 tools/power/idlestat/idlestat.h
 create mode 100644 tools/power/idlestat/list.h
 create mode 100644 tools/power/idlestat/topology.c
 create mode 100644 tools/power/idlestat/topology.h
 create mode 100644 tools/power/idlestat/trace.c
 create mode 100644 tools/power/idlestat/trace.h
 create mode 100644 tools/power/idlestat/utils.c
 create mode 100644 tools/power/idlestat/utils.h

diff --git a/tools/power/idlestat/.gitignore b/tools/power/idlestat/.gitignore
new file mode 100644
index 0000000..968abde
--- /dev/null
+++ b/tools/power/idlestat/.gitignore
@@ -0,0 +1,50 @@
+#
+# NOTE! Don't add files that are generated in specific
+# subdirectories here. Add them in the ".gitignore" file
+# in that subdirectory instead.
+#
+# NOTE! Please use 'git ls-files -i --exclude-standard'
+# command after changing this file, to see if there are
+# any tracked files which get ignored after the change.
+#
+# Normal rules
+#
+.*
+*.o
+*.o.*
+*.a
+*.s
+*.so
+*.so.dbg
+*.i
+*.elf
+*.bin
+*.gz
+*.bz2
+*.lzma
+*.xz
+*.lz4
+*.lzo
+*.patch
+*.gcno
+*.orig
+*~
+\#*#
+
+#
+# Top-level files
+#
+/idlestat
+
+#
+# git files that we don't want to ignore even it they are dot-files
+#
+!.gitignore
+!.mailmap
+
+# gnu global files
+GPATH
+GRTAGS
+GSYMS
+GTAGS
+
diff --git a/tools/power/idlestat/Makefile b/tools/power/idlestat/Makefile
new file mode 100644
index 0000000..e351b4d
--- /dev/null
+++ b/tools/power/idlestat/Makefile
@@ -0,0 +1,34 @@
+#
+# Makefile
+#
+# Copyright (C) 2014, Linaro Limited
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License
+# as published by the Free Software Foundation; either version 2
+# of the License, or (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program.
+#
+# Contributors:
+#     Daniel Lezcano <daniel.lezcano@linaro.org>
+#     Zoran Markovic <zoran.markovic@linaro.org>
+#
+CFLAGS?=-g -Wall
+CC?=gcc
+
+OBJS = idlestat.o topology.o trace.o utils.o
+
+default: idlestat
+
+idlestat: $(OBJS)
+	$(CC) ${CFLAGS} $(OBJS) -o $@
+
+clean:
+	rm -f $(OBJS) idlestat
diff --git a/tools/power/idlestat/idlestat.c b/tools/power/idlestat/idlestat.c
new file mode 100644
index 0000000..074926e
--- /dev/null
+++ b/tools/power/idlestat/idlestat.c
@@ -0,0 +1,1229 @@
+/*
+ *  idlestat.c
+ *
+ *  Copyright (C) 2014, Linaro Limited.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * Contributors:
+ *     Daniel Lezcano <daniel.lezcano@linaro.org>
+ *     Zoran Markovic <zoran.markovic@linaro.org>
+ *
+ */
+#define _GNU_SOURCE
+#include <getopt.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <sched.h>
+#include <string.h>
+#include <float.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/resource.h>
+#include <assert.h>
+
+#include "idlestat.h"
+#include "utils.h"
+#include "trace.h"
+#include "list.h"
+#include "topology.h"
+
+#define IDLESTAT_VERSION "0.3-rc1"
+
+static char irq_type_name[][8] = {
+			"irq",
+			"ipi",
+		};
+
+static char buffer[BUFSIZE];
+
+static inline int error(const char *str)
+{
+	perror(str);
+	return -1;
+}
+
+static inline void *ptrerror(const char *str)
+{
+	perror(str);
+	return NULL;
+}
+
+static int dump_states(struct cpuidle_cstates *cstates,
+		       struct cpufreq_pstates *pstates,
+		       int state, int count, char *str)
+{
+	int j, k;
+	struct cpuidle_cstate *cstate;
+
+	for (j = 0; j < cstates->cstate_max + 1; j++) {
+
+		if (state != -1 && state != j)
+			continue;
+
+		cstate = &cstates->cstate[j];
+
+		for (k = 0; k < MIN(count, cstate->nrdata); k++) {
+			printf("%lf %d\n", cstate->data[k].begin, j);
+			printf("%lf 0\n", cstate->data[k].end);
+		}
+
+		/* add a break */
+		printf("\n");
+	}
+
+	return 0;
+}
+
+static int display_states(struct cpuidle_cstates *cstates,
+			  struct cpufreq_pstates *pstates,
+			  int state, int count, char *str)
+{
+	int j;
+
+	printf("%s@state\thits\t      total(us)\t\tavg(us)\tmin(us)\t"
+	       "max(us)\n", str);
+	for (j = 0; j < cstates->cstate_max + 1; j++) {
+		struct cpuidle_cstate *c = &cstates->cstate[j];
+
+		if (state != -1 && state != j)
+			continue;
+
+		printf("%*c %s\t%d\t%15.2lf\t%15.2lf\t%.2lf\t%.2lf\n",
+			(int)strlen(str), ' ',
+			c->name, c->nrdata, c->duration,
+			c->avg_time,
+			(c->min_time == DBL_MAX ? 0. : c->min_time),
+			c->max_time);
+	}
+	if (pstates) {
+		for (j = 0; j < pstates->max; j++) {
+			struct cpufreq_pstate *p = &(pstates->pstate[j]);
+			printf("%*c %d\t%d\t%15.2lf\t%15.2lf\t%.2lf\t%.2lf\n",
+				(int)strlen(str), ' ',
+				p->freq/1000, p->count, p->duration,
+				p->avg_time,
+				(p->min_time == DBL_MAX ? 0. : p->min_time),
+				p->max_time);
+		}
+	}
+
+	if (strstr(str, IRQ_WAKEUP_UNIT_NAME)) {
+		struct wakeup_info *wakeinfo = &cstates->wakeinfo;
+		struct wakeup_irq *irqinfo = wakeinfo->irqinfo;
+		printf("%s wakeups \tname \t\tcount\n", str);
+		for (j = 0; j < wakeinfo->nrdata; j++, irqinfo++) {
+			printf("%*c %s%03d\t%-15.15s\t%d\n", (int)strlen(str),
+				' ',
+				(irqinfo->irq_type < IRQ_TYPE_MAX) ?
+				irq_type_name[irqinfo->irq_type] : "NULL",
+				irqinfo->id, irqinfo->name, irqinfo->count);
+		}
+	}
+
+	return 0;
+}
+
+int dump_all_data(struct cpuidle_datas *datas, int state, int count,
+		int (*dump)(struct cpuidle_cstates *,
+			    struct cpufreq_pstates *, int,  int, char *))
+{
+	int i = 0, nrcpus = datas->nrcpus;
+	struct cpuidle_cstates *cstates;
+	struct cpufreq_pstates *pstates;
+
+	do {
+		cstates = &datas->cstates[i];
+		pstates = &datas->pstates[i];
+
+		if (nrcpus == -1)
+			sprintf(buffer, "cluster");
+		else
+			sprintf(buffer, "cpu%d", i);
+
+		dump(cstates, pstates, state, count, buffer);
+
+		i++;
+
+	} while (i < nrcpus && nrcpus != -1);
+
+	return 0;
+}
+
+static struct cpuidle_data *intersection(struct cpuidle_data *data1,
+					 struct cpuidle_data *data2)
+{
+	double begin, end;
+	struct cpuidle_data *data;
+
+	begin = MAX(data1->begin, data2->begin);
+	end = MIN(data1->end, data2->end);
+
+	if (begin >= end)
+		return NULL;
+
+	data = malloc(sizeof(*data));
+	if (!data)
+		return NULL;
+
+	data->begin = begin;
+	data->end = end;
+	data->duration = end - begin;
+	data->duration *= 1000000;
+
+	return data;
+}
+
+static struct cpuidle_cstate *inter(struct cpuidle_cstate *c1,
+				    struct cpuidle_cstate *c2)
+{
+	int i, j;
+	struct cpuidle_data *interval;
+	struct cpuidle_cstate *result;
+	struct cpuidle_data *data = NULL;
+	size_t index;
+
+	if (!c1)
+		return c2;
+	if (!c2)
+		return c1;
+
+	result = calloc(sizeof(*result), 1);
+	if (!result)
+		return NULL;
+
+	for (i = 0, index = 0; i < c1->nrdata; i++) {
+
+		for (j = index; j < c2->nrdata; j++) {
+			struct cpuidle_data *tmp;
+
+			/* intervals are ordered, no need to go further */
+			if (c1->data[i].end < c2->data[j].begin)
+				break;
+
+			/* primary loop begins where we ended */
+			if (c1->data[i].begin > c2->data[j].end)
+				index = j;
+
+			interval = intersection(&c1->data[i], &c2->data[j]);
+			if (!interval)
+				continue;
+
+			result->min_time = MIN(result->min_time,
+					       interval->duration);
+
+			result->max_time = MAX(result->max_time,
+					       interval->duration);
+
+			result->avg_time = AVG(result->avg_time,
+					       interval->duration,
+					       result->nrdata + 1);
+
+			result->duration += interval->duration;
+
+			result->nrdata++;
+
+			tmp = realloc(data, sizeof(*data) *
+				       (result->nrdata + 1));
+			if (!tmp) {
+				free(data);
+				free(result);
+				return NULL;
+			}
+			data = tmp;
+
+			result->data = data;
+			result->data[result->nrdata - 1] = *interval;
+
+			free(interval);
+		}
+	}
+
+	return result;
+}
+
+#define CPUIDLE_STATENAME_PATH_FORMAT \
+	"/sys/devices/system/cpu/cpu%d/cpuidle/state%d/name"
+
+static char *cpuidle_cstate_name(int cpu, int state)
+{
+	char *fpath, *name;
+	FILE *snf;
+	char line[256];
+
+	if (asprintf(&fpath, CPUIDLE_STATENAME_PATH_FORMAT, cpu, state) < 0)
+		return NULL;
+
+	/* read cpuidle state name for the CPU */
+	snf = fopen(fpath, "r");
+	if (!snf) {
+		free(fpath);
+		return NULL;
+	}
+
+	name = fgets(line, sizeof(line)/sizeof(line[0]), snf);
+	if (!name)
+		goto free_exit;
+
+	/* get rid of trailing characters and duplicate string */
+	name = strtok(name, "\n ");
+	name = strdup(name);
+
+free_exit:
+	fclose(snf);
+	free(fpath);
+	return name;
+}
+
+
+/**
+ * release_cstate_info - free all C-state related structs
+ * @cstates: per-cpu array of C-state statistics structs
+ * @nrcpus: number of CPUs
+ */
+static void release_cstate_info(struct cpuidle_cstates *cstates, int nrcpus)
+{
+	int cpu, i;
+
+	if (!cstates)
+		/* already cleaned up */
+		return;
+
+	/* free C-state names */
+	for (cpu = 0; cpu < nrcpus; cpu++) {
+		for (i = 0; i < MAXCSTATE; i++) {
+			struct cpuidle_cstate *c = &(cstates[cpu].cstate[i]);
+			if (c->name)
+				free(c->name);
+		}
+	}
+
+	/* free the cstates array */
+	free(cstates);
+}
+
+/**
+ * build_cstate_info - parse cpuidle sysfs entries and build per-CPU
+ * structs to maintain statistics of C-state transitions
+ * @nrcpus: number of CPUs
+ *
+ * Return: per-CPU array of structs (success) or NULL (error)
+ */
+static struct cpuidle_cstates *build_cstate_info(int nrcpus)
+{
+	int cpu;
+	struct cpuidle_cstates *cstates;
+
+	cstates = calloc(nrcpus, sizeof(*cstates));
+	if (!cstates)
+		return NULL;
+	memset(cstates, 0, sizeof(*cstates) * nrcpus);
+
+	/* initialize cstate_max for each cpu */
+	for (cpu = 0; cpu < nrcpus; cpu++) {
+		int i;
+		struct cpuidle_cstate *c;
+		cstates[cpu].cstate_max = -1;
+		cstates[cpu].last_cstate = -1;
+		for (i = 0; i < MAXCSTATE; i++) {
+			c = &(cstates[cpu].cstate[i]);
+			c->name = cpuidle_cstate_name(cpu, i);
+			c->data = NULL;
+			c->nrdata = 0;
+			c->avg_time = 0.;
+			c->max_time = 0.;
+			c->min_time = DBL_MAX;
+			c->duration = 0.;
+		}
+	}
+	return cstates;
+}
+
+#define CPUFREQ_AVFREQ_PATH_FORMAT \
+	"/sys/devices/system/cpu/cpu%d/cpufreq/scaling_available_frequencies"
+
+/**
+ * release_pstate_info - free all P-state related structs
+ * @pstates: per-cpu array of P-state statistics structs
+ * @nrcpus: number of CPUs
+ */
+static void release_pstate_info(struct cpufreq_pstates *pstates, int nrcpus)
+{
+	int cpu;
+
+	if (!pstates)
+		/* already cleaned up */
+		return;
+
+	/* first check and clean per-cpu structs */
+	for (cpu = 0; cpu < nrcpus; cpu++)
+		if (pstates[cpu].pstate)
+			free(pstates[cpu].pstate);
+
+	/* now free the master cpufreq structs */
+	free(pstates);
+
+	return;
+}
+
+/**
+ * build_pstate_info - parse cpufreq sysfs entries and build per-CPU
+ * structs to maintain statistics of P-state transitions
+ * @nrcpus: number of CPUs
+ *
+ * Return: per-CPU array of structs (success) or NULL (error)
+ */
+static struct cpufreq_pstates *build_pstate_info(int nrcpus)
+{
+	int cpu;
+	struct cpufreq_pstates *pstates;
+
+	pstates = calloc(nrcpus, sizeof(*pstates));
+	if (!pstates)
+		return NULL;
+	memset(pstates, 0, sizeof(*pstates) * nrcpus);
+
+	for (cpu = 0; cpu < nrcpus; cpu++) {
+		struct cpufreq_pstate *pstate;
+		int nrfreq;
+		char *fpath, *freq, line[256];
+		FILE *sc_av_freq;
+
+		if (asprintf(&fpath, CPUFREQ_AVFREQ_PATH_FORMAT, cpu) < 0)
+			goto clean_exit;
+
+		/* read scaling_available_frequencies for the CPU */
+		sc_av_freq = fopen(fpath, "r");
+		free(fpath);
+		if (!sc_av_freq)
+			goto clean_exit;
+		freq = fgets(line, sizeof(line)/sizeof(line[0]), sc_av_freq);
+		fclose(sc_av_freq);
+		if (!freq)
+			goto clean_exit;
+
+		/* tokenize line and populate each frequency */
+		nrfreq = 0;
+		pstate = NULL;
+		while ((freq = strtok(freq, "\n ")) != NULL) {
+			pstate = realloc(pstate, sizeof(*pstate) * (nrfreq+1));
+			if (!pstate)
+				goto clean_exit;
+
+			/* initialize pstate record */
+			pstate[nrfreq].id = nrfreq;
+			pstate[nrfreq].freq = atol(freq);
+			pstate[nrfreq].count = 0;
+			pstate[nrfreq].min_time = DBL_MAX;
+			pstate[nrfreq].max_time = 0.;
+			pstate[nrfreq].avg_time = 0.;
+			pstate[nrfreq].duration = 0.;
+			nrfreq++;
+			freq = NULL;
+		}
+
+		/* now populate cpufreq_pstates for this CPU */
+		pstates[cpu].pstate = pstate;
+		pstates[cpu].max = nrfreq;
+		pstates[cpu].current = -1;	/* unknown */
+		pstates[cpu].idle = -1;		/* unknown */
+		pstates[cpu].time_enter = 0.;
+		pstates[cpu].time_exit = 0.;
+	}
+
+	return pstates;
+
+clean_exit:
+	release_pstate_info(pstates, nrcpus);
+	return NULL;
+}
+
+static int get_current_pstate(struct cpuidle_datas *datas, int cpu,
+				struct cpufreq_pstates **pstates,
+				struct cpufreq_pstate **pstate)
+{
+	struct cpufreq_pstates *ps;
+
+	if (cpu < 0 || cpu > datas->nrcpus)
+		return -2;
+
+	ps = &(datas->pstates[cpu]);
+
+	*pstate = (ps->current == -1 ? NULL : &(ps->pstate[ps->current]));
+	*pstates = ps;
+
+	/* return 1 if CPU is idle, otherwise return 0 */
+	return ps->idle;
+}
+
+static int freq_to_pstate_index(struct cpufreq_pstates *ps, int freq)
+{
+	int i;
+
+	/* find frequency in table of P-states */
+	for (i = 0; i < ps->max && freq != ps->pstate[i].freq; i++)
+		/* just search */;
+
+	/* if not found, return -1 */
+	return i >= ps->max ? -1 : ps->pstate[i].id;
+}
+
+static void open_current_pstate(struct cpufreq_pstates *ps, double time)
+{
+	ps->time_enter = time;
+}
+
+static void open_next_pstate(struct cpufreq_pstates *ps, int s, double time)
+{
+	ps->current = s;
+	if (ps->idle) {
+		fprintf(stderr, "warning: opening P-state on idle CPU\n");
+		return;
+	}
+	open_current_pstate(ps, time);
+}
+
+#define USEC_PER_SEC 1000000
+static void close_current_pstate(struct cpufreq_pstates *ps, double time)
+{
+	int c = ps->current;
+	struct cpufreq_pstate *p = &(ps->pstate[c]);
+	double elapsed;
+
+	if (ps->idle) {
+		fprintf(stderr, "warning: closing P-state on idle CPU\n");
+		return;
+	}
+	elapsed = (time - ps->time_enter) * USEC_PER_SEC;
+	p->min_time = MIN(p->min_time, elapsed);
+	p->max_time = MAX(p->max_time, elapsed);
+	p->avg_time = AVG(p->avg_time, elapsed, p->count + 1);
+	p->duration += elapsed;
+	p->count++;
+}
+
+static void cpu_change_pstate(struct cpuidle_datas *datas, int cpu,
+			      int freq, double time)
+{
+	struct cpufreq_pstates *ps;
+	struct cpufreq_pstate *p;
+	int cur, next;
+
+	cur = get_current_pstate(datas, cpu, &ps, &p);
+	next = freq_to_pstate_index(ps, freq);
+
+	switch (cur) {
+	case 1:
+		/* if CPU is idle, update current state and leave
+		 * stats unchanged
+		 */
+		ps->current = next;
+		return;
+
+	case -1:
+		/* current pstate is -1, i.e. this is the first update */
+		open_next_pstate(ps, next, time);
+		return;
+
+	case 0:
+		/* running CPU, update all stats, but skip closing current
+		 * state if it's the initial update for CPU
+		 */
+		if (p)
+			close_current_pstate(ps, time);
+		open_next_pstate(ps, next, time);
+		return;
+
+	default:
+		fprintf(stderr, "illegal pstate %d for cpu %d, exiting.\n",
+			cur, cpu);
+		exit(-1);
+	}
+}
+
+static void cpu_pstate_idle(struct cpuidle_datas *datas, int cpu, double time)
+{
+	struct cpufreq_pstates *ps = &(datas->pstates[cpu]);
+	if (ps->current != -1)
+		close_current_pstate(ps, time);
+	ps->idle = 1;
+}
+
+static void cpu_pstate_running(struct cpuidle_datas *datas, int cpu,
+			       double time)
+{
+	struct cpufreq_pstates *ps = &(datas->pstates[cpu]);
+	ps->idle = 0;
+	if (ps->current != -1)
+		open_current_pstate(ps, time);
+}
+
+static int store_data(double time, int state, int cpu,
+		      struct cpuidle_datas *datas, int count)
+{
+	struct cpuidle_cstates *cstates = &datas->cstates[cpu];
+	struct cpuidle_cstate *cstate;
+	struct cpuidle_data *data, *tmp;
+	int nrdata, last_cstate = cstates->last_cstate;
+
+	/* ignore when we got a "closing" state first */
+	if (state == -1 && cstates->cstate_max == -1)
+		return 0;
+
+	cstate = &cstates->cstate[state == -1 ? last_cstate : state];
+	data = cstate->data;
+	nrdata = cstate->nrdata;
+
+	if (state == -1) {
+
+		data = &data[nrdata];
+
+		data->end = time;
+		data->duration = data->end - data->begin;
+
+		/* That happens when precision digit in the file exceed
+		 * 7 (eg. xxx.1000000). Ignoring the result because I don't
+		 * find a way to fix with the sscanf used in the caller
+		 */
+		if (data->duration < 0)
+			return 0;
+
+		/* convert to us */
+		data->duration *= 1000000;
+
+		cstate->min_time = MIN(cstate->min_time, data->duration);
+
+		cstate->max_time = MAX(cstate->max_time, data->duration);
+
+
+		cstate->avg_time = AVG(cstate->avg_time, data->duration,
+				       cstate->nrdata + 1);
+
+		cstate->duration += data->duration;
+
+		cstate->nrdata++;
+
+		/* need indication if CPU is idle or not */
+		cstates->last_cstate = -1;
+		cpu_pstate_running(datas, cpu, time);
+
+		return 0;
+	}
+
+	tmp = realloc(data, sizeof(*data) * (nrdata + 1));
+	if (!tmp) {
+		free(data);
+		return error("realloc data");
+	}
+	data = tmp;
+
+	data[nrdata].begin = time;
+
+	cstates->cstate[state].data = data;
+	cstates->cstate_max = MAX(cstates->cstate_max, state);
+	cstates->last_cstate = state;
+	cstates->wakeirq = NULL;
+	cpu_pstate_idle(datas, cpu, time);
+
+	return 0;
+}
+
+static struct wakeup_irq *find_irqinfo(struct wakeup_info *wakeinfo, int irqid)
+{
+	struct wakeup_irq *irqinfo;
+	int i;
+
+	for (i = 0; i < wakeinfo->nrdata; i++) {
+		irqinfo = &wakeinfo->irqinfo[i];
+		if (irqinfo->id == irqid)
+			return irqinfo;
+	}
+
+	return NULL;
+}
+
+static int store_irq(int cpu, int irqid, char *irqname,
+		      struct cpuidle_datas *datas, int count, int irq_type)
+{
+	struct cpuidle_cstates *cstates = &datas->cstates[cpu];
+	struct wakeup_irq *irqinfo;
+	struct wakeup_info *wakeinfo = &cstates->wakeinfo;
+
+	if (cstates->wakeirq != NULL)
+		return 0;
+
+	irqinfo = find_irqinfo(wakeinfo, irqid);
+	if (NULL == irqinfo) {
+		irqinfo = realloc(wakeinfo->irqinfo,
+				sizeof(*irqinfo) * (wakeinfo->nrdata + 1));
+		if (!irqinfo)
+			return error("realloc irqinfo");
+
+		wakeinfo->irqinfo = irqinfo;
+
+		irqinfo = &wakeinfo->irqinfo[wakeinfo->nrdata++];
+		irqinfo->id = irqid;
+		strcpy(irqinfo->name, irqname);
+		irqinfo->irq_type = irq_type;
+		irqinfo->count = 0;
+	}
+
+	irqinfo->count++;
+
+	cstates->wakeirq = irqinfo;
+
+	return 0;
+}
+
+#define TRACE_IRQ_FORMAT "%*[^[][%d] %*[^=]=%d%*[^=]=%16s"
+#define TRACE_IPIIRQ_FORMAT "%*[^[][%d] %*[^=]=%d%*[^=]=%16s"
+
+#define TRACE_CMD_FORMAT "%*[^]]] %lf:%*[^=]=%u%*[^=]=%d"
+#define TRACE_FORMAT "%*[^]]] %*s %lf:%*[^=]=%u%*[^=]=%d"
+
+static int get_wakeup_irq(struct cpuidle_datas *datas, char *buffer, int count)
+{
+	int cpu, irqid;
+	char irqname[NAMELEN+1];
+
+	if (strstr(buffer, "irq_handler_entry")) {
+		assert(sscanf(buffer, TRACE_IRQ_FORMAT, &cpu, &irqid,
+			      irqname) == 3);
+
+		store_irq(cpu, irqid, irqname, datas, count, HARD_IRQ);
+		return 0;
+	}
+
+	if (strstr(buffer, "ipi_handler_entry")) {
+		assert(sscanf(buffer, TRACE_IPIIRQ_FORMAT, &cpu, &irqid,
+			      irqname) == 3);
+
+		store_irq(cpu, irqid, irqname, datas, count, IPI_IRQ);
+		return 0;
+	}
+
+	return -1;
+}
+
+static struct cpuidle_datas *idlestat_load(const char *path)
+{
+	FILE *f;
+	unsigned int state = 0, freq = 0, cpu = 0, nrcpus = 0;
+	double time, begin = 0, end = 0;
+	size_t count, start = 1;
+	struct cpuidle_datas *datas;
+	int ret;
+
+	f = fopen(path, "r");
+	if (!f)
+		return ptrerror("fopen");
+
+	/* version line */
+	fgets(buffer, BUFSIZE, f);
+
+	fgets(buffer, BUFSIZE, f);
+	assert(sscanf(buffer, "cpus=%u", &nrcpus) == 1);
+
+	if (!nrcpus) {
+		fclose(f);
+		return ptrerror("read error for 'cpus=' in trace file");
+	}
+
+	datas = malloc(sizeof(*datas));
+	if (!datas) {
+		fclose(f);
+		return ptrerror("malloc datas");
+	}
+
+	datas->cstates = build_cstate_info(nrcpus);
+	if (!datas->cstates) {
+		free(datas);
+		fclose(f);
+		return ptrerror("calloc cstate");
+	}
+
+	datas->pstates = build_pstate_info(nrcpus);
+	if (!datas->pstates)
+		return ptrerror("calloc pstate");
+
+	datas->nrcpus = nrcpus;
+
+	fgets(buffer, BUFSIZE, f);
+
+	/* read topology information */
+	read_cpu_topo_info(f, buffer);
+
+	do {
+		if (strstr(buffer, "cpu_idle")) {
+			assert(sscanf(buffer, TRACE_FORMAT, &time, &state,
+				      &cpu) == 3);
+
+			if (start) {
+				begin = time;
+				start = 0;
+			}
+			end = time;
+
+			store_data(time, state, cpu, datas, count);
+			count++;
+			continue;
+		} else if (strstr(buffer, "cpu_frequency")) {
+			assert(sscanf(buffer, TRACE_FORMAT, &time, &freq,
+				      &cpu) == 3);
+			cpu_change_pstate(datas, cpu, freq, time);
+			continue;
+		}
+
+		ret = get_wakeup_irq(datas, buffer, count);
+		count += (0 == ret) ? 1 : 0;
+
+	} while (fgets(buffer, BUFSIZE, f));
+
+	fclose(f);
+
+	fprintf(stderr, "Log is %lf secs long with %zd events\n",
+		end - begin, count);
+
+	return datas;
+}
+
+struct cpuidle_datas *cluster_data(struct cpuidle_datas *datas)
+{
+	struct cpuidle_cstate *c1, *cstates;
+	struct cpuidle_datas *result;
+	int i, j;
+	int cstate_max = -1;
+
+	result = malloc(sizeof(*result));
+	if (!result)
+		return NULL;
+
+	result->nrcpus = -1; /* the cluster */
+
+	result->cstates = calloc(sizeof(*result->cstates), 1);
+	if (!result->cstates)
+		return NULL;
+
+	/* hack but negligeable overhead */
+	for (i = 0; i < datas->nrcpus; i++)
+		cstate_max = MAX(cstate_max, datas->cstates[i].cstate_max);
+	result->cstates[0].cstate_max = cstate_max;
+
+	for (i = 0; i < cstate_max + 1; i++) {
+
+		for (j = 0, cstates = NULL; j < datas->nrcpus; j++) {
+
+			c1 = &datas->cstates[j].cstate[i];
+
+			cstates = inter(cstates, c1);
+			if (!cstates)
+				continue;
+		}
+
+		/* copy state names from the first cpu */
+		cstates->name = strdup(datas->cstates[0].cstate[i].name);
+
+		result->cstates[0].cstate[i] = *cstates;
+	}
+
+	return result;
+}
+
+struct cpuidle_cstates *core_cluster_data(struct cpu_core *s_core)
+{
+	struct cpuidle_cstate *c1, *cstates;
+	struct cpuidle_cstates *result;
+	struct cpu_cpu      *s_cpu;
+	int i;
+	int cstate_max = -1;
+
+	if (!s_core->is_ht)
+		list_for_each_entry(s_cpu, &s_core->cpu_head, list_cpu)
+			return s_cpu->cstates;
+
+	result = calloc(sizeof(*result), 1);
+	if (!result)
+		return NULL;
+
+	/* hack but negligeable overhead */
+	list_for_each_entry(s_cpu, &s_core->cpu_head, list_cpu)
+		cstate_max = MAX(cstate_max, s_cpu->cstates->cstate_max);
+	result->cstate_max = cstate_max;
+
+	for (i = 0; i < cstate_max + 1; i++) {
+		cstates = NULL;
+		list_for_each_entry(s_cpu, &s_core->cpu_head, list_cpu) {
+			c1 = &s_cpu->cstates->cstate[i];
+
+			cstates = inter(cstates, c1);
+			if (!cstates)
+				continue;
+		}
+		/* copy state name from first cpu */
+		s_cpu = list_first_entry(&s_core->cpu_head, struct cpu_cpu,
+				list_cpu);
+		cstates->name = strdup(s_cpu->cstates->cstate[i].name);
+
+		result->cstate[i] = *cstates;
+	}
+
+	return result;
+}
+
+struct cpuidle_cstates *physical_cluster_data(struct cpu_physical *s_phy)
+{
+	struct cpuidle_cstate *c1, *cstates;
+	struct cpuidle_cstates *result;
+	struct cpu_core      *s_core;
+	int i;
+	int cstate_max = -1;
+
+	result = calloc(sizeof(*result), 1);
+	if (!result)
+		return NULL;
+
+	/* hack but negligeable overhead */
+	list_for_each_entry(s_core, &s_phy->core_head, list_core)
+		cstate_max = MAX(cstate_max, s_core->cstates->cstate_max);
+	result->cstate_max = cstate_max;
+
+	for (i = 0; i < cstate_max + 1; i++) {
+		cstates = NULL;
+		list_for_each_entry(s_core, &s_phy->core_head, list_core) {
+			c1 = &s_core->cstates->cstate[i];
+
+			cstates = inter(cstates, c1);
+			if (!cstates)
+				continue;
+		}
+		/* copy state name from first core */
+		s_core = list_first_entry(&s_phy->core_head, struct cpu_core,
+				list_core);
+		cstates->name = strdup(s_core->cstates->cstate[i].name);
+
+		result->cstate[i] = *cstates;
+	}
+
+	return result;
+}
+
+static void help(const char *cmd)
+{
+	fprintf(stderr,
+		"%s [-d|--dump] [-c|--cstate=x] [-o|--output-file] <file>\n",
+		basename(cmd));
+}
+
+static void version(const char *cmd)
+{
+	printf("%s version %s\n", basename(cmd), IDLESTAT_VERSION);
+}
+
+static struct option long_options[] = {
+	{ "dump",        0, 0, 'd' },
+	{ "iterations",  0, 0, 'i' },
+	{ "cstate",      0, 0, 'c' },
+	{ "debug",       0, 0, 'g' },
+	{ "output-file", 0, 0, 'o' },
+	{ "verbose",     0, 0, 'v' },
+	{ "version",     0, 0, 'V' },
+	{ "help",        0, 0, 'h' },
+	{ 0,             0, 0, 0   }
+};
+
+struct idledebug_options {
+	bool debug;
+	bool dump;
+	int cstate;
+	int iterations;
+	char *filename;
+	unsigned int duration;
+};
+
+int getoptions(int argc, char *argv[], struct idledebug_options *options)
+{
+	int c;
+
+	memset(options, 0, sizeof(*options));
+	options->cstate = -1;
+	options->filename = NULL;
+
+	while (1) {
+
+		int optindex = 0;
+
+		c = getopt_long(argc, argv, "gdvVho:i:c:t:",
+				long_options, &optindex);
+		if (c == -1)
+			break;
+
+		switch (c) {
+		case 'g':
+			options->debug = true;
+			break;
+		case 'd':
+			options->dump = true;
+			break;
+		case 'i':
+			options->iterations = atoi(optarg);
+			break;
+		case 'c':
+			options->cstate = atoi(optarg);
+			break;
+		case 't':
+			options->duration = atoi(optarg);
+			break;
+		case 'o':
+			options->filename = optarg;
+			break;
+		case 'h':
+			help(argv[0]);
+			exit(0);
+			break;
+		case 'V':
+			version(argv[0]);
+			exit(0);
+			break;
+		case '?':
+			fprintf(stderr, "%s: Unknown option %c'.\n",
+				argv[0], optopt);
+			/* fall through */
+		default:
+			return -1;
+		}
+	}
+
+	if (options->cstate >= MAXCSTATE) {
+		fprintf(stderr, "C-state must be less than %d\n", MAXCSTATE);
+		return -1;
+	}
+
+	if (options->iterations < 0)
+		fprintf(stderr, "dump values must be a positive value\n");
+
+	if (NULL == options->filename) {
+		fprintf(stderr, "expected filename\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int idlestat_file_for_each_line(const char *path, void *data,
+					int (*handler)(const char *, void *))
+{
+	FILE *f;
+	int ret;
+
+	if (!handler)
+		return -1;
+
+	f = fopen(path, "r");
+
+	if (!f) {
+		fprintf(stderr, "failed to open '%s': %m\n", path);
+		return -1;
+	}
+
+	while (fgets(buffer, BUFSIZE, f)) {
+		ret = handler(buffer, data);
+		if (ret)
+			break;
+	}
+
+	fclose(f);
+
+	return ret;
+}
+
+static int idlestat_store(const char *path)
+{
+	FILE *f;
+	int ret;
+
+	ret = sysconf(_SC_NPROCESSORS_CONF);
+	if (ret < 0)
+		return -1;
+
+	f = fopen(path, "w+");
+	if (!f) {
+		fprintf(f, "failed to open '%s': %m\n", path);
+		return -1;
+	}
+
+	fprintf(f, "version = 1\n");
+	fprintf(f, "cpus=%d\n", ret);
+
+	/* output topology information */
+	output_cpu_topo_info(f);
+
+	ret = idlestat_file_for_each_line(TRACE_FILE, f, store_line);
+
+	fclose(f);
+
+	return ret;
+}
+
+static int idlestat_wake_all(void)
+{
+	int rcpu, i, ret;
+	cpu_set_t cpumask;
+
+	ret = sysconf(_SC_NPROCESSORS_CONF);
+	if (ret < 0)
+		return -1;
+
+	rcpu = sched_getcpu();
+	if (rcpu < 0)
+		return -1;
+
+	for (i = 0; i < ret; i++) {
+
+		/* Pointless to wake up ourself */
+		if (i == rcpu)
+			continue;
+
+		CPU_ZERO(&cpumask);
+		CPU_SET(i, &cpumask);
+
+		sched_setaffinity(0, sizeof(cpumask), &cpumask);
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct cpuidle_datas *datas;
+	struct cpuidle_datas *cluster;
+	struct idledebug_options options;
+	struct rusage rusage;
+
+	if (getoptions(argc, argv, &options))
+		return 1;
+
+	/* We have to manipulate some files only accessible to root */
+	if (getuid()) {
+		fprintf(stderr, "must be root to run the tool\n");
+		return -1;
+	}
+
+	/* init cpu topoinfo */
+	init_cpu_topo_info();
+
+	/* Acquisition time specified means we will get the traces */
+	if (options.duration) {
+
+		/* Read cpu topology info from sysfs */
+		read_sysfs_cpu_topo();
+
+		/* Stop tracing (just in case) */
+		if (idlestat_trace_enable(false))
+			return -1;
+
+		/* Initialize the traces for cpu_idle and increase the
+		 * buffer size to let 'idlestat' to sleep instead of
+		 * acquiring data, hence preventing it to pertubate the
+		 * measurements. */
+		if (idlestat_init_trace(options.duration))
+			return 1;
+
+		/* Remove all the previous traces */
+		if (idlestat_flush_trace())
+			return -1;
+
+		/* Start the recording */
+		if (idlestat_trace_enable(true))
+			return -1;
+		/* We want to prevent to begin the acquisition with a cpu in
+		 * idle state because we won't be able later to close the
+		 * state and to determine which state it was. */
+		if (idlestat_wake_all())
+			return -1;
+
+		/* Do nothing */
+		sleep(options.duration);
+
+		/* Wake up all cpus again to account for last idle state */
+		if (idlestat_wake_all())
+			return -1;
+
+		/* Stop tracing */
+		if (idlestat_trace_enable(false))
+			return -1;
+
+		/* At this point we should have some spurious wake up
+		 * at the beginning of the traces and at the end (wake
+		 * up all cpus and timer expiration for the timer
+		 * acquisition). We assume these will be lost in the number
+		 * of other traces and could be negligible. */
+		if (idlestat_store(options.filename))
+			return -1;
+	}
+
+	/* Load the idle states information */
+	datas = idlestat_load(options.filename);
+	if (!datas)
+		return 1;
+
+	/* Compute cluster idle intersection between cpus belonging to
+	 * the same cluster
+	 */
+	if (0 == establish_idledata_to_topo(datas)) {
+		if (options.dump > 0)
+			dump_cpu_topo_info(options.cstate, options.iterations,
+					   dump_states);
+		else
+			dump_cpu_topo_info(options.cstate, options.iterations,
+					   display_states);
+	} else {
+		cluster = cluster_data(datas);
+		if (!cluster)
+			return 1;
+
+		if (options.dump > 0) {
+			dump_all_data(datas, options.cstate,
+				      options.iterations, dump_states);
+			dump_all_data(cluster, options.cstate,
+				      options.iterations, dump_states);
+		} else {
+			dump_all_data(datas, options.cstate,
+				      options.iterations, display_states);
+			dump_all_data(cluster, options.cstate,
+				      options.iterations, display_states);
+		}
+
+		free(cluster->cstates);
+		free(cluster);
+	}
+
+	/* Computation could be heavy, let's give some information
+	 * about the memory consumption */
+	if (options.debug) {
+		getrusage(RUSAGE_SELF, &rusage);
+		printf("max rss : %ld kB\n", rusage.ru_maxrss);
+	}
+
+	release_cpu_topo_cstates();
+	release_cpu_topo_info();
+	release_pstate_info(datas->pstates, datas->nrcpus);
+	release_cstate_info(datas->cstates, datas->nrcpus);
+	free(datas);
+
+	return 0;
+}
diff --git a/tools/power/idlestat/idlestat.h b/tools/power/idlestat/idlestat.h
new file mode 100644
index 0000000..58477a6
--- /dev/null
+++ b/tools/power/idlestat/idlestat.h
@@ -0,0 +1,106 @@
+/*
+ *  idlestat.h
+ *
+ *  Copyright (C) 2014, Linaro Limited.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * Contributors:
+ *     Daniel Lezcano <daniel.lezcano@linaro.org>
+ *     Zoran Markovic <zoran.markovic@linaro.org>
+ *
+ */
+#ifndef __IDLESTAT_H
+#define __IDLESTAT_H
+
+#define BUFSIZE 256
+#define NAMELEN 16
+#define MAXCSTATE 8
+#define MAXPSTATE 8
+#define MAX(A, B) (A > B ? A : B)
+#define MIN(A, B) (A < B ? A : B)
+#define AVG(A, B, I) ((A) + ((B - A) / (I)))
+
+#define IRQ_WAKEUP_UNIT_NAME "cpu"
+
+struct cpuidle_data {
+	double begin;
+	double end;
+	double duration;
+};
+
+struct cpuidle_cstate {
+	char *name;
+	struct cpuidle_data *data;
+	int nrdata;
+	double avg_time;
+	double max_time;
+	double min_time;
+	double duration;
+};
+
+enum IRQ_TYPE {
+	HARD_IRQ = 0,
+	IPI_IRQ,
+	IRQ_TYPE_MAX
+};
+
+struct wakeup_irq {
+	int id;
+	int irq_type;
+	char name[NAMELEN+1];
+	int count;
+};
+
+struct wakeup_info {
+	struct wakeup_irq *irqinfo;
+	int nrdata;
+};
+
+struct cpuidle_cstates {
+	struct cpuidle_cstate cstate[MAXCSTATE];
+	struct wakeup_info wakeinfo;
+	int last_cstate;
+	int cstate_max;
+	struct wakeup_irq *wakeirq;
+};
+
+struct cpufreq_pstate {
+	int id;
+	unsigned int freq;
+	int count;
+	double min_time;
+	double max_time;
+	double avg_time;
+	double duration;
+};
+
+struct cpufreq_pstates {
+	struct cpufreq_pstate *pstate;
+	int current;
+	int idle;
+	double time_enter;
+	double time_exit;
+	int max;
+};
+
+struct cpuidle_datas {
+	struct cpuidle_cstates *cstates;
+	struct cpufreq_pstates *pstates;
+	int nrcpus;
+};
+
+#endif
diff --git a/tools/power/idlestat/list.h b/tools/power/idlestat/list.h
new file mode 100644
index 0000000..45166da
--- /dev/null
+++ b/tools/power/idlestat/list.h
@@ -0,0 +1,588 @@
+/*
+ *  list.h
+ *
+ *  Copyright (C) 2014, Linaro Limited.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * Contributors:
+ *     Daniel Lezcano <daniel.lezcano@linaro.org>
+ *     Zoran Markovic <zoran.markovic@linaro.org>
+ *
+ */
+#ifndef _LINUX_LIST_H
+#define _LINUX_LIST_H
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+
+#define LIST_POISON1 ((void *)0x00100100)
+#define LIST_POISON2 ((void *)0x00200200)
+
+struct list_head {
+	struct list_head *next, *prev;
+};
+
+/*
+ * Simple doubly linked list implementation.
+ *
+ * Some of the internal functions ("__xxx") are useful when
+ * manipulating whole lists rather than single entries, as
+ * sometimes we already know the next/prev entries and we can
+ * generate better code by using them directly rather than
+ * using the generic single-entry routines.
+ */
+
+#define LIST_HEAD_INIT(name) { &(name), &(name) }
+
+#define LIST_HEAD(name) \
+	struct list_head name = LIST_HEAD_INIT(name)
+
+static inline void INIT_LIST_HEAD(struct list_head *list)
+{
+	list->next = list;
+	list->prev = list;
+}
+
+/*
+ * Insert a new entry between two known consecutive entries.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_add(struct list_head *new,
+			      struct list_head *prev,
+			      struct list_head *next)
+{
+	next->prev = new;
+	new->next = next;
+	new->prev = prev;
+	prev->next = new;
+}
+
+/**
+ * list_add - add a new entry
+ * @new: new entry to be added
+ * @head: list head to add it after
+ *
+ * Insert a new entry after the specified head.
+ * This is good for implementing stacks.
+ */
+static inline void list_add(struct list_head *new, struct list_head *head)
+{
+	__list_add(new, head, head->next);
+}
+
+
+/**
+ * list_add_tail - add a new entry
+ * @new: new entry to be added
+ * @head: list head to add it before
+ *
+ * Insert a new entry before the specified head.
+ * This is useful for implementing queues.
+ */
+static inline void list_add_tail(struct list_head *new, struct list_head *head)
+{
+	__list_add(new, head->prev, head);
+}
+
+/*
+ * Delete a list entry by making the prev/next entries
+ * point to each other.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_del(struct list_head *prev, struct list_head *next)
+{
+	next->prev = prev;
+	prev->next = next;
+}
+
+/**
+ * list_del - deletes entry from list.
+ * @entry: the element to delete from the list.
+ * Note: list_empty() on entry does not return true after this, the entry is
+ * in an undefined state.
+ */
+static inline void __list_del_entry(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+}
+
+static inline void list_del(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	entry->next = LIST_POISON1;
+	entry->prev = LIST_POISON2;
+}
+
+/**
+ * list_replace - replace old entry by new one
+ * @old : the element to be replaced
+ * @new : the new element to insert
+ *
+ * If @old was empty, it will be overwritten.
+ */
+static inline void list_replace(struct list_head *old,
+				struct list_head *new)
+{
+	new->next = old->next;
+	new->next->prev = new;
+	new->prev = old->prev;
+	new->prev->next = new;
+}
+
+static inline void list_replace_init(struct list_head *old,
+					struct list_head *new)
+{
+	list_replace(old, new);
+	INIT_LIST_HEAD(old);
+}
+
+/**
+ * list_del_init - deletes entry from list and reinitialize it.
+ * @entry: the element to delete from the list.
+ */
+static inline void list_del_init(struct list_head *entry)
+{
+	__list_del_entry(entry);
+	INIT_LIST_HEAD(entry);
+}
+
+/**
+ * list_move - delete from one list and add as another's head
+ * @list: the entry to move
+ * @head: the head that will precede our entry
+ */
+static inline void list_move(struct list_head *list, struct list_head *head)
+{
+	__list_del_entry(list);
+	list_add(list, head);
+}
+
+/**
+ * list_move_tail - delete from one list and add as another's tail
+ * @list: the entry to move
+ * @head: the head that will follow our entry
+ */
+static inline void list_move_tail(struct list_head *list,
+				  struct list_head *head)
+{
+	__list_del_entry(list);
+	list_add_tail(list, head);
+}
+
+/**
+ * list_is_last - tests whether @list is the last entry in list @head
+ * @list: the entry to test
+ * @head: the head of the list
+ */
+static inline int list_is_last(const struct list_head *list,
+				const struct list_head *head)
+{
+	return list->next == head;
+}
+
+/**
+ * list_empty - tests whether a list is empty
+ * @head: the list to test.
+ */
+static inline int list_empty(const struct list_head *head)
+{
+	return head->next == head;
+}
+
+/**
+ * list_empty_careful - tests whether a list is empty and not being modified
+ * @head: the list to test
+ *
+ * Description:
+ * tests whether a list is empty _and_ checks that no other CPU might be
+ * in the process of modifying either member (next or prev)
+ *
+ * NOTE: using list_empty_careful() without synchronization
+ * can only be safe if the only activity that can happen
+ * to the list entry is list_del_init(). Eg. it cannot be used
+ * if another CPU could re-list_add() it.
+ */
+static inline int list_empty_careful(const struct list_head *head)
+{
+	struct list_head *next = head->next;
+	return (next == head) && (next == head->prev);
+}
+
+/**
+ * list_rotate_left - rotate the list to the left
+ * @head: the head of the list
+ */
+static inline void list_rotate_left(struct list_head *head)
+{
+	struct list_head *first;
+
+	if (!list_empty(head)) {
+		first = head->next;
+		list_move_tail(first, head);
+	}
+}
+
+/**
+ * list_is_singular - tests whether a list has just one entry.
+ * @head: the list to test.
+ */
+static inline int list_is_singular(const struct list_head *head)
+{
+	return !list_empty(head) && (head->next == head->prev);
+}
+
+static inline void __list_cut_position(struct list_head *list,
+		struct list_head *head, struct list_head *entry)
+{
+	struct list_head *new_first = entry->next;
+	list->next = head->next;
+	list->next->prev = list;
+	list->prev = entry;
+	entry->next = list;
+	head->next = new_first;
+	new_first->prev = head;
+}
+
+/**
+ * list_cut_position - cut a list into two
+ * @list: a new list to add all removed entries
+ * @head: a list with entries
+ * @entry: an entry within head, could be the head itself
+ *	and if so we won't cut the list
+ *
+ * This helper moves the initial part of @head, up to and
+ * including @entry, from @head to @list. You should
+ * pass on @entry an element you know is on @head. @list
+ * should be an empty list or a list you do not care about
+ * losing its data.
+ *
+ */
+static inline void list_cut_position(struct list_head *list,
+		struct list_head *head, struct list_head *entry)
+{
+	if (list_empty(head))
+		return;
+	if (list_is_singular(head) &&
+		(head->next != entry && head != entry))
+		return;
+	if (entry == head)
+		INIT_LIST_HEAD(list);
+	else
+		__list_cut_position(list, head, entry);
+}
+
+static inline void __list_splice(const struct list_head *list,
+				 struct list_head *prev,
+				 struct list_head *next)
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+
+	first->prev = prev;
+	prev->next = first;
+
+	last->next = next;
+	next->prev = last;
+}
+
+/**
+ * list_splice - join two lists, this is designed for stacks
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ */
+static inline void list_splice(const struct list_head *list,
+				struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice(list, head, head->next);
+}
+
+/**
+ * list_splice_tail - join two lists, each list being a queue
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ */
+static inline void list_splice_tail(struct list_head *list,
+				struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice(list, head->prev, head);
+}
+
+/**
+ * list_splice_init - join two lists and reinitialise the emptied list.
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ *
+ * The list at @list is reinitialised
+ */
+static inline void list_splice_init(struct list_head *list,
+				    struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice(list, head, head->next);
+		INIT_LIST_HEAD(list);
+	}
+}
+
+/**
+ * list_splice_tail_init - join two lists and reinitialise the emptied list
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ *
+ * Each of the lists is a queue.
+ * The list at @list is reinitialised
+ */
+static inline void list_splice_tail_init(struct list_head *list,
+					 struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice(list, head->prev, head);
+		INIT_LIST_HEAD(list);
+	}
+}
+
+#undef offsetof
+#define offsetof(s, m)      ((size_t)&(((s *)0)->m))
+
+#undef container_of
+#define container_of(ptr, type, member) ({			\
+	const typeof(((type *)0)->member) * __mptr = (ptr);	\
+	(type *)((char *)__mptr - offsetof(type, member)); })
+
+/**
+ * list_entry - get the struct for this entry
+ * @ptr:	the &struct list_head pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_entry(ptr, type, member) \
+	container_of(ptr, type, member)
+
+/**
+ * list_first_entry - get the first element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define list_first_entry(ptr, type, member) \
+	list_entry((ptr)->next, type, member)
+
+/**
+ * list_for_each	-	iterate over a list
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ */
+#define list_for_each(pos, head) \
+	for (pos = (head)->next; pos != (head); pos = pos->next)
+
+/**
+ * __list_for_each	-	iterate over a list
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ *
+ * This variant doesn't differ from list_for_each() any more.
+ * We don't do prefetching in either case.
+ */
+#define __list_for_each(pos, head) \
+	for (pos = (head)->next; pos != (head); pos = pos->next)
+
+/**
+ * list_for_each_prev	-	iterate over a list backwards
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ */
+#define list_for_each_prev(pos, head) \
+	for (pos = (head)->prev; pos != (head); pos = pos->prev)
+
+/**
+ * list_for_each_safe - iterate over a list safe against removal of list entry
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @n:		another &struct list_head to use as temporary storage
+ * @head:	the head for your list.
+ */
+#define list_for_each_safe(pos, n, head) \
+	for (pos = (head)->next, n = pos->next; pos != (head); \
+		pos = n, n = pos->next)
+
+/**
+ * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @n:		another &struct list_head to use as temporary storage
+ * @head:	the head for your list.
+ */
+#define list_for_each_prev_safe(pos, n, head) \
+	for (pos = (head)->prev, n = pos->prev; \
+	     pos != (head); \
+	     pos = n, n = pos->prev)
+
+/**
+ * list_for_each_entry	-	iterate over list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_each_entry(pos, head, member)				\
+	for (pos = list_entry((head)->next, typeof(*pos), member);	\
+	     &pos->member != (head);	\
+	     pos = list_entry(pos->member.next, typeof(*pos), member))
+
+/**
+ * list_for_each_entry_reverse - iterate backwards over list of given type.
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_each_entry_reverse(pos, head, member)			\
+	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
+	     &pos->member != (head);	\
+	     pos = list_entry(pos->member.prev, typeof(*pos), member))
+
+/**
+ * list_prepare_entry - prepare a entry for use in list_for_each_entry_continue()
+ * @pos:	the type * to use as a start point
+ * @head:	the head of the list
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Prepares a entry for use as a start point in list_for_each_entry_continue().
+ */
+#define list_prepare_entry(pos, head, member) \
+	((pos) ? : list_entry(head, typeof(*pos), member))
+
+/**
+ * list_for_each_entry_continue - continue iteration over list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Continue to iterate over list of given type, continuing after
+ * the current position.
+ */
+#define list_for_each_entry_continue(pos, head, member)		\
+	for (pos = list_entry(pos->member.next, typeof(*pos), member);	\
+	     &pos->member != (head);	\
+	     pos = list_entry(pos->member.next, typeof(*pos), member))
+
+/**
+ * list_for_each_entry_continue_reverse - iterate backwards from the given point
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Start to iterate over list of given type backwards, continuing after
+ * the current position.
+ */
+#define list_for_each_entry_continue_reverse(pos, head, member)		\
+	for (pos = list_entry(pos->member.prev, typeof(*pos), member);	\
+	     &pos->member != (head);	\
+	     pos = list_entry(pos->member.prev, typeof(*pos), member))
+
+/**
+ * list_for_each_entry_from - iterate over list of given type from the current point
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Iterate over list of given type, continuing from current position.
+ */
+#define list_for_each_entry_from(pos, head, member)			\
+	for (; &pos->member != (head);	\
+	     pos = list_entry(pos->member.next, typeof(*pos), member))
+
+/**
+ * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_each_entry_safe(pos, n, head, member)			\
+	for (pos = list_entry((head)->next, typeof(*pos), member),	\
+		n = list_entry(pos->member.next, typeof(*pos), member);	\
+	     &pos->member != (head);					\
+	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
+
+/**
+ * list_for_each_entry_safe_continue - continue list iteration safe against removal
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Iterate over list of given type, continuing after current point,
+ * safe against removal of list entry.
+ */
+#define list_for_each_entry_safe_continue(pos, n, head, member)		\
+	for (pos = list_entry(pos->member.next, typeof(*pos), member),	\
+		n = list_entry(pos->member.next, typeof(*pos), member);	\
+	     &pos->member != (head);					\
+	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
+
+/**
+ * list_for_each_entry_safe_from - iterate over list from current point safe against removal
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Iterate over list of given type from current point, safe against
+ * removal of list entry.
+ */
+#define list_for_each_entry_safe_from(pos, n, head, member)		\
+	for (n = list_entry(pos->member.next, typeof(*pos), member);	\
+	     &pos->member != (head);					\
+	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
+
+/**
+ * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Iterate backwards over list of given type, safe against removal
+ * of list entry.
+ */
+#define list_for_each_entry_safe_reverse(pos, n, head, member)		\
+	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
+		n = list_entry(pos->member.prev, typeof(*pos), member);	\
+	     &pos->member != (head);					\
+	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
+
+/**
+ * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
+ * @pos:	the loop cursor used in the list_for_each_entry_safe loop
+ * @n:		temporary storage used in list_for_each_entry_safe
+ * @member:	the name of the list_struct within the struct.
+ *
+ * list_safe_reset_next is not safe to use in general if the list may be
+ * modified concurrently (eg. the lock is dropped in the loop body). An
+ * exception to this is if the cursor element (pos) is pinned in the list,
+ * and list_safe_reset_next is called after re-taking the lock and before
+ * completing the current iteration of the loop body.
+ */
+#define list_safe_reset_next(pos, n, member)				\
+	(n = list_entry(pos->member.next, typeof(*pos), member))
+
+#endif
diff --git a/tools/power/idlestat/topology.c b/tools/power/idlestat/topology.c
new file mode 100644
index 0000000..f610053
--- /dev/null
+++ b/tools/power/idlestat/topology.c
@@ -0,0 +1,503 @@
+/*
+ *  topology.c
+ *
+ *  Copyright (C) 2014, Linaro Limited.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * Contributors:
+ *     Daniel Lezcano <daniel.lezcano@linaro.org>
+ *     Zoran Markovic <zoran.markovic@linaro.org>
+ *
+ */
+#define  _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <string.h>
+#include <dirent.h>
+#include <ctype.h>
+#include <sys/stat.h>
+#include <assert.h>
+
+#include "list.h"
+#include "utils.h"
+#include "topology.h"
+#include "idlestat.h"
+
+struct cpu_topology g_cpu_topo_list;
+
+struct topology_info {
+	int physical_id;
+	int core_id;
+	int cpu_id;
+};
+
+struct list_info {
+	struct list_head hlist;
+	int id;
+};
+
+struct list_head *check_exist_from_head(struct list_head *head, int id)
+{
+	struct list_head *tmp;
+
+	list_for_each(tmp, head) {
+		if (id == ((struct list_info *)tmp)->id)
+			return tmp;
+	}
+
+	return NULL;
+}
+
+struct list_head *check_pos_from_head(struct list_head *head, int id)
+{
+	struct list_head *tmp;
+
+	list_for_each(tmp, head) {
+		if (id < ((struct list_info *)tmp)->id)
+			break;
+	}
+
+	return tmp->prev;
+}
+
+int add_topo_info(struct cpu_topology *topo_list, struct topology_info *info)
+{
+	struct cpu_physical *s_phy;
+	struct cpu_core     *s_core;
+	struct cpu_cpu      *s_cpu = NULL;
+	struct list_head    *ptr;
+
+	/* add cpu physical info */
+	ptr = check_exist_from_head(&topo_list->physical_head,
+					info->physical_id);
+	if (!ptr) {
+		s_phy = calloc(sizeof(struct cpu_physical), 1);
+		if (!s_phy)
+			return -1;
+
+		s_phy->core_num = 0;
+		s_phy->physical_id = info->physical_id;
+		INIT_LIST_HEAD(&s_phy->core_head);
+
+		ptr = check_pos_from_head(&topo_list->physical_head,
+						s_phy->physical_id);
+		list_add(&s_phy->list_physical, ptr);
+		topo_list->physical_num++;
+	} else {
+		s_phy = list_entry(ptr, struct cpu_physical,
+						list_physical);
+	}
+
+	/* add cpu core info */
+	ptr = check_exist_from_head(&s_phy->core_head, info->core_id);
+	if (!ptr) {
+		s_core = calloc(sizeof(struct cpu_core), 1);
+		if (!s_core)
+			return -1;
+
+		s_core->cpu_num = 0;
+		s_core->is_ht = false;
+		s_core->core_id = info->core_id;
+		INIT_LIST_HEAD(&s_core->cpu_head);
+
+		ptr = check_pos_from_head(&s_phy->core_head,
+						s_core->core_id);
+		list_add(&s_core->list_core, ptr);
+		s_phy->core_num++;
+
+	} else {
+		s_core = list_entry(ptr, struct cpu_core, list_core);
+	}
+
+	/* add cpu info */
+	ptr = check_exist_from_head(&s_core->cpu_head, info->cpu_id);
+	if (!ptr) {
+		s_cpu = calloc(sizeof(struct cpu_cpu), 1);
+		if (!s_cpu)
+			return -1;
+
+		s_cpu->cpu_id = info->cpu_id;
+
+		ptr = check_pos_from_head(&s_core->cpu_head, s_cpu->cpu_id);
+		list_add(&s_cpu->list_cpu, ptr);
+		s_core->cpu_num++;
+		if (s_core->cpu_num > 1)
+			s_core->is_ht = true;
+	}
+
+	return 0;
+}
+
+void free_cpu_cpu_list(struct list_head *head)
+{
+	struct cpu_cpu *lcpu, *n;
+
+	list_for_each_entry_safe(lcpu, n, head, list_cpu) {
+		list_del(&lcpu->list_cpu);
+		free(lcpu);
+	}
+}
+
+void free_cpu_core_list(struct list_head *head)
+{
+	struct cpu_core *lcore, *n;
+
+	list_for_each_entry_safe(lcore, n, head, list_core) {
+		free_cpu_cpu_list(&lcore->cpu_head);
+		list_del(&lcore->list_core);
+		free(lcore);
+	}
+}
+
+void free_cpu_topology(struct list_head *head)
+{
+	struct cpu_physical *lphysical, *n;
+
+	list_for_each_entry_safe(lphysical, n, head, list_physical) {
+		free_cpu_core_list(&lphysical->core_head);
+		list_del(&lphysical->list_physical);
+		free(lphysical);
+	}
+}
+
+int output_topo_info(struct cpu_topology *topo_list)
+{
+	struct cpu_physical *s_phy;
+	struct cpu_core     *s_core;
+	struct cpu_cpu      *s_cpu;
+
+	list_for_each_entry(s_phy, &topo_list->physical_head, list_physical) {
+		printf("cluster%c:\n", s_phy->physical_id + 'A');
+		list_for_each_entry(s_core, &s_phy->core_head, list_core) {
+			printf("\tcore%d\n", s_core->core_id);
+			list_for_each_entry(s_cpu, &s_core->cpu_head, list_cpu)
+				printf("\t\tcpu%d\n", s_cpu->cpu_id);
+		}
+	}
+
+	return 0;
+}
+
+int outfile_topo_info(FILE *f, struct cpu_topology *topo_list)
+{
+	struct cpu_physical *s_phy;
+	struct cpu_core     *s_core;
+	struct cpu_cpu      *s_cpu;
+
+	list_for_each_entry(s_phy, &topo_list->physical_head, list_physical) {
+		fprintf(f, "cluster%c:\n", s_phy->physical_id + 'A');
+		list_for_each_entry(s_core, &s_phy->core_head, list_core) {
+			fprintf(f, "\tcore%d\n", s_core->core_id);
+			list_for_each_entry(s_cpu, &s_core->cpu_head, list_cpu)
+				fprintf(f, "\t\tcpu%d\n", s_cpu->cpu_id);
+		}
+	}
+
+	return 0;
+}
+
+struct cpu_cpu *find_cpu_point(struct cpu_topology *topo_list, int cpuid)
+{
+	struct cpu_physical *s_phy;
+	struct cpu_core     *s_core;
+	struct cpu_cpu      *s_cpu;
+
+	list_for_each_entry(s_phy, &topo_list->physical_head, list_physical)
+		list_for_each_entry(s_core, &s_phy->core_head, list_core)
+			list_for_each_entry(s_cpu, &s_core->cpu_head, list_cpu)
+				if (s_cpu->cpu_id == cpuid)
+					return s_cpu;
+
+	return NULL;
+}
+
+static inline int read_topology_cb(char *path, struct topology_info *info)
+{
+	file_read_value(path, "core_id", "%d", &info->core_id);
+	file_read_value(path, "physical_package_id", "%d", &info->physical_id);
+
+	return 0;
+}
+
+typedef int (*folder_filter_t)(const char *name);
+
+static int cpu_filter_cb(const char *name)
+{
+	/* let's ignore some directories in order to avoid to be
+	 * pulled inside the sysfs circular symlinks mess/hell
+	 * (choose the word which fit better)*/
+	if (!strcmp(name, "cpuidle"))
+		return 1;
+
+	if (!strcmp(name, "cpufreq"))
+		return 1;
+
+	return 0;
+}
+
+/*
+ * This function will browse the directory structure and build a
+ * reflecting the content of the directory tree.
+ *
+ * @path   : the root node of the folder
+ * @filter : a callback to filter out the directories
+ * Returns 0 on success, -1 otherwise
+ */
+static int topo_folder_scan(char *path, folder_filter_t filter)
+{
+	DIR *dir, *dir_topology;
+	char *basedir, *newpath;
+	struct dirent dirent, *direntp;
+	struct stat s;
+	int ret = 0;
+
+	dir = opendir(path);
+	if (!dir) {
+		printf("error: unable to open directory %s\n", path);
+		return -1;
+	}
+
+	ret = asprintf(&basedir, "%s", path);
+	if (ret < 0)
+		return -1;
+
+	while (!readdir_r(dir, &dirent, &direntp)) {
+
+		if (!direntp)
+			break;
+
+		if (direntp->d_name[0] == '.')
+			continue;
+
+		if (filter && filter(direntp->d_name))
+			continue;
+
+		if (!strstr(direntp->d_name, "cpu"))
+			continue;
+
+		ret = asprintf(&newpath, "%s/%s/%s", basedir,
+				direntp->d_name, "topology");
+		if (ret < 0)
+			goto out_free_basedir;
+
+		ret = stat(newpath, &s);
+		if (ret)
+			goto out_free_newpath;
+
+		if (S_ISDIR(s.st_mode) || (S_ISLNK(s.st_mode))) {
+			struct topology_info cpu_info;
+
+			dir_topology = opendir(path);
+			if (!dir_topology)
+				continue;
+
+			read_topology_cb(newpath, &cpu_info);
+			assert(sscanf(direntp->d_name, "cpu%d",
+				      &cpu_info.cpu_id) == 1);
+			add_topo_info(&g_cpu_topo_list, &cpu_info);
+		}
+
+out_free_newpath:
+		free(newpath);
+
+		if (ret)
+			break;
+	}
+
+out_free_basedir:
+	free(basedir);
+
+	closedir(dir);
+
+	return ret;
+}
+
+
+int init_cpu_topo_info(void)
+{
+	INIT_LIST_HEAD(&g_cpu_topo_list.physical_head);
+	g_cpu_topo_list.physical_num = 0;
+
+	return 0;
+}
+
+int read_sysfs_cpu_topo(void)
+{
+	topo_folder_scan("/sys/devices/system/cpu", cpu_filter_cb);
+
+	return 0;
+}
+
+int read_cpu_topo_info(FILE *f, char *buf)
+{
+	int ret = 0;
+	struct topology_info cpu_info;
+	bool is_ht = false;
+	char pid;
+
+	do {
+		ret = sscanf(buf, "cluster%c", &pid);
+		if (!ret)
+			break;
+
+		cpu_info.physical_id = pid - 'A';
+
+		fgets(buf, BUFSIZE, f);
+		do {
+			ret = sscanf(buf, "\tcore%u", &cpu_info.core_id);
+			if (ret) {
+				is_ht = true;
+				fgets(buf, BUFSIZE, f);
+			} else {
+				ret = sscanf(buf, "\tcpu%u", &cpu_info.cpu_id);
+				if (ret)
+					is_ht = false;
+				else
+					break;
+			}
+
+			do {
+				if (!is_ht) {
+					ret = sscanf(buf, "\tcpu%u",
+						     &cpu_info.cpu_id);
+					cpu_info.core_id = cpu_info.cpu_id;
+				} else {
+					ret = sscanf(buf, "\t\tcpu%u",
+						     &cpu_info.cpu_id);
+				}
+
+				if (!ret)
+					break;
+
+				add_topo_info(&g_cpu_topo_list, &cpu_info);
+
+				fgets(buf, BUFSIZE, f);
+			} while (1);
+		} while (1);
+	} while (1);
+
+	/* output_topo_info(&g_cpu_topo_list); */
+
+	return 0;
+}
+
+int release_cpu_topo_info(void)
+{
+	/* free alloced memory */
+	free_cpu_topology(&g_cpu_topo_list.physical_head);
+
+	return 0;
+}
+
+int output_cpu_topo_info(FILE *f)
+{
+	outfile_topo_info(f, &g_cpu_topo_list);
+
+	return 0;
+}
+
+int establish_idledata_to_topo(struct cpuidle_datas *datas)
+{
+	struct cpu_physical *s_phy;
+	struct cpu_core     *s_core;
+	struct cpu_cpu      *s_cpu;
+	int    i;
+	int    has_topo = 0;
+
+	for (i = 0; i < datas->nrcpus; i++) {
+		s_cpu = find_cpu_point(&g_cpu_topo_list, i);
+		if (s_cpu) {
+			s_cpu->cstates = &datas->cstates[i];
+			s_cpu->pstates = &datas->pstates[i];
+			has_topo = 1;
+		}
+	}
+
+	if (!has_topo)
+		return -1;
+
+	list_for_each_entry(s_phy, &g_cpu_topo_list.physical_head,
+			    list_physical)
+		list_for_each_entry(s_core, &s_phy->core_head, list_core)
+			s_core->cstates = core_cluster_data(s_core);
+
+	list_for_each_entry(s_phy, &g_cpu_topo_list.physical_head,
+			    list_physical)
+		s_phy->cstates = physical_cluster_data(s_phy);
+
+	return 0;
+}
+
+int dump_cpu_topo_info(int state, int count,
+	int (*dump)(struct cpuidle_cstates *, struct cpufreq_pstates *,
+	int,  int, char *))
+{
+	struct cpu_physical *s_phy;
+	struct cpu_core     *s_core;
+	struct cpu_cpu      *s_cpu;
+	char   tmp[30];
+	int    tab = 0;
+
+	list_for_each_entry(s_phy, &g_cpu_topo_list.physical_head,
+			    list_physical) {
+		sprintf(tmp, "cluster%c", s_phy->physical_id + 'A');
+		dump(s_phy->cstates, NULL, state, count, tmp);
+
+		list_for_each_entry(s_core, &s_phy->core_head, list_core) {
+			if (s_core->is_ht) {
+				sprintf(tmp, "  core%d", s_core->core_id);
+				dump(s_core->cstates, NULL, state, count, tmp);
+
+				tab = 1;
+			} else {
+				tab = 0;
+			}
+
+			list_for_each_entry(s_cpu, &s_core->cpu_head,
+					    list_cpu) {
+				sprintf(tmp, "%*ccpu%d", (tab + 1) * 2, 0x20,
+					s_cpu->cpu_id);
+				dump(s_cpu->cstates, s_cpu->pstates, state,
+				     count, tmp);
+			}
+		}
+	}
+
+	return 0;
+}
+
+int release_cpu_topo_cstates(void)
+{
+	struct cpu_physical *s_phy;
+	struct cpu_core     *s_core;
+
+	list_for_each_entry(s_phy, &g_cpu_topo_list.physical_head,
+			    list_physical) {
+		free(s_phy->cstates);
+		s_phy->cstates = NULL;
+		list_for_each_entry(s_core, &s_phy->core_head, list_core)
+			if (s_core->is_ht) {
+				free(s_core->cstates);
+				s_core->cstates = NULL;
+			}
+	}
+
+	return 0;
+}
diff --git a/tools/power/idlestat/topology.h b/tools/power/idlestat/topology.h
new file mode 100644
index 0000000..5ad244c
--- /dev/null
+++ b/tools/power/idlestat/topology.h
@@ -0,0 +1,77 @@
+/*
+ *  topology.h
+ *
+ *  Copyright (C) 2014, Linaro Limited.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * Contributors:
+ *     Daniel Lezcano <daniel.lezcano@linaro.org>
+ *     Zoran Markovic <zoran.markovic@linaro.org>
+ *
+ */
+#ifndef __TOPOLOGY_H
+#define __TOPOLOGY_H
+
+#include "list.h"
+#include "idlestat.h"
+
+struct cpu_cpu {
+	struct list_head list_cpu;
+	int cpu_id;
+	struct cpuidle_cstates *cstates;
+	struct cpufreq_pstates *pstates;
+};
+
+struct cpu_core {
+	struct list_head list_core;
+	int core_id;
+	struct list_head cpu_head;
+	int cpu_num;
+	bool is_ht;
+	struct cpuidle_cstates *cstates;
+};
+
+struct cpu_physical {
+	struct list_head list_physical;
+	int physical_id;
+	struct list_head core_head;
+	int core_num;
+	struct cpuidle_cstates *cstates;
+};
+
+struct cpu_topology {
+	struct list_head physical_head;
+	int physical_num;
+};
+
+extern int init_cpu_topo_info(void);
+extern int read_cpu_topo_info(FILE *f, char *buf);
+extern int read_sysfs_cpu_topo(void);
+extern int release_cpu_topo_info(void);
+extern int output_cpu_topo_info(FILE *f);
+extern int establish_idledata_to_topo(struct cpuidle_datas *datas);
+extern int release_cpu_topo_cstates(void);
+extern int dump_cpu_topo_info(int state, int count,
+		int (*dump)(struct cpuidle_cstates *, struct cpufreq_pstates *,
+			    int,  int, char *));
+
+
+extern struct cpuidle_cstates *core_cluster_data(struct cpu_core *s_core);
+extern struct cpuidle_cstates *
+	physical_cluster_data(struct cpu_physical *s_phy);
+
+#endif
diff --git a/tools/power/idlestat/trace.c b/tools/power/idlestat/trace.c
new file mode 100644
index 0000000..741415f
--- /dev/null
+++ b/tools/power/idlestat/trace.c
@@ -0,0 +1,87 @@
+/*
+ *  trace.c
+ *
+ *  Copyright (C) 2014, Linaro Limited.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * Contributors:
+ *     Daniel Lezcano <daniel.lezcano@linaro.org>
+ *     Zoran Markovic <zoran.markovic@linaro.org>
+ *
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <string.h>
+
+#include "trace.h"
+#include "utils.h"
+
+int idlestat_trace_enable(bool enable)
+{
+	return write_int(TRACE_ON_PATH, enable);
+}
+
+int idlestat_flush_trace(void)
+{
+	return write_int(TRACE_FILE, 0);
+}
+
+int idlestat_init_trace(unsigned int duration)
+{
+	int bufsize;
+
+	/* Assuming the worst case where we can have for cpuidle,
+	 * TRACE_IDLE_NRHITS_PER_SEC.  Each state enter/exit line are
+	 * 196 chars wide, so we have 2 x 196 x TRACE_IDLE_NRHITS_PER_SEC lines.
+	 * For cpufreq, assume a 196-character line for each frequency change,
+	 * and expect a rate of TRACE_CPUFREQ_NRHITS_PER_SEC.
+	 * Divide by 2^10 to have Kb. We add 1Kb to be sure to round up.
+	*/
+
+	bufsize = 2 * TRACE_IDLE_LENGTH * TRACE_IDLE_NRHITS_PER_SEC;
+	bufsize += TRACE_CPUFREQ_LENGTH * TRACE_CPUFREQ_NRHITS_PER_SEC;
+	bufsize = (bufsize * duration / (1 << 10)) + 1;
+
+	if (write_int(TRACE_BUFFER_SIZE_PATH, bufsize))
+		return -1;
+
+	if (read_int(TRACE_BUFFER_TOTAL_PATH, &bufsize))
+		return -1;
+
+	printf("Total trace buffer: %d kB\n", bufsize);
+
+	/* Disable all the traces */
+	if (write_int(TRACE_EVENT_PATH, 0))
+		return -1;
+
+	/* Enable cpu_idle traces */
+	if (write_int(TRACE_CPUIDLE_EVENT_PATH, 1))
+		return -1;
+
+	/* Enable cpu_frequency traces */
+	if (write_int(TRACE_CPUFREQ_EVENT_PATH, 1))
+		return -1;
+
+	/* Enable irq traces */
+	if (write_int(TRACE_IRQ_EVENT_PATH, 1))
+		return -1;
+
+	return 0;
+}
diff --git a/tools/power/idlestat/trace.h b/tools/power/idlestat/trace.h
new file mode 100644
index 0000000..aa805347
--- /dev/null
+++ b/tools/power/idlestat/trace.h
@@ -0,0 +1,43 @@
+/*
+ *  trace.h
+ *
+ *  Copyright (C) 2014  Zoran Markovic <zoran.markovic@linaro.org>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#ifndef __TRACE_H
+#define __TRACE_H
+
+#define TRACE_PATH "/sys/kernel/debug/tracing"
+#define TRACE_ON_PATH TRACE_PATH "/tracing_on"
+#define TRACE_BUFFER_SIZE_PATH TRACE_PATH "/buffer_size_kb"
+#define TRACE_BUFFER_TOTAL_PATH TRACE_PATH "/buffer_total_size_kb"
+#define TRACE_CPUIDLE_EVENT_PATH TRACE_PATH "/events/power/cpu_idle/enable"
+#define TRACE_CPUFREQ_EVENT_PATH TRACE_PATH "/events/power/cpu_frequency/enable"
+#define TRACE_IRQ_EVENT_PATH TRACE_PATH "/events/irq/enable"
+#define TRACE_EVENT_PATH TRACE_PATH "/events/enable"
+#define TRACE_FREE TRACE_PATH "/free_buffer"
+#define TRACE_FILE TRACE_PATH "/trace"
+#define TRACE_IDLE_NRHITS_PER_SEC 10000
+#define TRACE_IDLE_LENGTH 196
+#define TRACE_CPUFREQ_NRHITS_PER_SEC 100
+#define TRACE_CPUFREQ_LENGTH 196
+
+extern int idlestat_trace_enable(bool enable);
+extern int idlestat_flush_trace(void);
+extern int idlestat_init_trace(unsigned int duration);
+
+#endif
diff --git a/tools/power/idlestat/utils.c b/tools/power/idlestat/utils.c
new file mode 100644
index 0000000..a82afe6
--- /dev/null
+++ b/tools/power/idlestat/utils.c
@@ -0,0 +1,115 @@
+/*
+ *  utils.c
+ *
+ *  Copyright (C) 2014, Linaro Limited.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * Contributors:
+ *     Daniel Lezcano <daniel.lezcano@linaro.org>
+ *     Zoran Markovic <zoran.markovic@linaro.org>
+ *
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#undef _GNU_SOURCE
+#include <stdlib.h>
+
+#include "utils.h"
+
+int write_int(const char *path, int val)
+{
+	FILE *f;
+
+	f = fopen(path, "w");
+	if (!f) {
+		fprintf(stderr, "failed to open '%s': %m\n", path);
+		return -1;
+	}
+
+	fprintf(f, "%d", val);
+
+	fclose(f);
+
+	return 0;
+}
+
+int read_int(const char *path, int *val)
+{
+	FILE *f;
+
+	f = fopen(path, "r");
+
+	if (!f) {
+		fprintf(stderr, "failed to open '%s': %m\n", path);
+		return -1;
+	}
+
+	fscanf(f, "%d", val);
+
+	fclose(f);
+
+	return 0;
+}
+
+int store_line(const char *line, void *data)
+{
+	FILE *f = data;
+
+	/* ignore comment line */
+	if (line[0] == '#')
+		return 0;
+
+	fprintf(f, "%s", line);
+
+	return 0;
+}
+
+/*
+ * This functions is a helper to read a specific file content and store
+ * the content inside a variable pointer passed as parameter, the format
+ * parameter gives the variable type to be read from the file.
+ *
+ * @path : directory path containing the file
+ * @name : name of the file to be read
+ * @format : the format of the format
+ * @value : a pointer to a variable to store the content of the file
+ * Returns 0 on success, -1 otherwise
+ */
+int file_read_value(const char *path, const char *name,
+			const char *format, void *value)
+{
+	FILE *file;
+	char *rpath;
+	int ret;
+
+	ret = asprintf(&rpath, "%s/%s", path, name);
+	if (ret < 0)
+		return ret;
+
+	file = fopen(rpath, "r");
+	if (!file) {
+		ret = -1;
+		goto out_free;
+	}
+
+	ret = fscanf(file, format, value) == EOF ? -1 : 0;
+
+	fclose(file);
+out_free:
+	free(rpath);
+	return ret;
+}
diff --git a/tools/power/idlestat/utils.h b/tools/power/idlestat/utils.h
new file mode 100644
index 0000000..81a25fe
--- /dev/null
+++ b/tools/power/idlestat/utils.h
@@ -0,0 +1,35 @@
+/*
+ *  utils.h
+ *
+ *  Copyright (C) 2014, Linaro Limited.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * Contributors:
+ *     Daniel Lezcano <daniel.lezcano@linaro.org>
+ *     Zoran Markovic <zoran.markovic@linaro.org>
+ *
+ */
+#ifndef __UTILS_H
+#define __UTILS_H
+
+extern int write_int(const char *path, int val);
+extern int read_int(const char *path, int *val);
+extern int store_line(const char *line, void *data);
+extern int file_read_value(const char *path, const char *name,
+				const char *format, void *value);
+
+#endif
-- 
1.7.9.5

