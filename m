Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab3HLKVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:21:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47959 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3HLKV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:21:29 -0400
Date: Mon, 12 Aug 2013 03:20:40 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-b55ae0a976f2927ea8f15a85c43bbe6d25a68a41@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1375875537-4509-2-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add test for reading object code
Git-Commit-ID: b55ae0a976f2927ea8f15a85c43bbe6d25a68a41
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:20:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b55ae0a976f2927ea8f15a85c43bbe6d25a68a41
Gitweb:     http://git.kernel.org/tip/b55ae0a976f2927ea8f15a85c43bbe6d25a68a41
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 7 Aug 2013 14:38:45 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:30 -0300

perf tests: Add test for reading object code

Using the information in mmap events, perf tools can read object code
associated with sampled addresses.  A test is added that compares bytes
read by perf with the same bytes read using objdump.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375875537-4509-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile             |   1 +
 tools/perf/tests/builtin-test.c |   4 +
 tools/perf/tests/code-reading.c | 509 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |   1 +
 4 files changed, 515 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bfd12d0..e0d3d9f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -392,6 +392,7 @@ LIB_OBJS += $(OUTPUT)tests/sw-clock.o
 ifeq ($(ARCH),x86)
 LIB_OBJS += $(OUTPUT)tests/perf-time-to-tsc.o
 endif
+LIB_OBJS += $(OUTPUT)tests/code-reading.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index b7b4049..f5af192 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -100,6 +100,10 @@ static struct test {
 	},
 #endif
 	{
+		.desc = "Test object code reading",
+		.func = test__code_reading,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
new file mode 100644
index 0000000..28bee62
--- /dev/null
+++ b/tools/perf/tests/code-reading.c
@@ -0,0 +1,509 @@
+#include <sys/types.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <inttypes.h>
+#include <ctype.h>
+#include <string.h>
+
+#include "parse-events.h"
+#include "evlist.h"
+#include "evsel.h"
+#include "thread_map.h"
+#include "cpumap.h"
+#include "machine.h"
+#include "event.h"
+#include "thread.h"
+
+#include "tests.h"
+
+#define BUFSZ	1024
+#define READLEN	128
+
+static unsigned int hex(char c)
+{
+	if (c >= '0' && c <= '9')
+		return c - '0';
+	if (c >= 'a' && c <= 'f')
+		return c - 'a' + 10;
+	return c - 'A' + 10;
+}
+
+static void read_objdump_line(const char *line, size_t line_len, void **buf,
+			      size_t *len)
+{
+	const char *p;
+	size_t i;
+
+	/* Skip to a colon */
+	p = strchr(line, ':');
+	if (!p)
+		return;
+	i = p + 1 - line;
+
+	/* Read bytes */
+	while (*len) {
+		char c1, c2;
+
+		/* Skip spaces */
+		for (; i < line_len; i++) {
+			if (!isspace(line[i]))
+				break;
+		}
+		/* Get 2 hex digits */
+		if (i >= line_len || !isxdigit(line[i]))
+			break;
+		c1 = line[i++];
+		if (i >= line_len || !isxdigit(line[i]))
+			break;
+		c2 = line[i++];
+		/* Followed by a space */
+		if (i < line_len && line[i] && !isspace(line[i]))
+			break;
+		/* Store byte */
+		*(unsigned char *)*buf = (hex(c1) << 4) | hex(c2);
+		*buf += 1;
+		*len -= 1;
+	}
+}
+
+static int read_objdump_output(FILE *f, void **buf, size_t *len)
+{
+	char *line = NULL;
+	size_t line_len;
+	ssize_t ret;
+	int err = 0;
+
+	while (1) {
+		ret = getline(&line, &line_len, f);
+		if (feof(f))
+			break;
+		if (ret < 0) {
+			pr_debug("getline failed\n");
+			err = -1;
+			break;
+		}
+		read_objdump_line(line, ret, buf, len);
+	}
+
+	free(line);
+
+	return err;
+}
+
+static int read_via_objdump(const char *filename, u64 addr, void *buf,
+			    size_t len)
+{
+	char cmd[PATH_MAX * 2];
+	const char *fmt;
+	FILE *f;
+	int ret;
+
+	fmt = "%s -d --start-address=0x%"PRIx64" --stop-address=0x%"PRIx64" %s";
+	ret = snprintf(cmd, sizeof(cmd), fmt, "objdump", addr, addr + len,
+		       filename);
+	if (ret <= 0 || (size_t)ret >= sizeof(cmd))
+		return -1;
+
+	pr_debug("Objdump command is: %s\n", cmd);
+
+	f = popen(cmd, "r");
+	if (!f) {
+		pr_debug("popen failed\n");
+		return -1;
+	}
+
+	ret = read_objdump_output(f, &buf, &len);
+	if (len) {
+		pr_debug("objdump read too few bytes\n");
+		if (!ret)
+			ret = len;
+	}
+
+	pclose(f);
+
+	return ret;
+}
+
+static int read_object_code(u64 addr, size_t len, u8 cpumode,
+			    struct thread *thread, struct machine *machine)
+{
+	struct addr_location al;
+	unsigned char buf1[BUFSZ];
+	unsigned char buf2[BUFSZ];
+	size_t ret_len;
+	u64 objdump_addr;
+	int ret;
+
+	pr_debug("Reading object code for memory address: %#"PRIx64"\n", addr);
+
+	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION, addr,
+			      &al);
+	if (!al.map || !al.map->dso) {
+		pr_debug("thread__find_addr_map failed\n");
+		return -1;
+	}
+
+	pr_debug("File is: %s\n", al.map->dso->long_name);
+
+	if (al.map->dso->symtab_type == DSO_BINARY_TYPE__KALLSYMS) {
+		pr_debug("Unexpected kernel address - skipping\n");
+		return 0;
+	}
+
+	pr_debug("On file address is: %#"PRIx64"\n", al.addr);
+
+	if (len > BUFSZ)
+		len = BUFSZ;
+
+	/* Do not go off the map */
+	if (addr + len > al.map->end)
+		len = al.map->end - addr;
+
+	/* Read the object code using perf */
+	ret_len = dso__data_read_offset(al.map->dso, machine, al.addr, buf1,
+					len);
+	if (ret_len != len) {
+		pr_debug("dso__data_read_offset failed\n");
+		return -1;
+	}
+
+	/*
+	 * Converting addresses for use by objdump requires more information.
+	 * map__load() does that.  See map__rip_2objdump() for details.
+	 */
+	if (map__load(al.map, NULL))
+		return -1;
+
+	/* Read the object code using objdump */
+	objdump_addr = map__rip_2objdump(al.map, al.addr);
+	ret = read_via_objdump(al.map->dso->long_name, objdump_addr, buf2, len);
+	if (ret > 0) {
+		/*
+		 * The kernel maps are inaccurate - assume objdump is right in
+		 * that case.
+		 */
+		if (cpumode == PERF_RECORD_MISC_KERNEL ||
+		    cpumode == PERF_RECORD_MISC_GUEST_KERNEL) {
+			len -= ret;
+			if (len)
+				pr_debug("Reducing len to %zu\n", len);
+			else
+				return -1;
+		}
+	}
+	if (ret < 0) {
+		pr_debug("read_via_objdump failed\n");
+		return -1;
+	}
+
+	/* The results should be identical */
+	if (memcmp(buf1, buf2, len)) {
+		pr_debug("Bytes read differ from those read by objdump\n");
+		return -1;
+	}
+	pr_debug("Bytes read match those read by objdump\n");
+
+	return 0;
+}
+
+static int process_sample_event(struct machine *machine,
+				struct perf_evlist *evlist,
+				union perf_event *event)
+{
+	struct perf_sample sample;
+	struct thread *thread;
+	u8 cpumode;
+
+	if (perf_evlist__parse_sample(evlist, event, &sample)) {
+		pr_debug("perf_evlist__parse_sample failed\n");
+		return -1;
+	}
+
+	thread = machine__findnew_thread(machine, sample.pid);
+	if (!thread) {
+		pr_debug("machine__findnew_thread failed\n");
+		return -1;
+	}
+
+	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+
+	return read_object_code(sample.ip, READLEN, cpumode, thread, machine);
+}
+
+static int process_event(struct machine *machine, struct perf_evlist *evlist,
+			 union perf_event *event)
+{
+	if (event->header.type == PERF_RECORD_SAMPLE)
+		return process_sample_event(machine, evlist, event);
+
+	if (event->header.type < PERF_RECORD_MAX)
+		return machine__process_event(machine, event);
+
+	return 0;
+}
+
+static int process_events(struct machine *machine, struct perf_evlist *evlist)
+{
+	union perf_event *event;
+	int i, ret;
+
+	for (i = 0; i < evlist->nr_mmaps; i++) {
+		while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
+			ret = process_event(machine, evlist, event);
+			if (ret < 0)
+				return ret;
+		}
+	}
+	return 0;
+}
+
+static int comp(const void *a, const void *b)
+{
+	return *(int *)a - *(int *)b;
+}
+
+static void do_sort_something(void)
+{
+	size_t sz = 40960;
+	int buf[sz], i;
+
+	for (i = 0; i < (int)sz; i++)
+		buf[i] = sz - i - 1;
+
+	qsort(buf, sz, sizeof(int), comp);
+
+	for (i = 0; i < (int)sz; i++) {
+		if (buf[i] != i) {
+			pr_debug("qsort failed\n");
+			break;
+		}
+	}
+}
+
+static void sort_something(void)
+{
+	int i;
+
+	for (i = 0; i < 10; i++)
+		do_sort_something();
+}
+
+static void syscall_something(void)
+{
+	int pipefd[2];
+	int i;
+
+	for (i = 0; i < 1000; i++) {
+		if (pipe(pipefd) < 0) {
+			pr_debug("pipe failed\n");
+			break;
+		}
+		close(pipefd[1]);
+		close(pipefd[0]);
+	}
+}
+
+static void fs_something(void)
+{
+	const char *test_file_name = "temp-perf-code-reading-test-file--";
+	FILE *f;
+	int i;
+
+	for (i = 0; i < 1000; i++) {
+		f = fopen(test_file_name, "w+");
+		if (f) {
+			fclose(f);
+			unlink(test_file_name);
+		}
+	}
+}
+
+static void do_something(void)
+{
+	fs_something();
+
+	sort_something();
+
+	syscall_something();
+}
+
+enum {
+	TEST_CODE_READING_OK,
+	TEST_CODE_READING_NO_VMLINUX,
+	TEST_CODE_READING_NO_ACCESS,
+};
+
+static int do_test_code_reading(void)
+{
+	struct machines machines;
+	struct machine *machine;
+	struct thread *thread;
+	struct perf_record_opts opts = {
+		.mmap_pages	     = UINT_MAX,
+		.user_freq	     = UINT_MAX,
+		.user_interval	     = ULLONG_MAX,
+		.freq		     = 4000,
+		.target		     = {
+			.uses_mmap   = true,
+		},
+	};
+	struct thread_map *threads = NULL;
+	struct cpu_map *cpus = NULL;
+	struct perf_evlist *evlist = NULL;
+	struct perf_evsel *evsel = NULL;
+	int err = -1, ret;
+	pid_t pid;
+	struct map *map;
+	bool have_vmlinux, excl_kernel = false;
+
+	pid = getpid();
+
+	machines__init(&machines);
+	machine = &machines.host;
+
+	ret = machine__create_kernel_maps(machine);
+	if (ret < 0) {
+		pr_debug("machine__create_kernel_maps failed\n");
+		goto out_err;
+	}
+
+	/* Load kernel map */
+	map = machine->vmlinux_maps[MAP__FUNCTION];
+	ret = map__load(map, NULL);
+	if (ret < 0) {
+		pr_debug("map__load failed\n");
+		goto out_err;
+	}
+	have_vmlinux = map->dso->symtab_type == DSO_BINARY_TYPE__VMLINUX;
+	/* No point getting kernel events if there is no vmlinux */
+	if (!have_vmlinux)
+		excl_kernel = true;
+
+	threads = thread_map__new_by_tid(pid);
+	if (!threads) {
+		pr_debug("thread_map__new_by_tid failed\n");
+		goto out_err;
+	}
+
+	ret = perf_event__synthesize_thread_map(NULL, threads,
+						perf_event__process, machine);
+	if (ret < 0) {
+		pr_debug("perf_event__synthesize_thread_map failed\n");
+		goto out_err;
+	}
+
+	thread = machine__findnew_thread(machine, pid);
+	if (!thread) {
+		pr_debug("machine__findnew_thread failed\n");
+		goto out_err;
+	}
+
+	cpus = cpu_map__new(NULL);
+	if (!cpus) {
+		pr_debug("cpu_map__new failed\n");
+		goto out_err;
+	}
+
+	while (1) {
+		const char *str;
+
+		evlist = perf_evlist__new();
+		if (!evlist) {
+			pr_debug("perf_evlist__new failed\n");
+			goto out_err;
+		}
+
+		perf_evlist__set_maps(evlist, cpus, threads);
+
+		if (excl_kernel)
+			str = "cycles:u";
+		else
+			str = "cycles";
+		pr_debug("Parsing event '%s'\n", str);
+		ret = parse_events(evlist, str);
+		if (ret < 0) {
+			pr_debug("parse_events failed\n");
+			goto out_err;
+		}
+
+		perf_evlist__config(evlist, &opts);
+
+		evsel = perf_evlist__first(evlist);
+
+		evsel->attr.comm = 1;
+		evsel->attr.disabled = 1;
+		evsel->attr.enable_on_exec = 0;
+
+		ret = perf_evlist__open(evlist);
+		if (ret < 0) {
+			if (!excl_kernel) {
+				excl_kernel = true;
+				perf_evlist__delete(evlist);
+				evlist = NULL;
+				continue;
+			}
+			pr_debug("perf_evlist__open failed\n");
+			goto out_err;
+		}
+		break;
+	}
+
+	ret = perf_evlist__mmap(evlist, UINT_MAX, false);
+	if (ret < 0) {
+		pr_debug("perf_evlist__mmap failed\n");
+		goto out_err;
+	}
+
+	perf_evlist__enable(evlist);
+
+	do_something();
+
+	perf_evlist__disable(evlist);
+
+	ret = process_events(machine, evlist);
+	if (ret < 0)
+		goto out_err;
+
+	if (!have_vmlinux)
+		err = TEST_CODE_READING_NO_VMLINUX;
+	else if (excl_kernel)
+		err = TEST_CODE_READING_NO_ACCESS;
+	else
+		err = TEST_CODE_READING_OK;
+out_err:
+	if (evlist) {
+		perf_evlist__munmap(evlist);
+		perf_evlist__close(evlist);
+		perf_evlist__delete(evlist);
+	}
+	if (cpus)
+		cpu_map__delete(cpus);
+	if (threads)
+		thread_map__delete(threads);
+	machines__destroy_kernel_maps(&machines);
+	machine__delete_threads(machine);
+	machines__exit(&machines);
+
+	return err;
+}
+
+int test__code_reading(void)
+{
+	int ret;
+
+	ret = do_test_code_reading();
+
+	switch (ret) {
+	case TEST_CODE_READING_OK:
+		return 0;
+	case TEST_CODE_READING_NO_VMLINUX:
+		fprintf(stderr, " (no vmlinux)");
+		return 0;
+	case TEST_CODE_READING_NO_ACCESS:
+		fprintf(stderr, " (no access)");
+		return 0;
+	default:
+		return -1;
+	};
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index d22202a..c748f53 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -36,5 +36,6 @@ int test__bp_signal_overflow(void);
 int test__task_exit(void);
 int test__sw_clock_freq(void);
 int test__perf_time_to_tsc(void);
+int test__code_reading(void);
 
 #endif /* TESTS_H */
