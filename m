Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaCXTek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:34:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbaCXTdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 4/4] perf, report: Use new generic report parse callchain callback
Date: Mon, 24 Mar 2014 15:32:57 -0400
Message-Id: <1395689577-214654-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
References: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new routine.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-report.c | 77 +--------------------------------------------
 1 file changed, 1 insertion(+), 76 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c8f2113..c87412b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -576,8 +576,6 @@ static int
 parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 {
 	struct report *rep = (struct report *)opt->value;
-	char *tok, *tok2;
-	char *endptr;
 
 	/*
 	 * --no-call-graph
@@ -587,80 +585,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 		return 0;
 	}
 
-	symbol_conf.use_callchain = true;
-
-	if (!arg)
-		return 0;
-
-	tok = strtok((char *)arg, ",");
-	if (!tok)
-		return -1;
-
-	/* get the output mode */
-	if (!strncmp(tok, "graph", strlen(arg)))
-		callchain_param.mode = CHAIN_GRAPH_ABS;
-
-	else if (!strncmp(tok, "flat", strlen(arg)))
-		callchain_param.mode = CHAIN_FLAT;
-
-	else if (!strncmp(tok, "fractal", strlen(arg)))
-		callchain_param.mode = CHAIN_GRAPH_REL;
-
-	else if (!strncmp(tok, "none", strlen(arg))) {
-		callchain_param.mode = CHAIN_NONE;
-		symbol_conf.use_callchain = false;
-
-		return 0;
-	}
-
-	else
-		return -1;
-
-	/* get the min percentage */
-	tok = strtok(NULL, ",");
-	if (!tok)
-		goto setup;
-
-	callchain_param.min_percent = strtod(tok, &endptr);
-	if (tok == endptr)
-		return -1;
-
-	/* get the print limit */
-	tok2 = strtok(NULL, ",");
-	if (!tok2)
-		goto setup;
-
-	if (tok2[0] != 'c') {
-		callchain_param.print_limit = strtoul(tok2, &endptr, 0);
-		tok2 = strtok(NULL, ",");
-		if (!tok2)
-			goto setup;
-	}
-
-	/* get the call chain order */
-	if (!strncmp(tok2, "caller", strlen("caller")))
-		callchain_param.order = ORDER_CALLER;
-	else if (!strncmp(tok2, "callee", strlen("callee")))
-		callchain_param.order = ORDER_CALLEE;
-	else
-		return -1;
-
-	/* Get the sort key */
-	tok2 = strtok(NULL, ",");
-	if (!tok2)
-		goto setup;
-	if (!strncmp(tok2, "function", strlen("function")))
-		callchain_param.key = CCKEY_FUNCTION;
-	else if (!strncmp(tok2, "address", strlen("address")))
-		callchain_param.key = CCKEY_ADDRESS;
-	else
-		return -1;
-setup:
-	if (callchain_register_param(&callchain_param) < 0) {
-		pr_err("Can't register callchain params\n");
-		return -1;
-	}
-	return 0;
+	return report_parse_callchain_opt(arg);
 }
 
 int
-- 
1.7.11.7

