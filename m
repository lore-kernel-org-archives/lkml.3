Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaBHIC0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 03:02:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:46719 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaBHICW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 03:02:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="471776756"
From: Andi Kleen <ak@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 13/17] Kbuild, lto: Handle basic LTO in modpost
Date: Sat,  8 Feb 2014 09:01:17 +0100
Message-Id: <1391846481-31491-13-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391846481-31491-1-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Don't warn about LTO marker symbols. modpost runs before
the linker, so the module is not necessarily LTOed yet.
- Don't complain about .gnu.lto* sections

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/mod/modpost.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f91dd45..63804a1 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -623,7 +623,10 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
 
 	switch (sym->st_shndx) {
 	case SHN_COMMON:
-		warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
+		if (!strncmp(symname, "__gnu_lto_", sizeof("__gnu_lto_")-1)) {
+			/* Should warn here, but modpost runs before the linker */
+		} else
+			warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
 		break;
 	case SHN_UNDEF:
 		/* undefined symbol */
@@ -849,6 +852,7 @@ static const char *section_white_list[] =
 	".xt.lit",         /* xtensa */
 	".arcextmap*",			/* arc */
 	".gnu.linkonce.arcext*",	/* arc : modules */
+	".gnu.lto*",
 	NULL
 };
 
-- 
1.8.5.2

