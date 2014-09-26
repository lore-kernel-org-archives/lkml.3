Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaIZKu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:50:56 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57948 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbaIZKuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:50:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: soc for 3.18 #2
Date: Fri, 26 Sep 2014 12:50:02 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <1411391733-28891-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1411391733-28891-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201409261250.02565.arnd@arndb.de>
X-Provags-ID: V02:K0:Ocpr3MJdUV2+Nwq+A7feKxs2nY5M9/9/bD4XJG9CZpl
 x7g2Gm3hBFuVpbthSo6m39U49nLTnYexTBwP8svkMAp9UWUMXV
 guiuOgc/3fx/FOzsGUPzdSDSkvKeh/cyzaPnIW85OGPjG4Ktva
 6HZuuo0TmYKGytESz8FwW47+6GjGYUoLWE/4ZLDk0qpzBBCkJ1
 x9tJAxaoJdOLkOXVnD9FqogDZHoHzibMATj9U+m2VpeBljHpOr
 lknIHiPdgQhXnA0e7clro/YDhOiiExeRU3ioRX67Dw5Vt6Xsyh
 omSlAFNeBOgUK6r2IYy8SQqdFNwyHgMBlX70CT8xyWzeNrYySC
 wnF4vuOArv9Oz1gZLO8Y=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 September 2014, Nicolas Ferre wrote:

> Nicolas Ferre (4):
>       ARM: at91: introduce basic SAMA5D4 support
>       ARM: at91: SAMA5D4 SoC detection code and low level routines

This resulted in build failures both in at91x40_defconfig and some
randconfigs with MMU disabled. I've applied the patch below on top
to fix it.

I'm not exactly happy about the soc detection code anyway after I
had to look at that. Why do you even hardcode the physical register
location rather than getting it from DT?

Also, why do you care about which SoC version you have for the
modern SAMA5 chips? All I see is a sama5d4_map_io() callback
that maps a lot of completely unused registers along with
the uart that you normally get from the implicit debug_ll_io_init,
and the SRAM that should probably be turned into a normal driver.

	Arnd
8<-------
>From 45aeea29c360551519edd8e041b36d8a4d5f6a23 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 26 Sep 2014 12:27:00 +0200
Subject: [PATCH] ARM: at91: fix nommu build regression

The newly introduced support for SAMA5D4 added access to the
'AT91_ALT_BASE_SYS' register area, but failed to define the
symbols in the case when CONFIG_MMU is disabled.

We really should not hardwire addresses like this any more,
but as a small fixup, this patch just adds the missing
definitions for the nommu case, which gets at91x40_defconfig
and any configuration of sam9 and sama5 with MMU disabled
back to work.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 726d32bf79ef4 ("ARM: at91: SAMA5D4 SoC detection code and low ...")

diff --git a/arch/arm/mach-at91/include/mach/hardware.h b/arch/arm/mach-at91/include/mach/hardware.h
index d84776f6b8ac..c13797352688 100644
--- a/arch/arm/mach-at91/include/mach/hardware.h
+++ b/arch/arm/mach-at91/include/mach/hardware.h
@@ -51,11 +51,12 @@
  */
 #define AT91_BASE_SYS	0xffffc000
 
+#endif
+
 /*
  * On sama5d4 there is no system controller, we map some needed peripherals
  */
 #define AT91_ALT_BASE_SYS	0xfc069000
-#endif
 
 /*
  * On all at91 have the Advanced Interrupt Controller starts at address
@@ -90,6 +91,9 @@
  */
 #define AT91_IO_PHYS_BASE	AT91_BASE_SYS
 #define AT91_IO_VIRT_BASE	IOMEM(AT91_IO_PHYS_BASE)
+
+#define AT91_ALT_IO_PHYS_BASE	AT91_ALT_BASE_SYS
+#define AT91_ALT_IO_VIRT_BASE	IOMEM(AT91_ALT_BASE_SYS)
 #endif
 
 #define AT91_IO_SIZE		(0xFFFFFFFF - AT91_IO_PHYS_BASE + 1)
