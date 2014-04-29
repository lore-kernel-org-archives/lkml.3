Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaD2Mq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 08:46:56 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53033 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaD2Mqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 08:46:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: micky <micky_ching@realsil.com.cn>, Chris Ball <chris@printf.net>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Roger <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: [PATCH] mmc: rtsx: usb backend needs LED support
Date: Tue, 29 Apr 2014 14:46:43 +0200
Message-ID: <20686823.1FvTzs9RAn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAPDyKFpJrrviaZo_L8MkLF=v7DqGEVj9=uSNsNtU-FXNwu-MmQ@mail.gmail.com>
References: <cover.1398735435.git.micky_ching@realsil.com.cn> <7208467.nZIXMIfPji@wuerfel> <CAPDyKFpJrrviaZo_L8MkLF=v7DqGEVj9=uSNsNtU-FXNwu-MmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:CSkuh64mNeJqSBS6z9iCu7CW2xzNP4HHVO4orYigLFn
 ZbMQ9ZhZxKNlTpeEbvM+daTw4tM+LGPeZxwrIdvRGNomZOndIq
 PdY9+yoZaHKt741eF0Iwl0XL4HHgFjFi6Hy7wTV1NGAduPSzIJ
 4tJ0VhlreH7Zrhgd1kH4rj2lSEMoKgLJYAQVmblAF+Noi17y6Z
 74JUo81k2Uq4ePff9i7aXVXiUVsha5q2TqTuoYa9fGO43MiBfy
 c/jPXS1BRhk/8NT7EvdVExyCDz3kXf8rqkJB8vVYB+XsqZuJRi
 NHHDntBrF88kN82yrzkFTpyV6Yzkfdd+uDfMIC6SSQVUtOEk/L
 OdOV94RZ9RwfmxJxyTOA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2014 13:05:15 Ulf Hansson wrote:
> On 29 April 2014 11:45, Arnd Bergmann <arnd@arndb.de> wrote:
> > drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_remove':
> > :(.text+0x806480): undefined reference to `led_classdev_unregister'
> > drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_probe':
> > :(.text+0x806708): undefined reference to `led_classdev_register'
> >
> > This adds an explicit dependency in Kconfig
> 
> I think the proper solution is to fix the dependency in the driver code instead.
> 
> There are already some ifdefs hackery for making it optional to use
> leds, apparently that's not working properly.
> 

Ah, right, I misinterpreted the bug. Here is a new version:

8<---------
>From 5b5588f8c9b8ded8b296fd32d87b2d118e548a29 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 29 Apr 2014 11:41:40 +0200
Subject: [PATCH] mmc: rtsx: usb backend needs LED support

Building the rtsx USB driver uses the LED classdev base
support if available, but that fails if the classdev
is a module and the MMC driver is built-in, leading to this
link error.

drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_remove':
:(.text+0x806480): undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_probe':
:(.text+0x806708): undefined reference to `led_classdev_register'

This adds an explicit dependency in Kconfig to ensure that
the MMC driver has to be a module if LEDS_CLASS is a module,
but still allows it to be built-in if LEDS_CLASS is either
disabled or built-in.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 92d91fe..68da9b8 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -696,6 +696,7 @@ config MMC_REALTEK_PCI
 config MMC_REALTEK_USB
 	tristate "Realtek USB SD/MMC Card Interface Driver"
 	depends on MFD_RTSX_USB
+	depends on m || LEDS_CLASS!=m
 	help
 	  Say Y here to include driver code to support SD/MMC card interface
 	  of Realtek RTS5129/39 series card reader

