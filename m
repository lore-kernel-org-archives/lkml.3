Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3IZLhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:37:07 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:48488 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab3IZLhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:37:03 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Ingo Molnar <mingo@kernel.org>, linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 4/4] perf: parse the .debug_frame section in case .eh_frame is not present
Date: Thu, 26 Sep 2013 13:36:38 +0200
Message-Id: <1380195398-4402-5-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1380195398-4402-1-git-send-email-jean.pihet@linaro.org>
References: <1380195398-4402-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM the debug info is not present in the .eh_frame sections but
in .debug_frame instead, in dwarf format.
Use libunwind to load and parse the debug info.

Dependencies:
 . if present, libunwind >= 1.1 is needed to prevent a segfault when
   parsing the dwarf info,
 . libunwind needs to be configured with --enable-debug-frame. Note:
   --enable-debug-frame is automatically selected on ARM.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/util/unwind.c | 75 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 59 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index 2f891f7..5390d0b 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind.c
@@ -39,6 +39,15 @@ UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
 
 #define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
 
+extern int
+UNW_OBJ(dwarf_find_debug_frame) (int found, unw_dyn_info_t *di_debug,
+				 unw_word_t ip,
+				 unw_word_t segbase,
+				 const char *obj_name, unw_word_t start,
+				 unw_word_t end);
+
+#define dwarf_find_debug_frame UNW_OBJ(dwarf_find_debug_frame)
+
 #define DW_EH_PE_FORMAT_MASK	0x0f	/* format of the encoded value */
 #define DW_EH_PE_APPL_MASK	0x70	/* how the value is to be applied */
 
@@ -245,8 +254,9 @@ static int unwind_spec_ehframe(struct dso *dso, struct machine *machine,
 	return 0;
 }
 
-static int read_unwind_spec(struct dso *dso, struct machine *machine,
-			    u64 *table_data, u64 *segbase, u64 *fde_count)
+static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
+				     u64 *table_data, u64 *segbase,
+				     u64 *fde_count)
 {
 	int ret = -EINVAL, fd;
 	u64 offset;
@@ -255,6 +265,7 @@ static int read_unwind_spec(struct dso *dso, struct machine *machine,
 	if (fd < 0)
 		return -EINVAL;
 
+	/* Check the .eh_frame section for unwinding info */
 	offset = elf_section_offset(fd, ".eh_frame_hdr");
 	close(fd);
 
@@ -263,10 +274,29 @@ static int read_unwind_spec(struct dso *dso, struct machine *machine,
 					  table_data, segbase,
 					  fde_count);
 
-	/* TODO .debug_frame check if eh_frame_hdr fails */
 	return ret;
 }
 
+#ifndef NO_LIBUNWIND_DEBUG_FRAME
+static int read_unwind_spec_debug_frame(struct dso *dso,
+					struct machine *machine, u64 *offset)
+{
+	int fd = dso__data_fd(dso, machine);
+
+	if (fd < 0)
+		return -EINVAL;
+
+	/* Check the .debug_frame section for unwinding info */
+	*offset = elf_section_offset(fd, ".debug_frame");
+	close(fd);
+
+	if (*offset)
+		return 0;
+
+	return -EINVAL;
+}
+#endif
+
 static struct map *find_map(unw_word_t ip, struct unwind_info *ui)
 {
 	struct addr_location al;
@@ -291,20 +321,33 @@ find_proc_info(unw_addr_space_t as, unw_word_t ip, unw_proc_info_t *pi,
 
 	pr_debug("unwind: find_proc_info dso %s\n", map->dso->name);
 
-	if (read_unwind_spec(map->dso, ui->machine,
-			     &table_data, &segbase, &fde_count))
-		return -EINVAL;
+	/* Check the .eh_frame section for unwinding info */
+	if (!read_unwind_spec_eh_frame(map->dso, ui->machine,
+				       &table_data, &segbase, &fde_count)) {
+		memset(&di, 0, sizeof(di));
+		di.format   = UNW_INFO_FORMAT_REMOTE_TABLE;
+		di.start_ip = map->start;
+		di.end_ip   = map->end;
+		di.u.rti.segbase    = map->start + segbase;
+		di.u.rti.table_data = map->start + table_data;
+		di.u.rti.table_len  = fde_count * sizeof(struct table_entry)
+				      / sizeof(unw_word_t);
+		return dwarf_search_unwind_table(as, ip, &di, pi,
+						 need_unwind_info, arg);
+	}
+
+#ifndef NO_LIBUNWIND_DEBUG_FRAME
+	/* Check the .debug_frame section for unwinding info */
+	if (!read_unwind_spec_debug_frame(map->dso, ui->machine, &segbase)) {
+		memset(&di, 0, sizeof(di));
+		dwarf_find_debug_frame(0, &di, ip, 0, map->dso->name,
+				       map->start, map->end);
+		return dwarf_search_unwind_table(as, ip, &di, pi,
+						 need_unwind_info, arg);
+	}
+#endif
 
-	memset(&di, 0, sizeof(di));
-	di.format   = UNW_INFO_FORMAT_REMOTE_TABLE;
-	di.start_ip = map->start;
-	di.end_ip   = map->end;
-	di.u.rti.segbase    = map->start + segbase;
-	di.u.rti.table_data = map->start + table_data;
-	di.u.rti.table_len  = fde_count * sizeof(struct table_entry)
-			      / sizeof(unw_word_t);
-	return dwarf_search_unwind_table(as, ip, &di, pi,
-					 need_unwind_info, arg);
+	return -EINVAL;
 }
 
 static int access_fpreg(unw_addr_space_t __maybe_unused as,
-- 
1.7.11.7

