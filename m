Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaIPTIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:08:34 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:6649 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbaIPTIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:08:31 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2] perf mem: improves DSO long names search speed with RB tree
Date: Tue, 16 Sep 2014 15:08:19 -0400
Message-Id: <1410894499-27609-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1410894499-27609-1-git-send-email-Waiman.Long@hp.com>
References: <1410894499-27609-1-git-send-email-Waiman.Long@hp.com>
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
also put the DSO structures in a RB tree sorted by its long name
in additional to being in a simple linked list. With this change,
the processing time will become proportional to n*log(n) which will
be much quicker for large n. However, the short name will still
be searched using the old linear searching method which is slow.
With that patch in place, the same perf-mem post-processing step took
less than 30 seconds to complete.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 tools/perf/util/dso.c |   87 ++++++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/dso.h |    1 +
 2 files changed, 84 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 819f104..fccb2f0 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -611,17 +611,93 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
 	return dso;
 }
 
+/*
+ * RB root of DSOs sorted by the long name
+ */
+static struct rb_root dso__longname_root = { NULL };
+
+/*
+ * Find a matching entry and/or link current entry to RB tree.
+ * Either one of the dso or name parameter must be non-NULL or the
+ * function will not work.
+ */
+static struct dso *
+dso__findlink_by_longname(struct dso *dso, const char *name)
+{
+	struct rb_node **p = &dso__longname_root.rb_node;
+	struct rb_node  *parent = NULL;
+	int warned = false;
+
+	if (!name)
+		name = dso->long_name;
+	/*
+	 * Find node with the matching name
+	 */
+	while (*p) {
+		struct dso *this = rb_entry(*p, struct dso, longname_rb_node);
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
+		rb_link_node(&dso->longname_rb_node, parent, p);
+		rb_insert_color(&dso->longname_rb_node, &dso__longname_root);
+	}
+	return NULL;
+}
+
+static inline struct dso *
+dso__find_by_longname(const char *name)
+{
+	return dso__findlink_by_longname(NULL, name);
+}
+
+/*
+ * Unlink the longname-sorted RB tree node
+ */
+static inline void dso__unlink_longname_node(struct dso *dso)
+{
+	rb_erase(&dso->longname_rb_node, &dso__longname_root);
+}
+
 void dso__set_long_name(struct dso *dso, const char *name, bool name_allocated)
 {
 	if (name == NULL)
 		return;
 
+	if (dso->long_name) {
+		if (!strcmp(dso->long_name, name))
+			return;
+		dso__unlink_longname_node(dso);
+	}
+
 	if (dso->long_name_allocated)
 		free((char *)dso->long_name);
 
 	dso->long_name		 = name;
 	dso->long_name_len	 = strlen(name);
 	dso->long_name_allocated = name_allocated;
+	(void)dso__findlink_by_longname(dso, name);
 }
 
 void dso__set_short_name(struct dso *dso, const char *name, bool name_allocated)
@@ -695,6 +771,8 @@ struct dso *dso__new(const char *name)
 	if (dso != NULL) {
 		int i;
 		strcpy(dso->name, name);
+		RB_CLEAR_NODE(&dso->longname_rb_node);
+		dso->long_name = NULL;
 		dso__set_long_name(dso, dso->name, false);
 		dso__set_short_name(dso, dso->name, false);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
@@ -733,6 +811,10 @@ void dso__delete(struct dso *dso)
 		zfree((char **)&dso->long_name);
 		dso->long_name_allocated = false;
 	}
+	if (dso->long_name) {
+		dso__unlink_longname_node(dso);
+		dso->long_name = NULL;
+	}
 
 	dso__data_close(dso);
 	dso_cache__free(&dso->data.cache);
@@ -822,10 +904,7 @@ struct dso *dsos__find(const struct list_head *head, const char *name, bool cmp_
 				return pos;
 		return NULL;
 	}
-	list_for_each_entry(pos, head, node)
-		if (strcmp(pos->long_name, name) == 0)
-			return pos;
-	return NULL;
+	return dso__find_by_longname(name);
 }
 
 struct dso *__dsos__findnew(struct list_head *head, const char *name)
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index ad553ba..81a75ee 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -76,6 +76,7 @@ struct dso {
 	struct list_head node;
 	struct rb_root	 symbols[MAP__NR_TYPES];
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
+	struct rb_node   longname_rb_node;
 	void		 *a2l;
 	char		 *symsrc_filename;
 	unsigned int	 a2l_fails;
-- 
1.7.1

