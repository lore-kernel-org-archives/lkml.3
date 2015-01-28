Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373AbbA2CKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:10:20 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:56608 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbbA2CKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:10:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: renesas: fix extcon dependency
Date: Wed, 28 Jan 2015 22:47:18 +0100
Message-ID: <2167400.bYh9r60XLF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:PusqTmWVXVrlUJxwq79IeNVXaSWkeRTRaR66wKbEDg2kn0Vg2vf
 W07xz1FlX8F4Q0Cdp10YkMbC5mzjFU22YDcuJMEAzgya2PafgVDA/YByVXkBXbvwcrlKKfx
 xYI9yTFOTs2TGXldXY2aUesMICi1tpinXRgCshMqt8Pe8aCnpLa3LWexSxaMwO0K7E+3Ze+
 NX5upWE8Usg6zShge6UbQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The renesas usbhs driver calls extcon_get_edev_by_phandle(), which
is defined in drivers/extcon/extcon-class.c, and that can be a
loadable module. If the extcon-class support is disabled, usbhs
will work correctly for all devices that do not need extcon.

However, if extcon-class is a loadable module, and usbhs is
built-in, the kernel fails to link. In order to solve that,
we need a Kconfig dependency that allows extcon to be disabled
but does not allow usbhs built-in if extcon is a module.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/usb/renesas_usbhs/Kconfig b/drivers/usb/renesas_usbhs/Kconfig
index de83b9d0cd5c..0ea9040b9f10 100644
--- a/drivers/usb/renesas_usbhs/Kconfig
+++ b/drivers/usb/renesas_usbhs/Kconfig
@@ -6,6 +6,7 @@ config USB_RENESAS_USBHS
 	tristate 'Renesas USBHS controller'
 	depends on USB_GADGET
 	depends on ARCH_SHMOBILE || SUPERH || COMPILE_TEST
+	depends on EXTCON || !EXTCON # for module build if extcon is
 	default n
 	help
 	  Renesas USBHS is a discrete USB host and peripheral controller chip

