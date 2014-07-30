Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaG3XXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:23:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:14666 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbaG3XW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:22:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,768,1400050800"; 
   d="scan'208";a="577941252"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        mingo@kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/10] perf, tools: Query terminal width and use in perf list
Date: Wed, 30 Jul 2014 16:22:47 -0700
Message-Id: <1406762570-16694-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406762570-16694-1-git-send-email-andi@firstfloor.org>
References: <1406762570-16694-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Automatically adapt the now wider and word wrapped perf list
output to wider terminals. This requires querying the terminal
before the auto pager takes over, and exporting this
information from the pager subsystem.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/cache.h |  1 +
 tools/perf/util/pager.c | 15 +++++++++++++++
 tools/perf/util/pmu.c   | 12 ++----------
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 7b176dd..07527d6 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -31,6 +31,7 @@ extern void setup_pager(void);
 extern const char *pager_program;
 extern int pager_in_use(void);
 extern int pager_use_color;
+int pager_get_columns(void);
 
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
index 31ee02d..9761202 100644
--- a/tools/perf/util/pager.c
+++ b/tools/perf/util/pager.c
@@ -1,6 +1,7 @@
 #include "cache.h"
 #include "run-command.h"
 #include "sigchain.h"
+#include <sys/ioctl.h>
 
 /*
  * This is split up from the rest of git so that we can do
@@ -8,6 +9,7 @@
  */
 
 static int spawned_pager;
+static int pager_columns;
 
 static void pager_preexec(void)
 {
@@ -47,9 +49,12 @@ static void wait_for_pager_signal(int signo)
 void setup_pager(void)
 {
 	const char *pager = getenv("PERF_PAGER");
+	struct winsize sz;
 
 	if (!isatty(1))
 		return;
+	if (ioctl(1, TIOCGWINSZ, &sz) == 0)
+		pager_columns = sz.ws_col;
 	if (!pager) {
 		if (!pager_program)
 			perf_config(perf_default_config, NULL);
@@ -98,3 +103,13 @@ int pager_in_use(void)
 	env = getenv("PERF_PAGER_IN_USE");
 	return env ? perf_config_bool("PERF_PAGER_IN_USE", env) : 0;
 }
+
+int pager_get_columns(void)
+{
+	char *s;
+
+	s = getenv("COLUMNS");
+	if (s)
+		return atoi(s);
+	return (pager_columns ? pager_columns : 80) - 2;
+}
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index fa21319..8714f9a 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -9,6 +9,7 @@
 #include "pmu.h"
 #include "parse-events.h"
 #include "cpumap.h"
+#include "cache.h"
 #include "jevents.h"
 
 const char *json_file;
@@ -789,15 +790,6 @@ static void wordwrap(char *s, int start, int max, int corr)
 	}
 }
 
-static int get_columns(void)
-{
-	/*
-	 * Should ask the terminal with TIOCGWINSZ here, but we
-	 * need the original fd before the pager.
-	 */
-	return 79;
-}
-
 void print_pmu_events(const char *event_glob, bool name_only)
 {
 	struct perf_pmu *pmu;
@@ -807,7 +799,7 @@ void print_pmu_events(const char *event_glob, bool name_only)
 	int len, j;
 	struct pair *aliases;
 	int numdesc = 0;
-	int columns = get_columns();
+	int columns = pager_get_columns();
 
 	pmu = NULL;
 	len = 0;
-- 
1.9.3

