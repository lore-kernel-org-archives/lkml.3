Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbaIQIlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:41:16 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55182 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbaIQIlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:41:10 -0400
Subject: [PATCH perf/core 2/2] perf probe: Do not use dwfl_module_addrsym if
 dwarf_diename finds symbol name
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-perf-user@vger.kernel.org, david lerner <dlernerdroid@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, yrl.pp-manager.tt@hitachi.com
Date: Wed, 17 Sep 2014 08:41:01 +0000
Message-ID: <20140917084101.3722.25299.stgit@kbuild-f20.novalocal>
In-Reply-To: <20140917084054.3722.73975.stgit@kbuild-f20.novalocal>
References: <20140917084054.3722.73975.stgit@kbuild-f20.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not use dwfl_module_addrsym if dwarf_diename can find
the symbol name, since dwfl_module_addrsym can be failed
on shared libraries.

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
http://permalink.gmane.org/gmane.linux.kernel.perf.user/1691

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: david lerner <dlernerdroid@gmail.com>
---
 tools/perf/util/probe-finder.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 9c59356..c7918f8 100644
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


