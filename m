Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbaJWLal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:30:41 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56194 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaJWLag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:30:36 -0400
Subject: [PATCH v2 2/5] module: Unlink module with RCU synchronizing instead
 of stop_machine
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Date: Thu, 23 Oct 2014 15:26:50 -0400
Message-ID: <20141023192650.10463.7992.stgit@localhost.localdomain>
In-Reply-To: <20141023192636.10463.45031.stgit@localhost.localdomain>
References: <20141023192636.10463.45031.stgit@localhost.localdomain>
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
index 331b03f..bed608b 100644
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
@@ -1860,7 +1848,11 @@ static void free_module(struct module *mod)
 
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


