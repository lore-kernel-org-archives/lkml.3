Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3IRToE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:44:04 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:43300 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3IRToB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:44:01 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: [PATCH v4 2/2] RX-51: ARM errata 430973 workaround
Date: Wed, 18 Sep 2013 21:43:56 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, Nishanth Menon <nm@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
References: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com> <201309182122.01570@pali> <20130918192731.GE9994@atomide.com>
In-Reply-To: <20130918192731.GE9994@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5112465.jZeStCuFCH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309182143.56555@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5112465.jZeStCuFCH
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Closed and signed Nokia X-Loader bootloader stored in RX-51 nand does not s=
et
IBE bit in ACTLR and starting kernel in non-secure mode. So direct write to
ACTLR by our kernel does not working and the code for ARM errata 430973 in
commit 7ce236fcd6fd45b0441a2d49acb2ceb2de2e8a47 that sets IBE bit is a noop.

In order to have workaround for ARM errata 430973 from non-secure world on
RX-51 we needs Secure Monitor Call to set IBE BIT in ACTLR.

This patch adds RX-51 specific secure support code and sets IBE bit in ACTLR
during board init code for ARM errata 430973 workaround.

Note that new function rx51_secure_dispatcher() differs from existing
omap_secure_dispatcher(). It calling omap_smc3() and param[0] is nargs+1.

ARM errata 430973 workaround is needed for thumb-2 ISA compiled userspace
binaries. Without this workaround thumb-2 binaries crashing. So with this
patch it is possible to recompile and run applications/binaries with thumb-2
ISA on RX-51.

Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
=2D--

I added note about difference between rx51_secure_dispatcher and
omap_secure_dispatcher to commit message and also to code.

 arch/arm/mach-omap2/board-rx51.c  |   12 +++++++
 arch/arm/mach-omap2/omap-secure.c |   65 +++++++++++++++++++++++++++++++++=
++++
 arch/arm/mach-omap2/omap-secure.h |   11 +++++++
 3 files changed, 88 insertions(+)

diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-r=
x51.c
index 773510556..db168c9 100644
=2D-- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -2,6 +2,8 @@
  * Board support file for Nokia N900 (aka RX-51).
  *
  * Copyright (C) 2007, 2008 Nokia
+ * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
+ * Copyright (C) 2013 Pali Roh=C3=A1r <pali.rohar@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -31,7 +33,9 @@
 #include "mux.h"
 #include "gpmc.h"
 #include "pm.h"
+#include "soc.h"
 #include "sdram-nokia.h"
+#include "omap-secure.h"
=20
 #define RX51_GPIO_SLEEP_IND 162
=20
@@ -103,6 +107,14 @@ static void __init rx51_init(void)
 	usb_musb_init(&musb_board_data);
 	rx51_peripherals_init();
=20
+	if (omap_type() =3D=3D OMAP2_DEVICE_TYPE_SEC) {
+#ifdef CONFIG_ARM_ERRATA_430973
+		pr_info("RX-51: Enabling ARM errata 430973 workaround\n");
+		/* set IBE to 1 */
+		rx51_secure_update_aux_cr(BIT(6), 0);
+#endif
+	}
+
 	/* Ensure SDRC pins are mux'd for self-refresh */
 	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
 	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
diff --git a/arch/arm/mach-omap2/omap-secure.c b/arch/arm/mach-omap2/omap-s=
ecure.c
index b970440..146a7c4 100644
=2D-- a/arch/arm/mach-omap2/omap-secure.c
+++ b/arch/arm/mach-omap2/omap-secure.c
@@ -3,6 +3,8 @@
  *
  * Copyright (C) 2011 Texas Instruments, Inc.
  *	Santosh Shilimkar <santosh.shilimkar@ti.com>
+ * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
+ * Copyright (C) 2013 Pali Roh=C3=A1r <pali.rohar@gmail.com>
  *
  *
  * This program is free software,you can redistribute it and/or modify
@@ -70,3 +72,66 @@ phys_addr_t omap_secure_ram_mempool_base(void)
 {
 	return omap_secure_memblock_base;
 }
+
+/**
+ * rx51_secure_dispatcher: Routine to dispatch secure PPA API calls
+ * @idx: The PPA API index
+ * @process: Process ID
+ * @flag: The flag indicating criticality of operation
+ * @nargs: Number of valid arguments out of four.
+ * @arg1, arg2, arg3 args4: Parameters passed to secure API
+ *
+ * Return the non-zero error value on failure.
+ *
+ * NOTE: rx51_secure_dispatcher differs from omap_secure_dispatcher because
+ *       it calling omap_smc3() instead omap_smc2() and param[0] is nargs+1
+ */
+u32 rx51_secure_dispatcher(u32 idx, u32 process, u32 flag, u32 nargs,
+			   u32 arg1, u32 arg2, u32 arg3, u32 arg4)
+{
+	u32 ret;
+	u32 param[5];
+
+	param[0] =3D nargs+1; /* RX-51 needs number of arguments + 1 */
+	param[1] =3D arg1;
+	param[2] =3D arg2;
+	param[3] =3D arg3;
+	param[4] =3D arg4;
+
+	/*
+	 * Secure API needs physical address
+	 * pointer for the parameters
+	 */
+	local_irq_disable();
+	local_fiq_disable();
+	flush_cache_all();
+	outer_clean_range(__pa(param), __pa(param + 5));
+	ret =3D omap_smc3(idx, process, flag, __pa(param));
+	flush_cache_all();
+	local_fiq_enable();
+	local_irq_enable();
+
+	return ret;
+}
+
+/**
+ * rx51_secure_update_aux_cr: Routine to modify the contents of Auxiliary =
Control Register
+ *  @set_bits: bits to set in ACR
+ *  @clr_bits: bits to clear in ACR
+ *
+ * Return the non-zero error value on failure.
+*/
+u32 rx51_secure_update_aux_cr(u32 set_bits, u32 clear_bits)
+{
+	u32 acr;
+
+	/* Read ACR */
+	asm volatile ("mrc p15, 0, %0, c1, c0, 1" : "=3Dr" (acr));
+	acr &=3D ~clear_bits;
+	acr |=3D set_bits;
+
+	return rx51_secure_dispatcher(RX51_PPA_WRITE_ACR,
+				      0,
+				      FLAG_START_CRITICAL,
+				      1, acr, 0, 0, 0);
+}
diff --git a/arch/arm/mach-omap2/omap-secure.h b/arch/arm/mach-omap2/omap-s=
ecure.h
index c4586f4..51b59c6 100644
=2D-- a/arch/arm/mach-omap2/omap-secure.h
+++ b/arch/arm/mach-omap2/omap-secure.h
@@ -3,6 +3,8 @@
  *
  * Copyright (C) 2011 Texas Instruments, Inc.
  *	Santosh Shilimkar <santosh.shilimkar@ti.com>
+ * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
+ * Copyright (C) 2013 Pali Roh=C3=A1r <pali.rohar@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -46,6 +48,11 @@
 #define OMAP4_PPA_L2_POR_INDEX		0x23
 #define OMAP4_PPA_CPU_ACTRL_SMP_INDEX	0x25
=20
+/* Secure RX-51 PPA (Primary Protected Application) APIs */
+#define RX51_PPA_HWRNG			29
+#define RX51_PPA_L2_INVAL		40
+#define RX51_PPA_WRITE_ACR		42
+
 #ifndef __ASSEMBLER__
=20
 extern u32 omap_secure_dispatcher(u32 idx, u32 flag, u32 nargs,
@@ -55,6 +62,10 @@ extern u32 omap_smc3(u32 id, u32 process, u32 flag, u32 =
pargs);
 extern phys_addr_t omap_secure_ram_mempool_base(void);
 extern int omap_secure_ram_reserve_memblock(void);
=20
+extern u32 rx51_secure_dispatcher(u32 idx, u32 process, u32 flag, u32 narg=
s,
+				  u32 arg1, u32 arg2, u32 arg3, u32 arg4);
+extern u32 rx51_secure_update_aux_cr(u32 set_bits, u32 clear_bits);
+
 #ifdef CONFIG_OMAP4_ERRATA_I688
 extern int omap_barrier_reserve_memblock(void);
 #else
=2D-=20
1.7.10.4

--nextPart5112465.jZeStCuFCH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlI6AnwACgkQi/DJPQPkQ1KmigCgm33Cwf6Fwc6hWTZobCLHEaCA
b4cAoL1irnzP4dDWa0C027C6Dlqe3HCf
=rbRF
-----END PGP SIGNATURE-----

--nextPart5112465.jZeStCuFCH--
