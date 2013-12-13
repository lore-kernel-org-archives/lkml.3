Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab3LMQK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:10:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17774 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3LMQKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:10:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        gordan@bobich.net
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [RFC PATCH 4/5] xen/pciback: Move the FLR code to a function.
Date: Fri, 13 Dec 2013 11:09:37 -0500
Message-Id: <1386950978-8628-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
References: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving the bulk of the code its own function to aid
in making the 'xen/pciback: PCI reset slot or bus'
easier.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index b6a856f..4b450c5 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -242,6 +242,24 @@ struct pci_dev *pcistub_get_pci_dev(struct xen_pcibk_device *pdev,
 	return found_dev;
 }
 
+void pcistub_reset_pci_dev(struct pci_dev *dev)
+{
+	/* This is OK - we are running from workqueue context
+	 * and want to inhibit the user from fiddling with 'reset'
+	 */
+
+	dev_dbg(&dev->dev, "resetting (FLR, D3, etc) the device\n");
+
+	pci_reset_function(dev);
+	pci_restore_state(dev);
+
+	/* This disables the device. */
+	xen_pcibk_reset_device(dev);
+
+	/* And cleanup up our emulated fields. */
+	xen_pcibk_config_reset_dev(dev);
+}
+
 void pcistub_put_pci_dev(struct pci_dev *dev)
 {
 	struct pcistub_device *psdev, *found_psdev = NULL;
-- 
1.8.3.1

