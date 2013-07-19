Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030343Ab3GSHzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:55:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36000 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030254Ab3GSHzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:55:15 -0400
Date: Fri, 19 Jul 2013 00:54:50 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-2a08c3ec4f7d6058a450d2d4bc6e366955872707@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1374083403-14591-8-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-8-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header:
  Recognize version number for perf data file
Git-Commit-ID: 2a08c3ec4f7d6058a450d2d4bc6e366955872707
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:54:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a08c3ec4f7d6058a450d2d4bc6e366955872707
Gitweb:     http://git.kernel.org/tip/2a08c3ec4f7d6058a450d2d4bc6e366955872707
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 17 Jul 2013 19:49:47 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Jul 2013 17:04:00 -0300

perf header: Recognize version number for perf data file

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
