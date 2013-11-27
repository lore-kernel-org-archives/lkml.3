Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab3K0UUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:20:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32871 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab3K0URG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:06 -0500
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
Subject: [PATCH 12/34] perf tools: Add option macro OPT_BOOLEAN_SET
Date: Wed, 27 Nov 2013 17:16:12 -0300
Message-Id: <1385583394-3703-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
index b6b39ff14fbb..d22e3f8017dc 100644
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
index b0241e28eaf7..cbf0149cf221 100644
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
-- 
1.8.1.4

