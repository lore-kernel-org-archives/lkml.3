Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaJKAl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 20:41:27 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53836 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaJKAlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 20:41:25 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] power/reset: at91-poweroff: Fix error handling and other compiler warnings
Date: Fri, 10 Oct 2014 17:41:17 -0700
Message-Id: <1412988077-14751-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91_poweroff_get_wakeup_mode can return a negative error code and should
therefore not return an enum type. Similar, its result should not be
assigned to an enum type. Otherwise, the returned value is never negative,
resulting in a compiler warning and a missed error condition, which in turn
results in writing bad values into a chip register.

Also fix other compiler warnings which can be easily avoided.

drivers/power/reset/at91-poweroff.c:74:24:
	warning: type qualifiers ignored on function return type
drivers/power/reset/at91-poweroff.c:74:24:
	warning: no previous prototype for 'at91_poweroff_get_wakeup_mode'
drivers/power/reset/at91-poweroff.c:83:16:
	warning: comparison between signed and unsigned integer expressions
drivers/power/reset/at91-poweroff.c:97:2:
	warning: comparison of unsigned expression < 0 is always false

Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/at91-poweroff.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/power/reset/at91-poweroff.c b/drivers/power/reset/at91-poweroff.c
index c610003..4b72ea5 100644
--- a/drivers/power/reset/at91-poweroff.c
+++ b/drivers/power/reset/at91-poweroff.c
@@ -71,10 +71,11 @@ static void at91_poweroff(void)
 	writel(AT91_SHDW_KEY | AT91_SHDW_SHDW, at91_shdwc_base + AT91_SHDW_CR);
 }
 
-const enum wakeup_type at91_poweroff_get_wakeup_mode(struct device_node *np)
+static int at91_poweroff_get_wakeup_mode(struct device_node *np)
 {
 	const char *pm;
-	int err, i;
+	unsigned int i;
+	int err;
 
 	err = of_property_read_string(np, "atmel,wakeup-mode", &pm);
 	if (err < 0)
@@ -90,7 +91,7 @@ const enum wakeup_type at91_poweroff_get_wakeup_mode(struct device_node *np)
 static void at91_poweroff_dt_set_wakeup_mode(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	enum wakeup_type wakeup_mode;
+	int wakeup_mode;
 	u32 mode = 0, tmp;
 
 	wakeup_mode = at91_poweroff_get_wakeup_mode(np);
-- 
1.9.1

