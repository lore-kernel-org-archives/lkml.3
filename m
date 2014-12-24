Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbaLXHRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:17:45 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40304 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaLXHPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:15:43 -0500
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
Subject: [PATCH 33/37] perf tools: Add front cache for dso data access
Date: Wed, 24 Dec 2014 16:15:29 +0900
Message-Id: <1419405333-27952-34-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a high contention in dso_cache__find() due to the dso->lock
when dwarf unwinding is done with libunwind.  Add last accessed
pointers of dso_cache to lockless lookup.  It'll fallback to normal
tree search when it misses the last cache.

The size 16 is arbitrary and works best for my setting.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/dso.c | 28 ++++++++++++++++++++++++++--
 tools/perf/util/dso.h |  2 ++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 6c1f5619f423..d8ee1fd826e7 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -466,12 +466,31 @@ dso_cache__free(struct dso *dso)
 	pthread_mutex_unlock(&dso->lock);
 }
 
+static void update_last_cache(struct dso *dso, struct dso_cache *cache)
+{
+	int i;
+
+	for (i = DSO_LAST_CACHE_NR - 1; i > 0; i--)
+		dso->data.last[i] = dso->data.last[i-1];
+
+	dso->data.last[0] = cache;
+}
+
 static struct dso_cache *dso_cache__find(struct dso *dso, u64 offset)
 {
 	const struct rb_root *root = &dso->data.cache;
 	struct rb_node * const *p = &root->rb_node;
 	const struct rb_node *parent = NULL;
 	struct dso_cache *cache;
+	int i;
+
+	for (i = 0; i < DSO_LAST_CACHE_NR; i++) {
+		cache = dso->data.last[i];
+
+		if (cache && cache->offset <= offset &&
+		    offset < cache->offset + DSO__DATA_CACHE_SIZE)
+			return cache;
+	}
 
 	pthread_mutex_lock(&dso->lock);
 	while (*p != NULL) {
@@ -485,8 +504,10 @@ static struct dso_cache *dso_cache__find(struct dso *dso, u64 offset)
 			p = &(*p)->rb_left;
 		else if (offset >= end)
 			p = &(*p)->rb_right;
-		else
+		else {
+			update_last_cache(dso, cache);
 			goto out;
+		}
 	}
 	cache = NULL;
 out:
@@ -515,13 +536,16 @@ dso_cache__insert(struct dso *dso, struct dso_cache *new)
 			p = &(*p)->rb_left;
 		else if (offset >= end)
 			p = &(*p)->rb_right;
-		else
+		else {
+			update_last_cache(dso, cache);
 			goto out;
+		}
 	}
 
 	rb_link_node(&new->rb_node, parent, p);
 	rb_insert_color(&new->rb_node, root);
 
+	update_last_cache(dso, new);
 	cache = NULL;
 out:
 	pthread_mutex_unlock(&dso->lock);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index c18fcc0e8081..28e8bb320495 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -136,6 +136,8 @@ struct dso {
 	/* dso data file */
 	struct {
 		struct rb_root	 cache;
+#define DSO_LAST_CACHE_NR  16
+		struct dso_cache *last[DSO_LAST_CACHE_NR];
 		int		 fd;
 		int		 status;
 		u32		 status_seen;
-- 
2.1.3

