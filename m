Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbbA2IOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:14:15 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51484 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbbA2IKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:17 -0500
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
Subject: [PATCH 28/42] perf tools: Protect dso cache tree using dso->lock
Date: Thu, 29 Jan 2015 17:07:09 +0900
Message-Id: <1422518843-25818-29-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dso cache is accessed during dwarf callchain unwind and it might
be processed concurrently when multi-thread report is enabled.
Protect it under dso->lock.

Note that it doesn't protect dso_cache__find().  I think it's safe to
access to the cache tree without the lock since we don't delete nodes.
It it missed an existing node due to rotation, it'll find it during
dso_cache__insert() anyway.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/dso.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 3da75816b8f8..11ece224ef50 100644
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
 
@@ -455,10 +457,12 @@ dso_cache__free(struct rb_root *root)
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
@@ -477,17 +481,20 @@ static struct dso_cache *dso_cache__find(const struct rb_root *root, u64 offset)
 		else
 			return cache;
 	}
+
 	return NULL;
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
 
@@ -499,10 +506,17 @@ dso_cache__insert(struct rb_root *root, struct dso_cache *new)
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
@@ -520,6 +534,7 @@ static ssize_t
 dso_cache__read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
 {
 	struct dso_cache *cache;
+	struct dso_cache *old;
 	ssize_t ret;
 
 	do {
@@ -543,7 +558,12 @@ dso_cache__read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
 
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
 
@@ -560,7 +580,7 @@ static ssize_t dso_cache_read(struct dso *dso, u64 offset,
 {
 	struct dso_cache *cache;
 
-	cache = dso_cache__find(&dso->data.cache, offset);
+	cache = dso_cache__find(dso, offset);
 	if (cache)
 		return dso_cache__memcpy(cache, offset, data, size);
 	else
@@ -915,7 +935,7 @@ void dso__delete(struct dso *dso)
 	}
 
 	dso__data_close(dso);
-	dso_cache__free(&dso->data.cache);
+	dso_cache__free(dso);
 	dso__free_a2l(dso);
 	zfree(&dso->symsrc_filename);
 	pthread_mutex_destroy(&dso->lock);
-- 
2.2.2

