Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082AbaIFCDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 22:03:22 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:3640 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaIFCDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 22:03:19 -0400
Subject: [PATCH] MIPS: bugfix of coherentio variable default setup
To: <linux-mips@linux-mips.org>, <nbd@openwrt.org>, <james.hogan@imgtec.com>,
        <jchandra@broadcom.com>, <paul.burton@imgtec.com>,
        <david.daney@cavium.com>, <linux-kernel@vger.kernel.org>,
        <ralf@linux-mips.org>, <markos.chandras@imgtec.com>,
        <macro@linux-mips.org>, <manuel.lauss@gmail.com>,
        <jerinjacobk@gmail.com>, <chenhc@lemote.com>, <blogic@openwrt.org>
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Date: Fri, 5 Sep 2014 19:03:12 -0700
Message-ID: <20140906020312.5192.70037.stgit@linux-yegoshin>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch commit b6d92b4a6bdb880b39789c677b952c53a437028d

    MIPS: Add option to disable software I/O coherency.

    Some MIPS controllers have hardware I/O coherency. This patch
    detects those and turns off software coherency. A new kernel
    command line option also allows the user to manually turn
    software coherency on or off.

in fact enforces L2 cache flushes even on systems with IOCU.
The default value of coherentio is 0 and is not changed even with IOCU.
It is a serious performance problem because it destroys all IOCU performance
advantages.

It is fixed by setting coherentio to tri-state with default value as (-1) and
setup a final value during platform coherency setup.
---
 arch/mips/include/asm/mach-generic/dma-coherence.h |    7 ++++++-
 arch/mips/mm/c-r4k.c                               |    2 +-
 arch/mips/mm/dma-default.c                         |    2 +-
 arch/mips/mti-malta/malta-setup.c                  |    8 ++++++--
 arch/mips/pci/pci-alchemy.c                        |    2 +-
 5 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/mips/include/asm/mach-generic/dma-coherence.h b/arch/mips/include/asm/mach-generic/dma-coherence.h
index 7629c35..b4563df 100644
--- a/arch/mips/include/asm/mach-generic/dma-coherence.h
+++ b/arch/mips/include/asm/mach-generic/dma-coherence.h
@@ -49,7 +49,12 @@ static inline int plat_dma_supported(struct device *dev, u64 mask)
 
 static inline int plat_device_is_coherent(struct device *dev)
 {
-	return coherentio;
+#ifdef CONFIG_DMA_COHERENT
+	return 1;
+#else
+	return (coherentio > 0);
+#endif
+
 }
 
 #ifdef CONFIG_SWIOTLB
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index fbcd867..ad6ff7b 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -1660,7 +1660,7 @@ void r4k_cache_init(void)
 	local_flush_icache_range	= local_r4k_flush_icache_range;
 
 #if defined(CONFIG_DMA_NONCOHERENT) || defined(CONFIG_DMA_MAYBE_COHERENT)
-	if (coherentio) {
+	if (coherentio > 0) {
 		_dma_cache_wback_inv	= (void *)cache_noop;
 		_dma_cache_wback	= (void *)cache_noop;
 		_dma_cache_inv		= (void *)cache_noop;
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index 44b6dff..42c819a 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -24,7 +24,7 @@
 #include <dma-coherence.h>
 
 #ifdef CONFIG_DMA_MAYBE_COHERENT
-int coherentio = 0;	/* User defined DMA coherency from command line. */
+int coherentio = -1;    /* User defined DMA coherency is not defined yet. */
 EXPORT_SYMBOL_GPL(coherentio);
 int hw_coherentio = 0;	/* Actual hardware supported DMA coherency setting. */
 
diff --git a/arch/mips/mti-malta/malta-setup.c b/arch/mips/mti-malta/malta-setup.c
index db7c9e5..48039fd 100644
--- a/arch/mips/mti-malta/malta-setup.c
+++ b/arch/mips/mti-malta/malta-setup.c
@@ -147,13 +147,17 @@ static void __init plat_setup_iocoherency(void)
 	if (plat_enable_iocoherency()) {
 		if (coherentio == 0)
 			pr_info("Hardware DMA cache coherency disabled\n");
-		else
+		else {
+			coherentio = 1;
 			pr_info("Hardware DMA cache coherency enabled\n");
+		}
 	} else {
 		if (coherentio == 1)
 			pr_info("Hardware DMA cache coherency unsupported, but enabled from command line!\n");
-		else
+		else {
+			coherentio = 0;
 			pr_info("Software DMA cache coherency enabled\n");
+		}
 	}
 #else
 	if (!plat_enable_iocoherency())
diff --git a/arch/mips/pci/pci-alchemy.c b/arch/mips/pci/pci-alchemy.c
index c19600a..0d0b6c1 100644
--- a/arch/mips/pci/pci-alchemy.c
+++ b/arch/mips/pci/pci-alchemy.c
@@ -429,7 +429,7 @@ static int alchemy_pci_probe(struct platform_device *pdev)
 
 	/* Au1500 revisions older than AD have borked coherent PCI */
 	if ((alchemy_get_cputype() == ALCHEMY_CPU_AU1500) &&
-	    (read_c0_prid() < 0x01030202) && !coherentio) {
+	    (read_c0_prid() < 0x01030202) && (coherentio <= 0)) {
 		val = __raw_readl(ctx->regs + PCI_REG_CONFIG);
 		val |= PCI_CONFIG_NC;
 		__raw_writel(val, ctx->regs + PCI_REG_CONFIG);

