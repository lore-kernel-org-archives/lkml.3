Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab3KDUWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:22:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50080 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab3KDUWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:22:21 -0500
Date: Mon, 4 Nov 2013 12:22:05 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-d37a92dcb45094dc02836c8a77c693c6f9916fb2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1383291195-24386-5-git-send-email-namhyung@kernel.org>
References: <1383291195-24386-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Use parse_options_usage()
  for -s option failure
Git-Commit-ID: d37a92dcb45094dc02836c8a77c693c6f9916fb2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:22:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d37a92dcb45094dc02836c8a77c693c6f9916fb2
Gitweb:     http://git.kernel.org/tip/d37a92dcb45094dc02836c8a77c693c6f9916fb2
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 1 Nov 2013 16:33:14 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 12:56:41 -0300

perf top: Use parse_options_usage() for -s option failure

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
index 21db76d..ca5ca37 100644
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
