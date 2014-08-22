Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbaHVN7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:59:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbaHVN65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:58:57 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] perf tools: Add +field argument support for --sort option
Date: Fri, 22 Aug 2014 15:58:39 +0200
Message-Id: <1408715919-25990-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1408715919-25990-1-git-send-email-jolsa@kernel.org>
References: <1408715919-25990-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to add field(s) to default sort order
via using the '+' prefix, like for report:

  $ perf report
  Samples: 2K of event 'cycles', Event count (approx.): 882172583
  Overhead  Command          Shared Object                Symbol
     7.39%  swapper          [kernel.kallsyms]            [k] intel_idle
     1.97%  firefox          libpthread-2.17.so           [.] pthread_mutex_lock
     1.39%  firefox          [snd_hda_intel]              [k] azx_get_position
     1.11%  firefox          libpthread-2.17.so           [.] pthread_mutex_unlock

  $ perf report -s +cpu
  Samples: 2K of event 'cycles', Event count (approx.): 882172583
  Overhead  Command          Shared Object                Symbol                      CPU
     2.89%  swapper          [kernel.kallsyms]            [k] intel_idle              000
     2.61%  swapper          [kernel.kallsyms]            [k] intel_idle              002
     1.20%  swapper          [kernel.kallsyms]            [k] intel_idle              001
     0.82%  firefox          libpthread-2.17.so           [.] pthread_mutex_lock      002

Works in general for commands using --sort option.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/sort.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 1958637cf136..b3d7dc1837ec 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1446,12 +1446,38 @@ static const char *get_default_sort_order(void)
 	return default_sort_orders[sort__mode];
 }
 
+static int setup_sort_order(void)
+{
+#define BUF_MAX 4096
+	static char buf[BUF_MAX];
+
+	if (!sort_order || is_strict_order(sort_order))
+		return 0;
+
+	if (!strlen(sort_order + 1)) {
+		error("Invalid --fields key: `+'");
+		return -EINVAL;
+	}
+
+	scnprintf(buf, BUF_MAX, "%s,%s",
+		  get_default_sort_order(),
+		  sort_order + 1);
+
+	sort_order = buf;
+	return 0;
+#undef BUF_MAX
+}
+
 static int __setup_sorting(void)
 {
 	char *tmp, *tok, *str;
-	const char *sort_keys = sort_order;
+	const char *sort_keys;
 	int ret = 0;
 
+	if (setup_sort_order())
+		return -EINVAL;
+
+	sort_keys = sort_order;
 	if (sort_keys == NULL) {
 		if (is_strict_order(field_order)) {
 			/*
-- 
1.8.3.1

