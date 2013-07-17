Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988Ab3GQWzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:55:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56632 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964930Ab3GQWzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rusty Russell <rusty@rustcorp.com.au>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 117/145] module: do percpu allocation after uniqueness check.  No, really!
Date: Wed, 17 Jul 2013 15:47:29 -0700
Message-Id: <1374101277-7915-118-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit 8d8022e8aba85192e937f1f0f7450e256d66ae5c upstream.

v3.8-rc1-5-g1fb9341 was supposed to stop parallel kvm loads exhausting
percpu memory on large machines:

    Now we have a new state MODULE_STATE_UNFORMED, we can insert the
    module into the list (and thus guarantee its uniqueness) before we
    allocate the per-cpu region.

In my defence, it didn't actually say the patch did this.  Just that
we "can".

This patch actually *does* it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Jim Hull <jim.hull@hp.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/module.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index eab0827..af2c7e6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2930,7 +2930,6 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 {
 	/* Module within temporary copy. */
 	struct module *mod;
-	Elf_Shdr *pcpusec;
 	int err;
 
 	mod = setup_load_info(info, flags);
@@ -2945,17 +2944,10 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 	err = module_frob_arch_sections(info->hdr, info->sechdrs,
 					info->secstrings, mod);
 	if (err < 0)
-		goto out;
+		return ERR_PTR(err);
 
-	pcpusec = &info->sechdrs[info->index.pcpu];
-	if (pcpusec->sh_size) {
-		/* We have a special allocation for this section. */
-		err = percpu_modalloc(mod,
-				      pcpusec->sh_size, pcpusec->sh_addralign);
-		if (err)
-			goto out;
-		pcpusec->sh_flags &= ~(unsigned long)SHF_ALLOC;
-	}
+	/* We will do a special allocation for per-cpu sections later. */
+	info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
 
 	/* Determine total sizes, and put offsets in sh_entsize.  For now
 	   this is done generically; there doesn't appear to be any
@@ -2966,17 +2958,22 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 	/* Allocate and move to the final place */
 	err = move_module(mod, info);
 	if (err)
-		goto free_percpu;
+		return ERR_PTR(err);
 
 	/* Module has been copied to its final place now: return it. */
 	mod = (void *)info->sechdrs[info->index.mod].sh_addr;
 	kmemleak_load_module(mod, info);
 	return mod;
+}
 
-free_percpu:
-	percpu_modfree(mod);
-out:
-	return ERR_PTR(err);
+static int alloc_module_percpu(struct module *mod, struct load_info *info)
+{
+	Elf_Shdr *pcpusec = &info->sechdrs[info->index.pcpu];
+	if (!pcpusec->sh_size)
+		return 0;
+
+	/* We have a special allocation for this section. */
+	return percpu_modalloc(mod, pcpusec->sh_size, pcpusec->sh_addralign);
 }
 
 /* mod is no longer valid after this! */
@@ -3196,6 +3193,11 @@ again:
 		add_taint_module(mod, TAINT_FORCED_MODULE);
 #endif
 
+	/* To avoid stressing percpu allocator, do this once we're unique. */
+	err = alloc_module_percpu(mod, info);
+	if (err)
+		goto unlink_mod;
+
 	/* Now module is in final location, initialize linked lists, etc. */
 	err = module_unload_init(mod);
 	if (err)
-- 
1.8.1.2

