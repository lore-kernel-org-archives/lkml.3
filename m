Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbaEORYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:24:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbaEORYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:24:06 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/14] perf tools: Add file size check and factor dso__data_read_offset
Date: Thu, 15 May 2014 19:23:28 +0200
Message-Id: <1400174615-2121-8-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding file size check, because the lseek will succeed
for any offset behind file size. Factoring the code
the check the offset earli in the flow.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/dso.c | 78 ++++++++++++++++++++++++++++++++++++++-------------
 tools/perf/util/dso.h |  1 +
 2 files changed, 59 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 316e087..ad0e2da 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -197,6 +197,7 @@ static void close_data_fd(struct dso *dso)
 	if (dso->data.fd >= 0) {
 		close(dso->data.fd);
 		dso->data.fd = -1;
+		dso->data.file_size = 0;
 		dso__list_del(dso);
 	}
 }
@@ -366,17 +367,10 @@ dso_cache__memcpy(struct dso_cache *cache, u64 offset,
 }
 
 static ssize_t
-dso_cache__read(struct dso *dso, struct machine *machine,
-		 u64 offset, u8 *data, ssize_t size)
+dso_cache__read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
 {
-	bool new_fd = dso->data.fd == -1;
 	struct dso_cache *cache;
 	ssize_t ret;
-	int fd;
-
-	fd = dso__data_fd(dso, machine);
-	if (fd < 0)
-		return -1;
 
 	do {
 		u64 cache_offset;
@@ -390,10 +384,10 @@ dso_cache__read(struct dso *dso, struct machine *machine,
 		cache_offset = offset & DSO__DATA_CACHE_MASK;
 		ret = -EINVAL;
 
-		if (-1 == lseek(fd, cache_offset, SEEK_SET))
+		if (-1 == lseek(dso->data.fd, cache_offset, SEEK_SET))
 			break;
 
-		ret = read(fd, cache->data, DSO__DATA_CACHE_SIZE);
+		ret = read(dso->data.fd, cache->data, DSO__DATA_CACHE_SIZE);
 		if (ret <= 0)
 			break;
 
@@ -408,15 +402,11 @@ dso_cache__read(struct dso *dso, struct machine *machine,
 	if (ret <= 0)
 		free(cache);
 
-	/* Check the cache only if we just added new fd. */
-	if (new_fd)
-		data_close();
-
 	return ret;
 }
 
-static ssize_t dso_cache_read(struct dso *dso, struct machine *machine,
-			      u64 offset, u8 *data, ssize_t size)
+static ssize_t dso_cache_read(struct dso *dso, u64 offset,
+			      u8 *data, ssize_t size)
 {
 	struct dso_cache *cache;
 
@@ -424,11 +414,10 @@ static ssize_t dso_cache_read(struct dso *dso, struct machine *machine,
 	if (cache)
 		return dso_cache__memcpy(cache, offset, data, size);
 	else
-		return dso_cache__read(dso, machine, offset, data, size);
+		return dso_cache__read(dso, offset, data, size);
 }
 
-ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
-			      u64 offset, u8 *data, ssize_t size)
+static ssize_t cached_read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
 {
 	ssize_t r = 0;
 	u8 *p = data;
@@ -436,7 +425,7 @@ ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 	do {
 		ssize_t ret;
 
-		ret = dso_cache_read(dso, machine, offset, p, size);
+		ret = dso_cache_read(dso, offset, p, size);
 		if (ret < 0)
 			return ret;
 
@@ -456,6 +445,55 @@ ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 	return r;
 }
 
+static int data_file_size(struct dso *dso)
+{
+	struct stat st;
+
+	if (!dso->data.file_size) {
+		if (fstat(dso->data.fd, &st)) {
+			pr_err("dso mmap failed, fstat: %s\n", strerror(errno));
+			return -1;
+		}
+		dso->data.file_size = st.st_size;
+	}
+
+	return 0;
+}
+
+static ssize_t data_read_offset(struct dso *dso, u64 offset,
+				u8 *data, ssize_t size)
+{
+	if (data_file_size(dso))
+		return -1;
+
+	/* Check the offset sanity. */
+	if (offset > dso->data.file_size)
+		return -1;
+
+	if (offset + size < offset)
+		return -1;
+
+	return cached_read(dso, offset, data, size);
+}
+
+ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
+			      u64 offset, u8 *data, ssize_t size)
+{
+	bool new_fd = dso->data.fd == -1;
+	ssize_t ret;
+
+	if (dso__data_fd(dso, machine) < 0)
+		return -1;
+
+	ret = data_read_offset(dso, offset, data, size);
+
+	/* Check the cache only if we just added new fd. */
+	if (new_fd)
+		data_close();
+
+	return ret;
+}
+
 ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
 			    struct machine *machine, u64 addr,
 			    u8 *data, ssize_t size)
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 90988bf..da47b13 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -103,6 +103,7 @@ struct dso {
 	struct {
 		struct rb_root	 cache;
 		int		 fd;
+		size_t		 file_size;
 		struct list_head open_entry;
 	} data;
 
-- 
1.8.3.1

