Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbaLQPsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:48:43 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:59865 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbaLQPsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:48:41 -0500
From: Stefan Hengelein <stefan.hengelein@fau.de>
To: kgene@kernel.org
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, Stefan Hengelein <stefan.hengelein@fau.de>
Subject: [PATCH] ARM: SAMSUNG: remove dead #elif CONFIG_S3C24XX_DMAC
Date: Wed, 17 Dec 2014 16:40:37 +0100
Message-Id: <1418830837-7422-1-git-send-email-stefan.hengelein@fau.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The corresponding CPP-block can never be selected since there are
conflicting Kconfig constraints:
- CONFIG_S3C24XX_DMAC has a dependency on ARCH_S3C24XX
- The surrounding CPP-block needs CONFIG_S3C64XX_DEV_SPI0 to be defined.
  - CONFIG_S3C64XX_DEV_SPI0 is only selected by MACH_WLF_CRAGG_6410
  - MACH_WLF_CRAGG_6410 however has a dependency on ARCH_S3C64XX
    (through a surrounding if-statement in Kconfig)
- ARCH_S3C64XX and ARCH_S3C24XX are mutually exclusive since they are
  declared in the same choice and cannot be enabled at the same time.

Hence, the innner block
    "#elif defined(CONFIG_S3C24XX_DMAC)"
cannot be enabled at the same time with the surrounding block
    "#ifdef CONFIG_S3C64XX_DEV_SPI0"
and therefore is dead.

This (logical) defect has been found with the undertaker tool
(https://undertaker.cs.fau.de)

Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
---
 arch/arm/plat-samsung/devs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
index 83c7d15..b38b601 100644
--- a/arch/arm/plat-samsung/devs.c
+++ b/arch/arm/plat-samsung/devs.c
@@ -1134,8 +1134,6 @@ void __init s3c64xx_spi0_set_platdata(int (*cfg_gpio)(void), int src_clk_nr,
 	pd.filter = pl330_filter;
 #elif defined(CONFIG_S3C64XX_PL080)
 	pd.filter = pl08x_filter_id;
-#elif defined(CONFIG_S3C24XX_DMAC)
-	pd.filter = s3c24xx_dma_filter;
 #endif
 
 	s3c_set_platdata(&pd, sizeof(pd), &s3c64xx_device_spi0);
-- 
1.9.1

