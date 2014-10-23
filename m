Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbaJWLap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:30:45 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46317 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaJWLam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:30:42 -0400
Subject: [PATCH v2 3/5] lib/bug: Use RCU list ops for module_bug_list
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Date: Thu, 23 Oct 2014 15:26:57 -0400
Message-ID: <20141023192657.10463.85983.stgit@localhost.localdomain>
In-Reply-To: <20141023192636.10463.45031.stgit@localhost.localdomain>
References: <20141023192636.10463.45031.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually since module_bug_list should be used in BUG context,
we may not need this. But for someone who want to use this
from normal context, this makes module_bug_list an RCU list.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 kernel/module.c |    5 +++--
 lib/bug.c       |   20 ++++++++++++++------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index bed608b..d596a30 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1850,9 +1850,10 @@ static void free_module(struct module *mod)
 	mutex_lock(&module_mutex);
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
-	/* Wait for RCU synchronizing before releasing mod->list. */
-	synchronize_rcu();
+	/* Remove this module from bug list, this uses list_del_rcu */
 	module_bug_cleanup(mod);
+	/* Wait for RCU synchronizing before releasing mod->list and buglist. */
+	synchronize_rcu();
 	mutex_unlock(&module_mutex);
 
 	/* This may be NULL, but that's OK */
diff --git a/lib/bug.c b/lib/bug.c
index d1d7c78..0c3bd95 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -64,16 +64,22 @@ static LIST_HEAD(module_bug_list);
 static const struct bug_entry *module_find_bug(unsigned long bugaddr)
 {
 	struct module *mod;
+	const struct bug_entry *bug = NULL;
 
-	list_for_each_entry(mod, &module_bug_list, bug_list) {
-		const struct bug_entry *bug = mod->bug_table;
+	rcu_read_lock();
+	list_for_each_entry_rcu(mod, &module_bug_list, bug_list) {
 		unsigned i;
 
+		bug = mod->bug_table;
 		for (i = 0; i < mod->num_bugs; ++i, ++bug)
 			if (bugaddr == bug_addr(bug))
-				return bug;
+				goto out;
 	}
-	return NULL;
+	bug = NULL;
+out:
+	rcu_read_unlock();
+
+	return bug;
 }
 
 void module_bug_finalize(const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs,
@@ -99,13 +105,15 @@ void module_bug_finalize(const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs,
 	 * Strictly speaking this should have a spinlock to protect against
 	 * traversals, but since we only traverse on BUG()s, a spinlock
 	 * could potentially lead to deadlock and thus be counter-productive.
+	 * Thus, this uses RCU to safely manipulate the bug list, since BUG
+	 * must run in non-interruptive state.
 	 */
-	list_add(&mod->bug_list, &module_bug_list);
+	list_add_rcu(&mod->bug_list, &module_bug_list);
 }
 
 void module_bug_cleanup(struct module *mod)
 {
-	list_del(&mod->bug_list);
+	list_del_rcu(&mod->bug_list);
 }
 
 #else


