Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaIOQnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:43:40 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:13219 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbaIOQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:43:39 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH] perf mem: improves DSO long names search speed with RB tree
Date: Mon, 15 Sep 2014 12:43:21 -0400
Message-Id: <1410799401-22163-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With workload that spawns and destroys many threads and processes,
it was found that perf-mem could took a long time to post-process
the perf data after the target workload had completed its operation.
The performance bottleneck was found to be searching and insertion
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
put the DSO structures in a RB tree sorted by its long name. With
this change, the processing time will become proportional to n*log(n)
which will be much quicker for large n. However, the short name will
still be searched using the old linear searching method which is slow.
With that patch in place, the same perf-mem post-processing step took
less than 30 seconds to complete.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 tools/perf/util/dso.c |   77 ++++++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/dso.h |    1 +
 2 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 819f104..bd92564 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -611,17 +611,83 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
 	return dso;
 }
 
+/*
+ * RB root of DSOs sorted by the long name
+ */
+static struct rb_root dso__long_name_root = { NULL };
+
+/*
+ * Either one of the dso or name parameter must be non-NULL or the
+ * function will not work.
+ */
+static struct dso *
+dso__long_name_findadd_node(struct dso *dso, const char *name)
+{
+	struct rb_node **p = &dso__long_name_root.rb_node;
+	struct rb_node  *parent = NULL;
+	int warned = false;
+
+	if (!name)
+		name = dso->long_name;
+	/*
+	 * Find node with the matching name
+	 */
+	while (*p) {
+		struct dso *this = rb_entry(*p, struct dso, long_name_rb_node);
+		long rc = (long)strcmp(name, this->long_name);
+
+		parent = *p;
+		if (rc == 0) {
+			/*
+			 * In case the new DSO is a duplicate of an existing
+			 * one, print an one-time warning & sort the entry
+			 * by its DSO address.
+			 */
+			if (!dso || (dso == this))
+				return this;	/* Find matching dso */
+			if (!warned) {
+				pr_warning("Duplicated dso long name: %s\n",
+					   name);
+				warned = true;
+			}
+			rc = (long)dso - (long)this;
+		}
+		if (rc < 0)
+			p = &parent->rb_left;
+		else
+			p = &parent->rb_right;
+	}
+	if (dso) {
+		/* Add new node and rebalance tree */
+		rb_link_node(&dso->long_name_rb_node, parent, p);
+		rb_insert_color(&dso->long_name_rb_node, &dso__long_name_root);
+	}
+	return NULL;
+}
+
+static inline void dso__long_name_remove_node(struct dso *dso)
+{
+	rb_erase(&dso->long_name_rb_node, &dso__long_name_root);
+}
+
 void dso__set_long_name(struct dso *dso, const char *name, bool name_allocated)
 {
 	if (name == NULL)
 		return;
 
+	if (dso->long_name) {
+		if (!strcmp(dso->long_name, name))
+			return;
+		dso__long_name_remove_node(dso);
+	}
+
 	if (dso->long_name_allocated)
 		free((char *)dso->long_name);
 
 	dso->long_name		 = name;
 	dso->long_name_len	 = strlen(name);
 	dso->long_name_allocated = name_allocated;
+	(void)dso__long_name_findadd_node(dso, name);
 }
 
 void dso__set_short_name(struct dso *dso, const char *name, bool name_allocated)
@@ -695,6 +761,8 @@ struct dso *dso__new(const char *name)
 	if (dso != NULL) {
 		int i;
 		strcpy(dso->name, name);
+		RB_CLEAR_NODE(&dso->long_name_rb_node);
+		dso->long_name = NULL;
 		dso__set_long_name(dso, dso->name, false);
 		dso__set_short_name(dso, dso->name, false);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
@@ -733,6 +801,10 @@ void dso__delete(struct dso *dso)
 		zfree((char **)&dso->long_name);
 		dso->long_name_allocated = false;
 	}
+	if (dso->long_name) {
+		dso__long_name_remove_node(dso);
+		dso->long_name = NULL;
+	}
 
 	dso__data_close(dso);
 	dso_cache__free(&dso->data.cache);
@@ -822,10 +894,7 @@ struct dso *dsos__find(const struct list_head *head, const char *name, bool cmp_
 				return pos;
 		return NULL;
 	}
-	list_for_each_entry(pos, head, node)
-		if (strcmp(pos->long_name, name) == 0)
-			return pos;
-	return NULL;
+	return dso__long_name_findadd_node(NULL, name);
 }
 
 struct dso *__dsos__findnew(struct list_head *head, const char *name)
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index ad553ba..ed949e4 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -76,6 +76,7 @@ struct dso {
 	struct list_head node;
 	struct rb_root	 symbols[MAP__NR_TYPES];
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
+	struct rb_node   long_name_rb_node;
 	void		 *a2l;
 	char		 *symsrc_filename;
 	unsigned int	 a2l_fails;
-- 
1.7.1

