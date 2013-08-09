Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030392Ab3HICHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:07:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967708Ab3HIB7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [ 070/102] PCI: pciehp: Fix null pointer deref when hot-removing SR-IOV device
Date: Thu,  8 Aug 2013 18:57:46 -0700
Message-Id: <20130809015026.729024516@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 29ed1f29b68a8395d5679b3c4e38352b617b3236 upstream.

Hot-removing a device with SR-IOV enabled causes a null pointer dereference
in v3.9 and v3.10.

This is a regression caused by ba518e3c17 ("PCI: pciehp: Iterate over all
devices in slot, not functions 0-7").  When we iterate over the
bus->devices list, we first remove the PF, which also removes all the VFs
from the list.  Then the list iterator blows up because more than just the
current entry was removed from the list.

ac205b7bb7 ("PCI: make sriov work with hotplug remove") works around a
similar problem in pci_stop_bus_devices() by iterating over the list in
reverse, so the VFs are stopped and removed from the list first, before the
PF.

This patch changes pciehp_unconfigure_device() to iterate over the list in
reverse, too.

[bhelgaas: bugzilla, changelog]
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=60604
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/hotplug/pciehp_pci.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -92,7 +92,14 @@ int pciehp_unconfigure_device(struct slo
 	if (ret)
 		presence = 0;
 
-	list_for_each_entry_safe(dev, temp, &parent->devices, bus_list) {
+	/*
+	 * Stopping an SR-IOV PF device removes all the associated VFs,
+	 * which will update the bus->devices list and confuse the
+	 * iterator.  Therefore, iterate in reverse so we remove the VFs
+	 * first, then the PF.  We do the same in pci_stop_bus_device().
+	 */
+	list_for_each_entry_safe_reverse(dev, temp, &parent->devices,
+					 bus_list) {
 		pci_dev_get(dev);
 		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE && presence) {
 			pci_read_config_byte(dev, PCI_BRIDGE_CONTROL, &bctl);


