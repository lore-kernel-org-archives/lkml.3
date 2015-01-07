Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbbAGRba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:31:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45245 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405AbbAGRb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:31:27 -0500
From: Suman Anna <s-anna@ti.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Felipe Balbi <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [RFC PATCH 1/3] of/device: manage resources similar to platform_device_add
Date: Wed, 7 Jan 2015 11:30:52 -0600
Message-ID: <1420651854-17768-2-git-send-email-s-anna@ti.com>
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
of_platform_depopulate() is provided to delete these child platform
devices. The of_platform_depopulate() leverages the platform API
for performing the cleanup of these devices.

The platform device resources are managed differently between
of_device_add and platform_device_add, and this asymmetry causes
a kernel oops in platform_device_del during removal of the resources.
Manage the platform device resources similar to platform_device_add
to fix this kernel oops.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/of/device.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index 46d6c75c1404..fa27c1c71f29 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -50,6 +50,8 @@ EXPORT_SYMBOL(of_dev_put);
 
 int of_device_add(struct platform_device *ofdev)
 {
+	int i, ret;
+
 	BUG_ON(ofdev->dev.of_node == NULL);
 
 	/* name and id have to be set so that the platform bus doesn't get
@@ -63,7 +65,41 @@ int of_device_add(struct platform_device *ofdev)
 	if (!ofdev->dev.parent)
 		set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->dev.of_node));
 
-	return device_add(&ofdev->dev);
+	for (i = 0; i < ofdev->num_resources; i++) {
+		struct resource *p, *r = &ofdev->resource[i];
+
+		if (!r->name)
+			r->name = dev_name(&ofdev->dev);
+
+		p = r->parent;
+		if (!p) {
+			if (resource_type(r) == IORESOURCE_MEM)
+				p = &iomem_resource;
+			else if (resource_type(r) == IORESOURCE_IO)
+				p = &ioport_resource;
+		}
+
+		if (p && insert_resource(p, r)) {
+			dev_err(&ofdev->dev, "failed to claim resource %d\n",
+				i);
+			ret = -EBUSY;
+			goto failed;
+		}
+	}
+
+	ret = device_add(&ofdev->dev);
+	if (ret == 0)
+		return ret;
+
+failed:
+	while (--i >= 0) {
+		struct resource *r = &ofdev->resource[i];
+		unsigned long type = resource_type(r);
+
+		if (type == IORESOURCE_MEM || type == IORESOURCE_IO)
+			release_resource(r);
+	}
+	return ret;
 }
 
 int of_device_register(struct platform_device *pdev)
-- 
2.2.1

