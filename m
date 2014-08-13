Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaHMCar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 22:30:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56976 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaHMCap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 22:30:45 -0400
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: grant.likely@linaro.org, robh+dt@kernel.org, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        stepanm@codeaurora.org
Subject: [PATCH v2] of: Deep-copy names of platform devices
Date: Tue, 12 Aug 2014 19:30:37 -0700
Message-Id: <1407897037-6037-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <53EAC37C.4020203@codeaurora.org>
References: <53EAC37C.4020203@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we parse the device tree and allocate platform
devices, the 'name' of the newly-created platform_device
is set to point to the 'name' field of the 'struct device'
embedded within the platform_device. This is dangerous,
because the name of the 'struct device' is dynamically
allocated. Drivers may call dev_set_name() on the device,
which will free and reallocate the name of the device,
leaving the 'name' of the platform_device pointing to the
now-freed memory.

Furthermore, if the dev_set_name() call is made from a
driver's probe() function and a subsequent request results
in probe deferral, the dangling 'name' reference may lead
to the device being re-probed using the wrong driver.

To mitigate these scenarios, we use kstrdup to perform a
deep copy of the device name when assigning the name of the
platform_device, so that the platform_device name is
unaffected by any calls to dev_set_name() that might made
by drivers to rename the embedded 'struct device'.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
* v2 - swap cleanup order

 drivers/of/device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index f685e55..e9beae6 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -54,7 +54,7 @@ int of_device_add(struct platform_device *ofdev)

 	/* name and id have to be set so that the platform bus doesn't get
 	 * confused on matching */
-	ofdev->name = dev_name(&ofdev->dev);
+	ofdev->name = kstrdup(dev_name(&ofdev->dev), GFP_KERNEL);
 	ofdev->id = -1;

 	/* device_add will assume that this device is on the same node as
@@ -75,6 +75,7 @@ EXPORT_SYMBOL(of_device_register);

 void of_device_unregister(struct platform_device *ofdev)
 {
+	kfree(ofdev->name);
 	device_unregister(&ofdev->dev);
 }
 EXPORT_SYMBOL(of_device_unregister);
--
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

