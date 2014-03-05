Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbaCETts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:49:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:12245 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbaCETtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:49:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,594,1389772800"; 
   d="scan'208";a="492970298"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/8] perf, tools: Query terminal width and use in perf list
Date: Wed,  5 Mar 2014 11:49:36 -0800
Message-Id: <1394048978-15909-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Automatically adapt the now wider and word wrapped perf list
output to wider terminals. This requires querying the terminal
before the auto pager takes over, and exporting this
information from the pager subsystem.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/cache.h |  1 +
 tools/perf/util/pager.c |  7 ++++++-
 tools/perf/util/pmu.c   | 12 +++++++-----
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 7b176dd..d40cd4d 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -31,6 +31,7 @@ extern void setup_pager(void);
 extern const char *pager_program;
 extern int pager_in_use(void);
 extern int pager_use_color;
+extern int pager_columns;
 
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
index 3322b84..5a771ab 100644
--- a/tools/perf/util/pager.c
+++ b/tools/perf/util/pager.c
@@ -1,13 +1,15 @@
 #include "cache.h"
 #include "run-command.h"
 #include "sigchain.h"
+#include <sys/ioctl.h>
 
 /*
  * This is split up from the rest of git so that we can do
  * something different on Windows.
  */
 
-static int spawned_pager;
+int spawned_pager;
+int pager_columns;
 
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
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 5d69c29..a26ec85 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -9,6 +9,7 @@
 #include "pmu.h"
 #include "parse-events.h"
 #include "cpumap.h"
+#include "cache.h"
 #include "jevents.h"
 
 const char *json_file;
@@ -791,11 +792,12 @@ static void wordwrap(char *s, int start, int max, int corr)
 
 static int get_columns(void)
 {
-	/*
-	 * Should ask the terminal with TIOCGWINSZ here, but we
-	 * need the original fd before the pager.
-	 */
-	return 79;
+	char *s;
+
+	s = getenv("COLUMNS");
+	if (s)
+		return atoi(s);
+	return (pager_columns ? pager_columns : 80) - 2;
 }
 
 void print_pmu_events(const char *event_glob, bool name_only)
-- 
1.8.5.3

