Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab3ENQxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:53:45 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49323 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263Ab3ENQxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:53:41 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Daniel Drake <dsd@laptop.org>, Jonathan Corbet <corbet@lwn.net>,
        Javier Martin <javier.martin@vista-silicon.com>,
        linux-media@vger.kernel.org
Subject: [RFC PATCH v2, part 2 15/18] PCI, via-camera: use hotplug-safe iterators to walk PCI buses
Date: Wed, 15 May 2013 00:51:59 +0800
Message-Id: <1368550322-1045-15-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance via-camera drviers to use hotplug-safe iterators to walk
PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/media/platform/via-camera.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index b051c4a..ef10136 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -1284,7 +1284,8 @@ static struct video_device viacam_v4l_template = {
 
 static bool viacam_serial_is_enabled(void)
 {
-	struct pci_bus *pbus = pci_find_bus(0, 0);
+	struct pci_bus *pbus = pci_get_bus(0, 0);
+	bool ret = false;
 	u8 cbyte;
 
 	if (!pbus)
@@ -1292,18 +1293,21 @@ static bool viacam_serial_is_enabled(void)
 	pci_bus_read_config_byte(pbus, VIACAM_SERIAL_DEVFN,
 			VIACAM_SERIAL_CREG, &cbyte);
 	if ((cbyte & VIACAM_SERIAL_BIT) == 0)
-		return false; /* Not enabled */
+		goto out; /* Not enabled */
 	if (override_serial == 0) {
 		printk(KERN_NOTICE "Via camera: serial port is enabled, " \
 				"refusing to load.\n");
 		printk(KERN_NOTICE "Specify override_serial=1 to force " \
 				"module loading.\n");
-		return true;
+		ret = true;
+		goto out;
 	}
 	printk(KERN_NOTICE "Via camera: overriding serial port\n");
 	pci_bus_write_config_byte(pbus, VIACAM_SERIAL_DEVFN,
 			VIACAM_SERIAL_CREG, cbyte & ~VIACAM_SERIAL_BIT);
-	return false;
+out:
+	pci_bus_put(pbus);
+	return ret;
 }
 
 static struct ov7670_config sensor_cfg = {
-- 
1.8.1.2

