Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaILSDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:03:08 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36284 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaILSDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:03:03 -0400
Subject: [PATCH v1 02/13] PCI: Move pci_configure_slot() to
 drivers/pci/probe.c
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Fri, 12 Sep 2014 12:03:00 -0600
Message-ID: <20140912180300.1630.62966.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move pci_configure_slot() and related functions from
drivers/pci/hotplug/pcihp_slot to drivers/pci/probe.c.

This is to prepare for doing device configuration during the normal
enumeration process instead of just after hot-add.

No functional change.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/hotplug/Makefile     |    2 
 drivers/pci/hotplug/pcihp_slot.c |  176 --------------------------------------
 drivers/pci/probe.c              |  148 ++++++++++++++++++++++++++++++++
 3 files changed, 149 insertions(+), 177 deletions(-)
 delete mode 100644 drivers/pci/hotplug/pcihp_slot.c

diff --git a/drivers/pci/hotplug/Makefile b/drivers/pci/hotplug/Makefile
index 3e6532b945c1..4a9aa08b08f1 100644
--- a/drivers/pci/hotplug/Makefile
+++ b/drivers/pci/hotplug/Makefile
@@ -24,7 +24,7 @@ obj-$(CONFIG_HOTPLUG_PCI_S390)		+= s390_pci_hpc.o
 
 obj-$(CONFIG_HOTPLUG_PCI_ACPI_IBM)	+= acpiphp_ibm.o
 
-pci_hotplug-objs	:=	pci_hotplug_core.o pcihp_slot.o
+pci_hotplug-objs	:=	pci_hotplug_core.o
 
 ifdef CONFIG_HOTPLUG_PCI_CPCI
 pci_hotplug-objs	+=	cpci_hotplug_core.o	\
diff --git a/drivers/pci/hotplug/pcihp_slot.c b/drivers/pci/hotplug/pcihp_slot.c
deleted file mode 100644
index 3e36ec8d708a..000000000000
--- a/drivers/pci/hotplug/pcihp_slot.c
+++ /dev/null
@@ -1,176 +0,0 @@
-/*
- * Copyright (C) 1995,2001 Compaq Computer Corporation
- * Copyright (C) 2001 Greg Kroah-Hartman (greg@kroah.com)
- * Copyright (C) 2001 IBM Corp.
- * Copyright (C) 2003-2004 Intel Corporation
- * (c) Copyright 2009 Hewlett-Packard Development Company, L.P.
- *
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or (at
- * your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <linux/pci.h>
-#include <linux/export.h>
-#include <linux/pci_hotplug.h>
-
-static struct hpp_type0 pci_default_type0 = {
-	.revision = 1,
-	.cache_line_size = 8,
-	.latency_timer = 0x40,
-	.enable_serr = 0,
-	.enable_perr = 0,
-};
-
-static void program_hpp_type0(struct pci_dev *dev, struct hpp_type0 *hpp)
-{
-	u16 pci_cmd, pci_bctl;
-
-	if (!hpp) {
-		/*
-		 * Perhaps we *should* use default settings for PCIe, but
-		 * pciehp didn't, so we won't either.
-		 */
-		if (pci_is_pcie(dev))
-			return;
-		hpp = &pci_default_type0;
-	}
-
-	if (hpp->revision > 1) {
-		dev_warn(&dev->dev,
-			 "PCI settings rev %d not supported; using defaults\n",
-			 hpp->revision);
-		hpp = &pci_default_type0;
-	}
-
-	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, hpp->cache_line_size);
-	pci_write_config_byte(dev, PCI_LATENCY_TIMER, hpp->latency_timer);
-	pci_read_config_word(dev, PCI_COMMAND, &pci_cmd);
-	if (hpp->enable_serr)
-		pci_cmd |= PCI_COMMAND_SERR;
-	else
-		pci_cmd &= ~PCI_COMMAND_SERR;
-	if (hpp->enable_perr)
-		pci_cmd |= PCI_COMMAND_PARITY;
-	else
-		pci_cmd &= ~PCI_COMMAND_PARITY;
-	pci_write_config_word(dev, PCI_COMMAND, pci_cmd);
-
-	/* Program bridge control value */
-	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
-		pci_write_config_byte(dev, PCI_SEC_LATENCY_TIMER,
-				      hpp->latency_timer);
-		pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &pci_bctl);
-		if (hpp->enable_serr)
-			pci_bctl |= PCI_BRIDGE_CTL_SERR;
-		else
-			pci_bctl &= ~PCI_BRIDGE_CTL_SERR;
-		if (hpp->enable_perr)
-			pci_bctl |= PCI_BRIDGE_CTL_PARITY;
-		else
-			pci_bctl &= ~PCI_BRIDGE_CTL_PARITY;
-		pci_write_config_word(dev, PCI_BRIDGE_CONTROL, pci_bctl);
-	}
-}
-
-static void program_hpp_type1(struct pci_dev *dev, struct hpp_type1 *hpp)
-{
-	if (hpp)
-		dev_warn(&dev->dev, "PCI-X settings not supported\n");
-}
-
-static void program_hpp_type2(struct pci_dev *dev, struct hpp_type2 *hpp)
-{
-	int pos;
-	u32 reg32;
-
-	if (!hpp)
-		return;
-
-	if (hpp->revision > 1) {
-		dev_warn(&dev->dev, "PCIe settings rev %d not supported\n",
-			 hpp->revision);
-		return;
-	}
-
-	/* Initialize Device Control Register */
-	pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
-			~hpp->pci_exp_devctl_and, hpp->pci_exp_devctl_or);
-
-	/* Initialize Link Control Register */
-	if (dev->subordinate)
-		pcie_capability_clear_and_set_word(dev, PCI_EXP_LNKCTL,
-			~hpp->pci_exp_lnkctl_and, hpp->pci_exp_lnkctl_or);
-
-	/* Find Advanced Error Reporting Enhanced Capability */
-	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
-	if (!pos)
-		return;
-
-	/* Initialize Uncorrectable Error Mask Register */
-	pci_read_config_dword(dev, pos + PCI_ERR_UNCOR_MASK, &reg32);
-	reg32 = (reg32 & hpp->unc_err_mask_and) | hpp->unc_err_mask_or;
-	pci_write_config_dword(dev, pos + PCI_ERR_UNCOR_MASK, reg32);
-
-	/* Initialize Uncorrectable Error Severity Register */
-	pci_read_config_dword(dev, pos + PCI_ERR_UNCOR_SEVER, &reg32);
-	reg32 = (reg32 & hpp->unc_err_sever_and) | hpp->unc_err_sever_or;
-	pci_write_config_dword(dev, pos + PCI_ERR_UNCOR_SEVER, reg32);
-
-	/* Initialize Correctable Error Mask Register */
-	pci_read_config_dword(dev, pos + PCI_ERR_COR_MASK, &reg32);
-	reg32 = (reg32 & hpp->cor_err_mask_and) | hpp->cor_err_mask_or;
-	pci_write_config_dword(dev, pos + PCI_ERR_COR_MASK, reg32);
-
-	/* Initialize Advanced Error Capabilities and Control Register */
-	pci_read_config_dword(dev, pos + PCI_ERR_CAP, &reg32);
-	reg32 = (reg32 & hpp->adv_err_cap_and) | hpp->adv_err_cap_or;
-	pci_write_config_dword(dev, pos + PCI_ERR_CAP, reg32);
-
-	/*
-	 * FIXME: The following two registers are not supported yet.
-	 *
-	 *   o Secondary Uncorrectable Error Severity Register
-	 *   o Secondary Uncorrectable Error Mask Register
-	 */
-}
-
-void pci_configure_slot(struct pci_dev *dev)
-{
-	struct pci_dev *cdev;
-	struct hotplug_params hpp;
-
-	if (!(dev->hdr_type == PCI_HEADER_TYPE_NORMAL ||
-			(dev->hdr_type == PCI_HEADER_TYPE_BRIDGE &&
-			(dev->class >> 8) == PCI_CLASS_BRIDGE_PCI)))
-		return;
-
-	pcie_bus_configure_settings(dev->bus);
-
-	memset(&hpp, 0, sizeof(hpp));
-	pci_get_hp_params(dev, &hpp);
-
-	program_hpp_type2(dev, hpp.t2);
-	program_hpp_type1(dev, hpp.t1);
-	program_hpp_type0(dev, hpp.t0);
-
-	if (dev->subordinate) {
-		list_for_each_entry(cdev, &dev->subordinate->devices,
-				    bus_list)
-			pci_configure_slot(cdev);
-	}
-}
-EXPORT_SYMBOL_GPL(pci_configure_slot);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e3cf8a2e6292..5d0cc646817a 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -6,6 +6,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/pci_hotplug.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/cpumask.h>
@@ -1236,6 +1237,153 @@ int pci_setup_device(struct pci_dev *dev)
 	return 0;
 }
 
+static struct hpp_type0 pci_default_type0 = {
+	.revision = 1,
+	.cache_line_size = 8,
+	.latency_timer = 0x40,
+	.enable_serr = 0,
+	.enable_perr = 0,
+};
+
+static void program_hpp_type0(struct pci_dev *dev, struct hpp_type0 *hpp)
+{
+	u16 pci_cmd, pci_bctl;
+
+	if (!hpp) {
+		/*
+		 * Perhaps we *should* use default settings for PCIe, but
+		 * pciehp didn't, so we won't either.
+		 */
+		if (pci_is_pcie(dev))
+			return;
+		hpp = &pci_default_type0;
+	}
+
+	if (hpp->revision > 1) {
+		dev_warn(&dev->dev,
+			 "PCI settings rev %d not supported; using defaults\n",
+			 hpp->revision);
+		hpp = &pci_default_type0;
+	}
+
+	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, hpp->cache_line_size);
+	pci_write_config_byte(dev, PCI_LATENCY_TIMER, hpp->latency_timer);
+	pci_read_config_word(dev, PCI_COMMAND, &pci_cmd);
+	if (hpp->enable_serr)
+		pci_cmd |= PCI_COMMAND_SERR;
+	else
+		pci_cmd &= ~PCI_COMMAND_SERR;
+	if (hpp->enable_perr)
+		pci_cmd |= PCI_COMMAND_PARITY;
+	else
+		pci_cmd &= ~PCI_COMMAND_PARITY;
+	pci_write_config_word(dev, PCI_COMMAND, pci_cmd);
+
+	/* Program bridge control value */
+	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
+		pci_write_config_byte(dev, PCI_SEC_LATENCY_TIMER,
+				      hpp->latency_timer);
+		pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &pci_bctl);
+		if (hpp->enable_serr)
+			pci_bctl |= PCI_BRIDGE_CTL_SERR;
+		else
+			pci_bctl &= ~PCI_BRIDGE_CTL_SERR;
+		if (hpp->enable_perr)
+			pci_bctl |= PCI_BRIDGE_CTL_PARITY;
+		else
+			pci_bctl &= ~PCI_BRIDGE_CTL_PARITY;
+		pci_write_config_word(dev, PCI_BRIDGE_CONTROL, pci_bctl);
+	}
+}
+
+static void program_hpp_type1(struct pci_dev *dev, struct hpp_type1 *hpp)
+{
+	if (hpp)
+		dev_warn(&dev->dev, "PCI-X settings not supported\n");
+}
+
+static void program_hpp_type2(struct pci_dev *dev, struct hpp_type2 *hpp)
+{
+	int pos;
+	u32 reg32;
+
+	if (!hpp)
+		return;
+
+	if (hpp->revision > 1) {
+		dev_warn(&dev->dev, "PCIe settings rev %d not supported\n",
+			 hpp->revision);
+		return;
+	}
+
+	/* Initialize Device Control Register */
+	pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
+			~hpp->pci_exp_devctl_and, hpp->pci_exp_devctl_or);
+
+	/* Initialize Link Control Register */
+	if (dev->subordinate)
+		pcie_capability_clear_and_set_word(dev, PCI_EXP_LNKCTL,
+			~hpp->pci_exp_lnkctl_and, hpp->pci_exp_lnkctl_or);
+
+	/* Find Advanced Error Reporting Enhanced Capability */
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
+	if (!pos)
+		return;
+
+	/* Initialize Uncorrectable Error Mask Register */
+	pci_read_config_dword(dev, pos + PCI_ERR_UNCOR_MASK, &reg32);
+	reg32 = (reg32 & hpp->unc_err_mask_and) | hpp->unc_err_mask_or;
+	pci_write_config_dword(dev, pos + PCI_ERR_UNCOR_MASK, reg32);
+
+	/* Initialize Uncorrectable Error Severity Register */
+	pci_read_config_dword(dev, pos + PCI_ERR_UNCOR_SEVER, &reg32);
+	reg32 = (reg32 & hpp->unc_err_sever_and) | hpp->unc_err_sever_or;
+	pci_write_config_dword(dev, pos + PCI_ERR_UNCOR_SEVER, reg32);
+
+	/* Initialize Correctable Error Mask Register */
+	pci_read_config_dword(dev, pos + PCI_ERR_COR_MASK, &reg32);
+	reg32 = (reg32 & hpp->cor_err_mask_and) | hpp->cor_err_mask_or;
+	pci_write_config_dword(dev, pos + PCI_ERR_COR_MASK, reg32);
+
+	/* Initialize Advanced Error Capabilities and Control Register */
+	pci_read_config_dword(dev, pos + PCI_ERR_CAP, &reg32);
+	reg32 = (reg32 & hpp->adv_err_cap_and) | hpp->adv_err_cap_or;
+	pci_write_config_dword(dev, pos + PCI_ERR_CAP, reg32);
+
+	/*
+	 * FIXME: The following two registers are not supported yet.
+	 *
+	 *   o Secondary Uncorrectable Error Severity Register
+	 *   o Secondary Uncorrectable Error Mask Register
+	 */
+}
+
+void pci_configure_slot(struct pci_dev *dev)
+{
+	struct pci_dev *cdev;
+	struct hotplug_params hpp;
+
+	if (!(dev->hdr_type == PCI_HEADER_TYPE_NORMAL ||
+			(dev->hdr_type == PCI_HEADER_TYPE_BRIDGE &&
+			(dev->class >> 8) == PCI_CLASS_BRIDGE_PCI)))
+		return;
+
+	pcie_bus_configure_settings(dev->bus);
+
+	memset(&hpp, 0, sizeof(hpp));
+	pci_get_hp_params(dev, &hpp);
+
+	program_hpp_type2(dev, hpp.t2);
+	program_hpp_type1(dev, hpp.t1);
+	program_hpp_type0(dev, hpp.t0);
+
+	if (dev->subordinate) {
+		list_for_each_entry(cdev, &dev->subordinate->devices,
+				    bus_list)
+			pci_configure_slot(cdev);
+	}
+}
+EXPORT_SYMBOL_GPL(pci_configure_slot);
 static void pci_release_capabilities(struct pci_dev *dev)
 {
 	pci_vpd_release(dev);

