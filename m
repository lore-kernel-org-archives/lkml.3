Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab3HRUdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:33:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab3HRUdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, Guenter Roeck <linux@roeck-us.net>
Subject: [ 21/34] MIPS: Rewrite pfn_valid to work in modules, too.
Date: Sun, 18 Aug 2013 13:34:34 -0700
Message-Id: <20130818203301.136443082@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

Upstream commit 8b9232141bf40788cce31f893c13f344ec31ee66.

This fixes:

  MODPOST 393 modules
ERROR: "min_low_pfn" [arch/mips/kvm/kvm.ko] undefined!
make[3]: *** [__modpost] Error 1

It would have been possible to just export min_low_pfn but in the end
pfn_valid should return 1 for any pfn argument for which a struct page
exists so using min_low_pfn was wrong anyway.

[Backport to 3.4 kernel. Applies cleanly on top of current 3.4 patch queue,
and fixes "make ARCH=mips allmodconfig; make ARCH=mips" build problem. - Guenter]

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

 arch/mips/include/asm/page.h |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -175,14 +175,15 @@ typedef struct { unsigned long pgprot; }
 
 #ifdef CONFIG_FLATMEM
 
-#define pfn_valid(pfn)							\
-({									\
-	unsigned long __pfn = (pfn);					\
-	/* avoid <linux/bootmem.h> include hell */			\
-	extern unsigned long min_low_pfn;				\
-									\
-	__pfn >= min_low_pfn && __pfn < max_mapnr;			\
-})
+#ifndef __ASSEMBLY__
+static inline int pfn_valid(unsigned long pfn)
+{
+	/* avoid <linux/mm.h> include hell */
+	extern unsigned long max_mapnr;
+
+	return pfn >= ARCH_PFN_OFFSET && pfn < max_mapnr;
+}
+#endif
 
 #elif defined(CONFIG_SPARSEMEM)
 


