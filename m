Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab3HGKY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:24:28 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56347 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491Ab3HGKYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:24:24 -0400
Date: Wed, 7 Aug 2013 12:17:47 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 08/26] OF platform, of_amba_device_create(): add parent
 resource to parameters.
Message-ID: <6ffb74421dace254700dc2ee72d908dd7327bec1.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed when creating pci-amba devices: an amba device's
resource shall be child of the corresponding pci device's resource.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/of/platform.c       |   11 +++++++----
 include/linux/of_platform.h |    3 ++-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 57c6bbe..bf75aaa 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -252,7 +252,8 @@ EXPORT_SYMBOL(of_platform_device_create);
 struct amba_device *of_amba_device_create(struct device_node *node,
 					  const char *bus_id,
 					  void *platform_data,
-					  struct device *parent)
+					  struct device *parent,
+					  struct resource *parent_resource)
 {
 	struct amba_device *dev;
 	const void *prop;
@@ -293,7 +294,7 @@ struct amba_device *of_amba_device_create(struct device_node *node,
 	if (ret)
 		goto err_free;
 
-	ret = amba_device_add(dev, &iomem_resource);
+	ret = amba_device_add(dev, parent_resource);
 	if (ret)
 		goto err_free;
 
@@ -307,7 +308,8 @@ err_free:
 struct amba_device *of_amba_device_create(struct device_node *node,
 					  const char *bus_id,
 					  void *platform_data,
-					  struct device *parent)
+					  struct device *parent,
+					  struct resource *parent_resource)
 {
 	return NULL;
 }
@@ -375,7 +377,8 @@ static int of_platform_bus_create(struct device_node *bus,
 	}
 
 	if (of_device_is_compatible(bus, "arm,primecell")) {
-		of_amba_device_create(bus, bus_id, platform_data, parent);
+		of_amba_device_create(bus, bus_id, platform_data, parent,
+				      &iomem_resource);
 		return 0;
 	}
 
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 6cd5ac2..be13538 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -66,7 +66,8 @@ extern struct platform_device *of_platform_device_create(struct device_node *np,
 extern struct amba_device *of_amba_device_create(struct device_node *node,
 						 const char *bus_id,
 						 void *platform_data,
-						 struct device *parent);
+						 struct device *parent,
+						 struct resource *parent_res);
 
 extern int of_platform_bus_probe(struct device_node *root,
 				 const struct of_device_id *matches,
-- 
1.7.7.2
