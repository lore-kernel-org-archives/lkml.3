Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab3IYMwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:52:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784Ab3IYMvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:53 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 21/21] perf tools: Add record/stat support for toggling events
Date: Wed, 25 Sep 2013 14:50:47 +0200
Message-Id: <1380113447-17144-22-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for toggling events into record and stat
command. It's now possible to meassure/sample code
bounded by events.

The toggling events are defined via on/off terms,
assigned with the name of the event they should
toggle.

- Example: using k(ret)probes:
  Define toggle(on/off) events:
  # perf probe -a fork_entry=do_fork
  # perf probe -a fork_exit=do_fork%return

  Following record session samples only within do_fork function:
  # perf record -g -e '{cycles,cache-misses}:k,probe:fork_entry/on=cycles/,probe:fork_exit/off=cycles/' \
    perf bench sched messaging

  Following stat session measure cycles within do_fork function:
  # perf stat -e '{cycles,cache-misses}:k,probe:fork_entry/on=cycles/,probe:fork_exit/off=cycles/' \
    perf bench sched messaging

  # Running sched/messaging benchmark...
  # 20 sender and receiver processes per group
  # 1 groups == 40 processes run

       Total time: 0.073 [sec]

   Performance counter stats for './perf bench sched messaging -g 1':

          20,935,464 cycles                    #    0.000 GHz
              18,897 cache-misses
                  40 probe:fork_entry
                  40 probe:fork_exit

         0.086319682 seconds time elapsed

- Example: using u(ret)probes:
  Sample program:
  ---
  void krava(void)
  {
          asm volatile ("nop; nop");
  }

  int main(void)
  {
          krava();
          return 0;
  }
  ---

  Define toggle(on/off) events:
  # perf probe -x ./ex entry=krava
  # perf probe -x ./ex exit=krava%return

  Following stat session measure instructions within krava function:
  # perf stat -e instructions:u,probe_ex:entry/on=instructions/,probe_ex:exit/off=instructions/ ./ex

      Performance counter stats for './ex':

                   9 instructions:u            #    0.00  insns per cycle
                   1 probe_ex:entry
                   1 probe_ex:exit

         0.000556743 seconds time elapsed

  Following stat session measure cycles, instructions and cache-misses
  within krava function:
  # perf stat -e '{cycles,instructions,cache-misses}:u,probe_ex:entry/on=cycles/,probe_ex:exit/off=cycles/' ./ex

       Performance counter stats for './ex':

             2,068 cycles                    #    0.000 GHz
                 9 instructions              #    0.00  insns per cycle
                 0 cache-misses
                 1 probe_ex:entry
                 1 probe_ex:exit

       0.000557504 seconds time elapsed

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |  7 ++++
 tools/perf/builtin-stat.c   | 12 +++++++
 tools/perf/util/evlist.c    | 87 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h    |  2 ++
 tools/perf/util/evsel.c     |  4 +++
 tools/perf/util/evsel.h     |  1 +
 tools/perf/util/record.c    |  2 ++
 7 files changed, 115 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index da13840..a41d63c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -225,6 +225,13 @@ try_again:
 		goto out;
 	}
 
+	if (perf_evlist__apply_toggle(evlist)) {
+		error("failed to set toggling %d (%s)\n", errno,
+			strerror(errno));
+		rc = -1;
+		goto out;
+	}
+
 	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
 		if (errno == EPERM) {
 			pr_err("Permission error mapping pages.\n"
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f686d5f..86729ae 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -242,6 +242,7 @@ static void perf_stat__reset_stats(struct perf_evlist *evlist)
 static int create_perf_stat_counter(struct perf_evsel *evsel)
 {
 	struct perf_event_attr *attr = &evsel->attr;
+	struct perf_evsel *leader = evsel->leader;
 
 	if (scale)
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
@@ -249,6 +250,9 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 
 	attr->inherit = !no_inherit;
 
+	if (leader->is_toggled)
+		attr->paused = 1;
+
 	if (perf_target__has_cpu(&target))
 		return perf_evsel__open_per_cpu(evsel, perf_evsel__cpus(evsel));
 
@@ -462,6 +466,8 @@ static int __run_perf_stat(int argc, const char **argv)
 	if (group)
 		perf_evlist__set_leader(evsel_list);
 
+	perf_evlist__mark_toggled(evsel_list);
+
 	list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (create_perf_stat_counter(counter) < 0) {
 			/*
@@ -496,6 +502,12 @@ static int __run_perf_stat(int argc, const char **argv)
 		return -1;
 	}
 
+	if (perf_evlist__apply_toggle(evsel_list)) {
+		error("failed to set toggling with %d (%s)\n", errno,
+			strerror(errno));
+		return -1;
+	}
+
 	/*
 	 * Enable counters and exec the command:
 	 */
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index c4d382d..eda7907 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -16,6 +16,7 @@
 #include "evsel.h"
 #include "debug.h"
 #include <unistd.h>
+#include "asm/bug.h"
 
 #include "parse-events.h"
 #include "parse-options.h"
@@ -819,6 +820,91 @@ void perf_evlist__delete_maps(struct perf_evlist *evlist)
 	evlist->threads = NULL;
 }
 
+static struct perf_evsel *
+perf_evlist__find_evsel_by_name(struct perf_evlist *evlist, char *name)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node)
+		if (strstr(perf_evsel__name(evsel), name))
+			return evsel;
+
+	return NULL;
+}
+
+static int apply_toggle(struct perf_evsel *evsel, struct perf_evsel *toggled,
+			int ncpus, int nthreads)
+{
+	int cpu, thread, err = 0;
+
+	for (cpu = 0; cpu < ncpus; cpu++) {
+		for (thread = 0; thread < nthreads; thread++) {
+			int fd = FD(evsel, cpu, thread);
+			u64 args[2] = {
+				FD(toggled, cpu, thread),
+				evsel->toggle_flag
+			};
+
+			err = ioctl(fd, PERF_EVENT_IOC_SET_TOGGLE, args);
+			if (err)
+				break;
+		}
+	}
+
+	return err;
+}
+
+int perf_evlist__apply_toggle(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+	int err = 0;
+	const int ncpus = cpu_map__nr(evlist->cpus),
+		  nthreads = thread_map__nr(evlist->threads);
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		struct perf_evsel *toggled;
+
+		if (!evsel->toggle_flag)
+			continue;
+
+		toggled = perf_evlist__find_evsel_by_name(evlist,
+							  evsel->toggle_name);
+		if (WARN_ONCE(!toggled, "toggle apply: internal error\n"))
+			return -1;
+
+		pr_debug("toggle: %s toggles %s %s\n",
+			 perf_evsel__name(evsel),
+			 evsel->toggle_flag == PERF_FLAG_TOGGLE_ON ?
+					       "ON" : "OFF",
+			 perf_evsel__name(toggled));
+
+		err = apply_toggle(evsel, toggled, ncpus, nthreads);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
+void perf_evlist__mark_toggled(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		struct perf_evsel *toggled;
+
+		if (!evsel->toggle_flag)
+			continue;
+
+		toggled = perf_evlist__find_evsel_by_name(evlist,
+							  evsel->toggle_name);
+		if (WARN_ONCE(!toggled, "toggle mark: internal error\n"))
+			continue;
+
+		toggled->is_toggled = true;
+	}
+}
+
 int perf_evlist__apply_filters(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
@@ -827,6 +913,7 @@ int perf_evlist__apply_filters(struct perf_evlist *evlist)
 		  nthreads = thread_map__nr(evlist->threads);
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
+
 		if (evsel->filter == NULL)
 			continue;
 
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 0dbd8f8..eb77c81 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -135,6 +135,8 @@ static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 int perf_evlist__create_maps(struct perf_evlist *evlist,
 			     struct perf_target *target);
 void perf_evlist__delete_maps(struct perf_evlist *evlist);
+void perf_evlist__mark_toggled(struct perf_evlist *evlist);
+int perf_evlist__apply_toggle(struct perf_evlist *evlist);
 int perf_evlist__apply_filters(struct perf_evlist *evlist);
 
 void __perf_evlist__set_leader(struct list_head *list);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 3ed7947..4e6db1c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -696,6 +696,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	 */
 	if (perf_target__none(&opts->target) && perf_evsel__is_group_leader(evsel))
 		attr->enable_on_exec = 1;
+
+	if (leader->is_toggled)
+		attr->paused = 1;
 }
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
@@ -984,6 +987,7 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR2(exclude_host, exclude_guest);
 	ret += PRINT_ATTR2N("excl.callchain_kern", exclude_callchain_kernel,
 			    "excl.callchain_user", exclude_callchain_user);
+	ret += PRINT_ATTR2(paused, paused);
 
 	ret += PRINT_ATTR_U32(wakeup_events);
 	ret += PRINT_ATTR_U32(wakeup_watermark);
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index e70415b..69f4183 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -93,6 +93,7 @@ struct perf_evsel {
 	/* toggle event config */
 	char			toggle_flag;
 	char			*toggle_name;
+	bool			is_toggled;
 };
 
 #define hists_to_evsel(h) container_of(h, struct perf_evsel, hists)
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 18d73aa..7f7eeb4 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -88,6 +88,8 @@ void perf_evlist__config(struct perf_evlist *evlist,
 	if (evlist->cpus->map[0] < 0)
 		opts->no_inherit = true;
 
+	perf_evlist__mark_toggled(evlist);
+
 	list_for_each_entry(evsel, &evlist->entries, node)
 		perf_evsel__config(evsel, opts);
 
-- 
1.7.11.7

