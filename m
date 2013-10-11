Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab3JKG1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:27:32 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:61056 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3JKG13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:27:29 -0400
From: Kim Phillips <kim.phillips@linaro.org>
To: Bhushan Bharat <R65777@freescale.com>, Wood Scott <B07421@freescale.com>,
        Yoder Stuart <B08248@freescale.com>, christoffer.dall@linaro.org,
        alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        a.motakis@virtualopensystems.com, agraf@suse.de,
        Sethi Varun <B16395@freescale.com>, peter.maydell@linaro.org,
        santosh.shukla@linaro.org, kvm@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH 2/4] driver core: platform: allow platform drivers to bind to any device
Date: Fri, 11 Oct 2013 01:27:18 -0500
Message-Id: <1381472840-3470-2-git-send-email-kim.phillips@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381472840-3470-1-git-send-email-kim.phillips@linaro.org>
References: <1381418830.7979.405.camel@snotra.buserror.net>
 <1381472840-3470-1-git-send-email-kim.phillips@linaro.org>
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
 drivers/base/platform.c         | 4 ++++
 include/linux/platform_device.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 4f8bef3..0ca20d4 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -727,6 +727,10 @@ static int platform_match(struct device *dev, struct device_driver *drv)
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
index ce8e4ff..2d25d50 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -178,6 +178,7 @@ struct platform_driver {
 	int (*resume)(struct platform_device *);
 	struct device_driver driver;
 	const struct platform_device_id *id_table;
+	bool match_any_dev;
 };
 
 #define to_platform_driver(drv)	(container_of((drv), struct platform_driver, \
-- 
1.8.4

