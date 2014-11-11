Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaKKOUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:20:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:64540 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbaKKOUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:20:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630152199"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/25] perf itrace: Add a hashtable for caching decoded instructions
Date: Tue, 11 Nov 2014 16:16:55 +0200
Message-Id: <1415715423-15563-18-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Decoding Instruction Trace data may involve walking object
code.  Rather than repetitively decoding the same instructions,
a cache can be used to cache the results.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/itrace.c | 123 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h |  14 ++++++
 2 files changed, 137 insertions(+)

diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index eb43a7f..fd67a9a 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -37,6 +37,8 @@
 #include "thread_map.h"
 #include "itrace.h"
 
+#include <linux/hash.h>
+
 #include "event.h"
 #include "session.h"
 #include "debug.h"
@@ -916,3 +918,124 @@ int itrace_mmap__read(struct itrace_mmap *mm, struct itrace_record *itr,
 
 	return 1;
 }
+
+/**
+ * struct itrace_cache - hash table to cache decoded instruction blocks
+ * @hashtable: the hashtable
+ * @sz: hashtable size (number of hlists)
+ * @entry_size: size of an entry
+ * @limit: limit the number of entries to this maximum, when reached the cache
+ *         is dropped and caching begins again with an empty cache
+ * @cnt: current number of entries
+ * @bits: hashtable size (@sz = 2^@bits)
+ */
+struct itrace_cache {
+	struct hlist_head *hashtable;
+	size_t sz;
+	size_t entry_size;
+	size_t limit;
+	size_t cnt;
+	unsigned int bits;
+};
+
+struct itrace_cache *itrace_cache__new(unsigned int bits, size_t entry_size,
+				       unsigned int limit_percent)
+{
+	struct itrace_cache *c;
+	struct hlist_head *ht;
+	size_t sz, i;
+
+	c = zalloc(sizeof(struct itrace_cache));
+	if (!c)
+		return NULL;
+
+	sz = 1UL << bits;
+
+	ht = calloc(sz, sizeof(struct hlist_head));
+	if (!ht)
+		goto out_free;
+
+	for (i = 0; i < sz; i++)
+		INIT_HLIST_HEAD(&ht[i]);
+
+	c->hashtable = ht;
+	c->sz = sz;
+	c->entry_size = entry_size;
+	c->limit = (c->sz * limit_percent) / 100;
+	c->bits = bits;
+
+	return c;
+
+out_free:
+	free(c);
+	return NULL;
+}
+
+static void itrace_cache__drop(struct itrace_cache *c)
+{
+	struct itrace_cache_entry *entry;
+	struct hlist_node *tmp;
+	size_t i;
+
+	if (!c)
+		return;
+
+	for (i = 0; i < c->sz; i++) {
+		hlist_for_each_entry_safe(entry, tmp, &c->hashtable[i], hash) {
+			hlist_del(&entry->hash);
+			itrace_cache__free_entry(c, entry);
+		}
+	}
+
+	c->cnt = 0;
+}
+
+void itrace_cache__free(struct itrace_cache *c)
+{
+	if (!c)
+		return;
+
+	itrace_cache__drop(c);
+	free(c->hashtable);
+	free(c);
+}
+
+void *itrace_cache__alloc_entry(struct itrace_cache *c)
+{
+	return malloc(c->entry_size);
+}
+
+void itrace_cache__free_entry(struct itrace_cache *c __maybe_unused,
+			      void *entry)
+{
+	free(entry);
+}
+
+int itrace_cache__add(struct itrace_cache *c, u32 key,
+		      struct itrace_cache_entry *entry)
+{
+	if (c->limit && ++c->cnt > c->limit)
+		itrace_cache__drop(c);
+
+	entry->key = key;
+	hlist_add_head(&entry->hash, &c->hashtable[hash_32(key, c->bits)]);
+
+	return 0;
+}
+
+void *itrace_cache__lookup(struct itrace_cache *c, u32 key)
+{
+	struct itrace_cache_entry *entry;
+	struct hlist_head *hlist;
+
+	if (!c)
+		return NULL;
+
+	hlist = &c->hashtable[hash_32(key, c->bits)];
+	hlist_for_each_entry(entry, hlist, hash) {
+		if (entry->key == key)
+			return entry;
+	}
+
+	return NULL;
+}
diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index 575037c..e67fa34 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -316,6 +316,20 @@ int itrace_heap__add(struct itrace_heap *heap, unsigned int queue_nr,
 void itrace_heap__pop(struct itrace_heap *heap);
 void itrace_heap__free(struct itrace_heap *heap);
 
+struct itrace_cache_entry {
+	struct hlist_node hash;
+	u32 key;
+};
+
+struct itrace_cache *itrace_cache__new(unsigned int bits, size_t entry_size,
+				       unsigned int limit_percent);
+void itrace_cache__free(struct itrace_cache *itrace_cache);
+void *itrace_cache__alloc_entry(struct itrace_cache *c);
+void itrace_cache__free_entry(struct itrace_cache *c, void *entry);
+int itrace_cache__add(struct itrace_cache *c, u32 key,
+		      struct itrace_cache_entry *entry);
+void *itrace_cache__lookup(struct itrace_cache *c, u32 key);
+
 struct itrace_record *itrace_record__init(int *err);
 
 int itrace_record__options(struct itrace_record *itr,
-- 
1.9.1

