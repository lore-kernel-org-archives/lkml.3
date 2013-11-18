Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab3KRJtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:49:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:18013 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab3KRJsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:48:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,722,1378882800"; 
   d="scan'208";a="435266916"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/4] perf tools: Allow '--inherit' as the negation of '--no-inherit'
Date: Mon, 18 Nov 2013 11:55:55 +0200
Message-Id: <1384768557-23331-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1384768557-23331-1-git-send-email-adrian.hunter@intel.com>
References: <1384768557-23331-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long options can be negated by prefixing them
with 'no-'.  However options that already start
with 'no-', such as '--no-inherit' result in ugly
double 'no's.  Avoid that by accepting that the
removal of 'no-' also negates the long option.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/parse-options.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 31f404a..b6b39ff 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -224,6 +224,24 @@ static int parse_long_opt(struct parse_opt_ctx_t *p, const char *arg,
 			return 0;
 		}
 		if (!rest) {
+			if (!prefixcmp(options->long_name, "no-")) {
+				/*
+				 * The long name itself starts with "no-", so
+				 * accept the option without "no-" so that users
+				 * do not have to enter "no-no-" to get the
+				 * negation.
+				 */
+				rest = skip_prefix(arg, options->long_name + 3);
+				if (rest) {
+					flags |= OPT_UNSET;
+					goto match;
+				}
+				/* Abbreviated case */
+				if (!prefixcmp(options->long_name + 3, arg)) {
+					flags |= OPT_UNSET;
+					goto is_abbreviated;
+				}
+			}
 			/* abbreviated? */
 			if (!strncmp(options->long_name, arg, arg_end - arg)) {
 is_abbreviated:
@@ -259,6 +277,7 @@ is_abbreviated:
 			if (!rest)
 				continue;
 		}
+match:
 		if (*rest) {
 			if (*rest != '=')
 				continue;
-- 
1.7.11.7

