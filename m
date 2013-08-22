Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab3HVOoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:44:54 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:52492 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3HVOoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:44:37 -0400
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH resent 4/4] perf tools: Retry mapping buffers readonly on EACCES
Date: Thu, 22 Aug 2013 16:44:05 +0200
Message-Id: <1377182645-12922-5-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377182645-12922-1-git-send-email-rric@kernel.org>
References: <1377182645-12922-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Persistent event buffers may only be mmapped readonly. Thus, retry
mapping it readonly if mmap returns EACCES after trying to mmap
writable.

[ namhyung: Don't write to readonly mmap'ed buffers. ]
Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 tools/perf/builtin-record.c | 11 ++++++++---
 tools/perf/builtin-top.c    |  8 ++++++--
 tools/perf/perf.h           |  1 +
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a41ac415..f3f7483 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -152,8 +152,8 @@ static int perf_record__mmap_read(struct perf_record *rec,
 	}
 
 	md->prev = old;
-	perf_mmap__write_tail(md, old);
-
+	if (!rec->opts.mmap_ro)
+		perf_mmap__write_tail(md, old);
 out:
 	return rc;
 }
@@ -226,7 +226,12 @@ static int perf_record__open(struct perf_record *rec)
 		goto out;
 	}
 
-	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
+try_again2:
+	if (perf_evlist__mmap(evlist, opts->mmap_pages, opts->mmap_ro) < 0) {
+		if (!opts->mmap_ro && errno == EACCES) {
+			opts->mmap_ro = true;
+			goto try_again2;
+		}
 		if (errno == EPERM) {
 			pr_err("Permission error mapping pages.\n"
 			       "Consider increasing "
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e37521f..bef7b1d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -894,8 +894,12 @@ static int perf_top__start_counters(struct perf_top *top)
 			goto out_err;
 		}
 	}
-
-	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
+try_again2:
+	if (perf_evlist__mmap(evlist, opts->mmap_pages, opts->mmap_ro) < 0) {
+		if (!opts->mmap_ro && errno == EACCES) {
+			opts->mmap_ro = true;
+			goto try_again2;
+		}
 		ui__error("Failed to mmap with %d (%s)\n",
 			    errno, strerror(errno));
 		goto out_err;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index cf20187..dca43c72 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -224,6 +224,7 @@ struct perf_record_opts {
 	bool	     sample_weight;
 	bool	     sample_time;
 	bool	     period;
+	bool	     mmap_ro;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
-- 
1.8.3.2

