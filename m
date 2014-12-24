Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaLXHTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:19:52 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40136 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaLXHPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:15:36 -0500
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
Subject: [PATCH 22/37] perf tools: Protect dso cache tree using dso->lock
Date: Wed, 24 Dec 2014 16:15:18 +0900
Message-Id: <1419405333-27952-23-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dso cache is accessed during dwarf callchain unwind and it might
be processed concurrently when multi-thread report is enabled.
Protect it under dso->lock.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/dso.c | 41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 3da75816b8f8..9555b1772fb5 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -443,10 +443,12 @@ bool dso__data_status_seen(struct dso *dso, enum dso_data_status_seen by)
 }
 
 static void
-dso_cache__free(struct rb_root *root)
+dso_cache__free(struct dso *dso)
 {
+	struct rb_root *root = &dso->data.cache;
 	struct rb_node *next = rb_first(root);
 
+	pthread_mutex_lock(&dso->lock);
 	while (next) {
 		struct dso_cache *cache;
 
@@ -455,14 +457,17 @@ dso_cache__free(struct rb_root *root)
 		rb_erase(&cache->rb_node, root);
 		free(cache);
 	}
+	pthread_mutex_unlock(&dso->lock);
 }
 
-static struct dso_cache *dso_cache__find(const struct rb_root *root, u64 offset)
+static struct dso_cache *dso_cache__find(struct dso *dso, u64 offset)
 {
+	const struct rb_root *root = &dso->data.cache;
 	struct rb_node * const *p = &root->rb_node;
 	const struct rb_node *parent = NULL;
 	struct dso_cache *cache;
 
+	pthread_mutex_lock(&dso->lock);
 	while (*p != NULL) {
 		u64 end;
 
@@ -475,19 +480,24 @@ static struct dso_cache *dso_cache__find(const struct rb_root *root, u64 offset)
 		else if (offset >= end)
 			p = &(*p)->rb_right;
 		else
-			return cache;
+			goto out;
 	}
-	return NULL;
+	cache = NULL;
+out:
+	pthread_mutex_unlock(&dso->lock);
+	return cache;
 }
 
-static void
-dso_cache__insert(struct rb_root *root, struct dso_cache *new)
+static struct dso_cache *
+dso_cache__insert(struct dso *dso, struct dso_cache *new)
 {
+	struct rb_root *root = &dso->data.cache;
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct dso_cache *cache;
 	u64 offset = new->offset;
 
+	pthread_mutex_lock(&dso->lock);
 	while (*p != NULL) {
 		u64 end;
 
@@ -499,10 +509,17 @@ dso_cache__insert(struct rb_root *root, struct dso_cache *new)
 			p = &(*p)->rb_left;
 		else if (offset >= end)
 			p = &(*p)->rb_right;
+		else
+			goto out;
 	}
 
 	rb_link_node(&new->rb_node, parent, p);
 	rb_insert_color(&new->rb_node, root);
+
+	cache = NULL;
+out:
+	pthread_mutex_unlock(&dso->lock);
+	return cache;
 }
 
 static ssize_t
@@ -520,6 +537,7 @@ static ssize_t
 dso_cache__read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
 {
 	struct dso_cache *cache;
+	struct dso_cache *old;
 	ssize_t ret;
 
 	do {
@@ -543,7 +561,12 @@ dso_cache__read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
 
 		cache->offset = cache_offset;
 		cache->size   = ret;
-		dso_cache__insert(&dso->data.cache, cache);
+		old = dso_cache__insert(dso, cache);
+		if (old) {
+			/* we lose the race */
+			free(cache);
+			cache = old;
+		}
 
 		ret = dso_cache__memcpy(cache, offset, data, size);
 
@@ -560,7 +583,7 @@ static ssize_t dso_cache_read(struct dso *dso, u64 offset,
 {
 	struct dso_cache *cache;
 
-	cache = dso_cache__find(&dso->data.cache, offset);
+	cache = dso_cache__find(dso, offset);
 	if (cache)
 		return dso_cache__memcpy(cache, offset, data, size);
 	else
@@ -915,7 +938,7 @@ void dso__delete(struct dso *dso)
 	}
 
 	dso__data_close(dso);
-	dso_cache__free(&dso->data.cache);
+	dso_cache__free(dso);
 	dso__free_a2l(dso);
 	zfree(&dso->symsrc_filename);
 	pthread_mutex_destroy(&dso->lock);
-- 
2.1.3

