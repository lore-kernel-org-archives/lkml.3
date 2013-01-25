Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab3AYWtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:49:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58496 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3AYWpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:45:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 02/19] ARM: disable virt_to_bus/virt_to_bus almost everywhere
Date: Fri, 25 Jan 2013 22:44:01 +0000
Message-Id: <1359153858-31992-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:sX8sl3KU6Y3d6Hw/3q7PPZpPwFsPWI8nsUDvnoe22Ai
 C2z2Jht04wuzmQZrPJbVAiIa8Z8Z3AAmOVtgCSKRWfbTrBR9tT
 h0zStmuZK08571Q06SoMZS07Dq2kz2HVWUcMXNd4vAUJcbmon7
 zuJln4zn+dw6Pko2N1p0RBqSVSpIaZWA7yGplqixteICVUV00X
 oXvdbiz2eRYvBx2j+S1+AYicMvOWABjqgjinSBkvfUYtiTAUC7
 MuH+HvHss7IPAowuyKpSqlL9Rlr6EI7h4BDoc8HtqZn46j1Wlh
 ThZzSpV/hQ22xF8TOzvZ5TBaTfzeGNa9yzt4RIxSk8KZWcsh/q
 pgvXewv1R8LevZOkghr3r1+kLZV41mflu5kk6BH3d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are getting a number of warnings about the use of the deprecated
bus_to_virt function in drivers using the ARM ISA DMA API:

drivers/parport/parport_pc.c: In function 'parport_pc_fifo_write_block_dma':
drivers/parport/parport_pc.c:622:3: warning: 'bus_to_virt' is deprecated
(declared at arch/arm/include/asm/memory.h:253) [-Wdeprecated-declarations]

This is only because that function gets used by the inline
set_dma_addr() helper. We know that any driver for the ISA DMA API
is correctly using the DMA addresses, so we can change this
to use the __bus_to_virt() function instead, which does not warn.

After this, there are no remaining drivers that are used on
any defconfigs on ARM using virt_to_bus or bus_to_virt, with
the exception of the OSS sound driver. That driver is only used
on RiscPC, NetWinder and Shark, so we can set ARCH_NO_VIRT_TO_BUS
on all other platforms and hide the deprecated functions, which
is far more effective than marking them as deprecated, in order
to avoid any new users of that code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/Kconfig                 | 4 ++++
 arch/arm/configs/shark_defconfig | 1 -
 arch/arm/include/asm/dma.h       | 2 +-
 arch/arm/include/asm/memory.h    | 2 ++
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 67874b8..91d4aea 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1450,6 +1450,10 @@ config ISA_DMA
 	bool
 	select ISA_DMA_API
 
+config ARCH_NO_VIRT_TO_BUS
+	def_bool y
+	depends on !ARCH_RPC && !ARCH_NETWINDER && !ARCH_SHARK
+
 # Select ISA DMA interface
 config ISA_DMA_API
 	bool
diff --git a/arch/arm/configs/shark_defconfig b/arch/arm/configs/shark_defconfig
index caa07db..e319b2c 100644
--- a/arch/arm/configs/shark_defconfig
+++ b/arch/arm/configs/shark_defconfig
@@ -73,7 +73,6 @@ CONFIG_PARTITION_ADVANCED=y
 CONFIG_NLS_CODEPAGE_437=m
 CONFIG_NLS_CODEPAGE_850=m
 CONFIG_NLS_ISO8859_1=m
-# CONFIG_ENABLE_WARN_DEPRECATED is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_SCHED_DEBUG is not set
diff --git a/arch/arm/include/asm/dma.h b/arch/arm/include/asm/dma.h
index 5694a0d..58b8c6a 100644
--- a/arch/arm/include/asm/dma.h
+++ b/arch/arm/include/asm/dma.h
@@ -105,7 +105,7 @@ extern void set_dma_sg(unsigned int chan, struct scatterlist *sg, int nr_sg);
  */
 extern void __set_dma_addr(unsigned int chan, void *addr);
 #define set_dma_addr(chan, addr)				\
-	__set_dma_addr(chan, bus_to_virt(addr))
+	__set_dma_addr(chan, (void *)__bus_to_virt(addr))
 
 /* Set the DMA byte count for this channel
  *
diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 73cf03a..b11105c 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -245,6 +245,7 @@ static inline void *phys_to_virt(phys_addr_t x)
 #define __bus_to_pfn(x)	__phys_to_pfn(x)
 #endif
 
+#ifdef CONFIG_VIRT_TO_BUS
 static inline __deprecated unsigned long virt_to_bus(void *x)
 {
 	return __virt_to_bus((unsigned long)x);
@@ -254,6 +255,7 @@ static inline __deprecated void *bus_to_virt(unsigned long x)
 {
 	return (void *)__bus_to_virt(x);
 }
+#endif
 
 /*
  * Conversion between a struct page and a physical address.
-- 
1.8.0

