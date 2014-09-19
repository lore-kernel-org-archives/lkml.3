Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbaISFTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:19:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52850 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbaISFTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:19:40 -0400
Date: Thu, 18 Sep 2014 22:18:55 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-1a1c0ffb2adb2d2ce7bb9c4dfd2935ba345cf2c2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <20140823125948.GA1193@krava.brq.redhat.com>
References: <20140823125948.GA1193@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add +field argument support for --sort option
Git-Commit-ID: 1a1c0ffb2adb2d2ce7bb9c4dfd2935ba345cf2c2
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

Commit-ID:  1a1c0ffb2adb2d2ce7bb9c4dfd2935ba345cf2c2
Gitweb:     http://git.kernel.org/tip/1a1c0ffb2adb2d2ce7bb9c4dfd2935ba345cf2c2
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 23 Aug 2014 14:59:48 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 17:08:07 -0300

perf tools: Add +field argument support for --sort option

Adding support to add field(s) to default sort order via using the '+'
prefix, like for report:

  $ perf report
  Samples: 2K of event 'cycles', Event count (approx.): 882172583
  Overhead  Command  Shared Object        Symbol
     7.39%  swapper  [kernel.kallsyms]    [k] intel_idle
     1.97%  firefox  libpthread-2.17.so   [.] pthread_mutex_lock
     1.39%  firefox  [snd_hda_intel]      [k] azx_get_position
     1.11%  firefox  libpthread-2.17.so   [.] pthread_mutex_unlock

  $ perf report -s +cpu
  Samples: 2K of event 'cycles', Event count (approx.): 882172583
  Overhead  Command  Shared Object        Symbol                  CPU
     2.89%  swapper  [kernel.kallsyms]    [k] intel_idle          000
     2.61%  swapper  [kernel.kallsyms]    [k] intel_idle          002
     1.20%  swapper  [kernel.kallsyms]    [k] intel_idle          001
     0.82%  firefox  libpthread-2.17.so   [.] pthread_mutex_lock  002

Works in general for commands using --sort option.

v2 with changes suggested:
  - Use dynamic memory instead static buffer
  - Fix error message typo

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140823125948.GA1193@krava.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 1958637..289df9d 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1446,12 +1446,47 @@ static const char *get_default_sort_order(void)
 	return default_sort_orders[sort__mode];
 }
 
+static int setup_sort_order(void)
+{
+	char *new_sort_order;
+
+	/*
+	 * Append '+'-prefixed sort order to the default sort
+	 * order string.
+	 */
+	if (!sort_order || is_strict_order(sort_order))
+		return 0;
+
+	if (sort_order[1] == '\0') {
+		error("Invalid --sort key: `+'");
+		return -EINVAL;
+	}
+
+	/*
+	 * We allocate new sort_order string, but we never free it,
+	 * because it's checked over the rest of the code.
+	 */
+	if (asprintf(&new_sort_order, "%s,%s",
+		     get_default_sort_order(), sort_order + 1) < 0) {
+		error("Not enough memory to set up --sort");
+		return -ENOMEM;
+	}
+
+	sort_order = new_sort_order;
+	return 0;
+}
+
 static int __setup_sorting(void)
 {
 	char *tmp, *tok, *str;
-	const char *sort_keys = sort_order;
+	const char *sort_keys;
 	int ret = 0;
 
+	ret = setup_sort_order();
+	if (ret)
+		return ret;
+
+	sort_keys = sort_order;
 	if (sort_keys == NULL) {
 		if (is_strict_order(field_order)) {
 			/*
