Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3KED13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 22:27:29 -0500
Received: from ozlabs.org ([203.10.76.45]:60762 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab3KED12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 22:27:28 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, <linux-kbuild@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the modules tree
In-Reply-To: <20131104134134.48665968dd006e3310333993@canb.auug.org.au>
References: <20131104134134.48665968dd006e3310333993@canb.auug.org.au>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 05 Nov 2013 12:50:33 +1030
Message-ID: <87fvrba8su.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:
> Hi Rusty,
>
> After merging the modules tree, today's linux-next build (x86_64
> allmodconfig) produced these warning:
>
> WARNING: vmlinux: 'pci_restore_msi_state' exported twice. Previous export was in vmlinux
> WARNING: vmlinux: '__mod_zone_page_state' exported twice. Previous export was in vmlinux
> WARNING: vmlinux: 'scsi_prep_return' exported twice. Previous export was in vmlinux
> WARNING: vmlinux: 'hvc_poll' exported twice. Previous export was in vmlinux
> WARNING: vmlinux: 'nfs_clear_inode' exported twice. Previous export was in vmlinux
>
> (just some samples ... it scrolled off my scrollback :-()
>
> Presumably caused by commit e0f244c63fc9 ("asmlinkage, module: Make
> ksymtab and kcrctab symbols and __this_module __visible").  (reverting
> that commit makes the warnings go away.)

This works for me.... feedback please!

Cheers,
Rusty.

modpost: fix bogus 'exported twice' warnings.

Andi's change in e0f244c63fc9 ("asmlinkage, module: Make ksymtab and
kcrctab symbols and __this_module __visible") make the crc appear
first in the symbol table.

modpost creates an entry when it sees the CRC, then when it sees the
actual symbol, it complains that it's seen it before.  The preloaded
flag already exists for the equivalent case where we loaded from
Module.symvers, so use that.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 9b873ac6ed7b..5c677a3e7487 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -164,7 +164,7 @@ struct symbol {
 	unsigned int vmlinux:1;    /* 1 if symbol is defined in vmlinux */
 	unsigned int kernel:1;     /* 1 if symbol is from kernel
 				    *  (only for external modules) **/
-	unsigned int preloaded:1;  /* 1 if symbol from Module.symvers */
+	unsigned int preloaded:1;  /* 1 if symbol from Module.symvers, or crc */
 	enum export  export;       /* Type of export */
 	char name[0];
 };
@@ -332,8 +332,11 @@ static void sym_update_crc(const char *name, struct module *mod,
 {
 	struct symbol *s = find_symbol(name);
 
-	if (!s)
+	if (!s) {
 		s = new_symbol(name, mod, export);
+		/* Don't complain when we find it later. */
+		s->preloaded = 1;
+	}
 	s->crc = crc;
 	s->crc_valid = 1;
 }
