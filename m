Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3K3Mv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:51:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59599 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab3K3MvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:51:22 -0500
Date: Sat, 30 Nov 2013 04:50:55 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-167faf32b07fc47637048fbcbdfcf4a89481686d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1384768557-23331-4-git-send-email-adrian.hunter@intel.com>
References: <1384768557-23331-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add option macro OPT_BOOLEAN_SET
Git-Commit-ID: 167faf32b07fc47637048fbcbdfcf4a89481686d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:51:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  167faf32b07fc47637048fbcbdfcf4a89481686d
Gitweb:     http://git.kernel.org/tip/167faf32b07fc47637048fbcbdfcf4a89481686d
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 18 Nov 2013 11:55:56 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:36 -0300

perf tools: Add option macro OPT_BOOLEAN_SET

OPT_BOOLEAN_SET records whether a boolean option was set by the user.

That information can be used to change the default value for the option
after the options have been parsed.

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
Link: http://lkml.kernel.org/r/1384768557-23331-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-options.c | 2 ++
 tools/perf/util/parse-options.h | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index b6b39ff..d22e3f8 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -78,6 +78,8 @@ static int get_value(struct parse_opt_ctx_t *p,
 
 	case OPTION_BOOLEAN:
 		*(bool *)opt->value = unset ? false : true;
+		if (opt->set)
+			*(bool *)opt->set = true;
 		return 0;
 
 	case OPTION_INCR:
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index b0241e2..cbf0149 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -82,6 +82,9 @@ typedef int parse_opt_cb(const struct option *, const char *arg, int unset);
  *   OPTION_{BIT,SET_UINT,SET_PTR} store the {mask,integer,pointer} to put in
  *   the value when met.
  *   CALLBACKS can use it like they want.
+ *
+ * `set`::
+ *   whether an option was set by the user
  */
 struct option {
 	enum parse_opt_type type;
@@ -94,6 +97,7 @@ struct option {
 	int flags;
 	parse_opt_cb *callback;
 	intptr_t defval;
+	bool *set;
 };
 
 #define check_vtype(v, type) ( BUILD_BUG_ON_ZERO(!__builtin_types_compatible_p(typeof(v), type)) + v )
@@ -103,6 +107,10 @@ struct option {
 #define OPT_GROUP(h)                { .type = OPTION_GROUP, .help = (h) }
 #define OPT_BIT(s, l, v, h, b)      { .type = OPTION_BIT, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h), .defval = (b) }
 #define OPT_BOOLEAN(s, l, v, h)     { .type = OPTION_BOOLEAN, .short_name = (s), .long_name = (l), .value = check_vtype(v, bool *), .help = (h) }
+#define OPT_BOOLEAN_SET(s, l, v, os, h) \
+	{ .type = OPTION_BOOLEAN, .short_name = (s), .long_name = (l), \
+	.value = check_vtype(v, bool *), .help = (h), \
+	.set = check_vtype(os, bool *)}
 #define OPT_INCR(s, l, v, h)        { .type = OPTION_INCR, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h) }
 #define OPT_SET_UINT(s, l, v, h, i)  { .type = OPTION_SET_UINT, .short_name = (s), .long_name = (l), .value = check_vtype(v, unsigned int *), .help = (h), .defval = (i) }
 #define OPT_SET_PTR(s, l, v, h, p)  { .type = OPTION_SET_PTR, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (p) }
