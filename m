Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3EaJRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:17:25 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63319 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab3EaJQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:16:48 -0400
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 4/4] perf tools: Retry mapping buffers readonly on EACCES
Date: Fri, 31 May 2013 11:16:25 +0200
Message-Id: <1369991785-10499-5-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369991785-10499-1-git-send-email-rric@kernel.org>
References: <1369991785-10499-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

Persistent event buffers may only be mmapped readonly. Thus, retry
mapping it readonly if mmap returns EACCES after trying to mmap
writable.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 tools/perf/builtin-record.c | 7 ++++++-
 tools/perf/builtin-top.c    | 8 ++++++--
 tools/perf/perf.h           | 1 +
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index cdf58ec..916776d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -255,7 +255,12 @@ try_again:
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
index 67bdb9f..2a5757d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -899,8 +899,12 @@ try_again:
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
index 32bd102..41acea3 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -221,6 +221,7 @@ struct perf_record_opts {
 	bool	     sample_weight;
 	bool	     sample_time;
 	bool	     period;
+	bool	     mmap_ro;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
-- 
1.8.1.1

