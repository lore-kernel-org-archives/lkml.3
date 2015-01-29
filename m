Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbbA2IKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:10:55 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51715 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbbA2IKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:22 -0500
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
Subject: [PATCH 29/42] perf tools: Protect dso cache fd with a mutex
Date: Thu, 29 Jan 2015 17:07:10 +0900
Message-Id: <1422518843-25818-30-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dso cache is accessed in multi-thread environment, it's possible
to close other dso->data.fd during operation due to open file limit.
Protect the file descriptors using a separate mutex.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/tests/dso-data.c |   5 ++
 tools/perf/util/dso.c       | 136 +++++++++++++++++++++++++++++---------------
 2 files changed, 94 insertions(+), 47 deletions(-)

diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index caaf37f079b1..0276e7d2d41b 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -111,6 +111,9 @@ int test__dso_data(void)
 	memset(&machine, 0, sizeof(machine));
 
 	dso = dso__new((const char *)file);
+	TEST_ASSERT_VAL("failed to get dso", dso);
+
+	dso->binary_type = DSO_BINARY_TYPE__SYSTEM_PATH_DSO;
 
 	/* Basic 10 bytes tests. */
 	for (i = 0; i < ARRAY_SIZE(offsets); i++) {
@@ -199,6 +202,8 @@ static int dsos__create(int cnt, int size)
 
 		dsos[i] = dso__new(file);
 		TEST_ASSERT_VAL("failed to get dso", dsos[i]);
+
+		dsos[i]->binary_type = DSO_BINARY_TYPE__SYSTEM_PATH_DSO;
 	}
 
 	return 0;
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 11ece224ef50..ae92046ae2c8 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -213,6 +213,7 @@ bool dso__needs_decompress(struct dso *dso)
  */
 static LIST_HEAD(dso__data_open);
 static long dso__data_open_cnt;
+static pthread_mutex_t dso__data_open_lock = PTHREAD_MUTEX_INITIALIZER;
 
 static void dso__list_add(struct dso *dso)
 {
@@ -240,7 +241,7 @@ static int do_open(char *name)
 		if (fd >= 0)
 			return fd;
 
-		pr_debug("dso open failed, mmap: %s\n",
+		pr_debug("dso open failed: %s\n",
 			 strerror_r(errno, sbuf, sizeof(sbuf)));
 		if (!dso__data_open_cnt || errno != EMFILE)
 			break;
@@ -382,7 +383,9 @@ static void check_data_close(void)
  */
 void dso__data_close(struct dso *dso)
 {
+	pthread_mutex_lock(&dso__data_open_lock);
 	close_dso(dso);
+	pthread_mutex_unlock(&dso__data_open_lock);
 }
 
 /**
@@ -405,6 +408,8 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
 	if (dso->data.status == DSO_DATA_STATUS_ERROR)
 		return -1;
 
+	pthread_mutex_lock(&dso__data_open_lock);
+
 	if (dso->data.fd >= 0)
 		goto out;
 
@@ -427,6 +432,7 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
 	else
 		dso->data.status = DSO_DATA_STATUS_ERROR;
 
+	pthread_mutex_unlock(&dso__data_open_lock);
 	return dso->data.fd;
 }
 
@@ -531,52 +537,66 @@ dso_cache__memcpy(struct dso_cache *cache, u64 offset,
 }
 
 static ssize_t
-dso_cache__read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
+dso_cache__read(struct dso *dso, struct machine *machine,
+		u64 offset, u8 *data, ssize_t size)
 {
 	struct dso_cache *cache;
 	struct dso_cache *old;
-	ssize_t ret;
-
-	do {
-		u64 cache_offset;
+	ssize_t ret = -EINVAL;
+	u64 cache_offset;
 
-		ret = -ENOMEM;
+	cache = zalloc(sizeof(*cache) + DSO__DATA_CACHE_SIZE);
+	if (!cache)
+		return -ENOMEM;
 
-		cache = zalloc(sizeof(*cache) + DSO__DATA_CACHE_SIZE);
-		if (!cache)
-			break;
+	cache_offset = offset & DSO__DATA_CACHE_MASK;
 
-		cache_offset = offset & DSO__DATA_CACHE_MASK;
-		ret = -EINVAL;
+	pthread_mutex_lock(&dso__data_open_lock);
 
-		if (-1 == lseek(dso->data.fd, cache_offset, SEEK_SET))
-			break;
+	/*
+	 * dso->data.fd might be closed if other thread opened another
+	 * file (dso) due to open file limit (RLIMIT_NOFILE).
+	 */
+	if (dso->data.fd < 0) {
+		dso->data.fd = open_dso(dso, machine);
+		if (dso->data.fd < 0) {
+			ret = -errno;
+			dso->data.status = DSO_DATA_STATUS_ERROR;
+			goto err_unlock;
+		}
+	}
 
-		ret = read(dso->data.fd, cache->data, DSO__DATA_CACHE_SIZE);
-		if (ret <= 0)
-			break;
+	if (-1 == lseek(dso->data.fd, cache_offset, SEEK_SET))
+		goto err_unlock;
 
-		cache->offset = cache_offset;
-		cache->size   = ret;
-		old = dso_cache__insert(dso, cache);
-		if (old) {
-			/* we lose the race */
-			free(cache);
-			cache = old;
-		}
+	ret = read(dso->data.fd, cache->data, DSO__DATA_CACHE_SIZE);
+	if (ret <= 0)
+		goto err_unlock;
 
-		ret = dso_cache__memcpy(cache, offset, data, size);
+	pthread_mutex_unlock(&dso__data_open_lock);
 
-	} while (0);
+	cache->offset = cache_offset;
+	cache->size   = ret;
+	old = dso_cache__insert(dso, cache);
+	if (old) {
+		/* we lose the race */
+		free(cache);
+		cache = old;
+	}
 
+	ret = dso_cache__memcpy(cache, offset, data, size);
 	if (ret <= 0)
 		free(cache);
 
 	return ret;
+
+err_unlock:
+	pthread_mutex_unlock(&dso__data_open_lock);
+	return ret;
 }
 
-static ssize_t dso_cache_read(struct dso *dso, u64 offset,
-			      u8 *data, ssize_t size)
+static ssize_t dso_cache_read(struct dso *dso, struct machine *machine,
+			      u64 offset, u8 *data, ssize_t size)
 {
 	struct dso_cache *cache;
 
@@ -584,7 +604,7 @@ static ssize_t dso_cache_read(struct dso *dso, u64 offset,
 	if (cache)
 		return dso_cache__memcpy(cache, offset, data, size);
 	else
-		return dso_cache__read(dso, offset, data, size);
+		return dso_cache__read(dso, machine, offset, data, size);
 }
 
 /*
@@ -592,7 +612,8 @@ static ssize_t dso_cache_read(struct dso *dso, u64 offset,
  * in the rb_tree. Any read to already cached data is served
  * by cached data.
  */
-static ssize_t cached_read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
+static ssize_t cached_read(struct dso *dso, struct machine *machine,
+			   u64 offset, u8 *data, ssize_t size)
 {
 	ssize_t r = 0;
 	u8 *p = data;
@@ -600,7 +621,7 @@ static ssize_t cached_read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
 	do {
 		ssize_t ret;
 
-		ret = dso_cache_read(dso, offset, p, size);
+		ret = dso_cache_read(dso, machine, offset, p, size);
 		if (ret < 0)
 			return ret;
 
@@ -620,21 +641,42 @@ static ssize_t cached_read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
 	return r;
 }
 
-static int data_file_size(struct dso *dso)
+static int data_file_size(struct dso *dso, struct machine *machine)
 {
+	int ret = 0;
 	struct stat st;
 	char sbuf[STRERR_BUFSIZE];
 
-	if (!dso->data.file_size) {
-		if (fstat(dso->data.fd, &st)) {
-			pr_err("dso mmap failed, fstat: %s\n",
-				strerror_r(errno, sbuf, sizeof(sbuf)));
-			return -1;
+	if (dso->data.file_size)
+		return 0;
+
+	pthread_mutex_lock(&dso__data_open_lock);
+
+	/*
+	 * dso->data.fd might be closed if other thread opened another
+	 * file (dso) due to open file limit (RLIMIT_NOFILE).
+	 */
+	if (dso->data.fd < 0) {
+		dso->data.fd = open_dso(dso, machine);
+		if (dso->data.fd < 0) {
+			ret = -errno;
+			dso->data.status = DSO_DATA_STATUS_ERROR;
+			goto out;
 		}
-		dso->data.file_size = st.st_size;
 	}
 
-	return 0;
+	if (fstat(dso->data.fd, &st) < 0) {
+		ret = -errno;
+		pr_err("dso cache fstat failed: %s\n",
+		       strerror_r(errno, sbuf, sizeof(sbuf)));
+		dso->data.status = DSO_DATA_STATUS_ERROR;
+		goto out;
+	}
+	dso->data.file_size = st.st_size;
+
+out:
+	pthread_mutex_unlock(&dso__data_open_lock);
+	return ret;
 }
 
 /**
@@ -652,17 +694,17 @@ off_t dso__data_size(struct dso *dso, struct machine *machine)
 	if (fd < 0)
 		return fd;
 
-	if (data_file_size(dso))
+	if (data_file_size(dso, machine))
 		return -1;
 
 	/* For now just estimate dso data size is close to file size */
 	return dso->data.file_size;
 }
 
-static ssize_t data_read_offset(struct dso *dso, u64 offset,
-				u8 *data, ssize_t size)
+static ssize_t data_read_offset(struct dso *dso, struct machine *machine,
+				u64 offset, u8 *data, ssize_t size)
 {
-	if (data_file_size(dso))
+	if (data_file_size(dso, machine))
 		return -1;
 
 	/* Check the offset sanity. */
@@ -672,7 +714,7 @@ static ssize_t data_read_offset(struct dso *dso, u64 offset,
 	if (offset + size < offset)
 		return -1;
 
-	return cached_read(dso, offset, data, size);
+	return cached_read(dso, machine, offset, data, size);
 }
 
 /**
@@ -689,10 +731,10 @@ static ssize_t data_read_offset(struct dso *dso, u64 offset,
 ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 			      u64 offset, u8 *data, ssize_t size)
 {
-	if (dso__data_fd(dso, machine) < 0)
+	if (dso->data.status == DSO_DATA_STATUS_ERROR)
 		return -1;
 
-	return data_read_offset(dso, offset, data, size);
+	return data_read_offset(dso, machine, offset, data, size);
 }
 
 /**
-- 
2.2.2

