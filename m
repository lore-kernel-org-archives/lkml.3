Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaFMG03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:26:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44169 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaFMG00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:26:26 -0400
Date: Thu, 12 Jun 2014 23:26:08 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-c3fbd2a606c5f88de0079b027727a1fb0ae27b65@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1401892622-30848-8-git-send-email-jolsa@kernel.org>
References: <1401892622-30848-8-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add file size check and factor dso__data_read_offset
Git-Commit-ID: c3fbd2a606c5f88de0079b027727a1fb0ae27b65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3fbd2a606c5f88de0079b027727a1fb0ae27b65
Gitweb:     http://git.kernel.org/tip/c3fbd2a606c5f88de0079b027727a1fb0ae27b65
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 7 May 2014 18:51:41 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 12 Jun 2014 16:53:21 +0200

perf tools: Add file size check and factor dso__data_read_offset

Adding file size check, because the lseek will succeed for
any offset behind file size and thus succeed when it was
expected to fail.

Factoring the code to check the offset against file size
earlier in the flow.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1401892622-30848-8-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/dso.c | 64 +++++++++++++++++++++++++++++++++++++++------------
 tools/perf/util/dso.h |  1 +
 2 files changed, 50 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index fbf6cc9..db63438 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -205,6 +205,7 @@ static void close_data_fd(struct dso *dso)
 	if (dso->data.fd >= 0) {
 		close(dso->data.fd);
 		dso->data.fd = -1;
+		dso->data.file_size = 0;
 		dso__list_del(dso);
 	}
 }
@@ -373,16 +374,10 @@ dso_cache__memcpy(struct dso_cache *cache, u64 offset,
 }
 
 static ssize_t
-dso_cache__read(struct dso *dso, struct machine *machine,
-		 u64 offset, u8 *data, ssize_t size)
+dso_cache__read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
 {
 	struct dso_cache *cache;
 	ssize_t ret;
-	int fd;
-
-	fd = dso__data_fd(dso, machine);
-	if (fd < 0)
-		return -1;
 
 	do {
 		u64 cache_offset;
@@ -396,10 +391,10 @@ dso_cache__read(struct dso *dso, struct machine *machine,
 		cache_offset = offset & DSO__DATA_CACHE_MASK;
 		ret = -EINVAL;
 
-		if (-1 == lseek(fd, cache_offset, SEEK_SET))
+		if (-1 == lseek(dso->data.fd, cache_offset, SEEK_SET))
 			break;
 
-		ret = read(fd, cache->data, DSO__DATA_CACHE_SIZE);
+		ret = read(dso->data.fd, cache->data, DSO__DATA_CACHE_SIZE);
 		if (ret <= 0)
 			break;
 
@@ -417,8 +412,8 @@ dso_cache__read(struct dso *dso, struct machine *machine,
 	return ret;
 }
 
-static ssize_t dso_cache_read(struct dso *dso, struct machine *machine,
-			      u64 offset, u8 *data, ssize_t size)
+static ssize_t dso_cache_read(struct dso *dso, u64 offset,
+			      u8 *data, ssize_t size)
 {
 	struct dso_cache *cache;
 
@@ -426,11 +421,10 @@ static ssize_t dso_cache_read(struct dso *dso, struct machine *machine,
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
@@ -438,7 +432,7 @@ ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 	do {
 		ssize_t ret;
 
-		ret = dso_cache_read(dso, machine, offset, p, size);
+		ret = dso_cache_read(dso, offset, p, size);
 		if (ret < 0)
 			return ret;
 
@@ -458,6 +452,46 @@ ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
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
+	if (dso__data_fd(dso, machine) < 0)
+		return -1;
+
+	return data_read_offset(dso, offset, data, size);
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
 
