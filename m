Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763599Ab3DDREJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:04:09 -0400
Received: from smtp.infotech.no ([82.134.31.41]:33784 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763521Ab3DDREH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:04:07 -0400
Message-ID: <515DB248.6070105@interlog.com>
Date: Thu, 04 Apr 2013 13:03:04 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: linux-arm-kernel@lists.infradead.org, jhovold@gmail.com,
        robertcnelson@gmail.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: at91: add Acme Systems Aria G25 board
References: <20130402184947.GA8015@quad.lixom.net> <1365090153-1807-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1365090153-1807-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: multipart/mixed;
 boundary="------------040402050103090900030309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040402050103090900030309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 13-04-04 11:42 AM, Nicolas Ferre wrote:
> From: Douglas Gilbert <dgilbert@interlog.com>
>
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Hi all,
>
> Here is the third revision of this patch. I plan to include it in a
> pull-request real-soon-now!
>
> v3: - move to "at91-" prefix for .dts[i] files
>      - remove the rtc activation code because of the ongoing discussions
>        about this IP and its DT binding.
>

Nicolas,
It's a pity that the rtc activation code is removed.
At worst:
                         rtc@fffffeb0 {
                                 status = "okay";
                         };

does nothing. Also it is unlikely to be changed by any
movement on the rtc-at91rm9200 front.


The lack of use of uart1 is for my own, private reasons.
I think it would be more generally useful to show uart1's
definition and disable it as shown in the attached patch
fragment.


I also note that my date line was removed. I like dates,
so when I add comments like "the i2c-at91 driver is broken
for the SAM9G20 ** and use the i2c-gpio driver instead" then
this is not taken as an eternal truth. It worked in the
past and hopefully it will work again in the future.

While on the subject of I2C, I'm getting tired of seeing
this oft-copied line:
    i2c-gpio,delay-us = <2>;        /* ~100 kHz */

It is the clock half period in microseconds and for the 100 kHz
(standard) I2C clock speed, it should be 5. Due to rounding
(up) that gives a measured clock speed of around 88 kHz on
my equipment. Crappy I2C devices *** seem to cope better
with 12% below the standard clock frequency than 80% above
it.

Doug Gilbert

** broken in my tests on the FoxG20 with lk 3.9.0-rc5

*** if my experience is anything to go by there are many
     dodgy I2C devices, probably using I2C bit banging
     code borrowed from Wikipedia.



--------------040402050103090900030309
Content-Type: text/x-patch;
 name="ariag25_390rc5_dg1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ariag25_390rc5_dg1.patch"

--- a/arch/arm/boot/dts/ariag25.dts_orig	2013-04-04 11:58:40.518122816 -0400
+++ b/arch/arm/boot/dts/at91-ariag25.dts	2013-04-03 15:23:09.240385849 -0400
@@ -1,5 +1,5 @@
 /*
- * ariag25.dts - Device Tree file for Acme Systems Aria G25 (AT91SAM9G25 based)
+ * at91-ariag25.dts - Device Tree file for Acme Systems Aria G25 (AT91SAM9G25 based)
  *
  * Copyright (C) 2013 Douglas Gilbert <dgilbert@interlog.com>,
  *                    Robert Nelson <robertcnelson@gmail.com>
@@ -21,6 +21,7 @@
 		serial3 = &usart2;
 		serial4 = &usart3;
 		serial5 = &uart0;
+		serial6 = &uart1;
 	};
 
 	chosen {
@@ -121,6 +122,16 @@
 				status = "okay";
 			};
 
+			uart1: serial@f8044000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xf8044000 0x200>;
+				interrupts = <16 4 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_uart1>;
+				/* Remove following or change to "okay" if wanted */
+				status = "disabled";
+			};
+
 			spi0: spi@f0000000 {
 				status = "okay";
 				cs-gpios = <&pioA 14 0>, <0>, <0>, <0>;

--------------040402050103090900030309--
