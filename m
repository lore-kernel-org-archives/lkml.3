Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab3CNK4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:56:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51853 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022Ab3CNKhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 32/88] xen/pci: We don't do multiple MSI's.
Date: Thu, 14 Mar 2013 10:35:25 +0000
Message-Id: <1363257381-15900-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 884ac2978a295b7df3c4a686d3bff6932bbbb460 upstream.

There is no hypercall to setup multiple MSI per PCI device.
As such with these two new commits:
-  08261d87f7d1b6253ab3223756625a5c74532293
   PCI/MSI: Enable multiple MSIs with pci_enable_msi_block_auto()
- 5ca72c4f7c412c2002363218901eba5516c476b1
   AHCI: Support multiple MSIs

we would call the PHYSDEVOP_map_pirq 'nvec' times with the same
contents of the PCI device. Sander discovered that we would get
the same PIRQ value 'nvec' times and return said values to the
caller. That of course meant that the device was configured only
with one MSI and AHCI would fail with:

ahci 0000:00:11.0: version 3.0
xen: registering gsi 19 triggering 0 polarity 1
xen: --> pirq=19 -> irq=19 (gsi=19)
(XEN) [2013-02-27 19:43:07] IOAPIC[0]: Set PCI routing entry (6-19 -> 0x99 -> IRQ 19 Mode:1 Active:1)
ahci 0000:00:11.0: AHCI 0001.0200 32 slots 4 ports 6 Gbps 0xf impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
ahci: probe of 0000:00:11.0 failed with error -22

That is b/c in ahci_host_activate the second call to
devm_request_threaded_irq  would return -EINVAL as we passed in
(on the second run) an IRQ that was never initialized.

Reported-and-Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/pci/xen.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 56ab749..94e7662 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -162,6 +162,9 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	struct msi_desc *msidesc;
 	int *v;
 
+	if (type == PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
+
 	v = kzalloc(sizeof(int) * max(1, nvec), GFP_KERNEL);
 	if (!v)
 		return -ENOMEM;
@@ -220,6 +223,9 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	struct msi_desc *msidesc;
 	struct msi_msg msg;
 
+	if (type == PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
+
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 		__read_msi_msg(msidesc, &msg);
 		pirq = MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
@@ -263,6 +269,9 @@ static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	int ret = 0;
 	struct msi_desc *msidesc;
 
+	if (type == PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
+
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 		struct physdev_map_pirq map_irq;
 		domid_t domid;
-- 
1.8.1.2

