Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab3IHHng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 03:43:36 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39153 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3IHHne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 03:43:34 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dave Martin <Dave.Martin@arm.com>, tony@atomide.com
Subject: [PATCH v4 1/2] ARM: OMAP: Add secure function omap_smc3() which calling instruction smc #1
Date: Sun, 8 Sep 2013 09:43:29 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.0; x86_64; ; )
Cc: =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        nm@ti.com, linux@arm.linux.org.uk, aaro.koskinen@iki.fi,
        pdeschrijver@nvidia.com, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, pavel@ucw.cz, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
References: <20130904124303.GA2369@localhost.localdomain>
In-Reply-To: <20130904124303.GA2369@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5225140.5ByshU8eoQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309080943.30542@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5225140.5ByshU8eoQ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Here is new version (v4) of omap secure part patch:

Other secure functions omap_smc1() and omap_smc2() calling instruction smc =
#0
but Nokia RX-51 board needs to call smc #1 for PPA access.

Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
=2D--
diff --git a/arch/arm/mach-omap2/omap-secure.h b/arch/arm/mach-omap2/omap-s=
ecure.h
index 0e72917..c4586f4 100644
=2D-- a/arch/arm/mach-omap2/omap-secure.h
+++ b/arch/arm/mach-omap2/omap-secure.h
@@ -51,6 +51,7 @@
 extern u32 omap_secure_dispatcher(u32 idx, u32 flag, u32 nargs,
 				u32 arg1, u32 arg2, u32 arg3, u32 arg4);
 extern u32 omap_smc2(u32 id, u32 falg, u32 pargs);
+extern u32 omap_smc3(u32 id, u32 process, u32 flag, u32 pargs);
 extern phys_addr_t omap_secure_ram_mempool_base(void);
 extern int omap_secure_ram_reserve_memblock(void);
=20
diff --git a/arch/arm/mach-omap2/omap-smc.S b/arch/arm/mach-omap2/omap-smc.S
index f6441c1..fd90125 100644
=2D-- a/arch/arm/mach-omap2/omap-smc.S
+++ b/arch/arm/mach-omap2/omap-smc.S
@@ -1,9 +1,11 @@
 /*
=2D * OMAP44xx secure APIs file.
+ * OMAP34xx and OMAP44xx secure APIs file.
  *
  * Copyright (C) 2010 Texas Instruments, Inc.
  * Written by Santosh Shilimkar <santosh.shilimkar@ti.com>
  *
+ * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
+ * Copyright (C) 2013 Pali Roh=C3=A1r <pali.rohar@gmail.com>
  *
  * This program is free software,you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -54,6 +56,23 @@ ENTRY(omap_smc2)
 	ldmfd   sp!, {r4-r12, pc}
 ENDPROC(omap_smc2)
=20
+/**
+ * u32 omap_smc3(u32 service_id, u32 process_id, u32 flag, u32 pargs)
+ * Low level common routine for secure HAL and PPA APIs via smc #1
+ * r0 - @service_id: Secure Service ID
+ * r1 - @process_id: Process ID
+ * r2 - @flag: Flag to indicate the criticality of operation
+ * r3 - @pargs: Physical address of parameter list
+ */
+ENTRY(omap_smc3)
+	stmfd	sp!, {r4-r11, lr}
+	mov	r12, r0		@ Copy the secure service ID
+	mov	r6, #0xff	@ Indicate new Task call
+	dsb			@ Memory Barrier (not sure if needed, copied from omap_smc2)
+	smc	#1		@ Call PPA service
+	ldmfd	sp!, {r4-r11, pc}
+ENDPROC(omap_smc3)
+
 ENTRY(omap_modify_auxcoreboot0)
 	stmfd   sp!, {r1-r12, lr}
 	ldr	r12, =3D0x104


=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart5225140.5ByshU8eoQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlIsKqIACgkQi/DJPQPkQ1IxCgCgl+85ws5yUWVq4FR8cTqEgaAw
sc4AoJlmLkQpUJgyaTpHgbFrlno8gypk
=st2B
-----END PGP SIGNATURE-----

--nextPart5225140.5ByshU8eoQ--
