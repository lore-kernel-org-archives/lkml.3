Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbbA2IPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:15:19 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51467 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbbA2IKQ (ORCPT
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
Subject: [PATCH 27/42] perf tools: Protect dso symbol loading using a mutex
Date: Thu, 29 Jan 2015 17:07:08 +0900
Message-Id: <1422518843-25818-28-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When multi-thread support for perf report is enabled, it's possible to
access a dso concurrently.  Add a new pthread_mutex to protect it from
concurrent dso__load().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/dso.c    |  2 ++
 tools/perf/util/dso.h    |  1 +
 tools/perf/util/symbol.c | 34 ++++++++++++++++++++++++----------
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 45be944d450a..3da75816b8f8 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -888,6 +888,7 @@ struct dso *dso__new(const char *name)
 		RB_CLEAR_NODE(&dso->rb_node);
 		INIT_LIST_HEAD(&dso->node);
 		INIT_LIST_HEAD(&dso->data.open_entry);
+		pthread_mutex_init(&dso->lock, NULL);
 	}
 
 	return dso;
@@ -917,6 +918,7 @@ void dso__delete(struct dso *dso)
 	dso_cache__free(&dso->data.cache);
 	dso__free_a2l(dso);
 	zfree(&dso->symsrc_filename);
+	pthread_mutex_destroy(&dso->lock);
 	free(dso);
 }
 
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 3782c82c6e44..ac753594a469 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -102,6 +102,7 @@ struct dsos {
 };
 
 struct dso {
+	pthread_mutex_t	 lock;
 	struct list_head node;
 	struct rb_node	 rb_node;	/* rbtree node sorted by long name */
 	struct rb_root	 symbols[MAP__NR_TYPES];
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a69066865a55..714e20c99354 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1357,12 +1357,22 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	struct symsrc *syms_ss = NULL, *runtime_ss = NULL;
 	bool kmod;
 
-	dso__set_loaded(dso, map->type);
+	pthread_mutex_lock(&dso->lock);
+
+	/* check again under the dso->lock */
+	if (dso__loaded(dso, map->type)) {
+		ret = 1;
+		goto out;
+	}
+
+	if (dso->kernel) {
+		if (dso->kernel == DSO_TYPE_KERNEL)
+			ret = dso__load_kernel_sym(dso, map, filter);
+		else if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
+			ret = dso__load_guest_kernel_sym(dso, map, filter);
 
-	if (dso->kernel == DSO_TYPE_KERNEL)
-		return dso__load_kernel_sym(dso, map, filter);
-	else if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
-		return dso__load_guest_kernel_sym(dso, map, filter);
+		goto out;
+	}
 
 	if (map->groups && map->groups->machine)
 		machine = map->groups->machine;
@@ -1375,18 +1385,18 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 		struct stat st;
 
 		if (lstat(dso->name, &st) < 0)
-			return -1;
+			goto out;
 
 		if (st.st_uid && (st.st_uid != geteuid())) {
 			pr_warning("File %s not owned by current user or root, "
 				"ignoring it.\n", dso->name);
-			return -1;
+			goto out;
 		}
 
 		ret = dso__load_perf_map(dso, map, filter);
 		dso->symtab_type = ret > 0 ? DSO_BINARY_TYPE__JAVA_JIT :
 					     DSO_BINARY_TYPE__NOT_FOUND;
-		return ret;
+		goto out;
 	}
 
 	if (machine)
@@ -1394,7 +1404,7 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 
 	name = malloc(PATH_MAX);
 	if (!name)
-		return -1;
+		goto out;
 
 	kmod = dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE ||
 		dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP ||
@@ -1475,7 +1485,11 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 out_free:
 	free(name);
 	if (ret < 0 && strstr(dso->name, " (deleted)") != NULL)
-		return 0;
+		ret = 0;
+out:
+	dso__set_loaded(dso, map->type);
+	pthread_mutex_unlock(&dso->lock);
+
 	return ret;
 }
 
-- 
2.2.2

