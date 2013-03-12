Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab3CLPJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:09:48 -0400
Received: from multi.imgtec.com ([194.200.65.239]:23484 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218Ab3CLPJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:09:47 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Rusty Russell <rusty@rustcorp.com.au>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jonathan Kliegman <kliegs@chromium.org>
Subject: [PATCH 1/1] module: fix symbol versioning with symbol prefixes
Date: Tue, 12 Mar 2013 15:09:24 +0000
Message-ID: <1363100964-29982-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_12_15_09_45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Kliegman <kliegs@chromium.org>
---
This conflicts with Rusty's "CONFIG_SYMBOL_PREFIX: cleanup" patch.

 kernel/module.c       | 3 ++-
 scripts/mod/modpost.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 0925c9a..e64fcce 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1212,7 +1212,8 @@ static inline int check_modstruct_version(Elf_Shdr *sechdrs,
 	if (!find_symbol(MODULE_SYMBOL_PREFIX "module_layout", NULL,
 			 &crc, true, false))
 		BUG();
-	return check_version(sechdrs, versindex, "module_layout", mod, crc,
+	return check_version(sechdrs, versindex,
+			     MODULE_SYMBOL_PREFIX "module_layout", mod, crc,
 			     NULL);
 }
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 78b30c1..b454156 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1934,7 +1934,8 @@ static int add_versions(struct buffer *b, struct module *mod)
 				s->name, mod->name);
 			continue;
 		}
-		buf_printf(b, "\t{ %#8x, \"%s\" },\n", s->crc, s->name);
+		buf_printf(b, "\t{ %#8x, \"%s%s\" },\n", s->crc,
+			   MODULE_SYMBOL_PREFIX, s->name);
 	}
 
 	buf_printf(b, "};\n");
-- 
1.8.1.2


