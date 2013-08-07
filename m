Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab3HGK1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:27:19 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56432 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932701Ab3HGK1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:27:16 -0400
Date: Wed, 7 Aug 2013 12:20:37 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 18/26] x86 STA2X11 platform: add a common probe function
 for platform devices
Message-ID: <a8b59682307938e83e942581642013472a5653e7.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a common probe method for the STA2X11 base platform
drivers. The following steps are performed:

* Registers belonging to the probed device are ioremapped.
* devm_regmap_init_mmio() is invoked on such registers.
* A struct sta2x11_platform_drv_data containing device data is allocated,
  filled in, and "linked" to the struct sta2x11_instance_data representing
  the instance to which the probed device belongs.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/x86/include/asm/sta2x11.h      |    9 +++++
 arch/x86/platform/sta2x11/sta2x11.c |   68 ++++++++++++++++++++++++++++++++++-
 2 files changed, 76 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/sta2x11.h b/arch/x86/include/asm/sta2x11.h
index 6df0c87..31fc648 100644
--- a/arch/x86/include/asm/sta2x11.h
+++ b/arch/x86/include/asm/sta2x11.h
@@ -35,6 +35,15 @@ enum sta2x11_plat_dev {
 };
 
 /*
+ * Platform driver data for sta2x11 platform devices
+ */
+struct sta2x11_platform_drv_data {
+	void * __iomem regs;
+	spinlock_t lock;
+	struct regmap *regmap;
+};
+
+/*
  * Data structure representing a connext instance.
  */
 struct sta2x11_instance_data {
diff --git a/arch/x86/platform/sta2x11/sta2x11.c b/arch/x86/platform/sta2x11/sta2x11.c
index 861d447..1f1d1af 100644
--- a/arch/x86/platform/sta2x11/sta2x11.c
+++ b/arch/x86/platform/sta2x11/sta2x11.c
@@ -244,10 +244,76 @@ struct sta2x11_instance_data *sta2x11_node_to_instance(struct device_node *n)
 EXPORT_SYMBOL(sta2x11_node_to_instance);
 
 
+/* Common probe for the four platform devices */
 static int sta2x11_platform_probe(struct platform_device *dev,
 				  enum sta2x11_plat_dev index)
 {
-	return -EINVAL;
+	struct resource *res;
+	struct regmap_config *regmap_config =
+		sta2x11_platform_regmap_configs[index];
+	struct sta2x11_platform_drv_data *platform_drv_data, **dst;
+	struct sta2x11_instance_data *instance;
+
+	if (!regmap_config)
+		return -ENODEV;
+
+	platform_drv_data = devm_kzalloc(&dev->dev, sizeof(*platform_drv_data),
+					 GFP_KERNEL);
+	if (!platform_drv_data)
+		return -ENOMEM;
+
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENOMEM;
+
+	platform_drv_data->regs = devm_request_and_ioremap(&dev->dev, res);
+	if (!platform_drv_data->regs)
+		return -ENOMEM;
+
+	regmap_config->lock_arg = &platform_drv_data->lock;
+	/*
+	   No caching, registers could be reached both via regmap and via
+	   void __iomem *
+	*/
+	regmap_config->cache_type = REGCACHE_NONE;
+	platform_drv_data->regmap =
+		devm_regmap_init_mmio(&dev->dev, platform_drv_data->regs,
+				      regmap_config);
+	WARN_ON(!platform_drv_data->regmap);
+
+	if (!dev->dev.of_node)
+		return -ENODEV;
+
+	/* Find out the connext's instance id */
+	instance = sta2x11_dev_to_instance(&dev->dev);
+	if (!instance)
+		return -ENODEV;
+
+	/*
+	  In case the device represents the sysctl or apb soc registers,
+	  add clocks related data and maybe create the "virtual"
+	  sta2x11-clock-regs platform devices
+	 */
+	switch (index) {
+	case sta2x11_sctl:
+		dst = &instance->sctl;
+		break;
+	case sta2x11_apb_soc_regs:
+		dst = &instance->apb_soc_regs;
+		break;
+	case sta2x11_apbreg:
+		dst = &instance->apbreg;
+		break;
+	case sta2x11_scr:
+		dst = &instance->scr;
+		break;
+	default:
+		return -ENODEV;
+	}
+	*dst = platform_drv_data;
+
+	platform_set_drvdata(dev, platform_drv_data);
+	return 0;
 }
 
 static int sta2x11_sctl_probe(struct platform_device *dev)
-- 
1.7.7.2
