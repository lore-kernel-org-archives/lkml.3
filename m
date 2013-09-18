Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab3IRUIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:08:15 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:37749 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3IRUIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:08:11 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 2/2] RX-51: Add support for OMAP3 ROM Random Number Generator
Date: Wed, 18 Sep 2013 22:05:57 +0200
Message-Id: <1379534757-20870-3-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
References: <201303281854.02847@pali>
 <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 arch/arm/mach-omap2/board-rx51.c  |   10 ++++++++++
 arch/arm/mach-omap2/omap-secure.c |   11 +++++++++++
 arch/arm/mach-omap2/omap-secure.h |    1 +
 3 files changed, 22 insertions(+)

diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index db168c9..c2a3e39 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -93,6 +93,14 @@ static struct omap_musb_board_data musb_board_data = {
 	.power			= 0,
 };
 
+static struct platform_device omap3_rom_rng_device = {
+	.name		= "omap_rng",
+	.id		= -1,
+	.dev	= {
+		.platform_data	= rx51_secure_rng_call,
+	},
+};
+
 static void __init rx51_init(void)
 {
 	struct omap_sdrc_params *sdrc_params;
@@ -113,6 +121,8 @@ static void __init rx51_init(void)
 		/* set IBE to 1 */
 		rx51_secure_update_aux_cr(BIT(6), 0);
 #endif
+		pr_info("RX-51: Registring OMAP3 HWRNG device\n");
+		platform_device_register(&omap3_rom_rng_device);
 	}
 
 	/* Ensure SDRC pins are mux'd for self-refresh */
diff --git a/arch/arm/mach-omap2/omap-secure.c b/arch/arm/mach-omap2/omap-secure.c
index 146a7c4..5ac122e 100644
--- a/arch/arm/mach-omap2/omap-secure.c
+++ b/arch/arm/mach-omap2/omap-secure.c
@@ -135,3 +135,14 @@ u32 rx51_secure_update_aux_cr(u32 set_bits, u32 clear_bits)
 				      FLAG_START_CRITICAL,
 				      1, acr, 0, 0, 0);
 }
+
+/**
+ * rx51_secure_rng_call: Routine for HW random generator
+ */
+u32 rx51_secure_rng_call(u32 ptr, u32 count, u32 flag)
+{
+	return rx51_secure_dispatcher(RX51_PPA_HWRNG,
+				      0,
+				      NO_FLAG,
+				      3, ptr, count, flag, 0);
+}
diff --git a/arch/arm/mach-omap2/omap-secure.h b/arch/arm/mach-omap2/omap-secure.h
index 51b59c6..f6cabb0 100644
--- a/arch/arm/mach-omap2/omap-secure.h
+++ b/arch/arm/mach-omap2/omap-secure.h
@@ -65,6 +65,7 @@ extern int omap_secure_ram_reserve_memblock(void);
 extern u32 rx51_secure_dispatcher(u32 idx, u32 process, u32 flag, u32 nargs,
 				  u32 arg1, u32 arg2, u32 arg3, u32 arg4);
 extern u32 rx51_secure_update_aux_cr(u32 set_bits, u32 clear_bits);
+extern u32 rx51_secure_rng_call(u32 ptr, u32 count, u32 flag);
 
 #ifdef CONFIG_OMAP4_ERRATA_I688
 extern int omap_barrier_reserve_memblock(void);
-- 
1.7.10.4

