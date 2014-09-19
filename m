Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbaISFX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:23:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53083 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaISFXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:23:24 -0400
Date: Thu, 18 Sep 2014 22:23:11 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-664fee3dc37939bb8010906913fa9dbc52abb587@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        dlernerdroid@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        dlernerdroid@gmail.com
In-Reply-To: <20140917084101.3722.25299.stgit@kbuild-f20.novalocal>
References: <20140917084101.3722.25299.stgit@kbuild-f20.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Do not use dwfl_module_addrsym if dwarf_diename finds symbol name
Git-Commit-ID: 664fee3dc37939bb8010906913fa9dbc52abb587
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

Commit-ID:  664fee3dc37939bb8010906913fa9dbc52abb587
Gitweb:     http://git.kernel.org/tip/664fee3dc37939bb8010906913fa9dbc52abb587
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 17 Sep 2014 08:41:01 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 18:01:43 -0300

perf probe: Do not use dwfl_module_addrsym if dwarf_diename finds symbol name

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
