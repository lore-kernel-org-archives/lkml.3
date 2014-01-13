Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbaAMUwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:52:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40443 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaAMUsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:10 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Will Deacon <will.deacon@arm.com>,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 30/38] perf tools: Use the DWARF unwind info only if loaded
Date: Mon, 13 Jan 2014 17:47:31 -0300
Message-Id: <1389646059-24881-31-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <jean.pihet@linaro.org>

Use the info only if it has been found in the .debug_frame section of
the ELF binary.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linaro-kernel@lists.linaro.org
Cc: patches@linaro.org
Link: http://lkml.kernel.org/r/1387212194-8028-1-git-send-email-jean.pihet@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/unwind.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index 0efd5393de85..416f22bf3693 100644
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
1.8.1.4

