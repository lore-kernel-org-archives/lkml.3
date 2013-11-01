Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3KAHeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:34:18 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62010 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab3KAHdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:33:19 -0400
X-AuditID: 9c930179-b7c9bae000000e4c-2d-5273593d49b2
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/5] perf report: Use parse_options_usage() for -s option failure
Date: Fri,  1 Nov 2013 16:33:13 +0900
Message-Id: <1383291195-24386-4-git-send-email-namhyung@kernel.org>
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

  $ perf report -s help
    Error: Unknown --sort key: `help'

   usage: perf report [<options>]

      -s, --sort <key[,key2...]>
                            sort by key(s): pid, comm, dso, symbol, ...

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4df3161c7df2..25f83d5d66fd 100644
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
-- 
1.7.11.7

