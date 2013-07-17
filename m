Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab3GQRuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:50:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab3GQRuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:50:35 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 04/23] perf tools: Introduce feat_offset into perf_header
Date: Wed, 17 Jul 2013 19:49:44 +0200
Message-Id: <1374083403-14591-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing feat_offset into perf_header to make the
location of the features section clear.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
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
1.7.11.7

