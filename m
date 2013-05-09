Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3EIW2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:28:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab3EIW0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Bulkow <David.Bulkow@stratus.com>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 70/73] PCI: Delay final fixups until resources are assigned
Date: Thu,  9 May 2013 15:26:00 -0700
Message-Id: <20130509222533.509798069@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit e253aaf0af51c1e4dc7dd3b26ea8e666bf9a2d8d upstream.

Commit 4f535093cf "PCI: Put pci_dev in device tree as early as possible"
moved final fixups from pci_bus_add_device() to pci_device_add().  But
pci_device_add() happens before resource assignment, so BARs may not be
valid yet.

Typical flow for hot-add:

    pciehp_configure_device
      pci_scan_slot
        pci_scan_single_device
          pci_device_add
            pci_fixup_device(pci_fixup_final, dev)  # previous location
      # resource assignment happens here
      pci_bus_add_devices
        pci_bus_add_device
          pci_fixup_device(pci_fixup_final, dev)    # new location

[bhelgaas: changelog, move fixups to pci_bus_add_device()]
Reference: https://lkml.kernel.org/r/20130415182614.GB9224@xanatos
Reported-by: David Bulkow <David.Bulkow@stratus.com>
Tested-by: David Bulkow <David.Bulkow@stratus.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/bus.c   |    1 +
 drivers/pci/probe.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -174,6 +174,7 @@ int pci_bus_add_device(struct pci_dev *d
 	 * Can not put in pci_device_add yet because resources
 	 * are not assigned yet for some devices.
 	 */
+	pci_fixup_device(pci_fixup_final, dev);
 	pci_create_sysfs_dev_files(dev);
 
 	dev->match_driver = true;
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1339,7 +1339,6 @@ void pci_device_add(struct pci_dev *dev,
 	list_add_tail(&dev->bus_list, &bus->devices);
 	up_write(&pci_bus_sem);
 
-	pci_fixup_device(pci_fixup_final, dev);
 	ret = pcibios_add_device(dev);
 	WARN_ON(ret < 0);
 


