Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbaK0WU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 17:20:28 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53069 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750784AbaK0WU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 17:20:26 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [Update][PATCH 4/4] PCI / PM: Drop CONFIG_PM_RUNTIME from the PCI core
Date: Thu, 27 Nov 2014 23:41:42 +0100
Message-ID: <1665071.LpcEGj9O01@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2582138.zUe2QZynBg@vostro.rjw.lan>
References: <37310416.jZXoh5nfSC@vostro.rjw.lan> <2582138.zUe2QZynBg@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: PCI / PM: Drop CONFIG_PM_RUNTIME from the PCI core

After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
selected) PM_RUNTIME is always set if PM is set, so quite a few
#ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
depend on CONFIG_PM.

Replace CONFIG_PM_RUNTIME with CONFIG_PM in the PCI core code.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Changelog fixup.

---
 drivers/pci/pci-driver.c |   20 +++++++-------------
 drivers/pci/pci-sysfs.c  |    4 ++--
 drivers/pci/pcie/Kconfig |    2 +-
 3 files changed, 10 insertions(+), 16 deletions(-)

Index: linux-pm/drivers/pci/pcie/Kconfig
===================================================================
--- linux-pm.orig/drivers/pci/pcie/Kconfig
+++ linux-pm/drivers/pci/pcie/Kconfig
@@ -79,4 +79,4 @@ endchoice
 
 config PCIE_PME
 	def_bool y
-	depends on PCIEPORTBUS && PM_RUNTIME
+	depends on PCIEPORTBUS && PM
Index: linux-pm/drivers/pci/pci-driver.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-driver.c
+++ linux-pm/drivers/pci/pci-driver.c
@@ -1104,7 +1104,7 @@ static int pci_pm_restore(struct device
 
 #endif /* !CONFIG_HIBERNATE_CALLBACKS */
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 
 static int pci_pm_runtime_suspend(struct device *dev)
 {
@@ -1200,16 +1200,6 @@ static int pci_pm_runtime_idle(struct de
 	return ret;
 }
 
-#else /* !CONFIG_PM_RUNTIME */
-
-#define pci_pm_runtime_suspend	NULL
-#define pci_pm_runtime_resume	NULL
-#define pci_pm_runtime_idle	NULL
-
-#endif /* !CONFIG_PM_RUNTIME */
-
-#ifdef CONFIG_PM
-
 static const struct dev_pm_ops pci_dev_pm_ops = {
 	.prepare = pci_pm_prepare,
 	.suspend = pci_pm_suspend,
@@ -1231,11 +1221,15 @@ static const struct dev_pm_ops pci_dev_p
 
 #define PCI_PM_OPS_PTR	(&pci_dev_pm_ops)
 
-#else /* !COMFIG_PM_OPS */
+#else /* !CONFIG_PM */
+
+#define pci_pm_runtime_suspend	NULL
+#define pci_pm_runtime_resume	NULL
+#define pci_pm_runtime_idle	NULL
 
 #define PCI_PM_OPS_PTR	NULL
 
-#endif /* !COMFIG_PM_OPS */
+#endif /* !CONFIG_PM */
 
 /**
  * __pci_register_driver - register a new pci driver
Index: linux-pm/drivers/pci/pci-sysfs.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-sysfs.c
+++ linux-pm/drivers/pci/pci-sysfs.c
@@ -385,7 +385,7 @@ static ssize_t dev_bus_rescan_store(stru
 }
 static DEVICE_ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_bus_rescan_store);
 
-#if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
+#if defined(CONFIG_PM) && defined(CONFIG_ACPI)
 static ssize_t d3cold_allowed_store(struct device *dev,
 				    struct device_attribute *attr,
 				    const char *buf, size_t count)
@@ -566,7 +566,7 @@ static struct attribute *pci_dev_attrs[]
 	&dev_attr_enable.attr,
 	&dev_attr_broken_parity_status.attr,
 	&dev_attr_msi_bus.attr,
-#if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
+#if defined(CONFIG_PM) && defined(CONFIG_ACPI)
 	&dev_attr_d3cold_allowed.attr,
 #endif
 #ifdef CONFIG_OF

