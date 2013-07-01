Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3GAIxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:53:07 -0400
Received: from ozlabs.org ([203.10.76.45]:34342 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab3GAIxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:53:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chegu Vinod <chegu_vinod@hp.com>, prarit@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Subject: Re: kvm_intel: Could not allocate 42 bytes percpu data
In-Reply-To: <51C897A7.50302@hp.com>
References: <51C897A7.50302@hp.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 01 Jul 2013 15:52:04 +0930
Message-ID: <87ehbisstv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chegu Vinod <chegu_vinod@hp.com> writes:
> Hello,
>
> Lots (~700+) of the following messages are showing up in the dmesg of a 
> 3.10-rc1 based kernel (Host OS is running on a large socket count box 
> with HT-on).
>
> [   82.270682] PERCPU: allocation failed, size=42 align=16, alloc from 
> reserved chunk failed
> [   82.272633] kvm_intel: Could not allocate 42 bytes percpu data

Woah, weird....

Oh.  Shit.  Um, this is embarrassing.

Thanks,
Rusty.
===
module: do percpu allocation after uniqueness check.  No, really!

v3.8-rc1-5-g1fb9341 was supposed to stop parallel kvm loads exhausting
percpu memory on large machines:

    Now we have a new state MODULE_STATE_UNFORMED, we can insert the
    module into the list (and thus guarantee its uniqueness) before we
    allocate the per-cpu region.

In my defence, it didn't actually say the patch did this.  Just that
we "can".

This patch actually *does* it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Noone it seems.

diff --git a/kernel/module.c b/kernel/module.c
index cab4bce..fa53db8 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2927,7 +2927,6 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 {
 	/* Module within temporary copy. */
 	struct module *mod;
-	Elf_Shdr *pcpusec;
 	int err;
 
 	mod = setup_load_info(info, flags);
@@ -2942,17 +2941,10 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
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
@@ -2963,17 +2955,22 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
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
@@ -3237,6 +3234,11 @@ static int load_module(struct load_info *info, const char __user *uargs,
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
