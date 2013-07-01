Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3GAODY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:03:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52445 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab3GAODW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:03:22 -0400
Date: Mon, 1 Jul 2013 16:03:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: [PATCH] N900: fix operation on emulator
Message-ID: <20130701140315.GA15318@amd.pavel.ucw.cz>
References: <20130613132624.GA3464@amd.pavel.ucw.cz>
 <20130613141001.GF8164@atomide.com>
 <20130613142809.GA3775@amd.pavel.ucw.cz>
 <20130613145724.GH8164@atomide.com>
 <20130613155240.GB3775@amd.pavel.ucw.cz>
 <20130613161418.GJ8164@atomide.com>
 <20130613230808.GA14876@amd.pavel.ucw.cz>
 <20130614055629.GM8164@atomide.com>
 <20130614212816.GA31768@atrey.karlin.mff.cuni.cz>
 <20130617111031.GQ20992@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130617111031.GQ20992@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Errata workarounds for N900 hardware actually break operation on
emulator. Fix it.

This approach was suggested by Pali Rohár <pali.rohar@gmail.com>
(thanks!).

(Also explain what "sleep_ind" led actually does).

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index 74f83a5..81f7b9f 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -33,9 +33,12 @@
 #include "pm.h"
 #include "sdram-nokia.h"
 #include "board-rx51-secure.h"
+#include "soc.h"
 
 #define RX51_GPIO_SLEEP_IND 162
 
+/* This lights up left part of keyboard */
+
 static struct gpio_led gpio_leds[] = {
 	{
 		.name	= "sleep_ind",
@@ -107,9 +110,11 @@ static void __init rx51_init(void)
 	rx51_camera_init();
 
 #ifdef CONFIG_ARM_ERRATA_430973
-	printk(KERN_INFO "RX-51: Enabling ARM errata 430973 workaround.\n");
-	/* set IBE to 1 */
-	rx51_secure_update_aux_cr(1 << 6, 0);
+	if (omap_type() == OMAP2_DEVICE_TYPE_SEC) {
+		printk(KERN_INFO "RX-51: Enabling ARM errata 430973 workaround.\n");
+		/* set IBE to 1 */
+		rx51_secure_update_aux_cr(1 << 6, 0);
+	}
 #endif
 
 	/* Ensure SDRC pins are mux'd for self-refresh */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
