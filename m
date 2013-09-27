Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3I0G5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 02:57:15 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58152 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3I0G5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 02:57:13 -0400
Subject: [PATCH -tip ] [BUGFIX] perf probe: Fix to find line information for
 probe list
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 27 Sep 2013 15:57:07 +0900
Message-ID: <20130927065707.17408.36033.stgit@udc4-manage.rcp.hitachi.co.jp>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to find the correct (as much as possible) line information
for listing probes. Without this fix, perf probe --list action
will show incorrect line information as below;

# perf probe getname_flags
# perf probe -l
  probe:getname_flags  (on getname_flags@ksrc/linux-3/fs/namei.c)
  probe:getname_flags_1 (on getname:-89@x86/include/asm/current.h)
  probe:getname_flags_2 (on user_path_at_empty:-2054@x86/include/asm/current.h)

The minus line number is obviously wrong, and current.h is not
related to the probe point. Deeper investigation discovered
that there were 2 issues related to this bug, and minor typos too.

1st issue is the rack of considering about nested inlined
functions, which causes the wrong (relative) line number.
2nd issue is that the dwarf line info is not correct at
those points. It points 14th line of current.h.

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

# perf probe -l
  probe:getname_flags  (on getname_flags@ksrc/linux-3/fs/namei.c)
  probe:getname_flags_1 (on getname:2@ksrc/linux-3/fs/namei.c)
  probe:getname_flags_2 (on user_path_at_empty:4@ksrc/linux-3/fs/namei.c)


Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/util/dwarf-aux.c    |   21 ++++++++++++++++-
 tools/perf/util/dwarf-aux.h    |    6 ++++-
 tools/perf/util/probe-finder.c |   49 +++++++++++++++++++++++++++-------------
 3 files changed, 57 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index e23bde1..21d7c07 100644
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
@@ -454,13 +454,30 @@ static int __die_find_inline_cb(Dwarf_Die *die_mem, void *data)
 }
 
 /**
+ * die_find_inlinefunc_next - Search an inlined function at given address
+ * @cu_die: a CU DIE which including @addr
+ * @addr: target address
+ * @die_mem: a buffer for result DIE
+ *
+ * Search an inlined function DIE which includes @addr. Stores the
+ * DIE to @die_mem and returns it if found. Returns NULL if failed.
+ * Even if several inlined functions are expanded recursively, this
+ * doesn't trace it down, and returns the topmost one.
+ */
+Dwarf_Die *die_find_inlinefunc_next(Dwarf_Die *sp_die, Dwarf_Addr addr,
+				    Dwarf_Die *die_mem)
+{
+	return die_find_child(sp_die, __die_find_inline_cb, &addr, die_mem);
+}
+
+/**
  * die_find_inlinefunc - Search an inlined function at given address
  * @cu_die: a CU DIE which including @addr
  * @addr: target address
  * @die_mem: a buffer for result DIE
  *
  * Search an inlined function DIE which includes @addr. Stores the
- * DIE to @die_mem and returns it if found. Returns NULl if failed.
+ * DIE to @die_mem and returns it if found. Returns NULL if failed.
  * If several inlined functions are expanded recursively, this trace
  * it and returns deepest one.
  */
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index 8658d41..2d951b5 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -79,7 +79,11 @@ extern Dwarf_Die *die_find_child(Dwarf_Die *rt_die,
 extern Dwarf_Die *die_find_realfunc(Dwarf_Die *cu_die, Dwarf_Addr addr,
 				    Dwarf_Die *die_mem);
 
-/* Search an inlined function including given address */
+/* Search a child inlined function including given address */
+extern Dwarf_Die *die_find_inlinefunc_next(Dwarf_Die *sp_die, Dwarf_Addr addr,
+					   Dwarf_Die *die_mem);
+
+/* Search the deepest inlined function including given address */
 extern Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 				      Dwarf_Die *die_mem);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 371476c..6a4141e 100644
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
+		/* Track down the inline functions */
+		while (die_find_inlinefunc_next(&spdie, (Dwarf_Addr)addr,
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


