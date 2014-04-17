Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaDQRlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:41:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaDQRjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:39:42 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 3/3] perf tools: Replace dso data cache with mapped data
Date: Thu, 17 Apr 2014 19:39:12 +0200
Message-Id: <1397756352-26694-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
References: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing dso data cache processing and mapping
whole dso object instead when requested.

Got about 13% speed up in dso__data_read_offset function
for report command processing dwarf unwind stacks.

Output from report over 1.5 GB data with DWARF unwind stacks:
(TODO fix perf diff)

  13.63%  perf.old  perf.old                   [.] dso__data_read_offset

   0.32%     perf   perf                       [.] dso__data_read_offset

And overall speedup:

 Performance counter stats for './perf.old report -i perf-test.data --stdio':

   113,076,591,004      cycles:u                  #    2.675 GHz
   163,353,590,494      instructions:u            #    1.44  insns per cycle
      42269.774797      task-clock (msec)         #    1.000 CPUs utilized

      42.267550053 seconds time elapsed

 Performance counter stats for './perf report -i perf-test.data --stdio':

    92,953,167,072      cycles:u                  #    2.534 GHz
   132,967,448,023      instructions:u            #    1.43  insns per cycle
      36683.242639      task-clock (msec)         #    1.000 CPUs utilized

      36.682799394 seconds time elapsed

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jean Pihet <jean.pihet@linaro.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/tests/dso-data.c |   7 ++
 tools/perf/util/dso.c       | 185 +++++++++++---------------------------------
 tools/perf/util/dso.h       |  13 +---
 3 files changed, 54 insertions(+), 151 deletions(-)

diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index 9cc81a3..024c15f 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -40,6 +40,13 @@ static char *test_file(int size)
 	return templ;
 }
 
+/*
+ * The data access is now pure memory map of the file,
+ * so we dont need DSO__DATA_CACHE_SIZE anymore.
+ * Anyway keeping it for the sake of this test to
+ * ensure dso__data_read_offset interface works.
+ */
+#define DSO__DATA_CACHE_SIZE 4096
 #define TEST_FILE_SIZE (DSO__DATA_CACHE_SIZE * 20)
 
 struct test_data_offset {
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 0dca5d6..f274c85 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1,3 +1,5 @@
+#include <sys/mman.h>
+
 #include "symbol.h"
 #include "dso.h"
 #include "machine.h"
@@ -161,6 +163,14 @@ static int open_dso(struct dso *dso, struct machine *machine)
 
 static void dso__data_close(struct dso *dso)
 {
+	if (dso->data_mmap) {
+		size_t size = PERF_ALIGN(dso->data_size, page_size);
+
+		if (munmap(dso->data_mmap, size))
+			pr_err("dso mmap failed, munmap: %s\n",
+			       strerror(errno));
+	}
+
 	if (dso->data_fd >= 0)
 		close(dso->data_fd);
 }
@@ -191,164 +201,61 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
 	return -EINVAL;
 }
 
-static void
-dso_cache__free(struct rb_root *root)
-{
-	struct rb_node *next = rb_first(root);
-
-	while (next) {
-		struct dso_cache *cache;
-
-		cache = rb_entry(next, struct dso_cache, rb_node);
-		next = rb_next(&cache->rb_node);
-		rb_erase(&cache->rb_node, root);
-		free(cache);
-	}
-}
-
-static struct dso_cache *dso_cache__find(const struct rb_root *root, u64 offset)
+static int dso__data_mmap(struct dso *dso, struct machine *machine, char **ptr)
 {
-	struct rb_node * const *p = &root->rb_node;
-	const struct rb_node *parent = NULL;
-	struct dso_cache *cache;
-
-	while (*p != NULL) {
-		u64 end;
-
-		parent = *p;
-		cache = rb_entry(parent, struct dso_cache, rb_node);
-		end = cache->offset + DSO__DATA_CACHE_SIZE;
-
-		if (offset < cache->offset)
-			p = &(*p)->rb_left;
-		else if (offset >= end)
-			p = &(*p)->rb_right;
-		else
-			return cache;
-	}
-	return NULL;
-}
-
-static void
-dso_cache__insert(struct rb_root *root, struct dso_cache *new)
-{
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
-	struct dso_cache *cache;
-	u64 offset = new->offset;
-
-	while (*p != NULL) {
-		u64 end;
-
-		parent = *p;
-		cache = rb_entry(parent, struct dso_cache, rb_node);
-		end = cache->offset + DSO__DATA_CACHE_SIZE;
-
-		if (offset < cache->offset)
-			p = &(*p)->rb_left;
-		else if (offset >= end)
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&new->rb_node, parent, p);
-	rb_insert_color(&new->rb_node, root);
-}
-
-static ssize_t
-dso_cache__memcpy(struct dso_cache *cache, u64 offset,
-		  u8 *data, u64 size)
-{
-	u64 cache_offset = offset - cache->offset;
-	u64 cache_size   = min(cache->size - cache_offset, size);
-
-	memcpy(data, cache->data + cache_offset, cache_size);
-	return cache_size;
-}
-
-static ssize_t
-dso_cache__read(struct dso *dso, struct machine *machine,
-		 u64 offset, u8 *data, ssize_t size)
-{
-	struct dso_cache *cache;
-	ssize_t ret;
+	struct stat st;
 	int fd;
+	char *m;
+
+	if (dso->data_mmap)
+		goto out;
 
 	fd = dso__data_fd(dso, machine);
 	if (fd < 0)
-		return -1;
-
-	do {
-		u64 cache_offset;
-
-		ret = -ENOMEM;
-
-		cache = zalloc(sizeof(*cache) + DSO__DATA_CACHE_SIZE);
-		if (!cache)
-			break;
-
-		cache_offset = offset & DSO__DATA_CACHE_MASK;
-		ret = -EINVAL;
-
-		if (-1 == lseek(fd, cache_offset, SEEK_SET))
-			break;
+		return fd;
 
-		ret = read(fd, cache->data, DSO__DATA_CACHE_SIZE);
-		if (ret <= 0)
-			break;
-
-		cache->offset = cache_offset;
-		cache->size   = ret;
-		dso_cache__insert(&dso->cache, cache);
-
-		ret = dso_cache__memcpy(cache, offset, data, size);
-
-	} while (0);
+	if (fstat(fd, &st)) {
+		pr_err("dso mmap failed, fstat: %s\n", strerror(errno));
+		return -1;
+	}
 
-	if (ret <= 0)
-		free(cache);
+	dso->data_size = st.st_size;
 
-	return ret;
-}
+	m = mmap(0, PERF_ALIGN(dso->data_size, page_size),
+		 PROT_READ, MAP_SHARED, fd, 0);
+	if (m == MAP_FAILED) {
+		pr_err("dso mmap failed, mmap: %s\n", strerror(errno));
+		return -1;
+	}
 
-static ssize_t dso_cache_read(struct dso *dso, struct machine *machine,
-			      u64 offset, u8 *data, ssize_t size)
-{
-	struct dso_cache *cache;
+	dso->data_mmap = m;
 
-	cache = dso_cache__find(&dso->cache, offset);
-	if (cache)
-		return dso_cache__memcpy(cache, offset, data, size);
-	else
-		return dso_cache__read(dso, machine, offset, data, size);
+out:
+	*ptr = dso->data_mmap;
+	return 0;
 }
 
 ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 			      u64 offset, u8 *data, ssize_t size)
 {
-	ssize_t r = 0;
-	u8 *p = data;
+	ssize_t rsize = size;
+	char *m;
 
-	do {
-		ssize_t ret;
-
-		ret = dso_cache_read(dso, machine, offset, p, size);
-		if (ret < 0)
-			return ret;
-
-		/* Reached EOF, return what we have. */
-		if (!ret)
-			break;
+	if (dso__data_mmap(dso, machine, &m))
+		return -1;
 
-		BUG_ON(ret > size);
+	if (offset > dso->data_size)
+		return -1;
 
-		r      += ret;
-		p      += ret;
-		offset += ret;
-		size   -= ret;
+	/* unlikely, but anyway.. check overflow ;-) */
+	if (offset + size < offset)
+		return -1;
 
-	} while (size);
+	if (offset + size > dso->data_size)
+		rsize = dso->data_size - offset;
 
-	return r;
+	memcpy(data, m + offset, rsize);
+	return rsize;
 }
 
 ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
@@ -478,7 +385,6 @@ struct dso *dso__new(const char *name)
 		dso__set_short_name(dso, dso->name, false);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
-		dso->cache = RB_ROOT;
 		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->binary_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->loaded = 0;
@@ -513,7 +419,6 @@ void dso__delete(struct dso *dso)
 	}
 
 	dso__data_close(dso);
-	dso_cache__free(&dso->cache);
 	dso__free_a2l(dso);
 	zfree(&dso->symsrc_filename);
 	free(dso);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 6e48cdc..fe4e4aa 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -62,21 +62,10 @@ enum dso_swap_type {
 	____r;						\
 })
 
-#define DSO__DATA_CACHE_SIZE 4096
-#define DSO__DATA_CACHE_MASK ~(DSO__DATA_CACHE_SIZE - 1)
-
-struct dso_cache {
-	struct rb_node	rb_node;
-	u64 offset;
-	u64 size;
-	char data[0];
-};
-
 struct dso {
 	struct list_head node;
 	struct rb_root	 symbols[MAP__NR_TYPES];
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
-	struct rb_root	 cache;
 	void		 *a2l;
 	char		 *symsrc_filename;
 	unsigned int	 a2l_fails;
@@ -100,6 +89,8 @@ struct dso {
 	u16		 long_name_len;
 	u16		 short_name_len;
 	int		 data_fd;
+	size_t		 data_size;
+	char		 *data_mmap;
 	char		 name[0];
 };
 
-- 
1.8.3.1

