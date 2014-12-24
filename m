Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaLXHPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:15:37 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40023 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaLXHP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:15:29 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 19/37] perf tools: Introduce thread__find_addr_location_time() and friends
Date: Wed, 24 Dec 2014 16:15:15 +0900
Message-Id: <1419405333-27952-20-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The *_time() variants are for find appropriate map (and symbol) at the
given time.  This is based on the fact that map_groups list is sorted
by time in the previous patch.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/event.c            | 59 ++++++++++++++++++++++++++++++++++----
 tools/perf/util/machine.c          | 51 ++++++++++++++++++--------------
 tools/perf/util/thread.c           | 21 ++++++++++++++
 tools/perf/util/thread.h           | 10 +++++++
 tools/perf/util/unwind-libdw.c     | 11 +++----
 tools/perf/util/unwind-libunwind.c | 18 ++++++------
 6 files changed, 129 insertions(+), 41 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2d04949bdc7d..3bb186a26314 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -731,16 +731,14 @@ int perf_event__process(struct perf_tool *tool __maybe_unused,
 	return machine__process_event(machine, event, sample);
 }
 
-void thread__find_addr_map(struct thread *thread, u8 cpumode,
-			   enum map_type type, u64 addr,
-			   struct addr_location *al)
+static void map_groups__find_addr_map(struct map_groups *mg, u8 cpumode,
+				      enum map_type type, u64 addr,
+				      struct addr_location *al)
 {
-	struct map_groups *mg = thread->mg;
 	struct machine *machine = mg->machine;
 	bool load_map = false;
 
 	al->machine = machine;
-	al->thread = thread;
 	al->addr = addr;
 	al->cpumode = cpumode;
 	al->filtered = 0;
@@ -809,6 +807,35 @@ void thread__find_addr_map(struct thread *thread, u8 cpumode,
 	}
 }
 
+void thread__find_addr_map(struct thread *thread, u8 cpumode,
+			   enum map_type type, u64 addr,
+			   struct addr_location *al)
+{
+	al->thread = thread;
+	map_groups__find_addr_map(thread->mg, cpumode, type, addr, al);
+}
+
+void thread__find_addr_map_time(struct thread *thread, u8 cpumode,
+				enum map_type type, u64 addr,
+				struct addr_location *al, u64 timestamp)
+{
+	struct map_groups *mg;
+	struct thread *leader;
+
+	if (thread->tid == thread->pid_)
+		leader = thread;
+	else
+		leader = machine__find_thread(thread->mg->machine,
+					      thread->pid_, thread->pid_);
+
+	BUG_ON(leader == NULL);
+
+	mg = thread__get_map_groups(leader, timestamp);
+
+	al->thread = thread;
+	map_groups__find_addr_map(mg, cpumode, type, addr, al);
+}
+
 void thread__find_addr_location(struct thread *thread,
 				u8 cpumode, enum map_type type, u64 addr,
 				struct addr_location *al)
@@ -821,6 +848,21 @@ void thread__find_addr_location(struct thread *thread,
 		al->sym = NULL;
 }
 
+void thread__find_addr_location_time(struct thread *thread, u8 cpumode,
+				     enum map_type type, u64 addr,
+				     struct addr_location *al, u64 timestamp)
+{
+	struct map_groups *mg;
+
+	mg = thread__get_map_groups(thread, timestamp);
+	map_groups__find_addr_map(mg, cpumode, type, addr, al);
+	if (al->map != NULL)
+		al->sym = map__find_symbol(al->map, al->addr,
+					   mg->machine->symbol_filter);
+	else
+		al->sym = NULL;
+}
+
 int perf_event__preprocess_sample(const union perf_event *event,
 				  struct machine *machine,
 				  struct addr_location *al,
@@ -845,7 +887,12 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	    machine->vmlinux_maps[MAP__FUNCTION] == NULL)
 		machine__create_kernel_maps(machine);
 
-	thread__find_addr_map(thread, cpumode, MAP__FUNCTION, sample->ip, al);
+	/*
+	 * sample->time is -1ULL if !PERF_SAMPLE_TIME which ends up
+	 * with using most recent map_groups (same as default behavior).
+	 */
+	thread__find_addr_map_time(thread, cpumode, MAP__FUNCTION, sample->ip,
+				   al, sample->time);
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index beae6e8fe789..ffce0bcd2d9a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1466,7 +1466,7 @@ static bool symbol__match_regex(struct symbol *sym, regex_t *regex)
 
 static void ip__resolve_ams(struct thread *thread,
 			    struct addr_map_symbol *ams,
-			    u64 ip)
+			    u64 ip, u64 timestamp)
 {
 	struct addr_location al;
 
@@ -1478,7 +1478,8 @@ static void ip__resolve_ams(struct thread *thread,
 	 * Thus, we have to try consecutively until we find a match
 	 * or else, the symbol is unknown
 	 */
-	thread__find_cpumode_addr_location(thread, MAP__FUNCTION, ip, &al);
+	thread__find_cpumode_addr_location_time(thread, MAP__FUNCTION, ip, &al,
+						timestamp);
 
 	ams->addr = ip;
 	ams->al_addr = al.addr;
@@ -1486,21 +1487,24 @@ static void ip__resolve_ams(struct thread *thread,
 	ams->map = al.map;
 }
 
-static void ip__resolve_data(struct thread *thread,
-			     u8 m, struct addr_map_symbol *ams, u64 addr)
+static void ip__resolve_data(struct thread *thread, u8 m,
+			     struct addr_map_symbol *ams,
+			     u64 addr, u64 timestamp)
 {
 	struct addr_location al;
 
 	memset(&al, 0, sizeof(al));
 
-	thread__find_addr_location(thread, m, MAP__VARIABLE, addr, &al);
+	thread__find_addr_location_time(thread, m, MAP__VARIABLE, addr,
+					&al, timestamp);
 	if (al.map == NULL) {
 		/*
 		 * some shared data regions have execute bit set which puts
 		 * their mapping in the MAP__FUNCTION type array.
 		 * Check there as a fallback option before dropping the sample.
 		 */
-		thread__find_addr_location(thread, m, MAP__FUNCTION, addr, &al);
+		thread__find_addr_location_time(thread, m, MAP__FUNCTION, addr,
+						&al, timestamp);
 	}
 
 	ams->addr = addr;
@@ -1517,8 +1521,9 @@ struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 	if (!mi)
 		return NULL;
 
-	ip__resolve_ams(al->thread, &mi->iaddr, sample->ip);
-	ip__resolve_data(al->thread, al->cpumode, &mi->daddr, sample->addr);
+	ip__resolve_ams(al->thread, &mi->iaddr, sample->ip, sample->time);
+	ip__resolve_data(al->thread, al->cpumode, &mi->daddr, sample->addr,
+			 sample->time);
 	mi->data_src.val = sample->data_src;
 
 	return mi;
@@ -1527,19 +1532,20 @@ struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 static int add_callchain_ip(struct thread *thread,
 			    struct symbol **parent,
 			    struct addr_location *root_al,
-			    int cpumode,
-			    u64 ip)
+			    int cpumode, u64 ip, u64 timestamp)
 {
 	struct addr_location al;
 
 	al.filtered = 0;
 	al.sym = NULL;
+
 	if (cpumode == -1)
-		thread__find_cpumode_addr_location(thread, MAP__FUNCTION,
-						   ip, &al);
+		thread__find_cpumode_addr_location_time(thread, MAP__FUNCTION,
+							ip, &al, timestamp);
 	else
-		thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
-				   ip, &al);
+		thread__find_addr_location_time(thread, cpumode, MAP__FUNCTION,
+						ip, &al, timestamp);
+
 	if (al.sym != NULL) {
 		if (sort__has_parent && !*parent &&
 		    symbol__match_regex(al.sym, &parent_regex))
@@ -1567,8 +1573,10 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
 		return NULL;
 
 	for (i = 0; i < bs->nr; i++) {
-		ip__resolve_ams(al->thread, &bi[i].to, bs->entries[i].to);
-		ip__resolve_ams(al->thread, &bi[i].from, bs->entries[i].from);
+		ip__resolve_ams(al->thread, &bi[i].to, bs->entries[i].to,
+				sample->time);
+		ip__resolve_ams(al->thread, &bi[i].from, bs->entries[i].from,
+				sample->time);
 		bi[i].flags = bs->entries[i].flags;
 	}
 	return bi;
@@ -1620,7 +1628,7 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 					     struct branch_stack *branch,
 					     struct symbol **parent,
 					     struct addr_location *root_al,
-					     int max_stack)
+					     int max_stack, u64 timestamp)
 {
 	u8 cpumode = PERF_RECORD_MISC_USER;
 	int chain_nr = min(max_stack, (int)chain->nr);
@@ -1684,10 +1692,10 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 
 		for (i = 0; i < nr; i++) {
 			err = add_callchain_ip(thread, parent, root_al,
-					       -1, be[i].to);
+					       -1, be[i].to, timestamp);
 			if (!err)
 				err = add_callchain_ip(thread, parent, root_al,
-						       -1, be[i].from);
+						       -1, be[i].from, timestamp);
 			if (err == -EINVAL)
 				break;
 			if (err)
@@ -1741,7 +1749,7 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 		}
 
 		err = add_callchain_ip(thread, parent, root_al,
-				       cpumode, ip);
+				       cpumode, ip, timestamp);
 		if (err == -EINVAL)
 			break;
 		if (err)
@@ -1767,7 +1775,8 @@ int thread__resolve_callchain(struct thread *thread,
 {
 	int ret = thread__resolve_callchain_sample(thread, sample->callchain,
 						   sample->branch_stack,
-						   parent, root_al, max_stack);
+						   parent, root_al, max_stack,
+						   sample->time);
 	if (ret)
 		return ret;
 
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 109ceb5e2a85..87c20308b91f 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -332,3 +332,24 @@ void thread__find_cpumode_addr_location(struct thread *thread,
 			break;
 	}
 }
+
+void thread__find_cpumode_addr_location_time(struct thread *thread,
+					     enum map_type type, u64 addr,
+					     struct addr_location *al,
+					     u64 timestamp)
+{
+	size_t i;
+	const u8 const cpumodes[] = {
+		PERF_RECORD_MISC_USER,
+		PERF_RECORD_MISC_KERNEL,
+		PERF_RECORD_MISC_GUEST_USER,
+		PERF_RECORD_MISC_GUEST_KERNEL
+	};
+
+	for (i = 0; i < ARRAY_SIZE(cpumodes); i++) {
+		thread__find_addr_location_time(thread, cpumodes[i], type,
+						addr, al, timestamp);
+		if (al->map)
+			break;
+	}
+}
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 8b9a67764613..0b88ca22bc3d 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -66,14 +66,24 @@ size_t thread__fprintf(struct thread *thread, FILE *fp);
 void thread__find_addr_map(struct thread *thread,
 			   u8 cpumode, enum map_type type, u64 addr,
 			   struct addr_location *al);
+void thread__find_addr_map_time(struct thread *thread, u8 cpumode,
+				enum map_type type, u64 addr,
+				struct addr_location *al, u64 timestamp);
 
 void thread__find_addr_location(struct thread *thread,
 				u8 cpumode, enum map_type type, u64 addr,
 				struct addr_location *al);
+void thread__find_addr_location_time(struct thread *thread, u8 cpumode,
+				     enum map_type type, u64 addr,
+				     struct addr_location *al, u64 timestamp);
 
 void thread__find_cpumode_addr_location(struct thread *thread,
 					enum map_type type, u64 addr,
 					struct addr_location *al);
+void thread__find_cpumode_addr_location_time(struct thread *thread,
+					     enum map_type type, u64 addr,
+					     struct addr_location *al,
+					     u64 timestamp);
 
 static inline void *thread__priv(struct thread *thread)
 {
diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
index 2dcfe9a7c8d0..ba8d8e41d680 100644
--- a/tools/perf/util/unwind-libdw.c
+++ b/tools/perf/util/unwind-libdw.c
@@ -26,9 +26,10 @@ static int __report_module(struct addr_location *al, u64 ip,
 	Dwfl_Module *mod;
 	struct dso *dso = NULL;
 
-	thread__find_addr_location(ui->thread,
-				   PERF_RECORD_MISC_USER,
-				   MAP__FUNCTION, ip, al);
+	thread__find_addr_location_time(ui->thread,
+					PERF_RECORD_MISC_USER,
+					MAP__FUNCTION, ip, al,
+					ui->sample->time);
 
 	if (al->map)
 		dso = al->map->dso;
@@ -89,8 +90,8 @@ static int access_dso_mem(struct unwind_info *ui, Dwarf_Addr addr,
 	struct addr_location al;
 	ssize_t size;
 
-	thread__find_addr_map(ui->thread, PERF_RECORD_MISC_USER,
-			      MAP__FUNCTION, addr, &al);
+	thread__find_addr_map_time(ui->thread, PERF_RECORD_MISC_USER,
+				   MAP__FUNCTION, addr, &al, ui->sample->time);
 	if (!al.map) {
 		pr_debug("unwind: no map for %lx\n", (unsigned long)addr);
 		return -1;
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 371219a6daf1..94929ec491f3 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -284,8 +284,8 @@ static struct map *find_map(unw_word_t ip, struct unwind_info *ui)
 {
 	struct addr_location al;
 
-	thread__find_addr_map(ui->thread, PERF_RECORD_MISC_USER,
-			      MAP__FUNCTION, ip, &al);
+	thread__find_addr_map_time(ui->thread, PERF_RECORD_MISC_USER,
+				   MAP__FUNCTION, ip, &al, ui->sample->time);
 	return al.map;
 }
 
@@ -374,8 +374,8 @@ static int access_dso_mem(struct unwind_info *ui, unw_word_t addr,
 	struct addr_location al;
 	ssize_t size;
 
-	thread__find_addr_map(ui->thread, PERF_RECORD_MISC_USER,
-			      MAP__FUNCTION, addr, &al);
+	thread__find_addr_map_time(ui->thread, PERF_RECORD_MISC_USER,
+				   MAP__FUNCTION, addr, &al, ui->sample->time);
 	if (!al.map) {
 		pr_debug("unwind: no map for %lx\n", (unsigned long)addr);
 		return -1;
@@ -476,14 +476,14 @@ static void put_unwind_info(unw_addr_space_t __maybe_unused as,
 	pr_debug("unwind: put_unwind_info called\n");
 }
 
-static int entry(u64 ip, struct thread *thread,
+static int entry(u64 ip, struct thread *thread, u64 timestamp,
 		 unwind_entry_cb_t cb, void *arg)
 {
 	struct unwind_entry e;
 	struct addr_location al;
 
-	thread__find_addr_location(thread, PERF_RECORD_MISC_USER,
-				   MAP__FUNCTION, ip, &al);
+	thread__find_addr_location_time(thread, PERF_RECORD_MISC_USER,
+					MAP__FUNCTION, ip, &al, timestamp);
 
 	e.ip = ip;
 	e.map = al.map;
@@ -585,7 +585,7 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 		unw_word_t ip;
 
 		unw_get_reg(&c, UNW_REG_IP, &ip);
-		ret = ip ? entry(ip, ui->thread, cb, arg) : 0;
+		ret = ip ? entry(ip, ui->thread, ui->sample->time, cb, arg) : 0;
 	}
 
 	return ret;
@@ -610,7 +610,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 	if (ret)
 		return ret;
 
-	ret = entry(ip, thread, cb, arg);
+	ret = entry(ip, thread, data->time, cb, arg);
 	if (ret)
 		return -ENOMEM;
 
-- 
2.1.3

