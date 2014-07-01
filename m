Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbaGAHmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:42:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:43951 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbaGAHmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:42:09 -0400
From: <Wei.Yang@windriver.com>
To: <mroberto@cpti.cetuc.puc-rio.br>, <rmk+kernel@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <wei.yang@windriver.com>
Subject: [PATCH v1] ARM:sa1100: Remove a redundant spin lock
Date: Tue, 1 Jul 2014 15:41:28 +0800
Message-ID: <1404200488-7809-1-git-send-email-Wei.Yang@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Wei <Wei.Yang@windriver.com>

The pair read/write of accessing pci confiuration space function
has already protected by pci_lock. so remove nano_lock.

Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
---
 arch/arm/mach-sa1100/pci-nanoengine.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/mach-sa1100/pci-nanoengine.c b/arch/arm/mach-sa1100/pci-nanoengine.c
index ff02e2d..b944c99 100644
--- a/arch/arm/mach-sa1100/pci-nanoengine.c
+++ b/arch/arm/mach-sa1100/pci-nanoengine.c
@@ -30,7 +30,6 @@
 #include <mach/nanoengine.h>
 #include <mach/hardware.h>
 
-static DEFINE_SPINLOCK(nano_lock);
 
 static int nanoengine_get_pci_address(struct pci_bus *bus,
 	unsigned int devfn, int where, unsigned long *address)
@@ -52,7 +51,6 @@ static int nanoengine_read_config(struct pci_bus *bus, unsigned int devfn, int w
 {
 	int ret;
 	unsigned long address;
-	unsigned long flags;
 	u32 v;
 
 	/* nanoEngine PCI bridge does not return -1 for a non-existing
@@ -64,15 +62,12 @@ static int nanoengine_read_config(struct pci_bus *bus, unsigned int devfn, int w
 		goto exit_function;
 	}
 
-	spin_lock_irqsave(&nano_lock, flags);
 
 	ret = nanoengine_get_pci_address(bus, devfn, where, &address);
 	if (ret != PCIBIOS_SUCCESSFUL)
 		return ret;
 	v = __raw_readl(address);
 
-	spin_unlock_irqrestore(&nano_lock, flags);
-
 	v >>= ((where & 3) * 8);
 	v &= (unsigned long)(-1) >> ((4 - size) * 8);
 
@@ -86,13 +81,11 @@ static int nanoengine_write_config(struct pci_bus *bus, unsigned int devfn, int
 {
 	int ret;
 	unsigned long address;
-	unsigned long flags;
 	unsigned shift;
 	u32 v;
 
 	shift = (where & 3) * 8;
 
-	spin_lock_irqsave(&nano_lock, flags);
 
 	ret = nanoengine_get_pci_address(bus, devfn, where, &address);
 	if (ret != PCIBIOS_SUCCESSFUL)
@@ -113,8 +106,6 @@ static int nanoengine_write_config(struct pci_bus *bus, unsigned int devfn, int
 	}
 	__raw_writel(v, address);
 
-	spin_unlock_irqrestore(&nano_lock, flags);
-
 	return PCIBIOS_SUCCESSFUL;
 }
 
-- 
1.7.9.5

