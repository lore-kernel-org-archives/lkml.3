Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3C1RyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:54:09 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:34080 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3C1RyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:54:07 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] OMAP3 ROM Random Number Generator support
Date: Thu, 28 Mar 2013 18:54:02 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Juha Yrjola <juha.yrjola@solidboot.com>,
        Russell King <linux@arm.linux.org.uk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201302281905.48546@pali> <201303272303.44420@pali> <20130327222524.GR10155@atomide.com>
In-Reply-To: <20130327222524.GR10155@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart36882270.bcd0BETBej";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303281854.02847@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart36882270.bcd0BETBej
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 27 March 2013 23:25:24 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130327 15:08]:
> > I will remove above code for checking omap type from hw rand
> > driver, because same code is in omap part which creating
> > platform_device for this driver. So soc.h is not needed.
>=20
> OK thanks,
>=20
> Tony

Here is new version of patch:

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 5423456..37c4e09 100644
=2D-- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -82,7 +82,7 @@ obj-$(CONFIG_OMAP_PM_NOOP)		+=3D omap-pm-noop.o
 ifeq ($(CONFIG_PM),y)
 obj-$(CONFIG_ARCH_OMAP2)		+=3D pm24xx.o
 obj-$(CONFIG_ARCH_OMAP2)		+=3D sleep24xx.o
=2Dobj-$(CONFIG_ARCH_OMAP3)		+=3D pm34xx.o sleep34xx.o
+obj-$(CONFIG_ARCH_OMAP3)		+=3D pm34xx.o sleep34xx.o omap3-rom-rng.o
 obj-$(CONFIG_ARCH_OMAP4)		+=3D pm44xx.o omap-mpuss-lowpower.o
 obj-$(CONFIG_SOC_OMAP5)			+=3D omap-mpuss-lowpower.o
 obj-$(CONFIG_PM_DEBUG)			+=3D pm-debug.o
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 1ec7f05..0b6260a1 100644
=2D-- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -486,6 +486,23 @@ static void omap_init_mcspi(void)
 static inline void omap_init_mcspi(void) {}
 #endif
=20
+extern u32 *omap3_rom_rng_call(u32 id, u32 proc, u32 flags, u32 va_ptr);
+
+static struct platform_device omap3_rom_rng_device =3D {
+	.name		=3D "omap3-rom-rng",
+	.id		=3D -1,
+	.dev	=3D {
+		.platform_data	=3D omap3_rom_rng_call,
+	},
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
@@ -767,6 +784,7 @@ static int __init omap2_init_devices(void)
 	}
 	omap_init_sti();
 	omap_init_rng();
+	omap_init_rom_rng();
 	omap_init_sham();
 	omap_init_aes();
 	omap_init_vout();
diff --git a/arch/arm/mach-omap2/omap3-rom-rng.S b/arch/arm/mach-omap2/omap=
3-rom-rng.S
new file mode 100644
index 0000000..5d7d886
=2D-- /dev/null
+++ b/arch/arm/mach-omap2/omap3-rom-rng.S
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) 2009 Nokia Corporation
+ * Copyright (C) 2013 Pali Roh=C3=A1r <pali.rohar@gmail.com>
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
+ENTRY(omap3_rom_rng_call)
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
index 1fd7eec..c53e018 100644
=2D-- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -15,6 +15,7 @@ n2-rng-y :=3D n2-drv.o n2-asm.o
 obj-$(CONFIG_HW_RANDOM_VIA) +=3D via-rng.o
 obj-$(CONFIG_HW_RANDOM_IXP4XX) +=3D ixp4xx-rng.o
 obj-$(CONFIG_HW_RANDOM_OMAP) +=3D omap-rng.o
+obj-$(CONFIG_HW_RANDOM_OMAP3_ROM) +=3D omap3-rom-rng.o
 obj-$(CONFIG_HW_RANDOM_PASEMI) +=3D pasemi-rng.o
 obj-$(CONFIG_HW_RANDOM_VIRTIO) +=3D virtio-rng.o
 obj-$(CONFIG_HW_RANDOM_TX4939) +=3D tx4939-rng.o
diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_rando=
m/omap3-rom-rng.c
new file mode 100644
index 0000000..5343415
=2D-- /dev/null
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -0,0 +1,165 @@
+/*
+ * omap3-rom-drv.c - RNG driver for TI OMAP3 CPU family
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ * Author: Juha Yrjola <juha.yrjola@solidboot.com>
+ *
+ * Copyright (C) 2013 Pali Roh=C3=A1r <pali.rohar@gmail.com>
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
+#define SEC_HAL_RNG_GENERATE		29
+#define RNG_RESET			0x01
+#define RNG_GEN_PRNG_HW_INIT		0x02
+#define RNG_GEN_HW			0x08
+
+static const char *omap3_rom_rng_name =3D "OMAP3 ROM RNG";
+
+static u32 (*omap3_rom_rng_call)(u32, u32, u32, u32);
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
+	ret =3D omap3_rom_rng_call(appl_id, proc_id, flag,
+				 (u32) virt_to_phys((void *) val));
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
+
+	omap3_rom_rng_call =3D pdev->dev.platform_data;
+	if (!omap3_rom_rng_call) {
+		printk(KERN_ERR "%s: omap3_rom_rng_call is NULL\n",
+		       omap3_rom_rng_name);
+		return -EINVAL;
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
+MODULE_AUTHOR("Pali Roh=C3=A1r <pali.rohar@gmail.com>");
+MODULE_LICENSE("GPL");

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart36882270.bcd0BETBej
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFUg7oACgkQi/DJPQPkQ1JyMwCgn1Aa4sL9BxJJP/3abwldoUj6
c3UAoIqNmAjvpxgQA7cueKM8WzjJT+JH
=m1TJ
-----END PGP SIGNATURE-----

--nextPart36882270.bcd0BETBej--
