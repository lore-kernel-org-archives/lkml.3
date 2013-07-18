Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540Ab3GRTw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:52:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41728 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759504Ab3GRTuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:32 -0400
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
Subject: [PATCH 76/76] perf header: Recognize version number for perf data file
Date: Thu, 18 Jul 2013 16:50:03 -0300
Message-Id: <1374177003-3706-77-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Keep the recognized data file version within 'struct perf_header'.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1374083403-14591-8-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |  2 ++
 tools/perf/util/header.h | 16 +++++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index eefb052..f558f83 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2480,6 +2480,7 @@ static int check_magic_endian(u64 magic, uint64_t hdr_sz,
 	/* check for legacy format */
 	ret = memcmp(&magic, __perf_magic1, sizeof(magic));
 	if (ret == 0) {
+		ph->version = PERF_HEADER_VERSION_1;
 		pr_debug("legacy perf.data format\n");
 		if (is_pipe)
 			return try_all_pipe_abis(hdr_sz, ph);
@@ -2501,6 +2502,7 @@ static int check_magic_endian(u64 magic, uint64_t hdr_sz,
 		return -1;
 
 	ph->needs_swap = true;
+	ph->version = PERF_HEADER_VERSION_2;
 
 	return 0;
 }
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index e6387dc..307c9ae 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -34,6 +34,11 @@ enum {
 	HEADER_FEAT_BITS	= 256,
 };
 
+enum perf_header_version {
+	PERF_HEADER_VERSION_1,
+	PERF_HEADER_VERSION_2,
+};
+
 struct perf_file_section {
 	u64 offset;
 	u64 size;
@@ -85,12 +90,13 @@ struct perf_session_env {
 };
 
 struct perf_header {
-	bool			needs_swap;
-	u64			data_offset;
-	u64			data_size;
-	u64			feat_offset;
+	enum perf_header_version	version;
+	bool				needs_swap;
+	u64				data_offset;
+	u64				data_size;
+	u64				feat_offset;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
-	struct perf_session_env env;
+	struct perf_session_env 	env;
 };
 
 struct perf_evlist;
-- 
1.8.1.4

