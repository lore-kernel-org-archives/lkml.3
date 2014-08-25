Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaHYKzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:55:45 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55762 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbaHYKzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:55:43 -0400
Subject: [RFC PATCH 2/5] module: Unlink module with RCU synchronizing
 instead of stop_machine
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Date: Mon, 25 Aug 2014 10:55:34 +0000
Message-ID: <20140825105534.21089.94907.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140825105520.21089.26870.stgit@kbuild-fedora.novalocal>
References: <20140825105520.21089.26870.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlink module from module list with RCU synchronizing instead
of using stop_machine(). Since module list is already protected
by rcu, we don't need stop_machine() anymore.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 kernel/module.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 4c8a4f1..84b068d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1697,18 +1697,6 @@ static void mod_sysfs_teardown(struct module *mod)
 	mod_sysfs_fini(mod);
 }
 
-/*
- * unlink the module with the whole machine is stopped with interrupts off
- * - this defends against kallsyms not taking locks
- */
-static int __unlink_module(void *_mod)
-{
-	struct module *mod = _mod;
-	list_del(&mod->list);
-	module_bug_cleanup(mod);
-	return 0;
-}
-
 #ifdef CONFIG_DEBUG_SET_MODULE_RONX
 /*
  * LKM RO/NX protection: protect module's text/ro-data
@@ -1858,7 +1846,11 @@ static void free_module(struct module *mod)
 
 	/* Now we can delete it from the lists */
 	mutex_lock(&module_mutex);
-	stop_machine(__unlink_module, mod, NULL);
+	/* Unlink carefully: kallsyms could be walking list. */
+	list_del_rcu(&mod->list);
+	/* Wait for RCU synchronizing before releasing mod->list. */
+	synchronize_rcu();
+	module_bug_cleanup(mod);
 	mutex_unlock(&module_mutex);
 
 	/* This may be NULL, but that's OK */


