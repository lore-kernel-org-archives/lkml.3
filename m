Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3JYKcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:32:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52352 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab3JYKcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:32:12 -0400
Date: Fri, 25 Oct 2013 03:31:45 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-3d918a12a1b3088ac16ff37fa52760639d6e2403@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
In-Reply-To: <20131011071025.15557.13275.stgit@udc4-manage.rcp.hitachi.co.jp>
References: <20131011071025.15557.13275.stgit@udc4-manage.rcp.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Find fentry mcount fuzzed parameter location
Git-Commit-ID: 3d918a12a1b3088ac16ff37fa52760639d6e2403
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 25 Oct 2013 03:31:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d918a12a1b3088ac16ff37fa52760639d6e2403
Gitweb:     http://git.kernel.org/tip/3d918a12a1b3088ac16ff37fa52760639d6e2403
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 11 Oct 2013 16:10:26 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Oct 2013 09:55:37 -0300

perf probe: Find fentry mcount fuzzed parameter location

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
index 5a46be9..c044052 100644
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
