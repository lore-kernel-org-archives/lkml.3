Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbaBROdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:33:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:64994 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030AbaBRO3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:29:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="477060096"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 14/20] Kbuild, lto: Handle basic LTO in modpost
Date: Tue, 18 Feb 2014 15:28:52 +0100
Message-Id: <1392733738-8290-15-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
References: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

- Don't warn about LTO marker symbols. modpost runs before
the linker, so the module is not necessarily LTOed yet.
- Don't complain about .gnu.lto* sections

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/mod/modpost.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index d0fc656..4445f59 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -623,7 +623,11 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
 
 	switch (sym->st_shndx) {
 	case SHN_COMMON:
-		warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
+		if (!strncmp(symname,
+			     "__gnu_lto_", sizeof("__gnu_lto_") - 1)) {
+			/* Should warn here, but modpost runs before the linker */
+		} else
+			warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
 		break;
 	case SHN_UNDEF:
 		/* undefined symbol */
@@ -849,6 +853,7 @@ static const char *section_white_list[] =
 	".xt.lit",         /* xtensa */
 	".arcextmap*",			/* arc */
 	".gnu.linkonce.arcext*",	/* arc : modules */
+	".gnu.lto*",
 	NULL
 };
 
-- 
1.8.5.2

