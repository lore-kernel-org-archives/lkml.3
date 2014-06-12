Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136AbaFLPbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:31:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140AbaFLPbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:31:32 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/14] perf tools: Cache dso data file descriptor
Date: Thu, 12 Jun 2014 17:30:38 +0200
Message-Id: <1402587045-5461-8-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402587045-5461-1-git-send-email-jolsa@kernel.org>
References: <1402587045-5461-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caching dso data file descriptors to avoid expensive re-opens
especially during DWARF unwind.

We keep dsos data file descriptors open until their count reaches
the half of the current fd open limit (RLIMIT_NOFILE). In this case
we close file descriptor of the first opened dso object.

We've got overall speedup (~27% for my workload) of report:
 'perf report --stdio -i perf-test.data' (3 runs)
  (perf-test.data size was around 12GB)

  current code:
   545,640,944,228      cycles                     ( +-  0.53% )
   785,255,798,320      instructions               ( +-  0.03% )

     366.340910010 seconds time elapsed            ( +-  3.65% )

  after change:
   435,895,036,114      cycles                     ( +-  0.26% )
   636,790,271,176      instructions               ( +-  0.04% )

     266.481463387 seconds time elapsed            ( +-  0.13% )

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1401892622-30848-7-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/dso.c              | 61 ++++++++++++++++++++++++++++++++++++--
 tools/perf/util/unwind-libunwind.c |  2 --
 2 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 76e5c13..fbf6cc9 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1,4 +1,6 @@
 #include <asm/bug.h>
+#include <sys/time.h>
+#include <sys/resource.h>
 #include "symbol.h"
 #include "dso.h"
 #include "machine.h"
@@ -180,12 +182,20 @@ static int __open_dso(struct dso *dso, struct machine *machine)
 	return fd;
 }
 
+static void check_data_close(void);
+
 static int open_dso(struct dso *dso, struct machine *machine)
 {
 	int fd = __open_dso(dso, machine);
 
-	if (fd > 0)
+	if (fd > 0) {
 		dso__list_add(dso);
+		/*
+		 * Check if we crossed the allowed number
+		 * of opened DSOs and close one if needed.
+		 */
+		check_data_close();
+	}
 
 	return fd;
 }
@@ -204,6 +214,54 @@ static void close_dso(struct dso *dso)
 	close_data_fd(dso);
 }
 
+static void close_first_dso(void)
+{
+	struct dso *dso;
+
+	dso = list_first_entry(&dso__data_open, struct dso, data.open_entry);
+	close_dso(dso);
+}
+
+static rlim_t get_fd_limit(void)
+{
+	struct rlimit l;
+	rlim_t limit = 0;
+
+	/* Allow half of the current open fd limit. */
+	if (getrlimit(RLIMIT_NOFILE, &l) == 0) {
+		if (l.rlim_cur == RLIM_INFINITY)
+			limit = l.rlim_cur;
+		else
+			limit = l.rlim_cur / 2;
+	} else {
+		pr_err("failed to get fd limit\n");
+		limit = 1;
+	}
+
+	return limit;
+}
+
+static bool may_cache_fd(void)
+{
+	static rlim_t limit;
+
+	if (!limit)
+		limit = get_fd_limit();
+
+	if (limit == RLIM_INFINITY)
+		return true;
+
+	return limit > (rlim_t) dso__data_open_cnt;
+}
+
+static void check_data_close(void)
+{
+	bool cache_fd = may_cache_fd();
+
+	if (!cache_fd)
+		close_first_dso();
+}
+
 void dso__data_close(struct dso *dso)
 {
 	close_dso(dso);
@@ -356,7 +414,6 @@ dso_cache__read(struct dso *dso, struct machine *machine,
 	if (ret <= 0)
 		free(cache);
 
-	dso__data_close(dso);
 	return ret;
 }
 
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 4f8dd9e..25578b9 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -250,7 +250,6 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
 
 	/* Check the .eh_frame section for unwinding info */
 	offset = elf_section_offset(fd, ".eh_frame_hdr");
-	dso__data_close(dso);
 
 	if (offset)
 		ret = unwind_spec_ehframe(dso, machine, offset,
@@ -271,7 +270,6 @@ static int read_unwind_spec_debug_frame(struct dso *dso,
 
 	/* Check the .debug_frame section for unwinding info */
 	*offset = elf_section_offset(fd, ".debug_frame");
-	dso__data_close(dso);
 
 	if (*offset)
 		return 0;
-- 
1.8.3.1

