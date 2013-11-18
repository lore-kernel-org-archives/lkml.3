Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3KRS7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:59:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3KRSku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:40:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 3.11 13/25] hyperv-fb: add pci stub
Date: Mon, 18 Nov 2013 10:40:42 -0800
Message-Id: <20131118184036.363134643@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184032.248465920@linuxfoundation.org>
References: <20131118184032.248465920@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerd Hoffmann <kraxel@redhat.com>

commit 7ad9684721606efbfb9b347346816e1e6baff8bb upstream.

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
Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/hyperv_fb.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

--- a/drivers/video/hyperv_fb.c
+++ b/drivers/video/hyperv_fb.c
@@ -795,12 +795,21 @@ static int hvfb_remove(struct hv_device
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
 


