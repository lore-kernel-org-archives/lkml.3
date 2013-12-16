Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3LPQnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:43:33 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:45326 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab3LPQna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:43:30 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo <acme@ghostprotocols.net>
Cc: patches@linaro.org, Will Deacon <will.deacon@arm.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH] perf: unwind: use the dwarf info only if loaded
Date: Mon, 16 Dec 2013 17:43:14 +0100
Message-Id: <1387212194-8028-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the info only if it has been found in the .debug_frame
section of the ELF binary.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/util/unwind.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index 0efd539..416f22b 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind.c
@@ -340,10 +340,10 @@ find_proc_info(unw_addr_space_t as, unw_word_t ip, unw_proc_info_t *pi,
 	/* Check the .debug_frame section for unwinding info */
 	if (!read_unwind_spec_debug_frame(map->dso, ui->machine, &segbase)) {
 		memset(&di, 0, sizeof(di));
-		dwarf_find_debug_frame(0, &di, ip, 0, map->dso->name,
-				       map->start, map->end);
-		return dwarf_search_unwind_table(as, ip, &di, pi,
-						 need_unwind_info, arg);
+		if (dwarf_find_debug_frame(0, &di, ip, 0, map->dso->name,
+					   map->start, map->end))
+			return dwarf_search_unwind_table(as, ip, &di, pi,
+							 need_unwind_info, arg);
 	}
 #endif
 
-- 
1.7.11.7

