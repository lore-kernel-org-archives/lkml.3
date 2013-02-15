Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab3BOW4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:56:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab3BOW4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:56:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 3/4] PCI/PM: Clean up PME state when removing a device
Date: Fri, 15 Feb 2013 14:55:52 -0800
Message-Id: <20130215225523.933890685@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130215225523.525656849@linuxfoundation.org>
References: <20130215225523.525656849@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit 249bfb83cf8ba658955f0245ac3981d941f746ee upstream.

Devices are added to pci_pme_list when drivers use pci_enable_wake()
or pci_wake_from_d3(), but they aren't removed from the list unless
the driver explicitly disables wakeup.  Many drivers never disable
wakeup, so their devices remain on the list even after they are
removed, e.g., via hotplug.  A subsequent PME poll will oops when
it tries to touch the device.

This patch disables PME# on a device before removing it, which removes
the device from pci_pme_list.  This is safe even if the device never
had PME# enabled.

This oops can be triggered by unplugging a Thunderbolt ethernet adapter
on a Macbook Pro, as reported by Daniel below.

[bhelgaas: changelog]
Reference: http://lkml.kernel.org/r/CAMVG2svG21yiM1wkH4_2pen2n+cr2-Zv7TbH3Gj+8MwevZjDbw@mail.gmail.com
Reported-and-tested-by: Daniel J Blueman <daniel@quora.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/remove.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -19,6 +19,8 @@ static void pci_free_resources(struct pc
 
 static void pci_stop_dev(struct pci_dev *dev)
 {
+	pci_pme_active(dev, false);
+
 	if (dev->is_added) {
 		pci_proc_detach_device(dev);
 		pci_remove_sysfs_dev_files(dev);


