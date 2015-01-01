Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbbAAV32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 16:29:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbbAAV3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 16:29:24 -0500
Date: Thu, 1 Jan 2015 13:29:08 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-82aa019e0098a1e0801df94345c0297448323126@git.kernel.org>
Cc: dsahern@gmail.com, jolsa@redhat.com, a.p.zijlstra@chello.nl, hpa@zytor.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        acme@redhat.com, linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        tglx@linutronix.de
Reply-To: dsahern@gmail.com, mingo@kernel.org, namhyung@kernel.org,
        jolsa@redhat.com, a.p.zijlstra@chello.nl, eranian@google.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        acme@redhat.com, tglx@linutronix.de
In-Reply-To: <1419223455-4362-7-git-send-email-namhyung@kernel.org>
References: <1419223455-4362-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf callchain:
  Append callchains only when requested
Git-Commit-ID: 82aa019e0098a1e0801df94345c0297448323126
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

Commit-ID:  82aa019e0098a1e0801df94345c0297448323126
Gitweb:     http://git.kernel.org/tip/82aa019e0098a1e0801df94345c0297448323126
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 22 Dec 2014 13:44:14 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 23 Dec 2014 12:06:39 -0300

perf callchain: Append callchains only when requested

The perf report --children can be called with callchain disabled so no
need to append callchains.  Actually the root of callchain tree is not
initialized properly in this case.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1419223455-4362-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 1cc6ea4..0ced178 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -304,7 +304,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template,
 	size_t callchain_size = 0;
 	struct hist_entry *he;
 
-	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain)
+	if (symbol_conf.use_callchain)
 		callchain_size = sizeof(struct callchain_root);
 
 	he = zalloc(sizeof(*he) + callchain_size);
@@ -737,7 +737,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	iter->he = he;
 	he_cache[iter->curr++] = he;
 
-	callchain_append(he->callchain, &callchain_cursor, sample->period);
+	hist_entry__append_callchain(he, sample);
 
 	/*
 	 * We need to re-initialize the cursor since callchain_append()
@@ -810,7 +810,8 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 	iter->he = he;
 	he_cache[iter->curr++] = he;
 
-	callchain_append(he->callchain, &cursor, sample->period);
+	if (symbol_conf.use_callchain)
+		callchain_append(he->callchain, &cursor, sample->period);
 	return 0;
 }
 
