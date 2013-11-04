Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3KDUWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:22:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50069 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab3KDUWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:22:12 -0500
Date: Mon, 4 Nov 2013 12:21:56 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-91aba0a62e24ff7a567e13e1d88deab711df6f0f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1383291195-24386-4-git-send-email-namhyung@kernel.org>
References: <1383291195-24386-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Use parse_options_usage()
  for -s option failure
Git-Commit-ID: 91aba0a62e24ff7a567e13e1d88deab711df6f0f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:22:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91aba0a62e24ff7a567e13e1d88deab711df6f0f
Gitweb:     http://git.kernel.org/tip/91aba0a62e24ff7a567e13e1d88deab711df6f0f
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 1 Nov 2013 16:33:13 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 12:55:17 -0300

perf report: Use parse_options_usage() for -s option failure

The -s (--sort) option was processed after normal option parsing so that
it cannot call the parse_options_usage() automatically.  Currently it
calls usage_with_options() which shows entire help messages for event
option.  Fix it by showing just -s options.

  $ perf report -s help
    Error: Unknown --sort key: `help'

   usage: perf report [<options>]

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
Link: http://lkml.kernel.org/r/1383291195-24386-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4df3161..25f83d5 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -947,8 +947,10 @@ repeat:
 			sort_order = "local_weight,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked";
 	}
 
-	if (setup_sorting() < 0)
-		usage_with_options(report_usage, options);
+	if (setup_sorting() < 0) {
+		parse_options_usage(report_usage, options, "s", 1);
+		goto error;
+	}
 
 	if (parent_pattern != default_parent_pattern) {
 		if (sort_dimension__add("parent") < 0)
