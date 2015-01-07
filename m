Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbbAGRbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:31:32 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60428 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbbAGRb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:31:27 -0500
From: Suman Anna <s-anna@ti.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Felipe Balbi <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [RFC PATCH 2/3] core: platform: fix an invalid kfree during of_platform_depopulate
Date: Wed, 7 Jan 2015 11:30:53 -0600
Message-ID: <1420651854-17768-3-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420651854-17768-1-git-send-email-s-anna@ti.com>
References: <1420651854-17768-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers can use of_platform_populate() to create platform devices
for children of the device main node, and a complementary API
of_platform_depopulate() is provided to delete these child devices.
Any platform_data supplied for the OF devices through auxdata lookup
data is populated directly in the device's platform_data field, unlike
those created using platform API. The of_platform_depopulate()
leverages the platform code for cleanup, and this will result in a
kernel oops due to an invalid kfree on this direct populated
platform_data.

Fix this by resetting the platform data for OF devices during
platform device cleanup.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/base/platform.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 9421fed40905..129e69c8c894 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -200,6 +200,8 @@ static void platform_device_release(struct device *dev)
 	struct platform_object *pa = container_of(dev, struct platform_object,
 						  pdev.dev);
 
+	if (pa->pdev.dev.of_node)
+		pa->pdev.dev.platform_data = NULL;
 	of_device_node_put(&pa->pdev.dev);
 	kfree(pa->pdev.dev.platform_data);
 	kfree(pa->pdev.mfd_cell);
-- 
2.2.1

