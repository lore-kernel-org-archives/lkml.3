Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934455Ab3BSSzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:55:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54565 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934432Ab3BSSzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:55:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 79/81] PCI/PM: Clean up PME state when removing a device
Date: Tue, 19 Feb 2013 15:49:42 -0300
Message-Id: <1361299784-8830-80-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/pci/remove.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index fd77e2b..eae55c7 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -19,6 +19,8 @@ static void pci_free_resources(struct pci_dev *dev)
 
 static void pci_stop_dev(struct pci_dev *dev)
 {
+	pci_pme_active(dev, false);
+
 	if (dev->is_added) {
 		pci_proc_detach_device(dev);
 		pci_remove_sysfs_dev_files(dev);
-- 
1.7.9.5

