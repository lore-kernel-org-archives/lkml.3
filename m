Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaIJOKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:10:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:38538 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaIJOKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:10:05 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/14] perf tests: Add pollfd growing test
Date: Wed, 10 Sep 2014 11:08:43 -0300
Message-Id: <1410358129-9965-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410358129-9965-1-git-send-email-acme@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

  [acme@ssdandy linux]$ perf test "Add fd"
  34: Add fd to pollfd array, making it autogrow             : Ok
  [acme@ssdandy linux]$ perf test -v "Add fd"
  34: Add fd to pollfd array, making it autogrow             :
  --- start ---
  test child forked, pid 19817

  before growing array:   2 [ 1, 2 ]
  after 3rd add_pollfd:   3 [ 1, 2, 35 ]
  after 4th add_pollfd:   4 [ 1, 2, 35, 88 ]
  test child finished with 0
  ---- end ----
  Add fd to pollfd array, making it autogrow: Ok
  [acme@ssdandy linux]$

Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-smflpyta146bzog7z0effjss@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/builtin-test.c |   4 ++
 tools/perf/tests/evlist.c       | 111 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |   1 +
 3 files changed, 116 insertions(+)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 41e556edbe02..174c3ffc5713 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -162,6 +162,10 @@ static struct test {
 		.func = test__perf_evlist__filter_pollfd,
 	},
 	{
+		.desc = "Add fd to pollfd array, making it autogrow",
+		.func = test__perf_evlist__add_pollfd,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/evlist.c b/tools/perf/tests/evlist.c
index 77579158f4d9..99d7dfd4e20a 100644
--- a/tools/perf/tests/evlist.c
+++ b/tools/perf/tests/evlist.c
@@ -1,5 +1,7 @@
 #include "util/evlist.h"
 #include "util/debug.h"
+#include "util/thread_map.h"
+#include "util/cpumap.h"
 #include "tests/tests.h"
 
 static void perf_evlist__init_pollfd(struct perf_evlist *evlist,
@@ -101,3 +103,112 @@ int test__perf_evlist__filter_pollfd(void)
 
 	return 0;
 }
+
+int test__perf_evlist__add_pollfd(void)
+{
+	struct perf_evsel evsel = {
+		.system_wide = false,
+	};
+	struct thread_map threads = {
+		.nr = 2,
+	};
+	struct perf_evlist evlist_alloc = {
+		.pollfd	 = NULL,
+		.threads = &threads,
+	}, *evlist = &evlist_alloc;
+
+	INIT_LIST_HEAD(&evlist->entries);
+	list_add(&evsel.node, &evlist->entries);
+
+	if (perf_evlist__alloc_pollfd(evlist) < 0) {
+		pr_debug("\nperf_evlist__alloc_pollfd(evlist) failed!");
+		return TEST_FAIL;
+	}
+
+	if (evlist->nr_fds_alloc != threads.nr) {
+		pr_debug("\n_evlist__alloc_pollfd: nr_fds_alloc=%d != (threads->nr(%d) * cpu_map->nr(%d))=%d",
+			 evlist->nr_fds_alloc, thread_map__nr(evlist->threads), cpu_map__nr(evlist->cpus),
+			 thread_map__nr(evlist->threads) * cpu_map__nr(evlist->cpus));
+		return TEST_FAIL;
+	}
+
+	if (perf_evlist__add_pollfd(evlist, 1) < 0) {
+		pr_debug("\nperf_evlist__add_pollfd(evlist, 1) failed!");
+		return TEST_FAIL;
+	}
+
+	if (evlist->nr_fds != 1) {
+		pr_debug("\nperf_evlist__add_pollfd(evlist, 1)=%d != 1", evlist->nr_fds);
+		return TEST_FAIL;
+	}
+
+	if (perf_evlist__add_pollfd(evlist, 2) < 0) {
+		pr_debug("\nperf_evlist__add_pollfd(evlist, 2) failed!");
+		return TEST_FAIL;
+	}
+
+	if (evlist->nr_fds != 2) {
+		pr_debug("\nperf_evlist__add_pollfd(evlist, 2)=%d != 2", evlist->nr_fds);
+		return TEST_FAIL;
+	}
+
+	perf_evlist__fprintf_pollfd(evlist, "before growing array", stderr);
+
+	if (perf_evlist__add_pollfd(evlist, 35) < 0) {
+		pr_debug("\nperf_evlist__add_pollfd(evlist, 35) failed!");
+		return TEST_FAIL;
+	}
+
+	if (evlist->nr_fds != 3) {
+		pr_debug("\nperf_evlist__add_pollfd(evlist, 35)=%d != 3", evlist->nr_fds);
+		return TEST_FAIL;
+	}
+
+	if (evlist->pollfd == NULL) {
+		pr_debug("\nperf_evlist__add_pollfd(evlist, 35) should have allocated evlist->pollfd!");
+		return TEST_FAIL;
+	}
+
+	perf_evlist__fprintf_pollfd(evlist, "after 3rd add_pollfd", stderr);
+
+	if (evlist->pollfd[2].fd != 35) {
+		pr_debug("\nevlist->pollfd[2](%d) != 35!", evlist->pollfd[2].fd);
+		return TEST_FAIL;
+	}
+
+	if (perf_evlist__add_pollfd(evlist, 88) < 0) {
+		pr_debug("\nperf_evlist__add_pollfd(evlist, 88) failed!");
+		return TEST_FAIL;
+	}
+
+	if (evlist->nr_fds != 4) {
+		pr_debug("\nperf_evlist__add_pollfd(evlist, 88)=%d != 2", evlist->nr_fds);
+		return TEST_FAIL;
+	}
+
+	perf_evlist__fprintf_pollfd(evlist, "after 4th add_pollfd", stderr);
+
+	if (evlist->pollfd[0].fd != 1) {
+		pr_debug("\nevlist->pollfd[0](%d) != 1!", evlist->pollfd[0].fd);
+		return TEST_FAIL;
+	}
+
+	if (evlist->pollfd[1].fd != 2) {
+		pr_debug("\nevlist->pollfd[1](%d) != 2!", evlist->pollfd[1].fd);
+		return TEST_FAIL;
+	}
+
+	if (evlist->pollfd[2].fd != 35) {
+		pr_debug("\nevlist->pollfd[2](%d) != 35!", evlist->pollfd[2].fd);
+		return TEST_FAIL;
+	}
+
+	if (evlist->pollfd[3].fd != 88) {
+		pr_debug("\nevlist->pollfd[3](%d) != 88!", evlist->pollfd[3].fd);
+		return TEST_FAIL;
+	}
+
+	pr_debug("\n");
+
+	return 0;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 72c4c039bd80..699d4bb61dc7 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -50,6 +50,7 @@ int test__hists_output(void);
 int test__hists_cumulate(void);
 int test__switch_tracking(void);
 int test__perf_evlist__filter_pollfd(void);
+int test__perf_evlist__add_pollfd(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
-- 
1.9.3

