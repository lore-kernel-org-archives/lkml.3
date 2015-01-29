Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbbA2IKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:10:05 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51076 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbbA2IKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:02 -0500
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
Subject: [PATCH 09/42] perf tools: Introduce copyfile_offset() function
Date: Thu, 29 Jan 2015 17:06:50 +0900
Message-Id: <1422518843-25818-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The copyfile_offset() function is to copy source data from given
offset to a destination file with an offset.  It'll be used to build
an indexed data file.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/util.c | 38 +++++++++++++++++++++++++++++---------
 tools/perf/util/util.h |  1 +
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index de1307a6ff4b..cc1aa309d643 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -145,11 +145,38 @@ static int slow_copyfile(const char *from, const char *to, mode_t mode)
 	return err;
 }
 
+int copyfile_offset(int ifd, loff_t off_in, int ofd, loff_t off_out, u64 size)
+{
+	void *ptr;
+	loff_t pgoff;
+
+	pgoff = off_in & ~(page_size - 1);
+	off_in -= pgoff;
+
+	ptr = mmap(NULL, off_in + size, PROT_READ, MAP_PRIVATE, ifd, pgoff);
+	if (ptr == MAP_FAILED)
+		return -1;
+
+	while (size) {
+		ssize_t ret = pwrite(ofd, ptr + off_in, size, off_out);
+		if (ret < 0 && errno == EINTR)
+			continue;
+		if (ret <= 0)
+			break;
+
+		size -= ret;
+		off_in += ret;
+		off_out -= ret;
+	}
+	munmap(ptr, off_in + size);
+
+	return size ? -1 : 0;
+}
+
 int copyfile_mode(const char *from, const char *to, mode_t mode)
 {
 	int fromfd, tofd;
 	struct stat st;
-	void *addr;
 	int err = -1;
 
 	if (stat(from, &st))
@@ -166,15 +193,8 @@ int copyfile_mode(const char *from, const char *to, mode_t mode)
 	if (tofd < 0)
 		goto out_close_from;
 
-	addr = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fromfd, 0);
-	if (addr == MAP_FAILED)
-		goto out_close_to;
-
-	if (write(tofd, addr, st.st_size) == st.st_size)
-		err = 0;
+	err = copyfile_offset(fromfd, 0, tofd, 0, st.st_size);
 
-	munmap(addr, st.st_size);
-out_close_to:
 	close(tofd);
 	if (err)
 		unlink(to);
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7b71ad87cdc3..2291f08f11fe 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -251,6 +251,7 @@ int mkdir_p(char *path, mode_t mode);
 int rm_rf(char *path);
 int copyfile(const char *from, const char *to);
 int copyfile_mode(const char *from, const char *to, mode_t mode);
+int copyfile_offset(int fromfd, loff_t from_ofs, int tofd, loff_t to_ofs, u64 size);
 
 s64 perf_atoll(const char *str);
 char **argv_split(const char *str, int *argcp);
-- 
2.2.2

