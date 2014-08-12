Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaHLCmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:42:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45077 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbaHLCmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:42:42 -0400
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: grant.likely@linaro.org, Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, stepanm@codeaurora.org
Subject: [PATCH] of: Deep-copy names of platform devices
Date: Mon, 11 Aug 2014 19:42:36 -0700
Message-Id: <1407811356-24222-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
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
I suppose creating a 'pdev_set_name' API may seem like
another possibility, but I feel that dev.name and pdev.name
have two different meanings. One is used for device/driver
binding purposes, whereas the other serves a more general
identification purpose, and is used for things like sysfs.
Drivers might want to change dev.name while leaving the
pdev.name alone. I guess yet another possibility would be
to prohibit calling dev_set_name() on devices created from
device tree, but a driver does not necessarily know how a
given platform_device was allocated.

 drivers/of/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index f685e55..fe5f025 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -54,7 +54,7 @@ int of_device_add(struct platform_device *ofdev)

 	/* name and id have to be set so that the platform bus doesn't get
 	 * confused on matching */
-	ofdev->name = dev_name(&ofdev->dev);
+	ofdev->name = kstrdup(dev_name(&ofdev->dev), GFP_KERNEL);
 	ofdev->id = -1;

 	/* device_add will assume that this device is on the same node as
--
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

