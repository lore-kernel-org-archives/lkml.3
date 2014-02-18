Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbaBROiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:38:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:27315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989AbaBRO3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:29:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="485209689"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        Joe Mario <jmario@redhat.com>, rusty@rustcorp.com.au,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 05/20] lto: Handle LTO common symbols in module loader
Date: Tue, 18 Feb 2014 15:28:43 +0100
Message-Id: <1392733738-8290-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
References: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Mario <jmario@redhat.com>

Here is the workaround I made for having the kernel not reject modules
built with -flto.  The clean solution would be to get the compiler to not
emit the symbol.  Or if it has to emit the symbol, then emit it as
initialized data but put it into a comdat/linkonce section.

Minor tweaks by AK over Joe's patch.

Cc: rusty@rustcorp.com.au
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/module.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index d24fcf2..b99e801 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1948,6 +1948,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 
 		switch (sym[i].st_shndx) {
 		case SHN_COMMON:
+			/* Ignore common symbols */
+			if (!strncmp(name, "__gnu_lto", 9))
+				break;
+
 			/* We compiled with -fno-common.  These are not
 			   supposed to happen.  */
 			pr_debug("Common symbol: %s\n", name);
-- 
1.8.5.2

