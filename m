Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030320Ab3GSHy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:54:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35973 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3GSHy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:54:56 -0400
Date: Fri, 19 Jul 2013 00:54:31 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-944d62ba4c8e1c9bb2962a70e3d495106fae8cd9@git.kernel.org>
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
In-Reply-To: <1374083403-14591-4-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header: Remove attr_offset from perf_header
Git-Commit-ID: 944d62ba4c8e1c9bb2962a70e3d495106fae8cd9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:54:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  944d62ba4c8e1c9bb2962a70e3d495106fae8cd9
Gitweb:     http://git.kernel.org/tip/944d62ba4c8e1c9bb2962a70e3d495106fae8cd9
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 17 Jul 2013 19:49:43 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Jul 2013 16:46:25 -0300

perf header: Remove attr_offset from perf_header

Removing attr_offset from perf_header as it's possible to use it as a
local variable.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1374083403-14591-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 5 +++--
 tools/perf/util/header.h | 1 -
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 035efe7..dcba56a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2272,6 +2272,7 @@ int perf_session__write_header(struct perf_session *session,
 	struct perf_file_attr   f_attr;
 	struct perf_header *header = &session->header;
 	struct perf_evsel *evsel;
+	u64 attr_offset;
 	int err;
 
 	lseek(fd, sizeof(f_header), SEEK_SET);
@@ -2285,7 +2286,7 @@ int perf_session__write_header(struct perf_session *session,
 		}
 	}
 
-	header->attr_offset = lseek(fd, 0, SEEK_CUR);
+	attr_offset = lseek(fd, 0, SEEK_CUR);
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		f_attr = (struct perf_file_attr){
@@ -2315,7 +2316,7 @@ int perf_session__write_header(struct perf_session *session,
 		.size	   = sizeof(f_header),
 		.attr_size = sizeof(f_attr),
 		.attrs = {
-			.offset = header->attr_offset,
+			.offset = attr_offset,
 			.size   = evlist->nr_entries * sizeof(f_attr),
 		},
 		.data = {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 0bacb2d..6fa80f9 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -86,7 +86,6 @@ struct perf_session_env {
 
 struct perf_header {
 	bool			needs_swap;
-	s64			attr_offset;
 	u64			data_offset;
 	u64			data_size;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
