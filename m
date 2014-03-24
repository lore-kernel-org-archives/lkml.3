Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaCXTeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:34:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbaCXTdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:24 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/4] perf, callchain: Add generic report parse callchain callback function
Date: Mon, 24 Mar 2014 15:32:56 -0400
Message-Id: <1395689577-214654-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
References: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This takes the parse_callchain_opt function and copies it into the
callchain.c file.  Now the c2c tool can use it too without duplicating.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/callchain.c | 83 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/callchain.h |  1 +
 2 files changed, 84 insertions(+)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 8d9db45..2320678 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -25,6 +25,89 @@
 
 __thread struct callchain_cursor callchain_cursor;
 
+int
+report_parse_callchain_opt(const char *arg)
+{
+	//struct report *rep = (struct report *)opt->value;
+	char *tok, *tok2;
+	char *endptr;
+
+	symbol_conf.use_callchain = true;
+
+	if (!arg)
+		return 0;
+
+	tok = strtok((char *)arg, ",");
+	if (!tok)
+		return -1;
+
+	/* get the output mode */
+	if (!strncmp(tok, "graph", strlen(arg)))
+		callchain_param.mode = CHAIN_GRAPH_ABS;
+
+	else if (!strncmp(tok, "flat", strlen(arg)))
+		callchain_param.mode = CHAIN_FLAT;
+
+	else if (!strncmp(tok, "fractal", strlen(arg)))
+		callchain_param.mode = CHAIN_GRAPH_REL;
+
+	else if (!strncmp(tok, "none", strlen(arg))) {
+		callchain_param.mode = CHAIN_NONE;
+		symbol_conf.use_callchain = false;
+
+		return 0;
+	}
+
+	else
+		return -1;
+
+	/* get the min percentage */
+	tok = strtok(NULL, ",");
+	if (!tok)
+		goto setup;
+
+	callchain_param.min_percent = strtod(tok, &endptr);
+	if (tok == endptr)
+		return -1;
+
+	/* get the print limit */
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+
+	if (tok2[0] != 'c') {
+		callchain_param.print_limit = strtoul(tok2, &endptr, 0);
+		tok2 = strtok(NULL, ",");
+		if (!tok2)
+			goto setup;
+	}
+
+	/* get the call chain order */
+	if (!strncmp(tok2, "caller", strlen("caller")))
+		callchain_param.order = ORDER_CALLER;
+	else if (!strncmp(tok2, "callee", strlen("callee")))
+		callchain_param.order = ORDER_CALLEE;
+	else
+		return -1;
+
+	/* Get the sort key */
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+	if (!strncmp(tok2, "function", strlen("function")))
+		callchain_param.key = CCKEY_FUNCTION;
+	else if (!strncmp(tok2, "address", strlen("address")))
+		callchain_param.key = CCKEY_ADDRESS;
+	else
+		return -1;
+setup:
+	if (callchain_register_param(&callchain_param) < 0) {
+		pr_err("Can't register callchain params\n");
+		return -1;
+	}
+	return 0;
+}
+
 static void
 rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 		    enum chain_mode mode)
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 8ad97e9..0a828bb 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -157,4 +157,5 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample);
 
 extern const char record_callchain_help[];
+int report_parse_callchain_opt(const char *arg);
 #endif	/* __PERF_CALLCHAIN_H */
-- 
1.7.11.7

