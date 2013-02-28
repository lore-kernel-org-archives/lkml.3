Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944Ab3B1SF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:05:56 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:43729 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699Ab3B1SFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:05:54 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: [PATCH] OMAP3 ROM Random Number Generator support
Date: Thu, 28 Feb 2013 19:05:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-25-generic; KDE/4.10.0; x86_64; ; )
Cc: Juha Yrjola <juha.yrjola@solidboot.com>,
        Russell King <linux@arm.linux.org.uk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1557775.NvWmvZgbeZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201302281905.48546@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1557775.NvWmvZgbeZ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

This driver provides kernel-side support for the Random Number
Generator hardware found on OMAP34xx processors.

This driver is included in Maemo 2.6.28 kernel used on Nokia N900.

I fixed driver to work with 3.8 kernel and added platform_driver
code to autoload it on omap3 devices.

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 626f3ea..48e40f3 100644
=2D-- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -446,6 +446,18 @@ static void omap_init_mcspi(void)
 static inline void omap_init_mcspi(void) {}
 #endif
=20
+static struct platform_device omap3_rom_rng_device =3D {
+	.name		=3D "omap3-rom-rng",
+	.id		=3D -1,
+};
+
+static void omap_init_rom_rng(void)
+{
+	if (!cpu_is_omap34xx() || omap_type() =3D=3D OMAP2_DEVICE_TYPE_GP)
+		return;
+	platform_device_register(&omap3_rom_rng_device);
+}
+
 /**
  * omap_init_rng - bind the RNG hwmod to the RNG omap_device
  *
@@ -727,6 +739,7 @@ static int __init omap2_init_devices(void)
 	}
 	omap_init_sti();
 	omap_init_rng();
+	omap_init_rom_rng();
 	omap_init_sham();
 	omap_init_aes();
 	omap_init_vout();
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index c5a0262..2d51db6 100644
=2D-- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -153,6 +153,19 @@ config HW_RANDOM_OMAP
=20
  	  If unsure, say Y.
=20
+config HW_RANDOM_OMAP3_ROM
+	tristate "OMAP3 ROM Random Number Generator support"
+	depends on HW_RANDOM && ARCH_OMAP3
+	default HW_RANDOM
+	---help---
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on OMAP34xx processors.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called omap3-rom-rng.
+
+	  If unsure, say Y.
+
 config HW_RANDOM_OCTEON
 	tristate "Octeon Random Number Generator support"
 	depends on HW_RANDOM && CPU_CAVIUM_OCTEON
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makef=
ile
index 1fd7eec..d227cd6 100644
=2D-- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -15,6 +15,8 @@ n2-rng-y :=3D n2-drv.o n2-asm.o
 obj-$(CONFIG_HW_RANDOM_VIA) +=3D via-rng.o
 obj-$(CONFIG_HW_RANDOM_IXP4XX) +=3D ixp4xx-rng.o
 obj-$(CONFIG_HW_RANDOM_OMAP) +=3D omap-rng.o
+obj-$(CONFIG_HW_RANDOM_OMAP3_ROM) +=3D omap3-rom-rng.o
+omap3-rom-rng-y :=3D omap3-rom-drv.o omap3-rom-asm.o
 obj-$(CONFIG_HW_RANDOM_PASEMI) +=3D pasemi-rng.o
 obj-$(CONFIG_HW_RANDOM_VIRTIO) +=3D virtio-rng.o
 obj-$(CONFIG_HW_RANDOM_TX4939) +=3D tx4939-rng.o
diff --git a/drivers/char/hw_random/omap3-rom-asm.S b/drivers/char/hw_rando=
m/omap3-rom-asm.S
new file mode 100644
index 0000000..ce82e16
=2D-- /dev/null
+++ b/drivers/char/hw_random/omap3-rom-asm.S
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+ENTRY(omap3_rng_call_rom_asm)
+	.arch_extension sec
+	stmfd	sp!, {r4-r12, lr}
+	stmfd	sp!, {r0-r3}
+	bl	v7_flush_dcache_all
+	ldmfd	sp!, {r0-r3}
+	mov	r6, #0xff
+	mov	r12, r0
+	smc	#1
+	mov	r12, r0
+	bl	v7_flush_dcache_all
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c5, 0
+	mov	r0, r12
+	ldmfd	sp!, {r4-r12, pc}
diff --git a/drivers/char/hw_random/omap3-rom-drv.c b/drivers/char/hw_rando=
m/omap3-rom-drv.c
new file mode 100644
index 0000000..4e2c0ff
=2D-- /dev/null
+++ b/drivers/char/hw_random/omap3-rom-drv.c
@@ -0,0 +1,167 @@
+/*
+ * omap3-rom-drv.c - RNG driver for TI OMAP3 CPU family
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ * Author: Juha Yrjola <juha.yrjola@solidboot.com>
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/random.h>
+#include <linux/hw_random.h>
+#include <linux/timer.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+
+#include "../../../arch/arm/mach-omap2/soc.h"
+
+#define SEC_HAL_RNG_GENERATE		29
+#define RNG_RESET			0x01
+#define RNG_GEN_PRNG_HW_INIT		0x02
+#define RNG_GEN_HW			0x08
+
+static const char *omap3_rom_rng_name =3D "OMAP3 ROM RNG";
+
+extern u32 omap3_rng_call_rom_asm(u32 id, u32 proc, u32 flags, u32 va_ptr);
+
+static int call_sec_rom(u32 appl_id, u32 proc_id, u32 flag, ...)
+{
+	va_list ap;
+	u32 ret;
+	u32 val;
+
+	va_start(ap, flag);
+	val =3D *(u32 *) &ap;
+	local_irq_disable();
+	local_fiq_disable();
+	ret =3D omap3_rng_call_rom_asm(appl_id, proc_id, flag,
+				     (u32) virt_to_phys((void *) val));
+	local_fiq_enable();
+	local_irq_enable();
+	va_end(ap);
+
+	return ret;
+}
+
+static struct timer_list idle_timer;
+static int rng_idle;
+static struct clk *rng_clk;
+
+static void omap3_rom_idle_rng(unsigned long data)
+{
+	int r;
+
+	r =3D call_sec_rom(SEC_HAL_RNG_GENERATE, 0, 0, 3, NULL, 0,
+			 RNG_RESET);
+	if (r !=3D 0) {
+		printk(KERN_ERR "%s: reset failed: %d\n",
+		       omap3_rom_rng_name, r);
+		return;
+	}
+	clk_disable_unprepare(rng_clk);
+	rng_idle =3D 1;
+}
+
+static int omap3_rom_get_random(void *buf, unsigned int count)
+{
+	u32 r;
+	u32 ptr;
+
+	del_timer_sync(&idle_timer);
+	if (rng_idle) {
+		clk_prepare_enable(rng_clk);
+		r =3D call_sec_rom(SEC_HAL_RNG_GENERATE, 0, 0, 3, NULL, 0,
+				 RNG_GEN_PRNG_HW_INIT);
+		if (r !=3D 0) {
+			clk_disable_unprepare(rng_clk);
+			printk(KERN_ERR "%s: HW init failed: %d\n",
+			       omap3_rom_rng_name, r);
+			return -EIO;
+		}
+		rng_idle =3D 0;
+	}
+
+	ptr =3D virt_to_phys(buf);
+	r =3D call_sec_rom(SEC_HAL_RNG_GENERATE, 0, 0, 3, ptr,
+			 count, RNG_GEN_HW);
+	mod_timer(&idle_timer, jiffies + msecs_to_jiffies(500));
+	if (r !=3D 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int omap3_rom_rng_data_present(struct hwrng *rng, int wait)
+{
+	return 1;
+}
+
+static int omap3_rom_rng_data_read(struct hwrng *rng, u32 *data)
+{
+	int r;
+
+	r =3D omap3_rom_get_random(data, 4);
+	if (r < 0)
+		return r;
+	return 4;
+}
+
+static struct hwrng omap3_rom_rng_ops =3D {
+	.name		=3D "omap3-rom",
+	.data_present	=3D omap3_rom_rng_data_present,
+	.data_read	=3D omap3_rom_rng_data_read,
+};
+
+static int omap3_rom_rng_probe(struct platform_device *pdev)
+{
+	printk(KERN_INFO "%s: initializing\n", omap3_rom_rng_name);
+	if (!cpu_is_omap34xx()) {
+		printk(KERN_ERR "%s: currently supports only OMAP34xx CPUs\n",
+		       omap3_rom_rng_name);
+		return -ENODEV;
+	}
+	if (omap_type() =3D=3D OMAP2_DEVICE_TYPE_GP) {
+		printk(KERN_ERR "%s: GP OMAPs not supported\n",
+		       omap3_rom_rng_name);
+		return -ENODEV;
+	}
+
+	setup_timer(&idle_timer, omap3_rom_idle_rng, 0);
+	rng_clk =3D clk_get_sys("omap_rng", "ick");
+	if (IS_ERR(rng_clk)) {
+		printk(KERN_ERR "%s: unable to get RNG clock\n",
+		       omap3_rom_rng_name);
+		return IS_ERR(rng_clk);
+	}
+
+	/* Leave the RNG in reset state. */
+	clk_prepare_enable(rng_clk);
+	omap3_rom_idle_rng(0);
+
+	return hwrng_register(&omap3_rom_rng_ops);
+}
+
+static int omap3_rom_rng_remove(struct platform_device *pdev)
+{
+	hwrng_unregister(&omap3_rom_rng_ops);
+	return 0;
+}
+
+static struct platform_driver omap3_rom_rng_driver =3D {
+	.driver =3D {
+		.name		=3D "omap3-rom-rng",
+		.owner		=3D THIS_MODULE,
+	},
+	.probe		=3D omap3_rom_rng_probe,
+	.remove		=3D omap3_rom_rng_remove,
+};
+
+module_platform_driver(omap3_rom_rng_driver);
+
+MODULE_ALIAS("platform:omap3-rom-rng");
+MODULE_AUTHOR("Juha Yrjola");
+MODULE_LICENSE("GPL");

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1557775.NvWmvZgbeZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlEvnHwACgkQi/DJPQPkQ1I7MwCgiX6TOuUwpnxPdWWxGWLIGPKm
hb4AoMnNfdAmf606OVyd/Hg0NNKQBFeI
=2Mjq
-----END PGP SIGNATURE-----

--nextPart1557775.NvWmvZgbeZ--
