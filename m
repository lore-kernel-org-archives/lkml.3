Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab3CLTXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:23:24 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:34571 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab3CLTXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:23:22 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Mack <zonque@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <syrjala@sci.fi>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, stable <stable@vger.kernel.org>
Subject: [PATCH] ARM: w1-gpio: fix erroneous gpio requests
Date: Tue, 12 Mar 2013 20:21:34 +0100
Message-Id: <1363116094-8630-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix regression introduced by commit d2323cf773 ("onewire: w1-gpio: add
ext_pullup_enable pin in platform data") which added a gpio entry to the
platform data, but did not add the required initialisers to the board
files using it. Consequently, the driver would request gpio 0 at probe,
which could break other uses of the corresponding pin.

On AT91 requesting gpio 0 changes the pin muxing for PIOA0, which, for
instance, breaks SPI0 on at91sam9g20.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---

Not sure whose tree this should go in through, so adding relevant maintainers
and authors as CC.

/Johan

 arch/arm/mach-at91/board-foxg20.c    | 1 +
 arch/arm/mach-at91/board-stamp9g20.c | 1 +
 arch/arm/mach-ixp4xx/vulcan-setup.c  | 1 +
 arch/arm/mach-pxa/raumfeld.c         | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/arm/mach-at91/board-foxg20.c b/arch/arm/mach-at91/board-foxg20.c
index 191d37c..1478294 100644
--- a/arch/arm/mach-at91/board-foxg20.c
+++ b/arch/arm/mach-at91/board-foxg20.c
@@ -176,6 +176,7 @@ static struct w1_gpio_platform_data w1_gpio_pdata = {
 	/* If you choose to use a pin other than PB16 it needs to be 3.3V */
 	.pin		= AT91_PIN_PB16,
 	.is_open_drain  = 1,
+	.ext_pullup_enable_pin	= -EINVAL,
 };
 
 static struct platform_device w1_device = {
diff --git a/arch/arm/mach-at91/board-stamp9g20.c b/arch/arm/mach-at91/board-stamp9g20.c
index 48a962b..58a6758 100644
--- a/arch/arm/mach-at91/board-stamp9g20.c
+++ b/arch/arm/mach-at91/board-stamp9g20.c
@@ -188,6 +188,7 @@ static struct spi_board_info portuxg20_spi_devices[] = {
 static struct w1_gpio_platform_data w1_gpio_pdata = {
 	.pin		= AT91_PIN_PA29,
 	.is_open_drain	= 1,
+	.ext_pullup_enable_pin	= -EINVAL,
 };
 
 static struct platform_device w1_device = {
diff --git a/arch/arm/mach-ixp4xx/vulcan-setup.c b/arch/arm/mach-ixp4xx/vulcan-setup.c
index 2798f43..1dddc1b 100644
--- a/arch/arm/mach-ixp4xx/vulcan-setup.c
+++ b/arch/arm/mach-ixp4xx/vulcan-setup.c
@@ -163,6 +163,7 @@ static struct platform_device vulcan_max6369 = {
 
 static struct w1_gpio_platform_data vulcan_w1_gpio_pdata = {
 	.pin			= 14,
+	.ext_pullup_enable_pin	= -EINVAL,
 };
 
 static struct platform_device vulcan_w1_gpio = {
diff --git a/arch/arm/mach-pxa/raumfeld.c b/arch/arm/mach-pxa/raumfeld.c
index 25b08bfa..6283fcb 100644
--- a/arch/arm/mach-pxa/raumfeld.c
+++ b/arch/arm/mach-pxa/raumfeld.c
@@ -505,6 +505,7 @@ static struct w1_gpio_platform_data w1_gpio_platform_data = {
 	.pin			= GPIO_ONE_WIRE,
 	.is_open_drain		= 0,
 	.enable_external_pullup	= w1_enable_external_pullup,
+	.ext_pullup_enable_pin	= -EINVAL,
 };
 
 struct platform_device raumfeld_w1_gpio_device = {
-- 
1.8.1.5

