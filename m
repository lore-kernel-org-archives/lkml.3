Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbbA2Bgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:36:33 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:49644 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbbA2Bfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:35:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH] Input: sun4i-ts: add thermal driver dependency
Date: Wed, 28 Jan 2015 16:17:10 +0100
Message-ID: <2265502.1m7jYBaqyh@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:ntJ1gzIvReVBSmq1gxgnX6rgshkehWPi3am8rKZPFswMUNd0h24
 iRbAWmJU3dc9U8KzdXv4zvxvu2uNOeDXy9PlJo4Ky4s69yP/K03zmT5ufY4NcBYzO2HJLEU
 ADappQ9DXGFdysPMHjlVpuYvaaXg+QCmSHM0g73QDedf9k3csJyc7be2fDwKzrdjCplWWM+
 yDWavGzBzB3yknBXCTGtA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sun4i-ts driver has had a dependency on the thermal code
since it was first merged, but this is not currently enforced
in Kconfig, so in some randconfig builds we get

drivers/built-in.o: In function `sun4i_ts_remove':
:(.text+0x2376f4): undefined reference to `thermal_zone_of_sensor_unregister'
drivers/built-in.o: In function `sun4i_ts_probe':
:(.text+0x237a94): undefined reference to `thermal_zone_of_sensor_register'
:(.text+0x237c00): undefined reference to `thermal_zone_of_sensor_unregister'

We need the dependency on THERMAL in order to ensure that this
driver becomes a loadable module if the thermal support itself
is modular, while the dependency on THERMAL_OF is a runtime dependency
and the driver will still build but not work if it is missing.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 6decea7c5438e2 ("Input: add driver for Allwinner sunxi SoC's rtp controller")

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 58917525126e..e2447f0063b7 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -943,6 +943,8 @@ config TOUCHSCREEN_SUN4I
 	tristate "Allwinner sun4i resistive touchscreen controller support"
 	depends on ARCH_SUNXI || COMPILE_TEST
 	depends on HWMON
+	depends on THERMAL
+	depends on THERMAL_OF || COMPILE_TEST
 	help
 	  This selects support for the resistive touchscreen controller
 	  found on Allwinner sunxi SoCs.

