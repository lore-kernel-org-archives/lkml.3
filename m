Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbbAPVXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 16:23:47 -0500
Received: from mail.kernel.org ([198.145.29.136]:54316 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354AbbAPVX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 16:23:29 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/10] perf tools powerpc: Use dwfl_report_elf() instead of offline.
Date: Fri, 16 Jan 2015 18:22:42 -0300
Message-Id: <1421443362-10709-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421443362-10709-1-git-send-email-acme@kernel.org>
References: <1421443362-10709-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

dwfl_report_offline() works only when libraries are prelinked.

Replace dwfl_report_offline() with dwfl_report_elf() so we correctly
extract debug info even from libraries that are not prelinked.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Link: http://lkml.kernel.org/r/20150114221045.GA17703@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/powerpc/util/skip-callchain-idx.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/perf/arch/powerpc/util/skip-callchain-idx.c b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
index 3bb50eac5542..0c370f81e002 100644
--- a/tools/perf/arch/powerpc/util/skip-callchain-idx.c
+++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
@@ -103,7 +103,7 @@ static Dwarf_Frame *get_eh_frame(Dwfl_Module *mod, Dwarf_Addr pc)
 		return NULL;
 	}
 
-	result = dwarf_cfi_addrframe(cfi, pc, &frame);
+	result = dwarf_cfi_addrframe(cfi, pc-bias, &frame);
 	if (result) {
 		pr_debug("%s(): %s\n", __func__, dwfl_errmsg(-1));
 		return NULL;
@@ -128,7 +128,7 @@ static Dwarf_Frame *get_dwarf_frame(Dwfl_Module *mod, Dwarf_Addr pc)
 		return NULL;
 	}
 
-	result = dwarf_cfi_addrframe(cfi, pc, &frame);
+	result = dwarf_cfi_addrframe(cfi, pc-bias, &frame);
 	if (result) {
 		pr_debug("%s(): %s\n", __func__, dwfl_errmsg(-1));
 		return NULL;
@@ -145,7 +145,7 @@ static Dwarf_Frame *get_dwarf_frame(Dwfl_Module *mod, Dwarf_Addr pc)
  *		yet used)
  *	-1 in case of errors
  */
-static int check_return_addr(struct dso *dso, Dwarf_Addr pc)
+static int check_return_addr(struct dso *dso, u64 map_start, Dwarf_Addr pc)
 {
 	int		rc = -1;
 	Dwfl		*dwfl;
@@ -155,6 +155,7 @@ static int check_return_addr(struct dso *dso, Dwarf_Addr pc)
 	Dwarf_Addr	start = pc;
 	Dwarf_Addr	end = pc;
 	bool		signalp;
+	const char	*exec_file = dso->long_name;
 
 	dwfl = dso->dwfl;
 
@@ -165,8 +166,10 @@ static int check_return_addr(struct dso *dso, Dwarf_Addr pc)
 			return -1;
 		}
 
-		if (dwfl_report_offline(dwfl, "", dso->long_name, -1) == NULL) {
-			pr_debug("dwfl_report_offline() failed %s\n",
+		mod = dwfl_report_elf(dwfl, exec_file, exec_file, -1,
+						map_start, false);
+		if (!mod) {
+			pr_debug("dwfl_report_elf() failed %s\n",
 						dwarf_errmsg(-1));
 			/*
 			 * We normally cache the DWARF debug info and never
@@ -256,10 +259,10 @@ int arch_skip_callchain_idx(struct thread *thread, struct ip_callchain *chain)
 		return skip_slot;
 	}
 
-	rc = check_return_addr(dso, ip);
+	rc = check_return_addr(dso, al.map->start, ip);
 
-	pr_debug("DSO %s, nr %" PRIx64 ", ip 0x%" PRIx64 "rc %d\n",
-				dso->long_name, chain->nr, ip, rc);
+	pr_debug("[DSO %s, sym %s, ip 0x%" PRIx64 "] rc %d\n",
+				dso->long_name, al.sym->name, ip, rc);
 
 	if (rc == 0) {
 		/*
-- 
1.9.3

