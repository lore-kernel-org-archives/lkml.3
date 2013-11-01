Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab3KAHd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:33:27 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62010 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab3KAHdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:33:20 -0400
X-AuditID: 9c930179-b7c9bae000000e4c-32-5273593d2cb2
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 4/5] perf top: Use parse_options_usage() for -s option failure
Date: Fri,  1 Nov 2013 16:33:14 +0900
Message-Id: <1383291195-24386-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383291195-24386-1-git-send-email-namhyung@kernel.org>
References: <1383291195-24386-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The -s (--sort) option was processed after normal option parsing so
that it cannot call the parse_options_usage() automatically.
Currently it calls usage_with_options() which shows entire help
messages for event option.  Fix it by showing just -s options.

  $ perf top -s help
    Error: Unknown --sort key: `help'

   usage: perf top [<options>]

      -s, --sort <key[,key2...]>
                            sort by key(s): pid, comm, dso, symbol, ...

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-top.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 04f5bf2d8e10..a6d166539c23 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1040,7 +1040,7 @@ parse_percent_limit(const struct option *opt, const char *arg,
 
 int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	int status;
+	int status = -1;
 	char errbuf[BUFSIZ];
 	struct perf_top top = {
 		.count_filter	     = 5,
@@ -1156,8 +1156,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (sort_order == default_sort_order)
 		sort_order = "dso,symbol";
 
-	if (setup_sorting() < 0)
-		usage_with_options(top_usage, options);
+	if (setup_sorting() < 0) {
+		parse_options_usage(top_usage, options, "s", 1);
+		goto out_delete_evlist;
+	}
 
 	/* display thread wants entries to be collapsed in a different tree */
 	sort__need_collapse = 1;
-- 
1.7.11.7

