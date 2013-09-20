Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3ITJ5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:57:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42145 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab3ITJ5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:57:05 -0400
Date: Fri, 20 Sep 2013 02:56:40 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-0dbb1cac1dbdddf64cdd0f972c062a26484b7177@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, prashanth@linux.vnet.ibm.com, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, prashanth@linux.vnet.ibm.com, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20120423032435.8737.80064.stgit@localhost.localdomain>
References: <20120423032435.8737.80064.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe:
  Fix finder to find lines of given function
Git-Commit-ID: 0dbb1cac1dbdddf64cdd0f972c062a26484b7177
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 02:56:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0dbb1cac1dbdddf64cdd0f972c062a26484b7177
Gitweb:     http://git.kernel.org/tip/0dbb1cac1dbdddf64cdd0f972c062a26484b7177
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 23 Apr 2012 12:24:36 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Sep 2013 11:35:05 -0300

perf probe: Fix finder to find lines of given function

The commit ba28c59bc9ed8fb7b9a753cd88ee54a2c4f6265b fixed a declaration
entry bug in probe_point_search_cb().  There are same bugs in line
finder and call_probe_finder().  This introduces a new dwarf utility
function to determine given DIE is a function definition, not
declaration.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20120423032435.8737.80064.stgit@localhost.localdomain
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dwarf-aux.c    | 19 +++++++++++++++++++
 tools/perf/util/dwarf-aux.h    |  3 +++
 tools/perf/util/probe-finder.c | 12 +++++-------
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 3e5f543..e23bde1 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -263,6 +263,21 @@ bool die_is_signed_type(Dwarf_Die *tp_die)
 }
 
 /**
+ * die_is_func_def - Ensure that this DIE is a subprogram and definition
+ * @dw_die: a DIE
+ *
+ * Ensure that this DIE is a subprogram and NOT a declaration. This
+ * returns true if @dw_die is a function definition.
+ **/
+bool die_is_func_def(Dwarf_Die *dw_die)
+{
+	Dwarf_Attribute attr;
+
+	return (dwarf_tag(dw_die) == DW_TAG_subprogram &&
+		dwarf_attr(dw_die, DW_AT_declaration, &attr) == NULL);
+}
+
+/**
  * die_get_data_member_location - Get the data-member offset
  * @mb_die: a DIE of a member of a data structure
  * @offs: The offset of the member in the data structure
@@ -392,6 +407,10 @@ static int __die_search_func_cb(Dwarf_Die *fn_die, void *data)
 {
 	struct __addr_die_search_param *ad = data;
 
+	/*
+	 * Since a declaration entry doesn't has given pc, this always returns
+	 * function definition entry.
+	 */
 	if (dwarf_tag(fn_die) == DW_TAG_subprogram &&
 	    dwarf_haspc(fn_die, ad->addr)) {
 		memcpy(ad->die_mem, fn_die, sizeof(Dwarf_Die));
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index 6ce1717..8658d41 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -38,6 +38,9 @@ extern int cu_find_lineinfo(Dwarf_Die *cudie, unsigned long addr,
 extern int cu_walk_functions_at(Dwarf_Die *cu_die, Dwarf_Addr addr,
 			int (*callback)(Dwarf_Die *, void *), void *data);
 
+/* Ensure that this DIE is a subprogram and definition (not declaration) */
+extern bool die_is_func_def(Dwarf_Die *dw_die);
+
 /* Compare diename and tname */
 extern bool die_compare_name(Dwarf_Die *dw_die, const char *tname);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index be03293..20c7299 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -734,7 +734,7 @@ static int call_probe_finder(Dwarf_Die *sc_die, struct probe_finder *pf)
 	}
 
 	/* If not a real subprogram, find a real one */
-	if (dwarf_tag(sc_die) != DW_TAG_subprogram) {
+	if (!die_is_func_def(sc_die)) {
 		if (!die_find_realfunc(&pf->cu_die, pf->addr, &pf->sp_die)) {
 			pr_warning("Failed to find probe point in any "
 				   "functions.\n");
@@ -980,12 +980,10 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 	struct dwarf_callback_param *param = data;
 	struct probe_finder *pf = param->data;
 	struct perf_probe_point *pp = &pf->pev->point;
-	Dwarf_Attribute attr;
 
 	/* Check tag and diename */
-	if (dwarf_tag(sp_die) != DW_TAG_subprogram ||
-	    !die_compare_name(sp_die, pp->function) ||
-	    dwarf_attr(sp_die, DW_AT_declaration, &attr))
+	if (!die_is_func_def(sp_die) ||
+	    !die_compare_name(sp_die, pp->function))
 		return DWARF_CB_OK;
 
 	/* Check declared file */
@@ -1474,7 +1472,7 @@ static int line_range_inline_cb(Dwarf_Die *in_die, void *data)
 	return 0;
 }
 
-/* Search function from function name */
+/* Search function definition from function name */
 static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 {
 	struct dwarf_callback_param *param = data;
@@ -1485,7 +1483,7 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 	if (lr->file && strtailcmp(lr->file, dwarf_decl_file(sp_die)))
 		return DWARF_CB_OK;
 
-	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
+	if (die_is_func_def(sp_die) &&
 	    die_compare_name(sp_die, lr->function)) {
 		lf->fname = dwarf_decl_file(sp_die);
 		dwarf_decl_line(sp_die, &lr->offset);
