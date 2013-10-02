Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3JBL70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:59:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab3JBL7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:59:22 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        devel@linuxdriverproject.org (open list:Hyper-V CORE AND...),
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] hyperv-fb: add pci stub
Date: Wed,  2 Oct 2013 13:55:10 +0200
Message-Id: <1380714911-6254-1-git-send-email-kraxel@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a pci stub driver to hyper-fb.  The hyperv framebuffer
driver will bind to the pci device then, so linux kernel and userspace
know there is a proper kernel driver for the device active.  lspci shows
this for example:

[root@dhcp231 ~]# lspci -vs8
00:08.0 VGA compatible controller: Microsoft Corporation Hyper-V virtual
VGA (prog-if 00 [VGA controller])
        Flags: bus master, fast devsel, latency 0, IRQ 11
        Memory at f8000000 (32-bit, non-prefetchable) [size=64M]
        Expansion ROM at <unassigned> [disabled]
        Kernel driver in use: hyperv_fb

Another effect is that the xorg vesa driver will not attach to the
device and thus the Xorg server will automatically use the fbdev
driver instead.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/video/hyperv_fb.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c
index 8ac99b8..8d456dc 100644
--- a/drivers/video/hyperv_fb.c
+++ b/drivers/video/hyperv_fb.c
@@ -795,12 +795,21 @@ static int hvfb_remove(struct hv_device *hdev)
 }
 
 
+static DEFINE_PCI_DEVICE_TABLE(pci_stub_id_table) = {
+	{
+		.vendor      = PCI_VENDOR_ID_MICROSOFT,
+		.device      = PCI_DEVICE_ID_HYPERV_VIDEO,
+	},
+	{ /* end of list */ }
+};
+
 static const struct hv_vmbus_device_id id_table[] = {
 	/* Synthetic Video Device GUID */
 	{HV_SYNTHVID_GUID},
 	{}
 };
 
+MODULE_DEVICE_TABLE(pci, pci_stub_id_table);
 MODULE_DEVICE_TABLE(vmbus, id_table);
 
 static struct hv_driver hvfb_drv = {
@@ -810,14 +819,43 @@ static struct hv_driver hvfb_drv = {
 	.remove = hvfb_remove,
 };
 
+static int hvfb_pci_stub_probe(struct pci_dev *pdev,
+			       const struct pci_device_id *ent)
+{
+	return 0;
+}
+
+static void hvfb_pci_stub_remove(struct pci_dev *pdev)
+{
+}
+
+static struct pci_driver hvfb_pci_stub_driver = {
+	.name =		KBUILD_MODNAME,
+	.id_table =	pci_stub_id_table,
+	.probe =	hvfb_pci_stub_probe,
+	.remove =	hvfb_pci_stub_remove,
+};
 
 static int __init hvfb_drv_init(void)
 {
-	return vmbus_driver_register(&hvfb_drv);
+	int ret;
+
+	ret = vmbus_driver_register(&hvfb_drv);
+	if (ret != 0)
+		return ret;
+
+	ret = pci_register_driver(&hvfb_pci_stub_driver);
+	if (ret != 0) {
+		vmbus_driver_unregister(&hvfb_drv);
+		return ret;
+	}
+
+	return 0;
 }
 
 static void __exit hvfb_drv_exit(void)
 {
+	pci_unregister_driver(&hvfb_pci_stub_driver);
 	vmbus_driver_unregister(&hvfb_drv);
 }
 
-- 
1.8.3.1

