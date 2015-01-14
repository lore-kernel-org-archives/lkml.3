Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbbANCms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:42:48 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:56568 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbbANCmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:42:47 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <jolsa@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <namhyung@kernel.org>, <a.p.zijlstra@chello.nl>, <paulus@samba.org>,
        <mingo@redhat.com>, <acme@kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH v2] perf: fix dwarf unwind using libunwind.
Date: Wed, 14 Jan 2015 10:36:47 +0800
Message-ID: <1421203007-75799-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20150113091928.GA2160@krava.brq.redhat.com>
References: <20150113091928.GA2160@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.54B5D78D.011E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 8ed13e013ec1f8f4ec7757f07f549ad4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perf tool fails to unwind user stack if the event raises in a shared
object. This patch improves tests/dwarf-unwind.c to demonstrate the
problem by utilizing commonly used glibc function "bsearch". If perf
is not statically linked, the testcase will try to unwind a mixed call
trace.

By debugging libunwind I found that there is a bug in unwind-libunwind:
it always passes 0 as segbase to libunwind, cause libunwind unable to
locate debug_frame entry fir first level ip address (I add some more
debugging output into libunwind to make things clear):

               >_Uarm_dwarf_find_debug_frame: start_ip = 10be98, end_ip = 10c2a4
               >_Uarm_dwarf_find_debug_frame: found debug_frame table `/lib/libc-2.18.so': segbase=0x0, len=7, gp=0x0, table_data=0x449388
               >_Uarm_dwarf_search_unwind_table: call lookup:ip = b6cd3bcc, segbase = 0, rel_ip = b6cd3bcc
               >lookup: e->start_ip_offset = bcf18 (rel_ip = b6cd3bcc)
               >lookup: e->start_ip_offset = 6d314 (rel_ip = b6cd3bcc)
               >lookup: e->start_ip_offset = 33d0c (rel_ip = b6cd3bcc)
                ...
               >lookup: e->start_ip_offset = 15d0c (rel_ip = b6cd3bcc)
               >lookup: e->start_ip_offset = 15c40 (rel_ip = b6cd3bcc)
 >_Uarm_dwarf_search_unwind_table: IP b6cd3bcc inside range b6c12000-b6d4c000, but no explicit unwind info found
                >put_rs_cache: unmasking signals/interrupts and releasing lock
               >_Uarm_dwarf_step: returning -10
 >_Uarm_step: dwarf_step()=-10

This patch passes map->start as segbase to dwarf_find_debug_frame(), so
di will be initialized correctly.

In addition, dso and executable are different when setting segbase. This
patch first check whether the elf is executable, and pass segbase only
for shared object.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 tools/perf/tests/dwarf-unwind.c    | 36 ++++++++++++++++++++++++++++++++++--
 tools/perf/util/unwind-libunwind.c | 28 +++++++++++++++++++++++++++-
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index ab28cca..0bf06be 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -11,6 +11,9 @@
 #include "thread.h"
 #include "callchain.h"
 
+/* For bsearch. We try to unwind functions in shared object. */
+#include <stdlib.h>
+
 static int mmap_handler(struct perf_tool *tool __maybe_unused,
 			union perf_event *event,
 			struct perf_sample *sample __maybe_unused,
@@ -28,7 +31,7 @@ static int init_live_machine(struct machine *machine)
 						  mmap_handler, machine, true);
 }
 
-#define MAX_STACK 6
+#define MAX_STACK 8
 
 static int unwind_entry(struct unwind_entry *entry, void *arg)
 {
@@ -37,6 +40,8 @@ static int unwind_entry(struct unwind_entry *entry, void *arg)
 	static const char *funcs[MAX_STACK] = {
 		"test__arch_unwind_sample",
 		"unwind_thread",
+		"compare",
+		"bsearch",
 		"krava_3",
 		"krava_2",
 		"krava_1",
@@ -88,10 +93,37 @@ static int unwind_thread(struct thread *thread)
 	return err;
 }
 
+static int global_unwind_retval = -INT_MAX;
+
+__attribute__ ((noinline))
+static int compare(void *p1, void *p2)
+{
+	/* Any possible value should be 'thread' */
+	struct thread *thread = *(struct thread **)p1;
+
+	if (global_unwind_retval == -INT_MAX)
+		global_unwind_retval = unwind_thread(thread);
+
+	return p1 - p2;
+}
+
 __attribute__ ((noinline))
 static int krava_3(struct thread *thread)
 {
-	return unwind_thread(thread);
+	struct thread *array[2] = {thread, thread};
+	void *fp = &bsearch;
+	/*
+	 * make _bsearch a volatile function pointer to
+	 * prevent potential optimization, which may expand
+	 * bsearch and call compare directly from this function,
+	 * instead of libc shared object.
+	 */
+	void *(*volatile _bsearch)(void *, void *, size_t,
+			size_t, int (*)(void *, void *));
+
+	_bsearch = fp;
+	_bsearch(array, &thread, 2, sizeof(struct thread **), compare);
+	return global_unwind_retval;
 }
 
 __attribute__ ((noinline))
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 371219a..6edf535 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -185,6 +185,28 @@ static u64 elf_section_offset(int fd, const char *name)
 	return offset;
 }
 
+#ifndef NO_LIBUNWIND_DEBUG_FRAME
+static int elf_is_exec(int fd, const char *name)
+{
+	Elf *elf;
+	GElf_Ehdr ehdr;
+	int retval = 0;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL)
+		return 0;
+	if (gelf_getehdr(elf, &ehdr) == NULL)
+		goto out;
+
+	retval = (ehdr.e_type == ET_EXEC);
+
+out:
+	elf_end(elf);
+	pr_debug("unwind: elf_is_exec(%s): %d\n", name, retval);
+	return retval;
+}
+#endif
+
 struct table_entry {
 	u32 start_ip_offset;
 	u32 fde_offset;
@@ -322,8 +344,12 @@ find_proc_info(unw_addr_space_t as, unw_word_t ip, unw_proc_info_t *pi,
 #ifndef NO_LIBUNWIND_DEBUG_FRAME
 	/* Check the .debug_frame section for unwinding info */
 	if (!read_unwind_spec_debug_frame(map->dso, ui->machine, &segbase)) {
+		int fd = dso__data_fd(map->dso, ui->machine);
+		int is_exec = elf_is_exec(fd, map->dso->name);
+		unw_word_t base = is_exec ? 0 : map->start;
+
 		memset(&di, 0, sizeof(di));
-		if (dwarf_find_debug_frame(0, &di, ip, 0, map->dso->name,
+		if (dwarf_find_debug_frame(0, &di, ip, base, map->dso->name,
 					   map->start, map->end))
 			return dwarf_search_unwind_table(as, ip, &di, pi,
 							 need_unwind_info, arg);
-- 
1.8.4

