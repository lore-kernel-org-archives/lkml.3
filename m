Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbaDNOyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:54:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46653 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbaDNOyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:54:33 -0400
Date: Mon, 14 Apr 2014 07:54:17 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-90f6bb6c98ffef42125d7be6d4612505f561fbce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1395768699-16060-1-git-send-email-andi@firstfloor.org>
References: <1395768699-16060-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf stat: Initialize statistics correctly
Git-Commit-ID: 90f6bb6c98ffef42125d7be6d4612505f561fbce
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

Commit-ID:  90f6bb6c98ffef42125d7be6d4612505f561fbce
Gitweb:     http://git.kernel.org/tip/90f6bb6c98ffef42125d7be6d4612505f561fbce
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 25 Mar 2014 10:31:38 -0700
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Mon, 14 Apr 2014 12:56:06 +0200

perf stat: Initialize statistics correctly

perf stat did initialize the stats structure used to compute
stddev etc. incorrectly. It merely zeroes it. But one member
(min) needs to be set to a non zero value. This causes min
to be not computed at all. Call init_stats() correctly.

It doesn't matter for stat currently because it doesn't use
min, but it's still better to do it correctly.

The other users of statistics are already correct.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1395768699-16060-1-git-send-email-andi@firstfloor.org
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-stat.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8b0e1c9..65a151e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -174,13 +174,20 @@ static inline int perf_evsel__nr_cpus(struct perf_evsel *evsel)
 
 static void perf_evsel__reset_stat_priv(struct perf_evsel *evsel)
 {
-	memset(evsel->priv, 0, sizeof(struct perf_stat));
+	int i;
+	struct perf_stat *ps = evsel->priv;
+
+	for (i = 0; i < 3; i++)
+		init_stats(&ps->res_stats[i]);
 }
 
 static int perf_evsel__alloc_stat_priv(struct perf_evsel *evsel)
 {
 	evsel->priv = zalloc(sizeof(struct perf_stat));
-	return evsel->priv == NULL ? -ENOMEM : 0;
+	if (evsel == NULL)
+		return -ENOMEM;
+	perf_evsel__reset_stat_priv(evsel);
+	return 0;
 }
 
 static void perf_evsel__free_stat_priv(struct perf_evsel *evsel)
