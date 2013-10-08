Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3JHKlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:41:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37589 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3JHKlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:41:12 -0400
Date: Tue, 8 Oct 2013 03:40:50 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-e08cfd4bda7683cdbe6971c26cf23e2afdb1e7a8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <20130930092144.1693.11058.stgit@udc4-manage.rcp.hitachi.co.jp>
References: <20130930092144.1693.11058.stgit@udc4-manage.rcp.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe:
  Fix to find line information for probe list
Git-Commit-ID: e08cfd4bda7683cdbe6971c26cf23e2afdb1e7a8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 08 Oct 2013 03:40:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e08cfd4bda7683cdbe6971c26cf23e2afdb1e7a8
Gitweb:     http://git.kernel.org/tip/e08cfd4bda7683cdbe6971c26cf23e2afdb1e7a8
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 30 Sep 2013 18:21:44 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 4 Oct 2013 15:16:05 -0300

perf probe: Fix to find line information for probe list

Fix to find the correct (as much as possible) line information for
listing probes. Without this fix, perf probe --list action will show
incorrect line information as below;

  probe:getname_flags  (on getname_flags@ksrc/linux-3/fs/namei.c)
  probe:getname_flags_1 (on getname:-89@x86/include/asm/current.h)
  probe:getname_flags_2 (on user_path_at_empty:-2054@x86/include/asm/current.h)

The minus line number is obviously wrong, and current.h is not related
to the probe point. Deeper investigation discovered that there were 2
issues related to this bug, and minor typos too.

The 1st issue is the rack of considering about nested inlined functions,
which causes the wrong (relative) line number.

The 2nd issue is that the dwarf line info is not correct at those
points. It points 14th line of current.h.

Since it seems that the line info includes somewhat unreliable
information, this fixes perf to try to find correct line information
from both of debuginfo and line info as below.

1) Probe address is the entry of a function instance

  In this case, the line is set as the function declared line.

2) Probe address is the entry of an expanded inline function block

  In this case, the line is set as the function call-site line.
  This means that the line number is relative from the entry line
  of caller function (which can be an inlined function if nested)

3) Probe address is inside a function instance or an expanded
   inline function block

  In this case, perf probe queries the line number from lineinfo
  and verify the function declared file is same as the file name
  queried from lineinfo.

  If the file name is different, it is a failure case. The probe
  address is shown as symbol+offset.

4) Probe address is not in the any function instance

  This is a failure case, the probe address is shown as
  symbol+offset.

With this fix, perf probe -l shows correct probe lines as below;

  probe:getname_flags  (on getname_flags@ksrc/linux-3/fs/namei.c)
  probe:getname_flags_1 (on getname:2@ksrc/linux-3/fs/namei.c)
  probe:getname_flags_2 (on user_path_at_empty:4@ksrc/linux-3/fs/namei.c)

Changes at v2:
 - Fix typos in the function comments. (Thanks to Namhyung Kim)
 - Use die_find_top_inlinefunc instead of die_find_inlinefunc_next.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20130930092144.1693.11058.stgit@udc4-manage.rcp.hitachi.co.jp
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dwarf-aux.c    | 25 +++++++++++++++++----
 tools/perf/util/dwarf-aux.h    |  6 +++++-
 tools/perf/util/probe-finder.c | 49 ++++++++++++++++++++++++++++--------------
 3 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index e23bde1..7defd77 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -426,7 +426,7 @@ static int __die_search_func_cb(Dwarf_Die *fn_die, void *data)
  * @die_mem: a buffer for result DIE
  *
  * Search a non-inlined function DIE which includes @addr. Stores the
- * DIE to @die_mem and returns it if found. Returns NULl if failed.
+ * DIE to @die_mem and returns it if found. Returns NULL if failed.
  */
 Dwarf_Die *die_find_realfunc(Dwarf_Die *cu_die, Dwarf_Addr addr,
 				    Dwarf_Die *die_mem)
@@ -454,15 +454,32 @@ static int __die_find_inline_cb(Dwarf_Die *die_mem, void *data)
 }
 
 /**
+ * die_find_top_inlinefunc - Search the top inlined function at given address
+ * @sp_die: a subprogram DIE which including @addr
+ * @addr: target address
+ * @die_mem: a buffer for result DIE
+ *
+ * Search an inlined function DIE which includes @addr. Stores the
+ * DIE to @die_mem and returns it if found. Returns NULL if failed.
+ * Even if several inlined functions are expanded recursively, this
+ * doesn't trace it down, and returns the topmost one.
+ */
+Dwarf_Die *die_find_top_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
+				   Dwarf_Die *die_mem)
+{
+	return die_find_child(sp_die, __die_find_inline_cb, &addr, die_mem);
+}
+
+/**
  * die_find_inlinefunc - Search an inlined function at given address
- * @cu_die: a CU DIE which including @addr
+ * @sp_die: a subprogram DIE which including @addr
  * @addr: target address
  * @die_mem: a buffer for result DIE
  *
  * Search an inlined function DIE which includes @addr. Stores the
- * DIE to @die_mem and returns it if found. Returns NULl if failed.
+ * DIE to @die_mem and returns it if found. Returns NULL if failed.
  * If several inlined functions are expanded recursively, this trace
- * it and returns deepest one.
+ * it down and returns deepest one.
  */
 Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 			       Dwarf_Die *die_mem)
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index 8658d41..b4fe90c 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -79,7 +79,11 @@ extern Dwarf_Die *die_find_child(Dwarf_Die *rt_die,
 extern Dwarf_Die *die_find_realfunc(Dwarf_Die *cu_die, Dwarf_Addr addr,
 				    Dwarf_Die *die_mem);
 
-/* Search an inlined function including given address */
+/* Search the top inlined function including given address */
+extern Dwarf_Die *die_find_top_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
+					  Dwarf_Die *die_mem);
+
+/* Search the deepest inlined function including given address */
 extern Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 				      Dwarf_Die *die_mem);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 371476c..c09e0a9 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1327,8 +1327,8 @@ int debuginfo__find_probe_point(struct debuginfo *self, unsigned long addr,
 				struct perf_probe_point *ppt)
 {
 	Dwarf_Die cudie, spdie, indie;
-	Dwarf_Addr _addr, baseaddr;
-	const char *fname = NULL, *func = NULL, *tmp;
+	Dwarf_Addr _addr = 0, baseaddr = 0;
+	const char *fname = NULL, *func = NULL, *basefunc = NULL, *tmp;
 	int baseline = 0, lineno = 0, ret = 0;
 
 	/* Adjust address with bias */
@@ -1349,27 +1349,36 @@ int debuginfo__find_probe_point(struct debuginfo *self, unsigned long addr,
 	/* Find a corresponding function (name, baseline and baseaddr) */
 	if (die_find_realfunc(&cudie, (Dwarf_Addr)addr, &spdie)) {
 		/* Get function entry information */
-		tmp = dwarf_diename(&spdie);
-		if (!tmp ||
+		func = basefunc = dwarf_diename(&spdie);
+		if (!func ||
 		    dwarf_entrypc(&spdie, &baseaddr) != 0 ||
-		    dwarf_decl_line(&spdie, &baseline) != 0)
+		    dwarf_decl_line(&spdie, &baseline) != 0) {
+			lineno = 0;
 			goto post;
-		func = tmp;
+		}
 
-		if (addr == (unsigned long)baseaddr)
+		if (addr == (unsigned long)baseaddr) {
 			/* Function entry - Relative line number is 0 */
 			lineno = baseline;
-		else if (die_find_inlinefunc(&spdie, (Dwarf_Addr)addr,
-					     &indie)) {
+			fname = dwarf_decl_file(&spdie);
+			goto post;
+		}
+
+		/* Track down the inline functions step by step */
+		while (die_find_top_inlinefunc(&spdie, (Dwarf_Addr)addr,
+						&indie)) {
+			/* There is an inline function */
 			if (dwarf_entrypc(&indie, &_addr) == 0 &&
-			    _addr == addr)
+			    _addr == addr) {
 				/*
 				 * addr is at an inline function entry.
 				 * In this case, lineno should be the call-site
-				 * line number.
+				 * line number. (overwrite lineinfo)
 				 */
 				lineno = die_get_call_lineno(&indie);
-			else {
+				fname = die_get_call_file(&indie);
+				break;
+			} else {
 				/*
 				 * addr is in an inline function body.
 				 * Since lineno points one of the lines
@@ -1377,19 +1386,27 @@ int debuginfo__find_probe_point(struct debuginfo *self, unsigned long addr,
 				 * be the entry line of the inline function.
 				 */
 				tmp = dwarf_diename(&indie);
-				if (tmp &&
-				    dwarf_decl_line(&spdie, &baseline) == 0)
-					func = tmp;
+				if (!tmp ||
+				    dwarf_decl_line(&indie, &baseline) != 0)
+					break;
+				func = tmp;
+				spdie = indie;
 			}
 		}
+		/* Verify the lineno and baseline are in a same file */
+		tmp = dwarf_decl_file(&spdie);
+		if (!tmp || strcmp(tmp, fname) != 0)
+			lineno = 0;
 	}
 
 post:
 	/* Make a relative line number or an offset */
 	if (lineno)
 		ppt->line = lineno - baseline;
-	else if (func)
+	else if (basefunc) {
 		ppt->offset = addr - (unsigned long)baseaddr;
+		func = basefunc;
+	}
 
 	/* Duplicate strings */
 	if (func) {
