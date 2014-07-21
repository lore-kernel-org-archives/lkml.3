Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaGUBAG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 21:00:06 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56206 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750795AbaGUBAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 21:00:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huang Ying <huang.ying.caritas@gmail.com>
Subject: [Update][PATCH] PCI / PM: Allow PCI devices to be put into D3cold during system suspend
Date: Mon, 21 Jul 2014 03:18:24 +0200
Message-ID: <2273188.7kGSSgiQeA@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3331155.XU3LgTaBr4@vostro.rjw.lan>
References: <3331155.XU3LgTaBr4@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Commit 448bd857d48e (PCI/PM: add PCIe runtime D3cold support) added
a check to prevent PCI devices from being put into D3cold during
system suspend without giving any particular reason.

Also the check isn't really necessary, because acpi_pci_set_power_state()
maps PCI_D3hot to ACPI_STATE_D3_COLD anyway.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Ying notices that acpi_pci_set_power_state() maps PCI D3hot to ACPI
D3cold, so the check actually isn't effective even, but that means
that the second part of my original changelog was in fact incorrect.

---
 drivers/pci/pci.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-pm/drivers/pci/pci.c
===================================================================
--- linux-pm.orig/drivers/pci/pci.c
+++ linux-pm/drivers/pci/pci.c
@@ -1907,10 +1907,6 @@ int pci_prepare_to_sleep(struct pci_dev
 	if (target_state == PCI_POWER_ERROR)
 		return -EIO;
 
-	/* D3cold during system suspend/hibernate is not supported */
-	if (target_state > PCI_D3hot)
-		target_state = PCI_D3hot;
-
 	pci_enable_wake(dev, target_state, device_may_wakeup(&dev->dev));
 
 	error = pci_set_power_state(dev, target_state);

