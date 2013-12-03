Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab3LCMfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:35:03 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:36741 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab3LCMe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:34:58 -0500
Date: Tue, 3 Dec 2013 12:34:54 +0000
From: Kim Phillips <kim.phillips@linaro.org>
To: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kvm@vger.kernel.org, scottwood@freescale.com, R65777@freescale.com,
        B07421@freescale.com, B08248@freescale.com,
        christoffer.dall@linaro.org, alex.williamson@redhat.com,
        a.motakis@virtualopensystems.com, agraf@suse.de, B16395@freescale.com
Subject: [REPOST][PATCH 2/2] driver core: platform: allow platform drivers
 to bind to any device
Message-Id: <20131203123454.3ab18749ed0d0d943b10df9a@linaro.org>
X-Mailer: Sylpheed 3.4.0beta5 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform drivers such as the vfio-platform "meta-" driver [1]
should be allowed to specify that they can bind to any device,
much like PCI drivers can with PCI_ANY_ID.

Currently, binding platform drivers to devices depends on:

- a string match in the device node's compatible entry (OF)
- a string match in the ACPI id list (ACPI)
- a string match in the id_table (platform data)
- a string match on the driver name (fall-back)

none of which allow for the notion of "match any."

This patch adds the notion by adding a "match any device" boolean to
struct platform_driver, for drivers to be able to set and thus not cause
platform_match() to fail when a bind is requested.

[1] http://www.spinics.net/lists/kvm/msg96701.html

Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
---
rebased onto 3.13-rc2, and reposted from first submission which
received no comments:

https://lkml.org/lkml/2013/10/11/48

 drivers/base/platform.c         | 4 ++++
 include/linux/platform_device.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 3a94b79..78a5b62 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -736,6 +736,10 @@ static int platform_match(struct device *dev, struct device_driver *drv)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct platform_driver *pdrv = to_platform_driver(drv);
 
+	/* the driver matches any device */
+	if (pdrv->match_any_dev)
+		return 1;
+
 	/* Attempt an OF style match first */
 	if (of_driver_match_device(dev, drv))
 		return 1;
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 16f6654..55e76b1 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -179,6 +179,7 @@ struct platform_driver {
 	struct device_driver driver;
 	const struct platform_device_id *id_table;
 	bool prevent_deferred_probe;
+	bool match_any_dev;
 };
 
 #define to_platform_driver(drv)	(container_of((drv), struct platform_driver, \
-- 
1.8.5
