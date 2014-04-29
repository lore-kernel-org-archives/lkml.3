Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbaD2Gqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:46:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56879 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaD2Gqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:46:40 -0400
Date: Mon, 28 Apr 2014 23:46:16 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-93d5731dcb5b8cb7fa56ee11a5891f10c96c2a45@git.kernel.org>
Cc: eranian@google.com, acme@redhat.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, acme@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, dzickus@redhat.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, acme@redhat.com, eranian@google.com,
        jolsa@kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        acme@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, dzickus@redhat.com,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, adrian.hunter@intel.com
In-Reply-To: <1397490723-1992-3-git-send-email-jolsa@redhat.com>
References: <1397490723-1992-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Allocate thread map_groups'
 s dynamically
Git-Commit-ID: 93d5731dcb5b8cb7fa56ee11a5891f10c96c2a45
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93d5731dcb5b8cb7fa56ee11a5891f10c96c2a45
Gitweb:     http://git.kernel.org/tip/93d5731dcb5b8cb7fa56ee11a5891f10c96c2a45
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 21 Mar 2014 17:57:01 -0300
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 28 Apr 2014 13:43:20 +0200

perf tools: Allocate thread map_groups's dynamically

Moving towards sharing map groups within a process threads.

Because of this we need the map groups to be dynamically allocated. No
other functional change is intended in here.

Based on a patch by Jiri Olsa, but this time _just_ making the
conversion from statically allocating thread->mg to turning it into a
pointer and instead of initializing it at thread's constructor,
introduce a constructor/destructor for the map_groups class and
call at thread creation time.

Later we will introduce the get/put methods when we move to sharing
those map_groups, when the get/put refcounting semantics will be needed.

Signed-off-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1397490723-1992-3-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/arch/x86/tests/dwarf-unwind.c |  2 +-
 tools/perf/ui/stdio/hist.c               |  2 +-
 tools/perf/util/event.c                  |  2 +-
 tools/perf/util/map.c                    | 16 ++++++++++++++++
 tools/perf/util/map.h                    |  3 +++
 tools/perf/util/thread.c                 | 18 ++++++++++++------
 tools/perf/util/thread.h                 |  2 +-
 7 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/tools/perf/arch/x86/tests/dwarf-unwind.c b/tools/perf/arch/x86/tests/dwarf-unwind.c
index b8c0102..c916656 100644
--- a/tools/perf/arch/x86/tests/dwarf-unwind.c
+++ b/tools/perf/arch/x86/tests/dwarf-unwind.c
@@ -23,7 +23,7 @@ static int sample_ustack(struct perf_sample *sample,
 
 	sp = (unsigned long) regs[PERF_REG_X86_SP];
 
-	map = map_groups__find(&thread->mg, MAP__FUNCTION, (u64) sp);
+	map = map_groups__find(thread->mg, MAP__FUNCTION, (u64) sp);
 	if (!map) {
 		pr_debug("failed to get stack map\n");
 		free(buf);
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index d59893e..9eccf7f 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -495,7 +495,7 @@ print_entries:
 			break;
 
 		if (h->ms.map == NULL && verbose > 1) {
-			__map_groups__fprintf_maps(&h->thread->mg,
+			__map_groups__fprintf_maps(h->thread->mg,
 						   MAP__FUNCTION, verbose, fp);
 			fprintf(fp, "%.10s end\n", graph_dotted_line);
 		}
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 9d12aa6..dbcaea1 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -699,7 +699,7 @@ void thread__find_addr_map(struct thread *thread,
 			   enum map_type type, u64 addr,
 			   struct addr_location *al)
 {
-	struct map_groups *mg = &thread->mg;
+	struct map_groups *mg = thread->mg;
 	bool load_map = false;
 
 	al->machine = machine;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 39cd2d0..ae4c5e1 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -358,6 +358,22 @@ void map_groups__exit(struct map_groups *mg)
 	}
 }
 
+struct map_groups *map_groups__new(void)
+{
+	struct map_groups *mg = malloc(sizeof(*mg));
+
+	if (mg != NULL)
+		map_groups__init(mg);
+
+	return mg;
+}
+
+void map_groups__delete(struct map_groups *mg)
+{
+	map_groups__exit(mg);
+	free(mg);
+}
+
 void map_groups__flush(struct map_groups *mg)
 {
 	int type;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index f00f058..1073e2d 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -61,6 +61,9 @@ struct map_groups {
 	struct machine	 *machine;
 };
 
+struct map_groups *map_groups__new(void);
+void map_groups__delete(struct map_groups *mg);
+
 static inline struct kmap *map__kmap(struct map *map)
 {
 	return (struct kmap *)(map + 1);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 3ce0498..dc51d16 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -15,7 +15,10 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 	struct thread *thread = zalloc(sizeof(*thread));
 
 	if (thread != NULL) {
-		map_groups__init(&thread->mg);
+		thread->mg = map_groups__new();
+		if (thread->mg == NULL)
+			goto out_free;
+
 		thread->pid_ = pid;
 		thread->tid = tid;
 		thread->ppid = -1;
@@ -37,6 +40,8 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 	return thread;
 
 err_thread:
+	map_groups__delete(thread->mg);
+out_free:
 	free(thread);
 	return NULL;
 }
@@ -45,7 +50,8 @@ void thread__delete(struct thread *thread)
 {
 	struct comm *comm, *tmp;
 
-	map_groups__exit(&thread->mg);
+	map_groups__delete(thread->mg);
+	thread->mg = NULL;
 	list_for_each_entry_safe(comm, tmp, &thread->comm_list, list) {
 		list_del(&comm->list);
 		comm__free(comm);
@@ -111,13 +117,13 @@ int thread__comm_len(struct thread *thread)
 size_t thread__fprintf(struct thread *thread, FILE *fp)
 {
 	return fprintf(fp, "Thread %d %s\n", thread->tid, thread__comm_str(thread)) +
-	       map_groups__fprintf(&thread->mg, verbose, fp);
+	       map_groups__fprintf(thread->mg, verbose, fp);
 }
 
 void thread__insert_map(struct thread *thread, struct map *map)
 {
-	map_groups__fixup_overlappings(&thread->mg, map, verbose, stderr);
-	map_groups__insert(&thread->mg, map);
+	map_groups__fixup_overlappings(thread->mg, map, verbose, stderr);
+	map_groups__insert(thread->mg, map);
 }
 
 int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
@@ -135,7 +141,7 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 	}
 
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		if (map_groups__clone(&thread->mg, &parent->mg, i) < 0)
+		if (map_groups__clone(thread->mg, parent->mg, i) < 0)
 			return -ENOMEM;
 
 	thread->ppid = parent->tid;
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 9b29f08..bee1eb0 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -13,7 +13,7 @@ struct thread {
 		struct rb_node	 rb_node;
 		struct list_head node;
 	};
-	struct map_groups	mg;
+	struct map_groups	*mg;
 	pid_t			pid_; /* Not all tools update this */
 	pid_t			tid;
 	pid_t			ppid;
