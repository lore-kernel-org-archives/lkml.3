Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928Ab3DJXND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:13:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937200Ab3DJWrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [ 29/64] PCI/ACPI: Always resume devices on ACPI wakeup notifications
Date: Wed, 10 Apr 2013 15:46:26 -0700
Message-Id: <20130410224339.797464063@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 24ad0ef9c8b946ed2abe681e4e44f4a1e643d882 upstream.

It turns out that the _Lxx control methods provided by some BIOSes
clear the PME Status bit of PCI devices they handle, which means that
pci_acpi_wake_dev() cannot really use that bit to check whether or
not the device has signalled wakeup.

One symptom of the problem is, for example, that when an affected PCI
USB controller is runtime-suspended, then plugging in a new USB device
into one of the controller's ports will not wake up the controller,
which should happen.

For this reason, make pci_acpi_wake_dev() always attempt to resume
the device it is called for regardless of the device's PME Status bit
value (that bit still has to be cleared if set at this point,
though).

Reported-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci-acpi.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -53,14 +53,15 @@ static void pci_acpi_wake_dev(acpi_handl
 		return;
 	}
 
-	if (!pci_dev->pm_cap || !pci_dev->pme_support
-	     || pci_check_pme_status(pci_dev)) {
-		if (pci_dev->pme_poll)
-			pci_dev->pme_poll = false;
+	/* Clear PME Status if set. */
+	if (pci_dev->pme_support)
+		pci_check_pme_status(pci_dev);
 
-		pci_wakeup_event(pci_dev);
-		pm_runtime_resume(&pci_dev->dev);
-	}
+	if (pci_dev->pme_poll)
+		pci_dev->pme_poll = false;
+
+	pci_wakeup_event(pci_dev);
+	pm_runtime_resume(&pci_dev->dev);
 
 	if (pci_dev->subordinate)
 		pci_pme_wakeup_bus(pci_dev->subordinate);


