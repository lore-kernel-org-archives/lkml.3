Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3K3M4y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:56:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59625 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3K3Mvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:51:42 -0500
Date: Sat, 30 Nov 2013 04:50:46 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-4bc437964ef540462bd15af4a713da62961809aa@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, peterz@infradead.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1384768557-23331-3-git-send-email-adrian.hunter@intel.com>
References: <1384768557-23331-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Allow '--inherit' as the negation of 
 '--no-inherit'
Git-Commit-ID: 4bc437964ef540462bd15af4a713da62961809aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:50:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bc437964ef540462bd15af4a713da62961809aa
Gitweb:     http://git.kernel.org/tip/4bc437964ef540462bd15af4a713da62961809aa
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 18 Nov 2013 11:55:55 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:36 -0300

perf tools: Allow '--inherit' as the negation of '--no-inherit'

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
