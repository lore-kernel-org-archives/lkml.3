Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbbANWKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:10:55 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:37686 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbANWKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:10:54 -0500
Date: Wed, 14 Jan 2015 14:10:45 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org
Subject: [PATCH] Use dwfl_report_elf() instead of offline
Message-ID: <20150114221045.GA17703@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011422-0013-0000-0000-000007EB09BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 8e6fb4c58d0d9f4798c191d840e32084b1217cc3 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Fri, 21 Nov 2014 20:33:53 -0500
Subject: [PATCH 1/1] Use dwfl_report_elf() instead of offline.

dwfl_report_offline() works only when libraries are prelinked.

Replace dwfl_report_offline() with dwfl_report_elf() so we correctly
extract debug info even from libraries that are not prelinked.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/arch/powerpc/util/skip-callchain-idx.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/perf/arch/powerpc/util/skip-callchain-idx.c b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
index 3bb50ea..0c370f8 100644
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
1.8.3.1

