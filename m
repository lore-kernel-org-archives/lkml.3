Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbbAQKNq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 05:13:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44354 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbbAQKNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 05:13:45 -0500
Date: Sat, 17 Jan 2015 02:13:27 -0800
From: tip-bot for Sukadev Bhattiprolu <tipbot@zytor.com>
Message-ID: <tip-6bcf9c1ff3ec22fd81eba336737d9865476509b1@git.kernel.org>
Cc: sukadev@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        mpe@ellerman.id.au, mingo@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de, hpa@zytor.com, acme@redhat.com
Reply-To: sukadev@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, mpe@ellerman.id.au, jolsa@redhat.com,
        tglx@linutronix.de, hpa@zytor.com, acme@redhat.com
In-Reply-To: <20150114221045.GA17703@us.ibm.com>
References: <20150114221045.GA17703@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools powerpc: Use dwfl_report_elf()
  instead of offline.
Git-Commit-ID: 6bcf9c1ff3ec22fd81eba336737d9865476509b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6bcf9c1ff3ec22fd81eba336737d9865476509b1
Gitweb:     http://git.kernel.org/tip/6bcf9c1ff3ec22fd81eba336737d9865476509b1
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Fri, 21 Nov 2014 20:33:53 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Jan 2015 17:49:30 -0300

perf tools powerpc: Use dwfl_report_elf() instead of offline.

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
