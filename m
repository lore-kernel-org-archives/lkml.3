Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab3KDSCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:02:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37938 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab3KDR72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:59:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/29] perf top: Use parse_options_usage() for -s option failure
Date: Mon,  4 Nov 2013 14:58:58 -0300
Message-Id: <1383587947-17419-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383587947-17419-1-git-send-email-acme@infradead.org>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The -s (--sort) option was processed after normal option parsing so that
it cannot call the parse_options_usage() automatically.  Currently it
calls usage_with_options() which shows entire help messages for event
option.  Fix it by showing just -s options.

  $ perf top -s help
    Error: Unknown --sort key: `help'

   usage: perf top [<options>]

      -s, --sort <key[,key2...]>
                            sort by key(s): pid, comm, dso, symbol, ...

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Enthusiastically-Supported-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383291195-24386-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 21db76d71ddf..ca5ca37980fb 100644
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
@@ -1159,8 +1159,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
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
1.8.1.4

