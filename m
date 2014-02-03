Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaBCHYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 02:24:09 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.164]:30180 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbaBCHYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 02:24:07 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Feb 2014 02:24:07 EST
X-Env-Sender: michael.moese@men.de
X-Msg-Ref: server-12.tower-38.messagelabs.com!1391411820!12479082!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 03 Feb 2014 08:17:01 +0100
From: Michael Moese <michael.moese@men.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: Michael Moese <michael.moese@men.de>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] powerpc: add ioremap_wt
Date: Mon, 3 Feb 2014 08:16:49 +0100
Message-ID: <1391411809-1845-1-git-send-email-michael.moese@men.de>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.6.61]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow for IO memory to be mapped cacheable for performing
PCI read bursts.

Signed-off-by: Michael Moese <michael.moese@men.de>
---
 arch/powerpc/include/asm/io.h | 3 +++
 arch/powerpc/mm/pgtable_32.c  | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index 45698d5..9591fff 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -631,6 +631,8 @@ static inline void iosync(void)
  *
  * * ioremap_wc enables write combining
  *
+ * * ioremap_wc enables write thru
+ *
  * * iounmap undoes such a mapping and can be hooked
  *
  * * __ioremap_at (and the pending __iounmap_at) are low level functions to
@@ -652,6 +654,7 @@ extern void __iomem *ioremap(phys_addr_t address, unsigned long size);
 extern void __iomem *ioremap_prot(phys_addr_t address, unsigned long size,
 				  unsigned long flags);
 extern void __iomem *ioremap_wc(phys_addr_t address, unsigned long size);
+extern void __iomem *ioremap_wt(phys_addr_t address, unsigned long size);
 #define ioremap_nocache(addr, size)	ioremap((addr), (size))
 
 extern void iounmap(volatile void __iomem *addr);
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 51f8795..9ab0a54 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -141,6 +141,14 @@ ioremap_wc(phys_addr_t addr, unsigned long size)
 EXPORT_SYMBOL(ioremap_wc);
 
 void __iomem *
+ioremap_wt(phys_addr_t addr, unsigned long size)
+{
+	return __ioremap_caller(addr, size, _PAGE_WRITETHRU,
+				__builtin_return_address(0));
+}
+EXPORT_SYMBOL(ioremap_wt);
+
+void __iomem *
 ioremap_prot(phys_addr_t addr, unsigned long size, unsigned long flags)
 {
 	/* writeable implies dirty for kernel addresses */
-- 
1.8.5.3

