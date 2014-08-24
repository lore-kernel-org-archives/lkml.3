Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaHXPAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 11:00:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34231 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaHXPAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 11:00:31 -0400
Date: Sun, 24 Aug 2014 08:00:12 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-2f3f9bcf000b2043a480e7cc0cae582559fb0f13@git.kernel.org>
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
In-Reply-To: <1408715919-25990-2-git-send-email-jolsa@kernel.org>
References: <1408715919-25990-2-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add +field argument support for --field option
Git-Commit-ID: 2f3f9bcf000b2043a480e7cc0cae582559fb0f13
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

Commit-ID:  2f3f9bcf000b2043a480e7cc0cae582559fb0f13
Gitweb:     http://git.kernel.org/tip/2f3f9bcf000b2043a480e7cc0cae582559fb0f13
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 22 Aug 2014 15:58:38 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 24 Aug 2014 08:11:19 -0300

perf tools: Add +field argument support for --field option

Adding support to add field(s) to default field order via using the '+'
prefix, like for report:

  $ perf report
  Samples: 10  of event 'cycles', Event count (approx.): 4463799
  Overhead  Command  Shared Object      Symbol
    32.40%  ls       [kernel.kallsyms]  [k] filemap_fault
    28.19%  ls       [kernel.kallsyms]  [k] get_page_from_freelist
    23.38%  ls       [kernel.kallsyms]  [k] enqueue_entity
    15.04%  ls       [kernel.kallsyms]  [k] mmap_region

  $ perf report -F +period,sample
  Samples: 10  of event 'cycles', Event count (approx.): 4463799
  Overhead        Period       Samples  Command  Shared Object      Symbol
    32.40%       1446493             1  ls       [kernel.kallsyms]  [k] filemap_fault
    28.19%       1258486             1  ls       [kernel.kallsyms]  [k] get_page_from_freelist
    23.38%       1043754             1  ls       [kernel.kallsyms]  [k] enqueue_entity
    15.04%        671160             1  ls       [kernel.kallsyms]  [k] mmap_region

Works in general for commands using --field option.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1408715919-25990-2-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/hist.c   |  4 ++--
 tools/perf/util/sort.c | 24 +++++++++++++++++++-----
 tools/perf/util/sort.h |  1 +
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 75eb6ac..2af1837 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -452,7 +452,7 @@ void perf_hpp__init(void)
 	/*
 	 * If user specified field order, no need to setup default fields.
 	 */
-	if (field_order)
+	if (is_strict_order(field_order))
 		return;
 
 	if (symbol_conf.cumulate_callchain) {
@@ -519,7 +519,7 @@ void perf_hpp__column_disable(unsigned col)
 
 void perf_hpp__cancel_cumulate(void)
 {
-	if (field_order)
+	if (is_strict_order(field_order))
 		return;
 
 	perf_hpp__column_disable(PERF_HPP__OVERHEAD_ACC);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b4a805e..1958637 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1453,7 +1453,7 @@ static int __setup_sorting(void)
 	int ret = 0;
 
 	if (sort_keys == NULL) {
-		if (field_order) {
+		if (is_strict_order(field_order)) {
 			/*
 			 * If user specified field order but no sort order,
 			 * we'll honor it and not add default sort orders.
@@ -1639,23 +1639,36 @@ static void reset_dimensions(void)
 		memory_sort_dimensions[i].taken = 0;
 }
 
+bool is_strict_order(const char *order)
+{
+	return order && (*order != '+');
+}
+
 static int __setup_output_field(void)
 {
-	char *tmp, *tok, *str;
-	int ret = 0;
+	char *tmp, *tok, *str, *strp;
+	int ret = -EINVAL;
 
 	if (field_order == NULL)
 		return 0;
 
 	reset_dimensions();
 
-	str = strdup(field_order);
+	strp = str = strdup(field_order);
 	if (str == NULL) {
 		error("Not enough memory to setup output fields");
 		return -ENOMEM;
 	}
 
-	for (tok = strtok_r(str, ", ", &tmp);
+	if (!is_strict_order(field_order))
+		strp++;
+
+	if (!strlen(strp)) {
+		error("Invalid --fields key: `+'");
+		goto out;
+	}
+
+	for (tok = strtok_r(strp, ", ", &tmp);
 			tok; tok = strtok_r(NULL, ", ", &tmp)) {
 		ret = output_field_add(tok);
 		if (ret == -EINVAL) {
@@ -1667,6 +1680,7 @@ static int __setup_output_field(void)
 		}
 	}
 
+out:
 	free(str);
 	return ret;
 }
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 041f0c9..c03e4ff 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -218,4 +218,5 @@ void perf_hpp__set_elide(int idx, bool elide);
 
 int report_parse_ignore_callees_opt(const struct option *opt, const char *arg, int unset);
 
+bool is_strict_order(const char *order);
 #endif	/* __PERF_SORT_H */
