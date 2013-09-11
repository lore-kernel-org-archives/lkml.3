Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3IKKcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:32:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34656 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750988Ab3IKKcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:32:11 -0400
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        sparclinux@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH] sparc: fix MSI build failure on Sparc32
Date: Wed, 11 Sep 2013 12:32:05 +0200
Message-Id: <1378895525-23772-1-git-send-email-thomas.petazzoni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <522D1DAE.5010100@roeck-us.net>
References: <522D1DAE.5010100@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ebd97be635 ('PCI: remove ARCH_SUPPORTS_MSI kconfig option')
removes the ARCH_SUPPORTS_MSI Kconfig option that allowed
architectures to indicate whether they support PCI MSI or not. Now,
PCI MSI support can be compiled in on any architecture thanks to the
use of weak functions thanks to 4287d824f265 ('PCI: use weak functions
for MSI arch-specific functions').

So, architecture specific code is now responsible to ensure that its
PCI MSI code builds in all cases, or be appropriately conditionally
compiled.

On Sparc, the MSI support is only provided for Sparc64, so the
ARCH_SUPPORTS_MSI kconfig option was only selected for SPARC64, and
not for the Sparc architecture as a whole. Therefore, removing
ARCH_SUPPORTS_MSI broke Sparc32 configurations with CONFIG_PCI_MSI=y,
because the Sparc-specific MSI code is not designed to be built on
Sparc32.

To solve this, this commit ensures that the Sparc MSI code is only
built on Sparc64. This is done thanks to a new Kconfig Makefile helper
option SPARC64_PCI_MSI, modeled after the existing SPARC64_PCI. The
SPARC64_PCI_MSI option is an hidden option that is true when both
Sparc64 PCI support is enabled and MSI is enabled. The
arch/sparc/kernel/pci_msi.c file is now only built when
SPARC64_PCI_MSI is true.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/sparc/Kconfig         | 7 ++++++-
 arch/sparc/kernel/Makefile | 3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 1570ad2..a284efa 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -507,12 +507,17 @@ config SUN_OPENPROMFS
 	  Only choose N if you know in advance that you will not need to modify
 	  OpenPROM settings on the running system.
 
-# Makefile helper
+# Makefile helpers
 config SPARC64_PCI
 	bool
 	default y
 	depends on SPARC64 && PCI
 
+config SPARC64_PCI_MSI
+	bool
+	default y
+	depends on SPARC64_PCI && PCI_MSI
+
 endmenu
 
 menu "Executable file formats"
diff --git a/arch/sparc/kernel/Makefile b/arch/sparc/kernel/Makefile
index d432fb2..d15cc17 100644
--- a/arch/sparc/kernel/Makefile
+++ b/arch/sparc/kernel/Makefile
@@ -1,3 +1,4 @@
+
 #
 # Makefile for the linux kernel.
 #
@@ -99,7 +100,7 @@ obj-$(CONFIG_STACKTRACE)     += stacktrace.o
 obj-$(CONFIG_SPARC64_PCI)    += pci.o pci_common.o psycho_common.o
 obj-$(CONFIG_SPARC64_PCI)    += pci_psycho.o pci_sabre.o pci_schizo.o
 obj-$(CONFIG_SPARC64_PCI)    += pci_sun4v.o pci_sun4v_asm.o pci_fire.o
-obj-$(CONFIG_PCI_MSI)        += pci_msi.o
+obj-$(CONFIG_SPARC64_PCI_MSI) += pci_msi.o
 
 obj-$(CONFIG_COMPAT)         += sys32.o sys_sparc32.o signal32.o
 
-- 
1.8.1.2

