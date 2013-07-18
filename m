Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064Ab3GRTvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:51:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41755 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759524Ab3GRTuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 75/76] perf header: Introduce feat_offset into perf_header
Date: Thu, 18 Jul 2013 16:50:02 -0300
Message-Id: <1374177003-3706-76-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Introducing feat_offset into perf_header to make the location of the
features section clear.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1374083403-14591-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 6 ++++--
 tools/perf/util/header.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index dcba56a..eefb052 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2225,7 +2225,7 @@ static int perf_header__adds_write(struct perf_header *header,
 
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
-	sec_start = header->data_offset + header->data_size;
+	sec_start = header->feat_offset;
 	lseek(fd, sec_start + sec_size, SEEK_SET);
 
 	for_each_set_bit(feat, header->adds_features, HEADER_FEAT_BITS) {
@@ -2304,6 +2304,7 @@ int perf_session__write_header(struct perf_session *session,
 	}
 
 	header->data_offset = lseek(fd, 0, SEEK_CUR);
+	header->feat_offset = header->data_offset + header->data_size;
 
 	if (at_exit) {
 		err = perf_header__adds_write(header, evlist, fd);
@@ -2373,7 +2374,7 @@ int perf_header__process_sections(struct perf_header *header, int fd,
 
 	sec_size = sizeof(*feat_sec) * nr_sections;
 
-	lseek(fd, header->data_offset + header->data_size, SEEK_SET);
+	lseek(fd, header->feat_offset, SEEK_SET);
 
 	err = perf_header__getbuffer64(header, fd, feat_sec, sec_size);
 	if (err < 0)
@@ -2572,6 +2573,7 @@ int perf_file_header__read(struct perf_file_header *header,
 
 	ph->data_offset  = header->data.offset;
 	ph->data_size	 = header->data.size;
+	ph->feat_offset  = header->data.offset + header->data.size;
 	return 0;
 }
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 6fa80f9..e6387dc 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -88,6 +88,7 @@ struct perf_header {
 	bool			needs_swap;
 	u64			data_offset;
 	u64			data_size;
+	u64			feat_offset;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 	struct perf_session_env env;
 };
-- 
1.8.1.4

