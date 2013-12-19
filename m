Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3LSPOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:14:10 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:40794 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3LSPEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:38 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 15/38] mips: txx9: 7segled: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:26 +0100
Message-Id: <1387465429-3568-16-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Also, add a new tx_7segled_release function which will be called after the
put_device to ensure that device is kfree'd.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 arch/mips/txx9/generic/7segled.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/mips/txx9/generic/7segled.c b/arch/mips/txx9/generic/7segled.c
index 4642f56..3caa548 100644
--- a/arch/mips/txx9/generic/7segled.c
+++ b/arch/mips/txx9/generic/7segled.c
@@ -83,6 +83,10 @@ static struct bus_type tx_7segled_subsys = {
 	.dev_name	= "7segled",
 };
 
+void tx_7segled_release(struct device *dev) {
+	kfree(dev);
+}
+
 static int __init tx_7segled_init_sysfs(void)
 {
 	int error, i;
@@ -103,11 +107,14 @@ static int __init tx_7segled_init_sysfs(void)
 		}
 		dev->id = i;
 		dev->bus = &tx_7segled_subsys;
+		dev->release = &tx_7segled_release;
 		error = device_register(dev);
-		if (!error) {
-			device_create_file(dev, &dev_attr_ascii);
-			device_create_file(dev, &dev_attr_raw);
+		if (error) {
+			put_device(dev);
+			return error;
 		}
+		device_create_file(dev, &dev_attr_ascii);
+		device_create_file(dev, &dev_attr_raw);	
 	}
 	return error;
 }
-- 
1.8.3.1

