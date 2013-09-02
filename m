Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab3IBIzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:55:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37751 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758395Ab3IBIzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 29/58] MIPS: Rewrite pfn_valid to work in modules, too.
Date: Mon,  2 Sep 2013 09:54:14 +0100
Message-Id: <1378112083-9475-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

commit 8b9232141bf40788cce31f893c13f344ec31ee66 upstream.

This fixes:

  MODPOST 393 modules
ERROR: "min_low_pfn" [arch/mips/kvm/kvm.ko] undefined!
make[3]: *** [__modpost] Error 1

It would have been possible to just export min_low_pfn but in the end
pfn_valid should return 1 for any pfn argument for which a struct page
exists so using min_low_pfn was wrong anyway.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/include/asm/page.h | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index da9bd7d..ccb77ec 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -175,14 +175,13 @@ typedef struct { unsigned long pgprot; } pgprot_t;
 
 #ifdef CONFIG_FLATMEM
 
-#define pfn_valid(pfn)							\
-({									\
-	unsigned long __pfn = (pfn);					\
-	/* avoid <linux/bootmem.h> include hell */			\
-	extern unsigned long min_low_pfn;				\
-									\
-	__pfn >= min_low_pfn && __pfn < max_mapnr;			\
-})
+static inline int pfn_valid(unsigned long pfn)
+{
+	/* avoid <linux/mm.h> include hell */
+	extern unsigned long max_mapnr;
+
+	return pfn >= ARCH_PFN_OFFSET && pfn < max_mapnr;
+}
 
 #elif defined(CONFIG_SPARSEMEM)
 
-- 
1.8.3.2

