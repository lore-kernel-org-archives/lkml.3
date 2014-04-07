Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbaDGPGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:06:06 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55211 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbaDGPFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:05:32 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>
Cc: Robert Richter <robert.richter@linaro.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 16/16] perf tools: Retry mapping buffers readonly on EACCES
Date: Mon,  7 Apr 2014 17:04:38 +0200
Message-Id: <1396883078-25320-17-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
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
Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/builtin-record.c | 11 ++++++++---
 tools/perf/builtin-top.c    |  8 ++++++--
 tools/perf/perf.h           |  1 +
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index eb524f9..ede3af1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -133,8 +133,8 @@ static int record__mmap_read(struct record *rec, struct perf_mmap *md)
 	}
 
 	md->prev = old;
-	perf_mmap__write_tail(md, old);
-
+	if (!rec->opts.mmap_ro)
+		perf_mmap__write_tail(md, old);
 out:
 	return rc;
 }
@@ -207,7 +207,12 @@ try_again:
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
index 65aaa5b..479356f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -868,8 +868,12 @@ try_again:
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
index 1138c41..a8ffaba4 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -282,6 +282,7 @@ struct record_opts {
 	bool	     sample_weight;
 	bool	     sample_time;
 	bool	     period;
+	bool	     mmap_ro;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
-- 
1.7.11.7

