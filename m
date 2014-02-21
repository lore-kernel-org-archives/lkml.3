Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbaBUPid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:38:33 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54336 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151AbaBUPia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:38:30 -0500
From: "Strashko, Grygorii" <grygorii.strashko@ti.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Subject: RE: [PATCH v2] dt: platform driver: Fill the resources before probe
 and defer if needed
Thread-Topic: [PATCH v2] dt: platform driver: Fill the resources before
 probe and defer if needed
Thread-Index: AQHPLwgZ4qcczSJiVU+9DdUZkrGGP5q/xEtp
Date: Fri, 21 Feb 2014 15:37:53 +0000
Message-ID: <902E09E6452B0E43903E4F2D568737AB0B9D2959@DFRE01.ent.ti.com>
References: <20140220153042.DF053C4050F@trevor.secretlab.ca>,<1392988720-20976-1-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1392988720-20976-1-git-send-email-jjhiblot@traphandler.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.52]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Jean-Jacques,

Sorry for top posting.

As I know, there have been several attempts to solve the same problem already:)
[1] https://lkml.org/lkml/2013/9/18/216
[2] https://lkml.org/lkml/2013/11/22/520
[3] https://lkml.org/lkml/2014/1/8/240

There are some questions related to your approach:
1) How to distinguish between cases "IRQ domain not ready" and "wrong IRQ data in DT" or other IRQ parsing errors?
Otherwise, Driver's probe will be deffered wrongly and forever, 
Thierry Reding has tried to solve this in [1].

2) How will be handled driver reloading situation? 
The worst case (sparse IRQ enabled):
- remove driver A
- remove driver B (irq-controller)
- load driver B <--- different set of Linux IRQ numbers can be assigned 
- load driver A <--- oops. IRQ resources table contains invalid data



Best regards,
Grygorii Strashko 

=============================================

The goal of this patch is to allow drivers to be probed even if at the time of
the DT parsing some of their ressources are not available yet.

In the current situation, the resource of a platform device are filled from the
DT at the time the device is created (of_device_alloc()). The drawbackof this
is that a device sitting close to the top of the DT (ahb for example) but
depending on ressources that are initialized later (IRQ domain dynamically
created for example)  will fail to probe because the ressources don't exist
at this time.

This patch fills the resource structure only before the device is probed and
will defer the probe if the resource are not available yet.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---

Hi Grant,

I reworked the patch as you proposed. To keep the overhead minimum, nirq and
nreg are computed only the first time.
In this implementation, only the missing IRQ ressources are re-tried for. It could
easily be changed to re-parse all the IRQs though (replace if (!res->flags)
with if ((!res->flags) || (res->flags & IORESOURCE_IRQ)).

drivers/base/platform.c     |   5 +++
 drivers/of/platform.c       | 100 +++++++++++++++++++++++++++++++++-----------
 include/linux/of_platform.h |  10 +++++
 3 files changed, 90 insertions(+), 25 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index bc78848..cee9b8d 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -481,6 +481,10 @@ static int platform_drv_probe(struct device *_dev)
        struct platform_device *dev = to_platform_device(_dev);
        int ret;

+       ret = of_platform_device_prepare(dev);
+       if (ret)
+               goto error;
+
        if (ACPI_HANDLE(_dev))
                acpi_dev_pm_attach(_dev, true);

@@ -488,6 +492,7 @@ static int platform_drv_probe(struct device *_dev)
        if (ret && ACPI_HANDLE(_dev))
                acpi_dev_pm_detach(_dev, true);

+error:
        if (drv->prevent_deferred_probe && ret == -EPROBE_DEFER) {
                dev_warn(_dev, "probe deferral not supported\n");
                ret = -ENXIO;
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 404d1da..a4e2602 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -141,36 +141,11 @@ struct platform_device *of_device_alloc(struct device_node *np,
                                  struct device *parent)
 {
        struct platform_device *dev;
-       int rc, i, num_reg = 0, num_irq;
-       struct resource *res, temp_res;

        dev = platform_device_alloc("", -1);
        if (!dev)
                return NULL;

-       /* count the io and irq resources */
-       if (of_can_translate_address(np))
-               while (of_address_to_resource(np, num_reg, &temp_res) == 0)
-                       num_reg++;
-       num_irq = of_irq_count(np);
-
-       /* Populate the resource table */
-       if (num_irq || num_reg) {
-               res = kzalloc(sizeof(*res) * (num_irq + num_reg), GFP_KERNEL);
-               if (!res) {
-                       platform_device_put(dev);
-                       return NULL;
-               }
-
-               dev->num_resources = num_reg + num_irq;
-               dev->resource = res;
-               for (i = 0; i < num_reg; i++, res++) {
-                       rc = of_address_to_resource(np, i, res);
-                       WARN_ON(rc);
-               }
-               WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
-       }
-
        dev->dev.of_node = of_node_get(np);
 #if defined(CONFIG_MICROBLAZE)
        dev->dev.dma_mask = &dev->archdata.dma_mask;
@@ -233,6 +208,81 @@ static struct platform_device *of_platform_device_create_pdata(
        return dev;
 }

+static int of_reg_count(struct device_node *np)
+{
+       int nreg = 0;
+       if (of_can_translate_address(np)) {
+               struct resource temp_res;
+               while (of_address_to_resource(np, nreg, &temp_res) == 0)
+                       nreg++;
+       }
+       return nreg;
+}
+
+int of_platform_device_prepare(struct platform_device *dev)
+{
+       struct device_node *np;
+       int i, irq_index;
+       struct resource *res;
+
+       /*
+        * This function applies only devices described in the DT.
+        * Other platform devices have their ressources already populated.
+        */
+       np = dev->dev.of_node;
+       if (!np)
+               return 0;
+
+       /* Populate the resource table */
+       if (!dev->resource) {
+               int rc, nreg = 0, nirq;
+               /* count the io and irq resources */
+               nreg = of_reg_count(np);
+               nirq = of_irq_count(np);
+
+               if (!nirq && !nreg)
+                       return 0;
+
+               res = kzalloc(sizeof(*res) * (nirq + nreg), GFP_KERNEL);
+               if (!res)
+                       return -ENOMEM;
+
+               dev->resource = res;
+               dev->num_resources = nreg + nirq;
+
+               for (i = 0; i < nreg; i++, res++) {
+                       rc = of_address_to_resource(np, i, res);
+                       if (WARN_ON(rc)) {
+                               /* THIS IS BAD; don't try to defer probing */
+                               dev->num_resources = 0;
+                               dev->resource = NULL;
+                               kfree(res);
+                               return rc;
+                       }
+               }
+
+               if (!rc && of_irq_to_resource_table(np, res, nirq) != nirq) {
+                       /* IRQ controller is yet available. defer probing */
+                       return -EPROBE_DEFER;
+               }
+
+               return 0;
+       }
+
+       /* See which IRQ resources need to be redone */
+       irq_index = 0;
+       for (i = 0, res = dev->resource; i < dev->num_resources; i++, res++) {
+               if (!res->flags) {
+                       if (!of_irq_to_resource(np, irq_index, res))
+                               return -EPROBE_DEFER;
+                       irq_index++;
+               } else if (res->flags & IORESOURCE_IRQ)
+                       irq_index++;
+       }
+       return 0;
+}
+EXPORT_SYMBOL(of_platform_device_prepare);
+
 /**
  * of_platform_device_create - Alloc, initialize and register an of_device
  * @np: pointer to node to create device for
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 05cb4a9..4e487ff 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -53,6 +53,16 @@ struct of_dev_auxdata {

 extern const struct of_device_id of_default_bus_match_table[];

+/* Populate the resource for a platform device */
+#ifdef CONFIG_OF
+int of_platform_device_prepare(struct platform_device *dev);
+#else
+static inline int of_platform_device_prepare(
+       struct platform_device *dev)
+{
+       return 0;
+}
+#endif
 /* Platform drivers register/unregister */
 extern struct platform_device *of_device_alloc(struct device_node *np,
                                         const char *bus_id,
--
1.9.0


_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
