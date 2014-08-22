Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaHVCTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 22:19:50 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:41284 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbaHVCTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 22:19:48 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...),
        linux-kernel@vger.kernel.org (open list),
        linux-edac@vger.kernel.org (open list:EDAC-CORE)
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] powerpc: edac: Fix build error
Date: Thu, 21 Aug 2014 22:19:51 -0400
Message-Id: <1408673991-17892-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build error:

drivers/edac/ppc4xx_edac.c: In function 'mfsdram':
drivers/edac/ppc4xx_edac.c:249: error: implicit declaration of function
'__mfdcri'
drivers/edac/ppc4xx_edac.c: In function 'mtsdram':
drivers/edac/ppc4xx_edac.c:266: error: implicit declaration of function
'__mtdcri'
drivers/edac/ppc4xx_edac.c:269: warning: 'return' with a value, in function
returning void
drivers/edac/ppc4xx_edac.c: In function 'ppc4xx_edac_init_csrows':
drivers/edac/ppc4xx_edac.c:924: warning: initialization from incompatible
pointer type
drivers/edac/ppc4xx_edac.c:977: error: request for member 'dimm' in something
not a structure or union
drivers/edac/ppc4xx_edac.c: In function 'ppc4xx_edac_map_dcrs':
drivers/edac/ppc4xx_edac.c:1209: warning: passing argument 1 of 'dcr_map_mmio'
discards qualifiers from pointer target type

This driver depends on PPC_DCR_NATIVE to be set for the relevant headers to be
included. Also if PPC_DCR_MMIO=n the build fails. So make PPC_DCR depend on both
these options.

This is compile tested only.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 arch/powerpc/Kconfig       | 6 +++---
 drivers/edac/ppc4xx_edac.c | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 4bc7b62..9b90c1c 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -233,15 +233,15 @@ config ARCH_SUSPEND_POSSIBLE
 
 config PPC_DCR_NATIVE
 	bool
-	default n
+	default y
 
 config PPC_DCR_MMIO
 	bool
-	default n
+	default y
 
 config PPC_DCR
 	bool
-	depends on PPC_DCR_NATIVE || PPC_DCR_MMIO
+	depends on PPC_DCR_NATIVE && PPC_DCR_MMIO
 	default y
 
 config PPC_OF_PLATFORM_PCI
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index ef6b7e0..8725b73 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -246,8 +246,8 @@ static const char * const ppc4xx_plb_masters[9] = {
 static inline u32
 mfsdram(const dcr_host_t *dcr_host, unsigned int idcr_n)
 {
-	return __mfdcri(dcr_host->base + SDRAM_DCR_ADDR_OFFSET,
-			dcr_host->base + SDRAM_DCR_DATA_OFFSET,
+	return __mfdcri(dcr_host->host.native.base + SDRAM_DCR_ADDR_OFFSET,
+			dcr_host->host.native.base + SDRAM_DCR_DATA_OFFSET,
 			idcr_n);
 }
 
@@ -263,8 +263,8 @@ mfsdram(const dcr_host_t *dcr_host, unsigned int idcr_n)
 static inline void
 mtsdram(const dcr_host_t *dcr_host, unsigned int idcr_n, u32 value)
 {
-	return __mtdcri(dcr_host->base + SDRAM_DCR_ADDR_OFFSET,
-			dcr_host->base + SDRAM_DCR_DATA_OFFSET,
+	return __mtdcri(dcr_host->host.native.base + SDRAM_DCR_ADDR_OFFSET,
+			dcr_host->host.native.base + SDRAM_DCR_DATA_OFFSET,
 			idcr_n,
 			value);
 }
-- 
1.9.1

