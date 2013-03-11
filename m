Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3CKNLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:11:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab3CKNLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:11:10 -0400
Date: Mon, 11 Mar 2013 14:10:36 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Vince Weaver <vince@deater.net>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf tests: Add automated test for mixed type event groups
Message-ID: <20130311131036.GA13679@krava.brq.redhat.com>
References: <1362629990-10053-1-git-send-email-namhyung@kernel.org>
 <1362629990-10053-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362629990-10053-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 01:19:50PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> There's a problem with mixed hw/sw group when the leader is a software
> event.  For instance:
> 
>   $ perf stat -e '{task-clock,cycles,faults}' sleep 1
> 
>    Performance counter stats for 'sleep 1':
> 
>             0.273436 task-clock                #    0.000 CPUs utilized
>              962,965 cycles                    #    3.522 GHz
>      <not supported> faults
> 
>          1.000804279 seconds time elapsed
> 

as discussed on irc, here's automated test for this,
feel free to change it in any way

jirka


---
Adding automated test for mixed type event groups.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile             |    1 +
 tools/perf/tests/builtin-test.c |    4 ++
 tools/perf/tests/mixed-groups.c |  104 +++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |    1 +
 4 files changed, 110 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/tests/mixed-groups.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a2108ca..6eb5930 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -497,6 +497,7 @@ LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
 LIB_OBJS += $(OUTPUT)tests/hists_link.o
 LIB_OBJS += $(OUTPUT)tests/python-use.o
+LIB_OBJS += $(OUTPUT)tests/mixed-groups.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index acb98e0..aaec91d 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -78,6 +78,10 @@ static struct test {
 		.func = test__python_use,
 	},
 	{
+		.desc = "Test event mixed groups",
+		.func = test__mixed_groups,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/mixed-groups.c b/tools/perf/tests/mixed-groups.c
new file mode 100644
index 0000000..fe55354
--- /dev/null
+++ b/tools/perf/tests/mixed-groups.c
@@ -0,0 +1,104 @@
+
+#include <linux/compiler.h>
+#include "tests.h"
+#include "debug.h"
+
+#define EVENTS 4
+static int ret;
+
+static int event(int hw, int group)
+{
+	struct perf_event_attr pe;
+	u32 type = hw ? PERF_TYPE_HARDWARE : PERF_TYPE_SOFTWARE;
+	u64 config = hw ? PERF_COUNT_HW_CPU_CYCLES : PERF_COUNT_SW_CPU_CLOCK;
+	int fd;
+
+	memset(&pe, 0, sizeof(struct perf_event_attr));
+	pe.type   = type;
+	pe.config = config;
+	pe.size   = sizeof(struct perf_event_attr);
+
+	pe.disabled = group == -1 ? 1 : 0;
+	pe.exclude_hv = 1;
+
+	fd = sys_perf_event_open(&pe, 0, -1, group, 0);
+
+	pr_debug("%s(%d) ", hw ? "H" : "S", fd);
+
+	return fd;
+}
+
+static long long count(int fd)
+{
+	long long c;
+	int err;
+
+	if (fd < 0)
+		return 0;
+
+	err = read(fd, &c, sizeof(c));
+	if (err != sizeof(c)) {
+		pr_err("failed to read: %d\n", err);
+		ret = TEST_FAIL;
+	}
+
+	return c;
+}
+
+static void __test__mixed_groups(int events)
+{
+#define group fd[0]
+	int fd[EVENTS] = { -1 };
+	int i;
+
+	for (i = 0; i < EVENTS; i++) {
+		int hw = (1 << i) & events;
+
+		fd[i] = event(hw, group);
+		if (!hw && fd[i] < 0) {
+			pr_debug("\n");
+			ret = TEST_FAIL;
+			goto out;
+		}
+	}
+
+	pr_debug("\n  counts: ");
+
+	ioctl(group, PERF_EVENT_IOC_ENABLE, 0);
+
+	while(i++);
+
+	ioctl(group, PERF_EVENT_IOC_DISABLE, 0);
+
+	for (i = 0; i < EVENTS; i++) {
+		int hw = (1 << i) & events;
+		long long c;
+
+		c = count(fd[i]);
+
+		pr_debug("%d(%lld) ", fd[i], c);
+		if (!hw && !c) {
+			pr_debug("no count for SW event");
+			ret = TEST_FAIL;
+			break;
+		}
+	}
+
+	pr_debug("\n");
+
+ out:
+	for (i = 0; i < EVENTS; i++)
+		close(fd[i]);
+#undef group
+}
+
+int test__mixed_groups(void)
+{
+	int i;
+
+	for (i = 0; i < (1 << EVENTS); i++)
+		__test__mixed_groups(i);
+
+	pr_debug("ret %d\n", ret);
+	return ret;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 5de0be1..c4a2f05 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -23,5 +23,6 @@ int test__dso_data(void);
 int test__parse_events(void);
 int test__hists_link(void);
 int test__python_use(void);
+int test__mixed_groups(void);
 
 #endif /* TESTS_H */
-- 
1.7.7.6

