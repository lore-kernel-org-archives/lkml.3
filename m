Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaFYSow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:44:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaFYSov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:44:51 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 0/1] perf: Fix race in sample output
Date: Wed, 25 Jun 2014 20:44:34 +0200
Message-Id: <1403721875-15669-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
the perf test patch below is not to be merged. It's
just to show how to hit issue fixed by patch 1/1.

thanks,
jirka


Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf          |   1 +
 tools/perf/tests/builtin-test.c   |   4 +
 tools/perf/tests/group-read-bug.c | 169 ++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h          |   1 +
 4 files changed, 175 insertions(+)
 create mode 100644 tools/perf/tests/group-read-bug.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9670a16..909084f 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -419,6 +419,7 @@ endif
 endif
 LIB_OBJS += $(OUTPUT)tests/mmap-thread-lookup.o
 LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
+LIB_OBJS += $(OUTPUT)tests/group-read-bug.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 6f8b01b..2b2d544 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -154,6 +154,10 @@ static struct test {
 		.func = test__hists_cumulate,
 	},
 	{
+		.desc = "Test group read bug",
+		.func = test__group_read_bug,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/group-read-bug.c b/tools/perf/tests/group-read-bug.c
new file mode 100644
index 0000000..d69fabf
--- /dev/null
+++ b/tools/perf/tests/group-read-bug.c
@@ -0,0 +1,169 @@
+#include <unistd.h>
+#include <sys/syscall.h>   /* For SYS_xxx definitions */
+#include <linux/perf_event.h>
+#include <linux/hw_breakpoint.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <signal.h>
+#include <pthread.h>
+#include "tests.h"
+#include "perf.h"
+#include "debug.h"
+#include "trace-event.h"
+
+static int fd_leader;
+static bool done;
+static int pid;
+
+static int create_event(int group_fd)
+{
+	struct perf_event_attr pe;
+	struct event_format* format;
+	int fd;
+
+	memset(&pe, 0, sizeof(struct perf_event_attr));
+	pe.type = PERF_TYPE_TRACEPOINT;
+	pe.size = sizeof(struct perf_event_attr);
+
+	format = trace_event__tp_format("syscalls", "sys_enter_read");
+	if (!format)
+		return TEST_FAIL;
+
+	pe.config = format->id;
+	pe.sample_period = 1;
+	pe.sample_type = PERF_SAMPLE_ID|PERF_SAMPLE_READ;
+	pe.read_format = PERF_FORMAT_ID|PERF_FORMAT_GROUP;
+
+	if (group_fd == -1)
+		pe.disabled = 1;
+
+	fd = sys_perf_event_open(&pe, pid, -1, group_fd, 0);
+	if (fd < 0) {
+		pr_debug("failed opening event %llx, errno %d\n",
+			 pe.config, errno);
+		return TEST_FAIL;
+	}
+
+	return fd;
+}
+
+static __u64 read_head(struct perf_event_mmap_page *pc)
+{
+	__u64 head = ACCESS_ONCE(pc->data_head);
+	rmb();
+	return head;
+}
+
+static void write_tail(struct perf_event_mmap_page *pc, __u64 tail)
+{
+	mb();
+	pc->data_tail = tail;
+}
+
+static void mmap_read(struct perf_event_mmap_page *pc, int mask)
+{
+	__u64 old = 0;
+	__u64 empty = 0;
+
+	while (!done) {
+		__u64 size, head;
+
+		head = read_head(pc);
+
+		if (old == head) {
+			empty++;
+			continue;
+		}
+
+		size = head - old;
+
+		pr_debug("empty %llu, head = %llu, size %llu\n", empty, head, size);
+		empty = 0;
+
+		if ((old & mask) + size != (head & mask)) {
+			size = mask + 1 - (old & mask);
+			old += size;
+		}
+
+		size = head - old;
+		old += size;
+		write_tail(pc, old);
+	}
+}
+
+static void *worker_thread(void *data __maybe_unused)
+{
+#define CNT 1000
+	int fds[CNT];
+
+	while (!done) {
+		int i;
+
+		for (i = 0; i < CNT; i++)
+			fds[i] = create_event(fd_leader);
+
+		for (i = 0; i < CNT; i++)
+			close(fds[i]);
+	}
+
+	return NULL;
+}
+
+static void *gen_thread(void *data __maybe_unused)
+{
+	pid = syscall(SYS_gettid);
+
+	while (!done) {
+		int i;
+
+		i = read(300, &i, sizeof(i));
+	}
+
+	return NULL;
+}
+
+static void signal_fn(int signo __maybe_unused)
+{
+	done = 1;
+}
+
+int test__group_read_bug(void)
+{
+	pthread_t pthread, pthread_gen;
+	int mmap_len  = page_size + (page_size  << 5);
+	int mmap_mask = mmap_len - page_size - 1;
+	void *buf;
+	int err;
+
+	signal(SIGINT,  signal_fn);
+
+	err = pthread_create(&pthread, NULL, gen_thread, NULL);
+	TEST_ASSERT_VAL("create gen", !err);
+
+	while(!pid) {
+		pr_debug("waiting for pid\n");
+		sleep(1);
+	}
+
+	fd_leader = create_event(-1);
+	TEST_ASSERT_VAL("create a leader", fd_leader >= 0);
+
+	buf = mmap(NULL, mmap_len, PROT_READ|PROT_WRITE, MAP_SHARED, fd_leader, 0);
+	TEST_ASSERT_VAL("mmap leader", buf != MAP_FAILED);
+
+	err = ioctl(fd_leader, PERF_EVENT_IOC_ENABLE, 0);
+	TEST_ASSERT_VAL("enable leader", !err);
+
+	err = pthread_create(&pthread_gen, NULL, worker_thread, NULL);
+	TEST_ASSERT_VAL("create worker", !err);
+
+	mmap_read(buf, mmap_mask);
+
+	munmap(buf, mmap_len);
+	close(fd_leader);
+
+	pthread_join(pthread, NULL);
+	pthread_join(pthread_gen, NULL);
+	return 0;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index ed64790..af43c47 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -48,6 +48,7 @@ int test__mmap_thread_lookup(void);
 int test__thread_mg_share(void);
 int test__hists_output(void);
 int test__hists_cumulate(void);
+int test__group_read_bug(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
-- 
1.8.3.1

