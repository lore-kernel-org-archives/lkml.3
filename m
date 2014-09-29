Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaI2UH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:07:59 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:40630 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbaI2UHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:07:42 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v5 2/2] perf tool: improves DSO long names lookup speed with rbtree
Date: Mon, 29 Sep 2014 16:07:29 -0400
Message-Id: <1412021249-19201-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1412021249-19201-1-git-send-email-Waiman.Long@hp.com>
References: <1412021249-19201-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With workload that spawns and destroys many threads and processes,
it was found that perf-mem could took a long time to post-process
the perf data after the target workload had completed its operation.
The performance bottleneck was found to be the lookup and insertion
of the new DSO structures (thousands of them in this case).

In a dual-socket Ivy-Bridge E7-4890 v2 machine (30-core, 60-thread),
the perf profile below shows what perf was doing after the profiled
AIM7 shared workload completed:

-     83.94%  perf  libc-2.11.3.so     [.] __strcmp_sse42
   - __strcmp_sse42
      - 99.82% map__new
           machine__process_mmap_event
           perf_session_deliver_event
           perf_session__process_event
           __perf_session__process_events
           cmd_record
           cmd_mem
           run_builtin
           main
           __libc_start_main
-     13.17%  perf  perf               [.] __dsos__findnew
     __dsos__findnew
     map__new
     machine__process_mmap_event
     perf_session_deliver_event
     perf_session__process_event
     __perf_session__process_events
     cmd_record
     cmd_mem
     run_builtin
     main
     __libc_start_main

So about 97% of CPU times were spent in the map__new() function
trying to insert new DSO entry into the DSO linked list. The whole
post-processing step took about 9 minutes.

The DSO structures are currently searched linearly. So the total
processing time will be proportional to n^2.

To overcome this performance problem, the DSO code is modified to
also put the DSO structures in a RB tree sorted by its long name
in additional to being in a simple linked list. With this change,
the processing time will become proportional to n*log(n) which will
be much quicker for large n. However, the short name will still be
searched using the old linear searching method.  With that patch
in place, the same perf-mem post-processing step took less than 30
seconds to complete.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 tools/perf/util/dso.c     |   72 ++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/dso.h     |    1 +
 tools/perf/util/machine.c |    1 +
 tools/perf/util/machine.h |    4 ++-
 4 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 901a58f..9a81c03 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -653,6 +653,67 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
 	return dso;
 }
 
+/*
+ * Find a matching entry and/or link current entry to RB tree.
+ * Either one of the dso or name parameter must be non-NULL or the
+ * function will not work.
+ */
+static struct dso *dso__findlink_by_longname(struct rb_root *root,
+					     struct dso *dso, const char *name)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node  *parent = NULL;
+	int warned = false;
+
+	if (!name)
+		name = dso->long_name;
+	/*
+	 * Find node with the matching name
+	 */
+	while (*p) {
+		struct dso *this = rb_entry(*p, struct dso, rb_node);
+		int rc = strcmp(name, this->long_name);
+
+		parent = *p;
+		if (rc == 0) {
+			/*
+			 * In case the new DSO is a duplicate of an existing
+			 * one, print an one-time warning & put the new entry
+			 * at the end of the list of duplicates.
+			 */
+			if (!dso || (dso == this))
+				return this;	/* Find matching dso */
+			/*
+			 * The core kernel DSOs may have duplicated long name.
+			 * (See dso__load_sym()). Don't print warning for them.
+			 */
+			if (!warned && !strstr(name, "kernel.kallsyms")
+				    && !strstr(name, "/vmlinux")) {
+				pr_warning("Duplicated dso long name: %s\n",
+					   name);
+				warned = true;
+			}
+			rc = 1;
+		}
+		if (rc < 0)
+			p = &parent->rb_left;
+		else
+			p = &parent->rb_right;
+	}
+	if (dso) {
+		/* Add new node and rebalance tree */
+		rb_link_node(&dso->rb_node, parent, p);
+		rb_insert_color(&dso->rb_node, root);
+	}
+	return NULL;
+}
+
+static inline struct dso *
+dso__find_by_longname(struct rb_root *root, const char *name)
+{
+	return dso__findlink_by_longname(root, NULL, name);
+}
+
 void dso__set_long_name(struct dso *dso, const char *name, bool name_allocated)
 {
 	if (name == NULL)
@@ -755,6 +816,7 @@ struct dso *dso__new(const char *name)
 		dso->a2l_fails = 1;
 		dso->kernel = DSO_TYPE_USER;
 		dso->needs_swap = DSO_SWAP__UNSET;
+		RB_CLEAR_NODE(&dso->rb_node);
 		INIT_LIST_HEAD(&dso->node);
 		INIT_LIST_HEAD(&dso->data.open_entry);
 	}
@@ -765,6 +827,10 @@ struct dso *dso__new(const char *name)
 void dso__delete(struct dso *dso)
 {
 	int i;
+
+	if (!RB_EMPTY_NODE(&dso->rb_node))
+		pr_err("DSO %s is still in rbtree when being deleted!\n",
+		       dso->long_name);
 	for (i = 0; i < MAP__NR_TYPES; ++i)
 		symbols__delete(&dso->symbols[i]);
 
@@ -854,6 +920,7 @@ bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
 void dsos__add(struct dsos *dsos, struct dso *dso)
 {
 	list_add_tail(&dso->node, &dsos->head);
+	dso__findlink_by_longname(&dsos->root, dso, NULL);
 }
 
 struct dso *dsos__find(const struct dsos *dsos, const char *name,
@@ -867,10 +934,7 @@ struct dso *dsos__find(const struct dsos *dsos, const char *name,
 				return pos;
 		return NULL;
 	}
-	list_for_each_entry(pos, &dsos->head, node)
-		if (strcmp(pos->long_name, name) == 0)
-			return pos;
-	return NULL;
+	return dso__find_by_longname((struct rb_root *)&dsos->root, name);
 }
 
 struct dso *__dsos__findnew(struct dsos *dsos, const char *name)
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 91eec17..9ecd68b 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -94,6 +94,7 @@ struct dsos;
 
 struct dso {
 	struct list_head node;
+	struct rb_node	 rb_node;	/* rbtree node sorted by long name */
 	struct rb_root	 symbols[MAP__NR_TYPES];
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
 	void		 *a2l;
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 49a75ec..b7d477f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -77,6 +77,7 @@ static void dsos__delete(struct dsos *dsos)
 	struct dso *pos, *n;
 
 	list_for_each_entry_safe(pos, n, &dsos->head, node) {
+		RB_CLEAR_NODE(&pos->rb_node);
 		list_del(&pos->node);
 		dso__delete(pos);
 	}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 37b3487..5a5f765 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -23,10 +23,12 @@ extern const char *ref_reloc_sym_names[];
 struct vdso_info;
 
 /*
- * DSOs are put into a list for fast iteration.
+ * DSOs are put into both a list for fast iteration and rbtree for fast
+ * long name lookup.
  */
 struct dsos {
 	struct list_head head;
+	struct rb_root   root;	/* rbtree root sorted by long name */
 };
 
 struct machine {
-- 
1.7.1

