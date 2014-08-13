Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaHMFQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:16:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44955 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaHMFQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:16:42 -0400
Date: Tue, 12 Aug 2014 22:16:23 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-ni6gqdlvw7khp74r9htvklkb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add perf_config_u64 function
Git-Commit-ID: 94c0655fc16b0c09edc21cadddbeef95c408f3e7
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

Commit-ID:  94c0655fc16b0c09edc21cadddbeef95c408f3e7
Gitweb:     http://git.kernel.org/tip/94c0655fc16b0c09edc21cadddbeef95c408f3e7
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 6 Jun 2014 05:27:28 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:03:00 -0300

perf tools: Add perf_config_u64 function

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
index 7b176dd..5cf9e1b 100644
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
index 1e5e2e5..9970b8b 100644
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
