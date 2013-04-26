Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923Ab3DZBrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 21:47:52 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33573 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759807Ab3DZBrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 21:47:07 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Bulkow <David.Bulkow@stratus.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI: move down pci_fixup_final for hotplug path
Date: Thu, 25 Apr 2013 18:47:07 -0700
Message-Id: <1366940827-15336-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <5AA430FFE4486C448003201AC83BC85E03DEA379@EXHQ.corp.stratus.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David found some resource conflict issue after
| PCI: Put pci_dev in device tree as early as possible
| commit 4f535093cf8f6da8cfda7c36c2c1ecd2e9586ee4

and
| USB: Fix handoff when BIOS disables host PCI device
| commit: cab928ee1f221c9cc48d6615070fefe2e444384a

for usb qirks for hotplug path.

After checking pci_fixup_device() with pci_fixup_final,
now we have different path for boot path and hotadd path.

Boot path: because pci_apply_fix_final_quirks is not set yet,
	so pci_fixup_device(pci_fixup_final) will be skipped
	from pci_device_add().
        And later pci_apply_final_quirks will be called for all
	pci devices via fs_initcall.
	That is after pci_assign_unassign resource.
	In that case quirk could use bars with problem.

Hotadd path: pci_fixup_device(pci_fixup_final) will be executed
	via pci_device_add(), and that is too early for hotplug
	path, as pci bar for hot add devices is not assigned yet
	after commit 4f535093.

So we need to move down that for hotplug path, call that in
pci_bus_add_devices instead, as at that time just before
drivers get attached. 
And that is simliar calling place for pci_device_add before
commit 4f535093 is applied.

We should apply this fix for v3.9, but is too late now.
so get it into v3.10 and could get into v3.9 stable instead.

Reported-by: David Bulkow <David.Bulkow@stratus.com>
Tested-by: David Bulkow <David.Bulkow@stratus.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/bus.c   |    1 +
 drivers/pci/probe.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/bus.c
+++ linux-2.6/drivers/pci/bus.c
@@ -201,6 +201,7 @@ void pci_bus_add_devices(const struct pc
 		/* Skip already-added devices */
 		if (dev->is_added)
 			continue;
+		pci_fixup_device(pci_fixup_final, dev);
 		retval = pci_bus_add_device(dev);
 		if (retval)
 			dev_err(&dev->dev, "Error adding device (%d)\n",
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1341,7 +1341,6 @@ void pci_device_add(struct pci_dev *dev,
 	list_add_tail(&dev->bus_list, &bus->devices);
 	up_write(&pci_bus_sem);
 
-	pci_fixup_device(pci_fixup_final, dev);
 	ret = pcibios_add_device(dev);
 	WARN_ON(ret < 0);
 
