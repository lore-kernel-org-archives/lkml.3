Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbbAMDAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 22:00:19 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:64369 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbAMDAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 22:00:17 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <jolsa@kernel.org>, <namhyung@kernel.org>, <a.p.zijlstra@chello.nl>,
        <paulus@samba.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>, <jean.pihet@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>
Subject: [PATCH] perf: fix dwarf unwind using libunwind.
Date: Tue, 13 Jan 2015 10:54:37 +0800
Message-ID: <1421117677-51536-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original perf tool fails to unwind user stack if the event is issued in
a shared object:

 $ perf record -e syscalls:sys_enter_write -g --call-graph=dwarf babeltrace
 $ perf report --stdio

    # To display the perf.data header info, please use --header/--header-only options.
    #
    # Samples: 37  of event 'syscalls:sys_enter_write'
    # Event count (approx.): 37
    #
    # Children      Self  Command     Shared Object  Symbol
    # ........  ........  ..........  .............  .....................
    #
       100.00%   100.00%  babeltrace  libc-2.18.so   [.] __GI___libc_write
                |
                ---__GI___libc_write

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
               >lookup: e->start_ip_offset = 2ad6c (rel_ip = b6cd3bcc)
               >lookup: e->start_ip_offset = 23004 (rel_ip = b6cd3bcc)
               >lookup: e->start_ip_offset = 18f28 (rel_ip = b6cd3bcc)
               >lookup: e->start_ip_offset = 184e8 (rel_ip = b6cd3bcc)
               >lookup: e->start_ip_offset = 167cc (rel_ip = b6cd3bcc)
               >lookup: e->start_ip_offset = 16294 (rel_ip = b6cd3bcc)
               >lookup: e->start_ip_offset = 15d88 (rel_ip = b6cd3bcc)
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
 tools/perf/util/unwind-libunwind.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 371219a..32040fa 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -185,6 +185,27 @@ static u64 elf_section_offset(int fd, const char *name)
 	return offset;
 }
 
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
+
+}
+
 struct table_entry {
 	u32 start_ip_offset;
 	u32 fde_offset;
@@ -322,8 +343,12 @@ find_proc_info(unw_addr_space_t as, unw_word_t ip, unw_proc_info_t *pi,
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

