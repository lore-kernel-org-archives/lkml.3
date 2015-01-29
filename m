Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbbA2HJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:09:44 -0500
Received: from goliath.siemens.de ([192.35.17.28]:33423 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbbA2HJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:09:43 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH v11 28/28] scripts/gdb: Disable pagination while printing from breakpoint handler
Date: Thu, 29 Jan 2015 07:46:47 +0100
Message-Id: <e0dfc0f6e8154aa3d00f1e797d7faa997af092f8.1422514006.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While reporting the (refreshed) list of modules on automatic updates we
may hit the page boundary of the output console and cause a stop if
pagination is enabled. However, gdb does not accept user input while
running over the breakpoint handler. So we get stuck, and the user is
forced to interrupt gdb.

Resolve this by disabling pagination during automatic symbol updates. We
restore the user's configuration once done.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/symbols.py | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/scripts/gdb/linux/symbols.py b/scripts/gdb/linux/symbols.py
index bf05e45..cd5bea9 100644
--- a/scripts/gdb/linux/symbols.py
+++ b/scripts/gdb/linux/symbols.py
@@ -34,12 +34,23 @@ if hasattr(gdb, 'Breakpoint'):
             # enforce update if object file is not found
             cmd.module_files_updated = False
 
+            # Disable pagination while reporting symbol (re-)loading.
+            # The console input is blocked in this context so that we would
+            # get stuck waiting for the user to acknowledge paged output.
+            show_pagination = gdb.execute("show pagination", to_string=True)
+            pagination = show_pagination.endswith("on.\n")
+            gdb.execute("set pagination off")
+
             if module_name in cmd.loaded_modules:
                 gdb.write("refreshing all symbols to reload module "
                           "'{0}'\n".format(module_name))
                 cmd.load_all_symbols()
             else:
                 cmd.load_module_symbols(module)
+
+            # restore pagination state
+            gdb.execute("set pagination %s" % ("on" if pagination else "off"))
+
             return False
 
 
-- 
2.1.4

