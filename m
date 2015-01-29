Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbbA2IPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:15:20 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51434 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbbA2IKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:16 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 25/42] perf tools: Introduce thread__find_addr_location_time() and friends
Date: Thu, 29 Jan 2015 17:07:06 +0900
Message-Id: <1422518843-25818-26-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The *_time() variants are for find appropriate map (and symbol) at the
given time.  This is based on the fact that map_groups list is sorted
by time in the previous patch.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/event.c            | 80 +++++++++++++++++++++++++++++++++-----
 tools/perf/util/machine.c          | 51 ++++++++++++++----------
 tools/perf/util/thread.c           | 21 ++++++++++
 tools/perf/util/thread.h           | 10 +++++
 tools/perf/util/unwind-libdw.c     | 11 +++---
 tools/perf/util/unwind-libunwind.c | 18 ++++-----
 6 files changed, 146 insertions(+), 45 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1558a7085c7f..e7152a6e3043 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -732,16 +732,14 @@ int perf_event__process(struct perf_tool *tool __maybe_unused,
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
@@ -810,6 +808,36 @@ void thread__find_addr_map(struct thread *thread, u8 cpumode,
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
+		leader = machine__findnew_thread_time(thread->mg->machine,
+						      thread->pid_,
+						      thread->pid_,
+						      timestamp);
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
@@ -822,6 +850,21 @@ void thread__find_addr_location(struct thread *thread,
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
@@ -854,7 +897,13 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	    machine->vmlinux_maps[MAP__FUNCTION] == NULL)
 		machine__create_kernel_maps(machine);
 
-	thread__find_addr_map(thread, cpumode, MAP__FUNCTION, sample->ip, al);
+	if (session && perf_session__has_index(session))
+		thread__find_addr_map_time(thread, cpumode, MAP__FUNCTION,
+					   sample->ip, al, sample->time);
+	else
+		thread__find_addr_map(thread, cpumode, MAP__FUNCTION,
+				      sample->ip, al);
+
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
@@ -915,15 +964,26 @@ void perf_event__preprocess_sample_addr(union perf_event *event,
 					struct perf_sample *sample,
 					struct thread *thread,
 					struct addr_location *al,
-					struct perf_session *session __maybe_unused)
+					struct perf_session *session)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	thread__find_addr_map(thread, cpumode, MAP__FUNCTION, sample->addr, al);
-	if (!al->map)
-		thread__find_addr_map(thread, cpumode, MAP__VARIABLE,
+	if (session && perf_session__has_index(session))
+		thread__find_addr_map_time(thread, cpumode, MAP__FUNCTION,
+					   sample->addr, al, sample->time);
+	else
+		thread__find_addr_map(thread, cpumode, MAP__FUNCTION,
 				      sample->addr, al);
 
+	if (!al->map) {
+		if (session && perf_session__has_index(session))
+			thread__find_addr_map_time(thread, cpumode, MAP__VARIABLE,
+						   sample->addr, al, sample->time);
+		else
+			thread__find_addr_map(thread, cpumode, MAP__VARIABLE,
+					      sample->addr, al);
+	}
+
 	al->cpu = sample->cpu;
 	al->sym = NULL;
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 09c2edccccd9..7dc044b93cf8 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1471,7 +1471,7 @@ static bool symbol__match_regex(struct symbol *sym, regex_t *regex)
 
 static void ip__resolve_ams(struct thread *thread,
 			    struct addr_map_symbol *ams,
-			    u64 ip)
+			    u64 ip, u64 timestamp)
 {
 	struct addr_location al;
 
@@ -1483,7 +1483,8 @@ static void ip__resolve_ams(struct thread *thread,
 	 * Thus, we have to try consecutively until we find a match
 	 * or else, the symbol is unknown
 	 */
-	thread__find_cpumode_addr_location(thread, MAP__FUNCTION, ip, &al);
+	thread__find_cpumode_addr_location_time(thread, MAP__FUNCTION, ip, &al,
+						timestamp);
 
 	ams->addr = ip;
 	ams->al_addr = al.addr;
@@ -1491,21 +1492,24 @@ static void ip__resolve_ams(struct thread *thread,
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
@@ -1522,8 +1526,9 @@ struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 	if (!mi)
 		return NULL;
 
-	ip__resolve_ams(al->thread, &mi->iaddr, sample->ip);
-	ip__resolve_data(al->thread, al->cpumode, &mi->daddr, sample->addr);
+	ip__resolve_ams(al->thread, &mi->iaddr, sample->ip, sample->time);
+	ip__resolve_data(al->thread, al->cpumode, &mi->daddr, sample->addr,
+			 sample->time);
 	mi->data_src.val = sample->data_src;
 
 	return mi;
@@ -1533,15 +1538,16 @@ static int add_callchain_ip(struct thread *thread,
 			    struct symbol **parent,
 			    struct addr_location *root_al,
 			    bool branch_history,
-			    u64 ip)
+			    u64 ip, u64 timestamp)
 {
 	struct addr_location al;
 
 	al.filtered = 0;
 	al.sym = NULL;
+
 	if (branch_history)
-		thread__find_cpumode_addr_location(thread, MAP__FUNCTION,
-						   ip, &al);
+		thread__find_cpumode_addr_location_time(thread, MAP__FUNCTION,
+							ip, &al, timestamp);
 	else {
 		u8 cpumode = PERF_RECORD_MISC_USER;
 
@@ -1568,8 +1574,8 @@ static int add_callchain_ip(struct thread *thread,
 			}
 			return 0;
 		}
-		thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
-				   ip, &al);
+		thread__find_addr_location_time(thread, cpumode, MAP__FUNCTION,
+						ip, &al, timestamp);
 	}
 
 	if (al.sym != NULL) {
@@ -1599,8 +1605,10 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
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
@@ -1652,7 +1660,7 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 					     struct branch_stack *branch,
 					     struct symbol **parent,
 					     struct addr_location *root_al,
-					     int max_stack)
+					     int max_stack, u64 timestamp)
 {
 	int chain_nr = min(max_stack, (int)chain->nr);
 	int i, j, err;
@@ -1713,10 +1721,10 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 
 		for (i = 0; i < nr; i++) {
 			err = add_callchain_ip(thread, parent, root_al,
-					       true, be[i].to);
+					       true, be[i].to, timestamp);
 			if (!err)
 				err = add_callchain_ip(thread, parent, root_al,
-						       true, be[i].from);
+						true, be[i].from, timestamp);
 			if (err == -EINVAL)
 				break;
 			if (err)
@@ -1745,8 +1753,8 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 #endif
 		ip = chain->ips[j];
 
-		err = add_callchain_ip(thread, parent, root_al, false, ip);
-
+		err = add_callchain_ip(thread, parent, root_al, false, ip,
+				       timestamp);
 		if (err)
 			return (err < 0) ? err : 0;
 	}
@@ -1770,7 +1778,8 @@ int thread__resolve_callchain(struct thread *thread,
 {
 	int ret = thread__resolve_callchain_sample(thread, sample->callchain,
 						   sample->branch_stack,
-						   parent, root_al, max_stack);
+						   parent, root_al, max_stack,
+						   sample->time);
 	if (ret)
 		return ret;
 
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 895c74683c81..293157dafd2c 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -331,3 +331,24 @@ void thread__find_cpumode_addr_location(struct thread *thread,
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
index 08cafa2d97f9..5209ad5adadf 100644
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
index 6edf535f65c2..7ed6eaf232b6 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -306,8 +306,8 @@ static struct map *find_map(unw_word_t ip, struct unwind_info *ui)
 {
 	struct addr_location al;
 
-	thread__find_addr_map(ui->thread, PERF_RECORD_MISC_USER,
-			      MAP__FUNCTION, ip, &al);
+	thread__find_addr_map_time(ui->thread, PERF_RECORD_MISC_USER,
+				   MAP__FUNCTION, ip, &al, ui->sample->time);
 	return al.map;
 }
 
@@ -400,8 +400,8 @@ static int access_dso_mem(struct unwind_info *ui, unw_word_t addr,
 	struct addr_location al;
 	ssize_t size;
 
-	thread__find_addr_map(ui->thread, PERF_RECORD_MISC_USER,
-			      MAP__FUNCTION, addr, &al);
+	thread__find_addr_map_time(ui->thread, PERF_RECORD_MISC_USER,
+				   MAP__FUNCTION, addr, &al, ui->sample->time);
 	if (!al.map) {
 		pr_debug("unwind: no map for %lx\n", (unsigned long)addr);
 		return -1;
@@ -502,14 +502,14 @@ static void put_unwind_info(unw_addr_space_t __maybe_unused as,
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
@@ -611,7 +611,7 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 		unw_word_t ip;
 
 		unw_get_reg(&c, UNW_REG_IP, &ip);
-		ret = ip ? entry(ip, ui->thread, cb, arg) : 0;
+		ret = ip ? entry(ip, ui->thread, ui->sample->time, cb, arg) : 0;
 	}
 
 	return ret;
@@ -636,7 +636,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 	if (ret)
 		return ret;
 
-	ret = entry(ip, thread, cb, arg);
+	ret = entry(ip, thread, data->time, cb, arg);
 	if (ret)
 		return -ENOMEM;
 
-- 
2.2.2

