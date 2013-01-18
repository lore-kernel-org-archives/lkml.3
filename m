Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137Ab3ARJlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 04:41:20 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48444 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab3ARJlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 04:41:15 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <tony@atomide.com>,
        <balbi@ti.com>, <b-cousson@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH 2/4] ARM: OMAP: devices: create device for usb part of control module
Date: Fri, 18 Jan 2013 15:10:43 +0530
Message-ID: <1358502045-27008-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358502045-27008-1-git-send-email-kishon@ti.com>
References: <1358502045-27008-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A seperate driver has been added to handle the usb part of control
module. A device for the above driver is created here, using the register
address information to be used by the driver for powering on the PHY and
for writing to the mailbox.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/devices.c |   48 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 5e304d0..a58b0ce 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -20,6 +20,7 @@
 #include <linux/pinctrl/machine.h>
 #include <linux/platform_data/omap4-keypad.h>
 #include <linux/platform_data/omap_ocp2scp.h>
+#include <linux/usb/omap_control_usb.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/map.h>
@@ -254,6 +255,52 @@ static inline void omap_init_camera(void)
 #endif
 }
 
+#if IS_ENABLED(CONFIG_OMAP_CONTROL_USB)
+static struct omap_control_usb_platform_data omap4_control_usb_pdata = {
+	.has_mailbox = true,
+};
+
+struct resource omap4_control_usb_res[] = {
+	{
+		.name	= "control_dev_conf",
+		.start	= 0x4a002300,
+		.end	= 0x4a002303,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.name	= "otghs_control",
+		.start	= 0x4a00233c,
+		.end	= 0x4a00233f,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device omap4_control_usb = {
+	.name		= "omap-control-usb",
+	.id		= -1,
+	.dev = {
+		.platform_data = &omap4_control_usb_pdata,
+	},
+	.num_resources = 2,
+	.resource = omap4_control_usb_res,
+};
+
+static inline void __init omap_init_control_usb(void)
+{
+	int ret = 0;
+
+	if (cpu_is_omap44xx()) {
+		ret = platform_device_register(&omap4_control_usb);
+		if (ret)
+			pr_err("Error registering omap_control_usb device:%d\n",
+			    ret);
+	}
+}
+
+#else
+static inline void omap_init_control_usb(void) { }
+#endif /* CONFIG_OMAP_CONTROL_USB */
+
 int __init omap4_keyboard_init(struct omap4_keypad_platform_data
 			*sdp4430_keypad_data, struct omap_board_data *bdata)
 {
@@ -721,6 +768,7 @@ static int __init omap2_init_devices(void)
 	omap_init_mbox();
 	/* If dtb is there, the devices will be created dynamically */
 	if (!of_have_populated_dt()) {
+		omap_init_control_usb();
 		omap_init_dmic();
 		omap_init_mcpdm();
 		omap_init_mcspi();
-- 
1.7.9.5

