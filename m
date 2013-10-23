Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3JWU63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 16:58:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55380 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3JWU61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 16:58:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/16] perf probe: Find fentry mcount fuzzed parameter location
Date: Wed, 23 Oct 2013 17:58:04 -0300
Message-Id: <1382561895-8237-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382561895-8237-1-git-send-email-acme@infradead.org>
References: <1382561895-8237-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

At this point, --fentry (mcount function entry) option for gcc fuzzes
the debuginfo variable locations by skipping the mcount instruction
offset (on x86, this is a 5 byte call instruction).

This makes variable searching fail at the entry of functions which
are mcount'ed.

e.g.)
Available variables at vfs_read
        @<vfs_read+0>
                (No matched variables)

This patch adds additional location search at the function entry point
to solve this issue, which tries to find the earliest address for the
variable location.

Note that this only works with function parameters (formal parameters)
because any local variables should not exist on the function entry
address (those are not initialized yet).

With this patch, perf probe shows correct parameters if possible;
 # perf probe --vars vfs_read
 Available variables at vfs_read
         @<vfs_read+0>
                 char*   buf
                 loff_t* pos
                 size_t  count
                 struct file*    file

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20131011071025.15557.13275.stgit@udc4-manage.rcp.hitachi.co.jp
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5a46be968c0b..c04405296e5b 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -273,12 +273,15 @@ static struct probe_trace_arg_ref *alloc_trace_arg_ref(long offs)
 /*
  * Convert a location into trace_arg.
  * If tvar == NULL, this just checks variable can be converted.
+ * If fentry == true and vr_die is a parameter, do huristic search
+ * for the location fuzzed by function entry mcount.
  */
 static int convert_variable_location(Dwarf_Die *vr_die, Dwarf_Addr addr,
-				     Dwarf_Op *fb_ops,
+				     Dwarf_Op *fb_ops, Dwarf_Die *sp_die,
 				     struct probe_trace_arg *tvar)
 {
 	Dwarf_Attribute attr;
+	Dwarf_Addr tmp = 0;
 	Dwarf_Op *op;
 	size_t nops;
 	unsigned int regn;
@@ -291,12 +294,29 @@ static int convert_variable_location(Dwarf_Die *vr_die, Dwarf_Addr addr,
 		goto static_var;
 
 	/* TODO: handle more than 1 exprs */
-	if (dwarf_attr(vr_die, DW_AT_location, &attr) == NULL ||
-	    dwarf_getlocation_addr(&attr, addr, &op, &nops, 1) <= 0 ||
-	    nops == 0) {
-		/* TODO: Support const_value */
+	if (dwarf_attr(vr_die, DW_AT_location, &attr) == NULL)
+		return -EINVAL;	/* Broken DIE ? */
+	if (dwarf_getlocation_addr(&attr, addr, &op, &nops, 1) <= 0) {
+		ret = dwarf_entrypc(sp_die, &tmp);
+		if (ret || addr != tmp ||
+		    dwarf_tag(vr_die) != DW_TAG_formal_parameter ||
+		    dwarf_highpc(sp_die, &tmp))
+			return -ENOENT;
+		/*
+		 * This is fuzzed by fentry mcount. We try to find the
+		 * parameter location at the earliest address.
+		 */
+		for (addr += 1; addr <= tmp; addr++) {
+			if (dwarf_getlocation_addr(&attr, addr, &op,
+						   &nops, 1) > 0)
+				goto found;
+		}
 		return -ENOENT;
 	}
+found:
+	if (nops == 0)
+		/* TODO: Support const_value */
+		return -ENOENT;
 
 	if (op->atom == DW_OP_addr) {
 static_var:
@@ -600,7 +620,7 @@ static int convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 		 dwarf_diename(vr_die));
 
 	ret = convert_variable_location(vr_die, pf->addr, pf->fb_ops,
-					pf->tvar);
+					&pf->sp_die, pf->tvar);
 	if (ret == -ENOENT)
 		pr_err("Failed to find the location of %s at this address.\n"
 		       " Perhaps, it has been optimized out.\n", pf->pvar->var);
@@ -1148,13 +1168,15 @@ struct local_vars_finder {
 static int copy_variables_cb(Dwarf_Die *die_mem, void *data)
 {
 	struct local_vars_finder *vf = data;
+	struct probe_finder *pf = vf->pf;
 	int tag;
 
 	tag = dwarf_tag(die_mem);
 	if (tag == DW_TAG_formal_parameter ||
 	    tag == DW_TAG_variable) {
 		if (convert_variable_location(die_mem, vf->pf->addr,
-					      vf->pf->fb_ops, NULL) == 0) {
+					      vf->pf->fb_ops, &pf->sp_die,
+					      NULL) == 0) {
 			vf->args[vf->nargs].var = (char *)dwarf_diename(die_mem);
 			if (vf->args[vf->nargs].var == NULL) {
 				vf->ret = -ENOMEM;
@@ -1302,7 +1324,8 @@ static int collect_variables_cb(Dwarf_Die *die_mem, void *data)
 	if (tag == DW_TAG_formal_parameter ||
 	    tag == DW_TAG_variable) {
 		ret = convert_variable_location(die_mem, af->pf.addr,
-						af->pf.fb_ops, NULL);
+						af->pf.fb_ops, &af->pf.sp_die,
+						NULL);
 		if (ret == 0) {
 			ret = die_get_varname(die_mem, buf, MAX_VAR_LEN);
 			pr_debug2("Add new var: %s\n", buf);
-- 
1.8.1.4

