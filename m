Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab3BQPQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:16:59 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57329 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab3BQPQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:16:58 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ADP1653 board code for Nokia RX-51
Date: Sun, 17 Feb 2013 16:16:49 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-24-generic; KDE/4.10.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1961998.jPWA2rUJ6Z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201302171616.50152@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1961998.jPWA2rUJ6Z
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I'm sending ADP1653 flash torch board code for Nokia RX-51. Kernel
driver ADP1653 is already in upstream kernel. Board code was extracted
from this big camera meego patch:

https://api.pub.meego.com/public/source/CE:Adaptation:N900/kernel-adaptatio=
n-n900/linux-2.6-Camera-for-Meego-N900-Adaptation-kernel-2.6.37-patch.patch

diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-r=
x51.c
index d0374ea..92117a13 100644
=2D-- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -75,6 +75,7 @@ static struct platform_device leds_gpio =3D {
 */
=20
 extern void __init rx51_peripherals_init(void);
+extern void __init rx51_camera_init(void);
=20
 #ifdef CONFIG_OMAP_MUX
 static struct omap_board_mux board_mux[] __initdata =3D {
@@ -100,6 +101,7 @@ static void __init rx51_init(void)
=20
 	usb_musb_init(&musb_board_data);
 	rx51_peripherals_init();
+	rx51_camera_init();
=20
 	/* Ensure SDRC pins are mux'd for self-refresh */
 	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
diff --git a/arch/arm/mach-omap2/board-rx51-camera.c b/arch/arm/mach-omap2/=
board-rx51-camera.c
new file mode 100644
index 0000000..26b37ea
=2D-- /dev/null
+++ b/arch/arm/mach-omap2/board-rx51-camera.c
@@ -0,0 +1,177 @@
+/*
+ * arch/arm/mach-omap2/board-rx51-camera.c
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Sakari Ailus <sakari.ailus@nokia.com>
+ *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/i2c.h>
+#include <linux/delay.h>
+
+#include <asm/gpio.h>
+
+#include "../../../drivers/media/platform/omap3isp/isp.h"
+
+#include <media/adp1653.h>
+
+#include "devices.h"
+
+#define ADP1653_GPIO_ENABLE	88	/* Used for resetting ADP1653 */
+#define ADP1653_GPIO_INT	167	/* Fault interrupt */
+#define ADP1653_GPIO_STROBE	126	/* Pin used in cam_strobe mode ->
+					 * control using ISP drivers */
+
+static int __init rx51_adp1653_init(void)
+{
+	int err;
+
+	err =3D gpio_request(ADP1653_GPIO_ENABLE, "adp1653 enable");
+	if (err) {
+		printk(KERN_ERR ADP1653_NAME
+		       " Failed to request EN gpio\n");
+		err =3D -ENODEV;
+		goto err_omap_request_gpio;
+	}
+
+	err =3D gpio_request(ADP1653_GPIO_INT, "adp1653 interrupt");
+	if (err) {
+		printk(KERN_ERR ADP1653_NAME " Failed to request IRQ gpio\n");
+		err =3D -ENODEV;
+		goto err_omap_request_gpio_2;
+	}
+
+	err =3D gpio_request(ADP1653_GPIO_STROBE, "adp1653 strobe");
+	if (err) {
+		printk(KERN_ERR ADP1653_NAME
+		       " Failed to request STROBE gpio\n");
+		err =3D -ENODEV;
+		goto err_omap_request_gpio_3;
+	}
+
+	gpio_direction_output(ADP1653_GPIO_ENABLE, 0);
+	gpio_direction_input(ADP1653_GPIO_INT);
+	gpio_direction_output(ADP1653_GPIO_STROBE, 0);
+
+	return 0;
+
+err_omap_request_gpio_3:
+	gpio_free(ADP1653_GPIO_INT);
+
+err_omap_request_gpio_2:
+	gpio_free(ADP1653_GPIO_ENABLE);
+
+err_omap_request_gpio:
+	return err;
+}
+
+static int __init rx51_camera_hw_init(void)
+{
+	int rval;
+
+	rval =3D rx51_adp1653_init();
+	if (rval)
+		return rval;
+
+	return 0;
+}
+
+/*
+ *
+ * ADP1653
+ *
+ */
+
+static int rx51_adp1653_power(struct v4l2_subdev *subdev, int on)
+{
+	gpio_set_value(ADP1653_GPIO_ENABLE, on);
+	if (on) {
+		/* Some delay is apparently required. */
+		udelay(20);
+	}
+
+	return 0;
+}
+
+static struct adp1653_platform_data rx51_adp1653_platform_data =3D {
+	.power			 =3D rx51_adp1653_power,
+	/* Must be limited to 500 ms in RX-51 */
+	.max_flash_timeout	 =3D 500000,		/* us */
+	/* Must be limited to 320 mA in RX-51 B3 and newer hardware */
+	.max_flash_intensity	 =3D ADP1653_FLASH_INTENSITY_REG_TO_mA(19),
+	/* Must be limited to 50 mA in RX-51 */
+	.max_torch_intensity	 =3D ADP1653_FLASH_INTENSITY_REG_TO_mA(1),
+	.max_indicator_intensity =3D ADP1653_INDICATOR_INTENSITY_REG_TO_uA(
+		ADP1653_REG_OUT_SEL_ILED_MAX),
+};
+
+/*
+ *
+ * Init it all
+ *
+ */
+
+#define ADP1653_I2C_BUS_NUM		2
+
+static struct i2c_board_info rx51_camera_i2c_devices[] =3D {
+	{
+		I2C_BOARD_INFO(ADP1653_NAME, ADP1653_I2C_ADDR),
+		.platform_data =3D &rx51_adp1653_platform_data,
+	},
+};
+
+static struct isp_subdev_i2c_board_info rx51_camera_primary_subdevs[] =3D {
+	{
+		.board_info =3D &rx51_camera_i2c_devices[0],
+		.i2c_adapter_id =3D ADP1653_I2C_BUS_NUM,
+	},
+	{ NULL, 0, },
+};
+
+static struct isp_v4l2_subdevs_group rx51_camera_subdevs[] =3D {
+	{
+		.subdevs =3D rx51_camera_primary_subdevs,
+		.interface =3D ISP_INTERFACE_CCP2B_PHY1,
+		.bus =3D { .ccp2 =3D {
+			.strobe_clk_pol		=3D 0,
+			.crc			=3D 1,
+			.ccp2_mode		=3D 1,
+			.phy_layer		=3D 1,
+			.vpclk_div		=3D 1,
+		} },
+	},
+	{ NULL, 0, },
+};
+
+static struct isp_platform_data rx51_isp_platform_data =3D {
+	.subdevs =3D rx51_camera_subdevs,
+};
+
+void __init rx51_camera_init(void)
+{
+	if (rx51_camera_hw_init()) {
+		printk(KERN_WARNING "%s: Unable to initialize camera\n",
+		       __func__);
+		return;
+	}
+
+	if (omap3_init_camera(&rx51_isp_platform_data) < 0)
+		printk(KERN_WARNING "%s: Unable to register camera platform "
+		       "device\n", __func__);
+}
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index be0f62b..268fa57 100644
=2D-- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -286,6 +287,7 @@ config MACH_NOKIA_RX51
 	depends on ARCH_OMAP3
 	default y
 	select OMAP_PACKAGE_CBB
+	select VIDEO_ADP1653 if VIDEO_OMAP3 && VIDEO_HELPER_CHIPS_AUTO
=20
 config MACH_OMAP_ZOOM2
 	bool "OMAP3 Zoom2 board"
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index c8b6ff3..df78c58 100644
=2D-- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -239,6 +239,7 @@ obj-$(CONFIG_MACH_NOKIA_RM680)		+=3D board-rm680.o sdra=
m-nokia.o
 obj-$(CONFIG_MACH_NOKIA_RX51)		+=3D board-rx51.o sdram-nokia.o
 obj-$(CONFIG_MACH_NOKIA_RX51)		+=3D board-rx51-peripherals.o
 obj-$(CONFIG_MACH_NOKIA_RX51)		+=3D board-rx51-video.o
+obj-$(CONFIG_MACH_NOKIA_RX51)		+=3D board-rx51-camera.o
 obj-$(CONFIG_MACH_OMAP_ZOOM2)		+=3D board-zoom.o board-zoom-peripherals.o
 obj-$(CONFIG_MACH_OMAP_ZOOM2)		+=3D board-zoom-display.o
 obj-$(CONFIG_MACH_OMAP_ZOOM2)		+=3D board-zoom-debugboard.o


=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1961998.jPWA2rUJ6Z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlEg9GIACgkQi/DJPQPkQ1KvYgCghtGRtb7NH74k18BdIp5JS/z6
HgoAn3qpmCGSlVdThx3UW/IHXFjcKCrv
=ko56
-----END PGP SIGNATURE-----

--nextPart1961998.jPWA2rUJ6Z--
