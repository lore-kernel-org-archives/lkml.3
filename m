Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab3KLVz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:55:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40083 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab3KLVzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:55:37 -0500
Date: Tue, 12 Nov 2013 13:55:21 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-7524f63b997cc02a80aa073558728ae3ee242cf8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
In-Reply-To: <1383900822-14609-1-git-send-email-namhyung@kernel.org>
References: <1383900822-14609-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Prevent condition that all sort keys are elided
Git-Commit-ID: 7524f63b997cc02a80aa073558728ae3ee242cf8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:55:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7524f63b997cc02a80aa073558728ae3ee242cf8
Gitweb:     http://git.kernel.org/tip/7524f63b997cc02a80aa073558728ae3ee242cf8
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 8 Nov 2013 17:53:42 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 11 Nov 2013 15:56:40 -0300

perf tools: Prevent condition that all sort keys are elided

If given sort keys are all elided there'll be no output except for the
overhead column - actually the TUI shows a noisy output.  In this case
it'd be better to show up the sort keys rather than elide.

Before:

  $ perf report -s comm -c perf
  (...)
  # Overhead
  # ........
  #
     100.00%

After:

  $ perf report -s comm -c perf
  (...)
  # Overhead  Command
  # ........  .......
  #
     100.00%     perf

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383900822-14609-1-git-send-email-namhyung@kernel.org
[ Us curly braces around multi-line statements, as requested by Ingo Molnar ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 3c1b75c..8b0bb1f 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1137,6 +1137,8 @@ static void sort_entry__setup_elide(struct sort_entry *se,
 
 void sort__setup_elide(FILE *output)
 {
+	struct sort_entry *se;
+
 	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
 				"dso", output);
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list,
@@ -1172,4 +1174,15 @@ void sort__setup_elide(FILE *output)
 					"snoop", output);
 	}
 
+	/*
+	 * It makes no sense to elide all of sort entries.
+	 * Just revert them to show up again.
+	 */
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (!se->elide)
+			return;
+	}
+
+	list_for_each_entry(se, &hist_entry__sort_list, list)
+		se->elide = false;
 }
