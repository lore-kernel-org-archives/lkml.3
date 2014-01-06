Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbaAFWim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:38:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbaAFWii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.12 047/144] ARM: OMAP2+: Fix LCD panel backlight regression for LDP legacy booting
Date: Mon,  6 Jan 2014 14:36:48 -0800
Message-Id: <20140106223746.695222852@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 7e367c18c059c638bf6fb540f1decec18d64cb55 upstream.

Looks like the LCD panel on LDP has been broken quite a while, and
recently got fixed by commit 0b2aa8bed3e1 (gpio: twl4030: Fix regression
for twl gpio output). However, there's still an issue left where the panel
backlight does not come on if the LCD drivers are built into the
kernel.

Fix the issue by registering the DPI LCD panel only after the twl4030
GPIO has probed.

Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
[tony@atomide.com: updated per Tomi's comments]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/board-ldp.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -243,12 +243,18 @@ static void __init ldp_display_init(void
 
 static int ldp_twl_gpio_setup(struct device *dev, unsigned gpio, unsigned ngpio)
 {
+	int res;
+
 	/* LCD enable GPIO */
 	ldp_lcd_pdata.enable_gpio = gpio + 7;
 
 	/* Backlight enable GPIO */
 	ldp_lcd_pdata.backlight_gpio = gpio + 15;
 
+	res = platform_device_register(&ldp_lcd_device);
+	if (res)
+		pr_err("Unable to register LCD: %d\n", res);
+
 	return 0;
 }
 
@@ -347,7 +353,6 @@ static struct omap2_hsmmc_info mmc[] __i
 
 static struct platform_device *ldp_devices[] __initdata = {
 	&ldp_gpio_keys_device,
-	&ldp_lcd_device,
 };
 
 #ifdef CONFIG_OMAP_MUX


