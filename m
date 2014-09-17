Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbaIQVZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:25:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:58305 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249AbaIQVZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:25:49 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        david lerner <dlernerdroid@gmail.com>, linux-perf-user@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/20] perf probe: Do not use dwfl_module_addrsym if dwarf_diename finds symbol name
Date: Wed, 17 Sep 2014 18:24:22 -0300
Message-Id: <1410989063-14207-20-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410989063-14207-1-git-send-email-acme@kernel.org>
References: <1410989063-14207-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Do not use dwfl_module_addrsym if dwarf_diename can find the symbol
name, since dwfl_module_addrsym can be failed on shared libraries.

Without this patch
  ----
  $ perf probe -x ../lib/traceevent/libtraceevent.so -V create_arg_op
  Failed to find symbol at 0x11df1
  Failed to find the address of create_arg_op
    Error: Failed to show vars.
  ----
With this patch
  ----
  $ perf probe -x ../lib/traceevent/libtraceevent.so -V create_arg_op
  Available variables at create_arg_op
          @<create_arg_op+0>
                  enum filter_op_type     btype
                  struct filter_arg*      arg
  ----

This bug was reported on linux-perf-users@vger.kernel.org.

Reported-by: david lerner <dlernerdroid@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: david lerner <dlernerdroid@gmail.com>
Cc: linux-perf-user@vger.kernel.org
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://permalink.gmane.org/gmane.linux.kernel.perf.user/1691
Link: http://lkml.kernel.org/r/20140917084101.3722.25299.stgit@kbuild-f20.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 9c593561aa71..c7918f83b300 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -609,14 +609,18 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, Dwfl_Module *mod,
 		return -EINVAL;
 	}
 
-	/* Get an appropriate symbol from symtab */
-	symbol = dwfl_module_addrsym(mod, paddr, &sym, NULL);
+	symbol = dwarf_diename(sp_die);
 	if (!symbol) {
-		pr_warning("Failed to find symbol at 0x%lx\n",
-			   (unsigned long)paddr);
-		return -ENOENT;
+		/* Try to get the symbol name from symtab */
+		symbol = dwfl_module_addrsym(mod, paddr, &sym, NULL);
+		if (!symbol) {
+			pr_warning("Failed to find symbol at 0x%lx\n",
+				   (unsigned long)paddr);
+			return -ENOENT;
+		}
+		eaddr = sym.st_value;
 	}
-	tp->offset = (unsigned long)(paddr - sym.st_value);
+	tp->offset = (unsigned long)(paddr - eaddr);
 	tp->address = (unsigned long)paddr;
 	tp->symbol = strdup(symbol);
 	if (!tp->symbol)
-- 
1.9.3

