Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab3CNGpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 02:45:21 -0400
Received: from ozlabs.org ([203.10.76.45]:41493 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab3CNGpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 02:45:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Kliegman <kliegs@chromium.org>
Subject: Re: [PATCH 1/1] module: fix symbol versioning with symbol prefixes
In-Reply-To: <1363100964-29982-1-git-send-email-james.hogan@imgtec.com>
References: <1363100964-29982-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 14 Mar 2013 10:21:19 +1030
Message-ID: <8738vyvoy0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Hogan <james.hogan@imgtec.com> writes:
> Fix symbol versioning on architectures with symbol prefixes. Although
> the build was free from warnings the actual modules still wouldn't load
> as the ____versions table contained unprefixed symbol names, which were
> being compared against the prefixed symbol names when checking the
> symbol versions.
>
> This is fixed by modifying modpost to add the symbol prefix to the
> ____versions table it outputs (Modules.symvers still contains unprefixed
> symbol names). The check_modstruct_version() function is also fixed as
> it checks the version of the unprefixed "module_layout" symbol which
> would no longer work.

Hmm, this has always been broken, right?  And noone noticed?  Unless you
really want it now, I'll queue it for *next* merge window.

I've applied it (reworked) to my pending-rebases queue, and will put it
in modules-next once the cleanup goes in.

Thanks,
Rusty.

From: James Hogan <james.hogan@imgtec.com>
Subject: module: fix symbol versioning with symbol prefixes

Fix symbol versioning on architectures with symbol prefixes. Although
the build was free from warnings the actual modules still wouldn't load
as the ____versions table contained unprefixed symbol names, which were
being compared against the prefixed symbol names when checking the
symbol versions.

This is fixed by modifying modpost to add the symbol prefix to the
____versions table it outputs (Modules.symvers still contains unprefixed
symbol names). The check_modstruct_version() function is also fixed as
it checks the version of the unprefixed "module_layout" symbol which
would no longer work.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Kliegman <kliegs@chromium.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (updated for cleanup)

diff --git a/kernel/module.c b/kernel/module.c
index cfd4a3f..3c2c72d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1212,7 +1212,8 @@ static inline int check_modstruct_version(Elf_Shdr *sechdrs,
 	if (!find_symbol(VMLINUX_SYMBOL_STR(module_layout), NULL,
 			 &crc, true, false))
 		BUG();
-	return check_version(sechdrs, versindex, "module_layout", mod, crc,
+	return check_version(sechdrs, versindex,
+			     VMLINUX_SYMBOL_STR(module_layout), mod, crc,
 			     NULL);
 }
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 6985021..909b5e7 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1927,7 +1927,8 @@ static int add_versions(struct buffer *b, struct module *mod)
 				s->name, mod->name);
 			continue;
 		}
-		buf_printf(b, "\t{ %#8x, \"%s\" },\n", s->crc, s->name);
+		buf_printf(b, "\t{ %#8x, \"%s%s\" },\n", s->crc,
+			   VMLINUX_SYMBOL_PREFIX_STR, s->name);
 	}
 
 	buf_printf(b, "};\n");
