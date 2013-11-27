Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab3K0URx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:17:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32887 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934Ab3K0URH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:07 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/34] perf tools: Allow '--inherit' as the negation of '--no-inherit'
Date: Wed, 27 Nov 2013 17:16:11 -0300
Message-Id: <1385583394-3703-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Long options can be negated by prefixing them with 'no-'.  However
options that already start with 'no-', such as '--no-inherit' result in
ugly double 'no's.

Avoid that by accepting that the removal of 'no-' also negates the long
option.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1384768557-23331-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-options.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 31f404a032a9..b6b39ff14fbb 100644
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
1.8.1.4

