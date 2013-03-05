Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3CEIGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:06:33 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:48984 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab3CEIGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:06:32 -0500
Date: Tue, 5 Mar 2013 09:06:20 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] gpio-ich: Check for pin availability at request time
Message-ID: <20130305090620.2c9f1ff5@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop checking for pin availability in get functions. These functions
can be called repeatedly, so checking every time is bad for
performance.

Instead, check at pin request time. This only happens once, and we can
let the caller know of the unavailability much earlier.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Peter Tyser <ptyser@xes-inc.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-ich.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- linux-3.7.orig/drivers/gpio/gpio-ich.c	2013-03-05 08:36:40.940199905 +0100
+++ linux-3.7/drivers/gpio/gpio-ich.c	2013-03-05 08:36:51.047437884 +0100
@@ -169,9 +169,6 @@ static int ichx_gpio_direction_output(st
 
 static int ichx_gpio_get(struct gpio_chip *chip, unsigned nr)
 {
-	if (!ichx_gpio_check_available(chip, nr))
-		return -ENXIO;
-
 	return ichx_read_bit(GPIO_LVL, nr);
 }
 
@@ -180,9 +177,6 @@ static int ich6_gpio_get(struct gpio_chi
 	unsigned long flags;
 	u32 data;
 
-	if (!ichx_gpio_check_available(chip, nr))
-		return -ENXIO;
-
 	/*
 	 * GPI 0 - 15 need to be read from the power management registers on
 	 * a ICH6/3100 bridge.
@@ -207,6 +201,9 @@ static int ich6_gpio_get(struct gpio_chi
 
 static int ichx_gpio_request(struct gpio_chip *chip, unsigned nr)
 {
+	if (!ichx_gpio_check_available(chip, nr))
+		return -ENXIO;
+
 	/*
 	 * Note we assume the BIOS properly set a bridge's USE value.  Some
 	 * chips (eg Intel 3100) have bogus USE values though, so first see if


-- 
Jean Delvare
