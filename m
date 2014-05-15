Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaEORYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbaEORYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:24:10 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/14] perf tools: Add dso__data_* interface descriptons
Date: Thu, 15 May 2014 19:23:30 +0200
Message-Id: <1400174615-2121-10-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding descriptions/explanations for dso__data_*
interface functions.

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
 tools/perf/util/dso.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/dso.h | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 7404f67..80b54e7 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -268,6 +268,11 @@ static bool may_cache_fd(void)
 	return limit > (rlim_t) dso__data_open_cnt;
 }
 
+/*
+ * Check and close LRU dso if we crossed allowed limit
+ * for opened dso file descriptors. The limit is half
+ * of the RLIMIT_NOFILE files opened.
+*/
 static void data_close(void)
 {
 	bool cache_fd = may_cache_fd();
@@ -276,12 +281,27 @@ static void data_close(void)
 		close_first_dso();
 }
 
+/**
+ * dso__data_close - close data file
+ * @dso: dso object
+ *
+ * Calls data_close (in case current dso is open) which takes care
+ * about caching dso objects file descriptors.
+ */
 void dso__data_close(struct dso *dso)
 {
 	if (dso->data.fd >= 0)
 		data_close();
 }
 
+/**
+ * dso__data_fd - Get dso's data file descriptor
+ * @dso: dso object
+ * @machine: machine object
+ *
+ * Find dso's file, open it and returns file descriptor,
+ * which needs to be closed later by dso__data_close.
+ */
 int dso__data_fd(struct dso *dso, struct machine *machine)
 {
 	enum dso_binary_type binary_type_data[] = {
@@ -438,6 +458,11 @@ static ssize_t dso_cache_read(struct dso *dso, u64 offset,
 		return dso_cache__read(dso, offset, data, size);
 }
 
+/*
+ * Reads and caches dso data DSO__DATA_CACHE_SIZE size chunks
+ * in the rb_tree. Any read to already cached data is served
+ * by cached data.
+ */
 static ssize_t cached_read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
 {
 	ssize_t r = 0;
@@ -497,6 +522,17 @@ static ssize_t data_read_offset(struct dso *dso, u64 offset,
 	return cached_read(dso, offset, data, size);
 }
 
+/**
+ * dso__data_read_offset - Read data from dso file offset
+ * @dso: dso object
+ * @machine: machine object
+ * @offset: file offset
+ * @data: buffer to store data
+ * @size: size of the @data buffer
+ *
+ * Read data from dso file offset. Opens dso data file
+ * and use cached_read to get the data.
+ */
 ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 			      u64 offset, u8 *data, ssize_t size)
 {
@@ -515,6 +551,16 @@ ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 	return ret;
 }
 
+/**
+ * dso__data_read_addr - Read data from dso address
+ * @dso: dso object
+ * @machine: machine object
+ * @offset: file offset
+ * @data: buffer to store data
+ * @size: size of the @data buffer
+ *
+ * Read data from dso address.
+ */
 ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
 			    struct machine *machine, u64 addr,
 			    u8 *data, ssize_t size)
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index da47b13..d713184 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -149,6 +149,47 @@ char dso__symtab_origin(const struct dso *dso);
 int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type type,
 				   char *root_dir, char *filename, size_t size);
 
+/*
+ * The dso__data_* interface provides following functions:
+ *   dso__data_fd
+ *   dso__data_close
+ *   dso__data_read_offset
+ *   dso__data_read_addr
+ *
+ * Please refer to the dso.c object code for each function
+ * and arguments documentation. Following text tries to
+ * explain the dso file descriptor caching.
+ *
+ * The dso__data* interface allows caching of opened file
+ * descriptors to speed up the dso data accesses. The idea
+ * is to leave the file descriptor opened/mmaped ideally
+ * for the whole life of the dso object.
+ *
+ * The current usage of the dso__data_* interface is as follows:
+ *
+ *   int fd = dso__data_fd(dso, machine);
+ *   USE 'fd' SOMEHOW
+ *   dso__data_close(dso);
+ *
+ * When the dso data file is opened/closed it's added/removed
+ * to/from the global list dso__data_open. The caching itself
+ * is done by dso__data_close(dso) and works as explained
+ * in pseudo code below:
+ *
+ * if dso is open:
+ *   if (number of opened dsos) > RLIMIT_NOFILE/2:
+ *      close/unmap first dso on dso__data_open list
+ *
+ * Both *read* functions opens dso data file and call
+ * dso__data_close(dso) before return:
+ *
+ *   n = dso__data_read_offset(dso_0, &machine, 0, buf, BUFSIZE);
+ *   n = dso__data_read_addr(dso_0, &machine, 0, buf, BUFSIZE);
+ *
+ * The dso__delete function calls close_dso function to ensure the
+ * data file descriptor gets closed/unmapped before the dso object
+ * is freed.
+*/
 int dso__data_fd(struct dso *dso, struct machine *machine);
 void dso__data_close(struct dso *dso);
 
-- 
1.8.3.1

