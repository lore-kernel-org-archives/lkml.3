Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab3CRV52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:57:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab3CRVGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [ 31/75] ARM: w1-gpio: fix erroneous gpio requests
Date: Mon, 18 Mar 2013 14:06:54 -0700
Message-Id: <20130318210512.477739673@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 2d798a3f20ae992b0b69a2b68c04ada397c32ed4 upstream.

Fix regression introduced by commit d2323cf773 ("onewire: w1-gpio: add
ext_pullup_enable pin in platform data") which added a gpio entry to the
platform data, but did not add the required initialisers to the board
files using it. Consequently, the driver would request gpio 0 at probe,
which could break other uses of the corresponding pin.

On AT91 requesting gpio 0 changes the pin muxing for PIOA0, which, for
instance, breaks SPI0 on at91sam9g20.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/board-foxg20.c    |    1 +
 arch/arm/mach-at91/board-stamp9g20.c |    1 +
 arch/arm/mach-ixp4xx/vulcan-setup.c  |    1 +
 arch/arm/mach-pxa/raumfeld.c         |    1 +
 4 files changed, 4 insertions(+)

--- a/arch/arm/mach-at91/board-foxg20.c
+++ b/arch/arm/mach-at91/board-foxg20.c
@@ -176,6 +176,7 @@ static struct w1_gpio_platform_data w1_g
 	/* If you choose to use a pin other than PB16 it needs to be 3.3V */
 	.pin		= AT91_PIN_PB16,
 	.is_open_drain  = 1,
+	.ext_pullup_enable_pin	= -EINVAL,
 };
 
 static struct platform_device w1_device = {
--- a/arch/arm/mach-at91/board-stamp9g20.c
+++ b/arch/arm/mach-at91/board-stamp9g20.c
@@ -188,6 +188,7 @@ static struct spi_board_info portuxg20_s
 static struct w1_gpio_platform_data w1_gpio_pdata = {
 	.pin		= AT91_PIN_PA29,
 	.is_open_drain	= 1,
+	.ext_pullup_enable_pin	= -EINVAL,
 };
 
 static struct platform_device w1_device = {
--- a/arch/arm/mach-ixp4xx/vulcan-setup.c
+++ b/arch/arm/mach-ixp4xx/vulcan-setup.c
@@ -163,6 +163,7 @@ static struct platform_device vulcan_max
 
 static struct w1_gpio_platform_data vulcan_w1_gpio_pdata = {
 	.pin			= 14,
+	.ext_pullup_enable_pin	= -EINVAL,
 };
 
 static struct platform_device vulcan_w1_gpio = {
--- a/arch/arm/mach-pxa/raumfeld.c
+++ b/arch/arm/mach-pxa/raumfeld.c
@@ -505,6 +505,7 @@ static struct w1_gpio_platform_data w1_g
 	.pin			= GPIO_ONE_WIRE,
 	.is_open_drain		= 0,
 	.enable_external_pullup	= w1_enable_external_pullup,
+	.ext_pullup_enable_pin	= -EINVAL,
 };
 
 struct platform_device raumfeld_w1_gpio_device = {


