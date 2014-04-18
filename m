Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaDRM4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:56:07 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:53215 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaDRM4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:56:01 -0400
Date: Fri, 18 Apr 2014 13:59:24 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches@linaro.org,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 3/3] of: Handle memory@0 node on PPC32 only
Message-ID: <20140418125924.GF5904@bivouac.eciton.net>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
 <1397756521-29387-4-git-send-email-leif.lindholm@linaro.org>
 <CAMuHMdXBNWum7UJ95uT2hwTd1b5C8ebF2LQ4T-A+RS80p7MH=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXBNWum7UJ95uT2hwTd1b5C8ebF2LQ4T-A+RS80p7MH=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Fri, Apr 18, 2014 at 10:04:15AM +0200, Geert Uytterhoeven wrote:
> On Thu, Apr 17, 2014 at 7:42 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> > In order to deal with an firmware bug on a specific ppc32 platform
> > (longtrail), early_init_dt_scan_memory() looks for a node called
> > memory@0 on all platforms. Restrict this quirk to ppc32 kernels only.
> 
> This breaks backwards compatibilty with old DTSes (at least on ARM/MIPS,
> where you added the missing property in patches 1 and 2 of the series)?

As Rob said in response to 0/3, the MIPSs would likely not be affected,
since they embed the DT.

> For the Longtrail, I don't care much anymore, as mine died in 2004.
> AFAIK, there have never been many users anyway.

There are still a few mentions of it under arch/powerpc/, so I wouldn't
want to be the one to kill it off...

How about the below v2 3/3 to address the ARM platform?

Regards,

Leif

>From 6fa0b837ad71780334eb97d63c507165b6c57add Mon Sep 17 00:00:00 2001
From: Leif Lindholm <leif.lindholm@linaro.org>
Date: Thu, 17 Apr 2014 14:24:47 +0100
Subject: [PATCH] of: arm: powerpc: Restrict memory@0 node handling to
 affected platforms

In order to deal with a firmware bug on a specific ppc32 platform
(longtrail), early_init_dt_scan_memory() looks for a node called
memory@0 on all platforms, for all nodes lacking a device_type.
Restrict this quirk to ppc32 and the arm mach-ux500 platforms (one of
which has depended on this special handling).

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: devicetree@vger.kernel.org
---
 arch/arm/mach-ux500/Kconfig |    1 +
 arch/powerpc/Kconfig        |    1 +
 drivers/of/Kconfig          |    3 +++
 drivers/of/fdt.c            |   10 +++++++++-
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index b41a42d..e6b0c3b 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -13,6 +13,7 @@ config ARCH_U8500
 	select CLKSRC_NOMADIK_MTU
 	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if SMP
+	select OF_MEMORY_AT_0_QUIRK
 	select PINCTRL
 	select PINCTRL_ABX500
 	select PINCTRL_NOMADIK
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index e099899..d78452d 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -3,6 +3,7 @@ source "arch/powerpc/platforms/Kconfig.cputype"
 config PPC32
 	bool
 	default y if !PPC64
+	select OF_MEMORY_AT_0_QUIRK
 
 config 32BIT
 	bool
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 889005f..230c747 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -77,4 +77,7 @@ config OF_RESERVED_MEM
 	help
 	  Helpers to allow for reservation of memory regions
 
+config OF_MEMORY_AT_0_QUIRK
+	def_bool n
+
 endmenu # OF
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index fa16a91..1b80b94 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -887,14 +887,22 @@ int __init early_init_dt_scan_memory(unsigned long node, const char *uname,
 
 	/* We are scanning "memory" nodes only */
 	if (type == NULL) {
+#ifdef CONFIG_OF_MEMORY_AT_0_QUIRK
 		/*
 		 * The longtrail doesn't have a device_type on the
 		 * /memory node, so look for the node called /memory@0.
+		 * Converted to generic quirk to handle later platforms
+		 * with inforrect DTs that work only because of this
+		 * special handling.
 		 */
 		if (depth != 1 || strcmp(uname, "memory@0") != 0)
 			return 0;
-	} else if (strcmp(type, "memory") != 0)
+#else
+		return 0;
+#endif
+	} else if (strcmp(type, "memory") != 0) {
 		return 0;
+	}
 
 	reg = of_get_flat_dt_prop(node, "linux,usable-memory", &l);
 	if (reg == NULL)
-- 
1.7.10.4

