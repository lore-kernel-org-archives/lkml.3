Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaILSDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:03:01 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:46887 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaILSC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:02:56 -0400
Subject: [PATCH v1 01/13] PCI: Remove "no hotplug settings from platform"
 warning
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Fri, 12 Sep 2014 12:02:54 -0600
Message-ID: <20140912180254.1630.79691.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We print way too many messages like this:

    pci 0000:00:00.0: no hotplug settings from platform
    pci 0000:00:00.0: using default PCI settings

This usually happens when the platform doesn't supply an ACPI _HPP method,
but the method is optional, so there's no point in warning about it.

Not only are the messages useless, but we call pci_configure_slot() far too
many times, so they're repeated many times.  I'll fix the overuse of
pci_configure_slot() too, but that will wait until the next merge window.

For now, just remove both log messages.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=84391
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/hotplug/pcihp_slot.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pci/hotplug/pcihp_slot.c b/drivers/pci/hotplug/pcihp_slot.c
index e246a10a0d2c..3e36ec8d708a 100644
--- a/drivers/pci/hotplug/pcihp_slot.c
+++ b/drivers/pci/hotplug/pcihp_slot.c
@@ -46,7 +46,6 @@ static void program_hpp_type0(struct pci_dev *dev, struct hpp_type0 *hpp)
 		 */
 		if (pci_is_pcie(dev))
 			return;
-		dev_info(&dev->dev, "using default PCI settings\n");
 		hpp = &pci_default_type0;
 	}
 
@@ -153,7 +152,6 @@ void pci_configure_slot(struct pci_dev *dev)
 {
 	struct pci_dev *cdev;
 	struct hotplug_params hpp;
-	int ret;
 
 	if (!(dev->hdr_type == PCI_HEADER_TYPE_NORMAL ||
 			(dev->hdr_type == PCI_HEADER_TYPE_BRIDGE &&
@@ -163,9 +161,7 @@ void pci_configure_slot(struct pci_dev *dev)
 	pcie_bus_configure_settings(dev->bus);
 
 	memset(&hpp, 0, sizeof(hpp));
-	ret = pci_get_hp_params(dev, &hpp);
-	if (ret)
-		dev_warn(&dev->dev, "no hotplug settings from platform\n");
+	pci_get_hp_params(dev, &hpp);
 
 	program_hpp_type2(dev, hpp.t2);
 	program_hpp_type1(dev, hpp.t1);

