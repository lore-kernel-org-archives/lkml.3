Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3LSPEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:04:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35705 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3LSPEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:35 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Markos Chandras <markos.chandras@imgtec.com>,
        "Steven J. Hill" <Steven.Hill@imgtec.com>, linux-mips@linux-mips.org
Subject: [PATCH 14/38] mips: txx9: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:25 +0100
Message-Id: <1387465429-3568-15-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Also, rework error path so that it is easier to read.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 arch/mips/txx9/generic/setup.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index 2b0b83c..24332f5 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -937,6 +937,12 @@ static ssize_t txx9_sram_write(struct file *filp, struct kobject *kobj,
 	return size;
 }
 
+void txx9_device_release(struct device *dev) {
+	struct txx9_sramc_dev *sramc_dev;
+	txx9_sramc_dev = container_of(dev, struct txx9_sramc_dev, dev);
+	kfree(txx9_sramc_dev);
+}
+
 void __init txx9_sramc_init(struct resource *r)
 {
 	struct txx9_sramc_dev *dev;
@@ -951,8 +957,11 @@ void __init txx9_sramc_init(struct resource *r)
 		return;
 	size = resource_size(r);
 	dev->base = ioremap(r->start, size);
-	if (!dev->base)
-		goto exit;
+	if (!dev->base) {
+		kfree(dev);
+		return;
+	}
+	dev->dev.release = &txx9_device_release;
 	dev->dev.bus = &txx9_sramc_subsys;
 	sysfs_bin_attr_init(&dev->bindata_attr);
 	dev->bindata_attr.attr.name = "bindata";
@@ -963,17 +972,15 @@ void __init txx9_sramc_init(struct resource *r)
 	dev->bindata_attr.private = dev;
 	err = device_register(&dev->dev);
 	if (err)
-		goto exit;
+		goto exit_put;
 	err = sysfs_create_bin_file(&dev->dev.kobj, &dev->bindata_attr);
 	if (err) {
 		device_unregister(&dev->dev);
-		goto exit;
-	}
-	return;
-exit:
-	if (dev) {
-		if (dev->base)
-			iounmap(dev->base);
+		iounmap(dev->base);
 		kfree(dev);
 	}
+	return;
+exit_put:
+	put_device(&dev->dev);
+	return;
 }
-- 
1.8.3.1

