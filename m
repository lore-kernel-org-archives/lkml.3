Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806AbaFCSdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:33:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44818 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717AbaFCSdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:33:19 -0400
Date: Tue, 3 Jun 2014 11:33:03 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-be7f855a3eebe07f797b9e4a43bf59bab8ca3dbe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1401335910-16832-10-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-10-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Save callchain info for each cumulative entry
Git-Commit-ID: be7f855a3eebe07f797b9e4a43bf59bab8ca3dbe
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

Commit-ID:  be7f855a3eebe07f797b9e4a43bf59bab8ca3dbe
Gitweb:     http://git.kernel.org/tip/be7f855a3eebe07f797b9e4a43bf59bab8ca3dbe
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 26 Dec 2013 17:44:10 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:35:00 +0200

perf tools: Save callchain info for each cumulative entry

When accumulating callchain entry, also save current snapshot of the
chain so that it can show the rest of the chain.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-10-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/hist.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index bf03db5..c6f5f52 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -738,6 +738,14 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	iter->he = he;
 	he_cache[iter->curr++] = he;
 
+	callchain_append(he->callchain, &callchain_cursor, sample->period);
+
+	/*
+	 * We need to re-initialize the cursor since callchain_append()
+	 * advanced the cursor to the end.
+	 */
+	callchain_cursor_commit(&callchain_cursor);
+
 	/*
 	 * The iter->he will be over-written after ->add_next_entry()
 	 * called so inc stats for the original entry now.
@@ -760,8 +768,6 @@ iter_next_cumulative_entry(struct hist_entry_iter *iter,
 	if (node == NULL)
 		return 0;
 
-	callchain_cursor_advance(&callchain_cursor);
-
 	return fill_callchain_info(al, node, iter->hide_unresolved);
 }
 
@@ -785,6 +791,11 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 		.parent = iter->parent,
 	};
 	int i;
+	struct callchain_cursor cursor;
+
+	callchain_cursor_snapshot(&cursor, &callchain_cursor);
+
+	callchain_cursor_advance(&callchain_cursor);
 
 	/*
 	 * Check if there's duplicate entries in the callchain.
@@ -804,6 +815,7 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 	iter->he = he;
 	he_cache[iter->curr++] = he;
 
+	callchain_append(he->callchain, &cursor, sample->period);
 	return 0;
 }
 
