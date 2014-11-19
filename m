Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbaKSQGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:06:46 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46426 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbaKSQFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:05:39 -0500
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, bhelgaas@google.com,
        lorenzo.pieralisi@arm.com, wangyijing@huawei.com, arnd@arndb.de,
        hanjun.guo@linaro.org, Liviu.Dudau@arm.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rjw@rjwysocki.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH 4/6] x86, acpi, pci: mmconfig_{32,64}.c code refactoring - remove code duplication.
Date: Wed, 19 Nov 2014 17:04:49 +0100
Message-Id: <1416413091-13452-5-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmconfig_64.c version is going to be default implementation for arch
agnostic low-level direct PCI config space accessors via MMCONFIG.
However, now it initialize raw_pci_ext_ops pointer which is used in
x86 specific code only. Moreover, mmconfig_32.c is doing the same thing
at the same time.

Move it to mmconfig_shared.c so it becomes common for both and
mmconfig_64.c turns out to be purely arch agnostic.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Tested-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/x86/pci/mmconfig-shared.c | 10 ++++++++--
 arch/x86/pci/mmconfig_32.c     | 10 ++--------
 arch/x86/pci/mmconfig_64.c     |  6 ++----
 include/linux/mmconfig.h       |  4 ++++
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index b397544..e42004c 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -29,6 +29,11 @@
 static bool pci_mmcfg_running_state;
 static bool pci_mmcfg_arch_init_failed;
 
+const struct pci_raw_ops pci_mmcfg = {
+	.read =		pci_mmcfg_read,
+	.write =	pci_mmcfg_write,
+};
+
 static const char *__init pci_mmcfg_e7520(void)
 {
 	u32 win;
@@ -486,9 +491,10 @@ static void __init __pci_mmcfg_init(int early)
 		}
 	}
 
-	if (pci_mmcfg_arch_init())
+	if (pci_mmcfg_arch_init()) {
+		raw_pci_ext_ops = &pci_mmcfg;
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
-	else {
+	} else {
 		free_all_mmcfg();
 		pci_mmcfg_arch_init_failed = true;
 	}
diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index d774672..c0106a6 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -50,7 +50,7 @@ static void pci_exp_set_dev_base(unsigned int base, int bus, int devfn)
 	}
 }
 
-static int pci_mmcfg_read(unsigned int seg, unsigned int bus,
+int pci_mmcfg_read(unsigned int seg, unsigned int bus,
 			  unsigned int devfn, int reg, int len, u32 *value)
 {
 	unsigned long flags;
@@ -89,7 +89,7 @@ err:		*value = -1;
 	return 0;
 }
 
-static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
+int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 			   unsigned int devfn, int reg, int len, u32 value)
 {
 	unsigned long flags;
@@ -126,15 +126,9 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 	return 0;
 }
 
-const struct pci_raw_ops pci_mmcfg = {
-	.read =		pci_mmcfg_read,
-	.write =	pci_mmcfg_write,
-};
-
 int __init pci_mmcfg_arch_init(void)
 {
 	printk(KERN_INFO "PCI: Using MMCONFIG for extended config space\n");
-	raw_pci_ext_ops = &pci_mmcfg;
 	return 1;
 }
 
diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
index 1209596..ff2c50c 100644
--- a/arch/x86/pci/mmconfig_64.c
+++ b/arch/x86/pci/mmconfig_64.c
@@ -25,7 +25,7 @@ static char __iomem *pci_dev_base(unsigned int seg, unsigned int bus, unsigned i
 	return NULL;
 }
 
-static int pci_mmcfg_read(unsigned int seg, unsigned int bus,
+int pci_mmcfg_read(unsigned int seg, unsigned int bus,
 			  unsigned int devfn, int reg, int len, u32 *value)
 {
 	char __iomem *addr;
@@ -59,7 +59,7 @@ err:		*value = -1;
 	return 0;
 }
 
-static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
+int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 			   unsigned int devfn, int reg, int len, u32 value)
 {
 	char __iomem *addr;
@@ -121,8 +121,6 @@ int __init pci_mmcfg_arch_init(void)
 			return 0;
 		}
 
-	raw_pci_ext_ops = &pci_mmcfg;
-
 	return 1;
 }
 
diff --git a/include/linux/mmconfig.h b/include/linux/mmconfig.h
index 6ccd1ee..ae8ec83 100644
--- a/include/linux/mmconfig.h
+++ b/include/linux/mmconfig.h
@@ -43,6 +43,10 @@ int pci_mmcfg_arch_init(void);
 void pci_mmcfg_arch_free(void);
 int pci_mmcfg_arch_map(struct pci_mmcfg_region *cfg);
 void pci_mmcfg_arch_unmap(struct pci_mmcfg_region *cfg);
+int pci_mmcfg_read(unsigned int seg, unsigned int bus,
+		   unsigned int devfn, int reg, int len, u32 *value);
+int pci_mmcfg_write(unsigned int seg, unsigned int bus,
+		    unsigned int devfn, int reg, int len, u32 value);
 
 extern struct list_head pci_mmcfg_list;
 
-- 
1.9.1

