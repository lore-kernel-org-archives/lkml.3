Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab3EGN5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:57:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933434Ab3EGN5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:57:03 -0400
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Li Zefan <lizefan@huawei.com>,
        Libo Chen <libo.chen@huawei.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] menuconfig: fix NULL pointer dereference when searching a symbol
Date: Tue,  7 May 2013 15:56:54 +0200
Message-Id: <1367935014-25455-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>

Searching PPC_EFIKA results segmentation fault, and it's because
get_symbol_prop() returns NULL.

In this case CONFIG_PPC_EFIKA is defined in arch/powerpc/platforms/
52xx/Kconfig, so it won't be parsed if ARCH!=PPC, but menuconfig
knows this symbol when it parses sound/soc/fsl/Kconfig:

config SND_MPC52xx_SOC_EFIKA
        tristate "SoC AC97 Audio support for bbplan Efika and STAC9766"
        depends on PPC_EFIKA

This bug was introduced by commit bcdedcc1afd6 ("menuconfig: print more
info for symbol without prompts").

Reported-and-tested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Tested-by: Libo Chen <libo.chen@huawei.com>
Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---

This is a fix for a commit that is not in my kconfig branch, therefore
I am sending it directly.

Michal

---
 scripts/kconfig/menu.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 826da66..b5c7d90 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -600,14 +600,18 @@ void get_symbol_str(struct gstr *r, struct symbol *sym,
 	}
 	for_all_prompts(sym, prop)
 		get_prompt_str(r, prop, head);
+
 	prop = get_symbol_prop(sym);
-	str_printf(r, _("  Defined at %s:%d\n"), prop->menu->file->name,
-		prop->menu->lineno);
-	if (!expr_is_yes(prop->visible.expr)) {
-		str_append(r, _("  Depends on: "));
-		expr_gstr_print(prop->visible.expr, r);
-		str_append(r, "\n");
+	if (prop) {
+		str_printf(r, _("  Defined at %s:%d\n"), prop->menu->file->name,
+			prop->menu->lineno);
+		if (!expr_is_yes(prop->visible.expr)) {
+			str_append(r, _("  Depends on: "));
+			expr_gstr_print(prop->visible.expr, r);
+			str_append(r, "\n");
+		}
 	}
+
 	hit = false;
 	for_all_properties(sym, prop, P_SELECT) {
 		if (!hit) {
-- 
1.8.2.1

