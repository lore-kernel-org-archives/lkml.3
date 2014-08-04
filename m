Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaHDQUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:20:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:39298 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbaHDQUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:20:03 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/33] perf tools: Add perf_config_u64 function
Date: Mon,  4 Aug 2014 13:17:29 -0300
Message-Id: <1407169064-25625-19-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Adding perf_config_u64 function to be able to parse 'llong' values out
of config file.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-ni6gqdlvw7khp74r9htvklkb@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/cache.h  |  1 +
 tools/perf/util/config.c | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 7b176dd02e1a..5cf9e1b5989d 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -22,6 +22,7 @@ typedef int (*config_fn_t)(const char *, const char *, void *);
 extern int perf_default_config(const char *, const char *, void *);
 extern int perf_config(config_fn_t fn, void *);
 extern int perf_config_int(const char *, const char *);
+extern u64 perf_config_u64(const char *, const char *);
 extern int perf_config_bool(const char *, const char *);
 extern int config_error_nonbool(const char *);
 extern const char *perf_config_dirname(const char *, const char *);
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 1e5e2e5af6b1..9970b8b0190b 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -286,6 +286,21 @@ static int parse_unit_factor(const char *end, unsigned long *val)
 	return 0;
 }
 
+static int perf_parse_llong(const char *value, long long *ret)
+{
+	if (value && *value) {
+		char *end;
+		long long val = strtoll(value, &end, 0);
+		unsigned long factor = 1;
+
+		if (!parse_unit_factor(end, &factor))
+			return 0;
+		*ret = val * factor;
+		return 1;
+	}
+	return 0;
+}
+
 static int perf_parse_long(const char *value, long *ret)
 {
 	if (value && *value) {
@@ -307,6 +322,15 @@ static void die_bad_config(const char *name)
 	die("bad config value for '%s'", name);
 }
 
+u64 perf_config_u64(const char *name, const char *value)
+{
+	long long ret = 0;
+
+	if (!perf_parse_llong(value, &ret))
+		die_bad_config(name);
+	return (u64) ret;
+}
+
 int perf_config_int(const char *name, const char *value)
 {
 	long ret = 0;
-- 
1.9.3

