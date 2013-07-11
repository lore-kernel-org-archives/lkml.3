Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab3GKWUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:20:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab3GKWT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:19:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Jim Hull <jim.hull@hp.com>
Subject: [ 04/15] module: do percpu allocation after uniqueness check.  No, really!
Date: Thu, 11 Jul 2013 15:19:34 -0700
Message-Id: <20130711221256.493148140@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711221255.925669600@linuxfoundation.org>
References: <20130711221255.925669600@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/module.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2939,7 +2939,6 @@ static struct module *layout_and_allocat
 {
 	/* Module within temporary copy. */
 	struct module *mod;
-	Elf_Shdr *pcpusec;
 	int err;
 
 	mod = setup_load_info(info, flags);
@@ -2954,17 +2953,10 @@ static struct module *layout_and_allocat
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
@@ -2975,17 +2967,22 @@ static struct module *layout_and_allocat
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
@@ -3249,6 +3246,11 @@ static int load_module(struct load_info
 	}
 #endif
 
+	/* To avoid stressing percpu allocator, do this once we're unique. */
+	err = alloc_module_percpu(mod, info);
+	if (err)
+		goto unlink_mod;
+
 	/* Now module is in final location, initialize linked lists, etc. */
 	err = module_unload_init(mod);
 	if (err)


