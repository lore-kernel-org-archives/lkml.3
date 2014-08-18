Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaHRIXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:23:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51535 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaHRIXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:23:34 -0400
Date: Mon, 18 Aug 2014 01:22:34 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-e8232f1ad4682c34e7e774c212ccd0c15bb5aa26@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, rodrigo@sdfg.com.ar,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, rodrigo@sdfg.com.ar,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1407996100-6359-2-git-send-email-namhyung@kernel.org>
References: <1407996100-6359-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Relax -g option parsing not to limit the option order
Git-Commit-ID: e8232f1ad4682c34e7e774c212ccd0c15bb5aa26
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

Commit-ID:  e8232f1ad4682c34e7e774c212ccd0c15bb5aa26
Gitweb:     http://git.kernel.org/tip/e8232f1ad4682c34e7e774c212ccd0c15bb5aa26
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 14 Aug 2014 15:01:38 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Aug 2014 10:50:07 -0300

perf report: Relax -g option parsing not to limit the option order

Current perf report -g/--call-graph option parser requires for option
argument having following order:

  type,min_percent[,print_limit],order,key

But sometimes it's annoying to type all even if one just wants to change
the "order" or "key" setting.

This patch fixes it to remove the ordering restriction so that one can
use just "-g caller", for instance.  The only remaining restriction is
that the "print_limit" always comes after the "min_percent".

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rodrigo Campos <rodrigo@sdfg.com.ar>
Link: http://lkml.kernel.org/r/1407996100-6359-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/callchain.c | 95 ++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 57 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 437ee09..08f0fbf 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -28,74 +28,55 @@ __thread struct callchain_cursor callchain_cursor;
 int
 parse_callchain_report_opt(const char *arg)
 {
-	char *tok, *tok2;
+	char *tok;
 	char *endptr;
+	bool minpcnt_set = false;
 
 	symbol_conf.use_callchain = true;
 
 	if (!arg)
 		return 0;
 
-	tok = strtok((char *)arg, ",");
-	if (!tok)
-		return -1;
-
-	/* get the output mode */
-	if (!strncmp(tok, "graph", strlen(arg))) {
-		callchain_param.mode = CHAIN_GRAPH_ABS;
-
-	} else if (!strncmp(tok, "flat", strlen(arg))) {
-		callchain_param.mode = CHAIN_FLAT;
-	} else if (!strncmp(tok, "fractal", strlen(arg))) {
-		callchain_param.mode = CHAIN_GRAPH_REL;
-	} else if (!strncmp(tok, "none", strlen(arg))) {
-		callchain_param.mode = CHAIN_NONE;
-		symbol_conf.use_callchain = false;
-		return 0;
-	} else {
-		return -1;
-	}
-
-	/* get the min percentage */
-	tok = strtok(NULL, ",");
-	if (!tok)
-		goto setup;
-
-	callchain_param.min_percent = strtod(tok, &endptr);
-	if (tok == endptr)
-		return -1;
+	while ((tok = strtok((char *)arg, ",")) != NULL) {
+		if (!strncmp(tok, "none", strlen(tok))) {
+			callchain_param.mode = CHAIN_NONE;
+			symbol_conf.use_callchain = false;
+			return 0;
+		}
 
-	/* get the print limit */
-	tok2 = strtok(NULL, ",");
-	if (!tok2)
-		goto setup;
+		/* try to get the output mode */
+		if (!strncmp(tok, "graph", strlen(tok)))
+			callchain_param.mode = CHAIN_GRAPH_ABS;
+		else if (!strncmp(tok, "flat", strlen(tok)))
+			callchain_param.mode = CHAIN_FLAT;
+		else if (!strncmp(tok, "fractal", strlen(tok)))
+			callchain_param.mode = CHAIN_GRAPH_REL;
+		/* try to get the call chain order */
+		else if (!strncmp(tok, "caller", strlen(tok)))
+			callchain_param.order = ORDER_CALLER;
+		else if (!strncmp(tok, "callee", strlen(tok)))
+			callchain_param.order = ORDER_CALLEE;
+		/* try to get the sort key */
+		else if (!strncmp(tok, "function", strlen(tok)))
+			callchain_param.key = CCKEY_FUNCTION;
+		else if (!strncmp(tok, "address", strlen(tok)))
+			callchain_param.key = CCKEY_ADDRESS;
+		/* try to get the min percent */
+		else if (!minpcnt_set) {
+			callchain_param.min_percent = strtod(tok, &endptr);
+			if (tok == endptr)
+				return -1;
+			minpcnt_set = true;
+		} else {
+			/* try print limit at last */
+			callchain_param.print_limit = strtoul(tok, &endptr, 0);
+			if (tok == endptr)
+				return -1;
+		}
 
-	if (tok2[0] != 'c') {
-		callchain_param.print_limit = strtoul(tok2, &endptr, 0);
-		tok2 = strtok(NULL, ",");
-		if (!tok2)
-			goto setup;
+		arg = NULL;
 	}
 
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
 	if (callchain_register_param(&callchain_param) < 0) {
 		pr_err("Can't register callchain params\n");
 		return -1;
