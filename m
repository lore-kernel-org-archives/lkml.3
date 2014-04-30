Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbaD3ITo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:19:44 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:47319 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaD3ITj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:19:39 -0400
MIME-Version: 1.0
In-Reply-To: <53606F49.1000401@realtek.com>
References: <cover.1398735435.git.micky_ching@realsil.com.cn>
	<7208467.nZIXMIfPji@wuerfel>
	<CAPDyKFpJrrviaZo_L8MkLF=v7DqGEVj9=uSNsNtU-FXNwu-MmQ@mail.gmail.com>
	<201404300228.s3U2S7WA026782@rtits1.realtek.com>
	<53606F49.1000401@realtek.com>
Date: Wed, 30 Apr 2014 10:19:39 +0200
Message-ID: <CAPDyKFrA39eFnoy-sAGcAUeDqtB78cvAivV+mmRR5C-tov-9eg@mail.gmail.com>
Subject: Re: [PATCH] mmc: rtsx: usb backend needs LED support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Roger <rogerable@realtek.com>
Cc: Arnd Bergmann <arnd@arndb.de>, micky <micky_ching@realsil.com.cn>,
        Chris Ball <chris@printf.net>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 April 2014 05:34, Roger <rogerable@realtek.com> wrote:
>
> On 04/29/2014 08:46 PM, Arnd Bergmann wrote:
>>
>> On Tuesday 29 April 2014 13:05:15 Ulf Hansson wrote:
>>>
>>> On 29 April 2014 11:45, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>
>>>> drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_remove':
>>>> :(.text+0x806480): undefined reference to `led_classdev_unregister'
>>>> drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_probe':
>>>> :(.text+0x806708): undefined reference to `led_classdev_register'
>>>>
>>>> This adds an explicit dependency in Kconfig
>>>
>>>
>>> I think the proper solution is to fix the dependency in the driver code
>>> instead.
>>>
>>> There are already some ifdefs hackery for making it optional to use
>>> leds, apparently that's not working properly.
>>>
>>
>> Ah, right, I misinterpreted the bug. Here is a new version:
>>
>> 8<---------
>>>
>>> From 5b5588f8c9b8ded8b296fd32d87b2d118e548a29 Mon Sep 17 00:00:00 2001
>>
>> From: Arnd Bergmann <arnd@arndb.de>
>> Date: Tue, 29 Apr 2014 11:41:40 +0200
>> Subject: [PATCH] mmc: rtsx: usb backend needs LED support
>>
>> Building the rtsx USB driver uses the LED classdev base
>> support if available, but that fails if the classdev
>> is a module and the MMC driver is built-in, leading to this
>> link error.
>>
>> drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_remove':
>> :(.text+0x806480): undefined reference to `led_classdev_unregister'
>> drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_probe':
>> :(.text+0x806708): undefined reference to `led_classdev_register'
>>
>> This adds an explicit dependency in Kconfig to ensure that
>> the MMC driver has to be a module if LEDS_CLASS is a module,
>> but still allows it to be built-in if LEDS_CLASS is either
>> disabled or built-in.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
>> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
>> index 92d91fe..68da9b8 100644
>>
>> --- a/drivers/mmc/host/Kconfig
>> +++ b/drivers/mmc/host/Kconfig
>> @@ -696,6 +696,7 @@ config MMC_REALTEK_PCI
>>   config MMC_REALTEK_USB
>>         tristate "Realtek USB SD/MMC Card Interface Driver"
>>         depends on MFD_RTSX_USB
>> +       depends on m || LEDS_CLASS!=m
>>
>>         help
>>           Say Y here to include driver code to support SD/MMC card
>> interface
>>           of Realtek RTS5129/39 series card reader
>>
>> .
>>
>
> I think Ulf's idea is to fix the bug by modifying the .c files.
> I really found the problem of my ifdef hackery and it should do something
> similar in sdhci.c as:
>
> From: Roger Tseng <rogerable@realtek.com>
> Date: Wed, 30 Apr 2014 11:11:25 +0800
> Subject: [PATCH] mmc: rtsx: fix possible linking error if built-in
>
> rtsx_usb_sdmmc module uses the LED classdev if available, but the code
> failed
> to consider the situation that it is built-in and the LED classdev is a
> module,
> leading to following linking error:
>
>   LD      init/built-in.o
> drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_remove':
> rtsx_usb_sdmmc.c:(.text+0x2a018e): undefined reference to
> `led_classdev_unregister'
> drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_probe':
> rtsx_usb_sdmmc.c:(.text+0x2a197e): undefined reference to
> `led_classdev_register'
>
> Fix by excluding such condition when defining macro RTSX_USB_USE_LEDS_CLASS.
>
> Signed-off-by: Roger Tseng <rogerable@realtek.com>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

> ---
>  drivers/mmc/host/rtsx_usb_sdmmc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c
> b/drivers/mmc/host/rtsx_usb_sdmmc.c
> index e11fafa..38bdda5 100644
> --- a/drivers/mmc/host/rtsx_usb_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
> @@ -34,7 +34,8 @@
>  #include <linux/mfd/rtsx_usb.h>
>  #include <asm/unaligned.h>
>
> -#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
> +#if defined(CONFIG_LEDS_CLASS) || (defined(CONFIG_LEDS_CLASS_MODULE) && \
> +       defined(CONFIG_MMC_REALTEK_USB_MODULE))
>  #include <linux/leds.h>
>  #include <linux/workqueue.h>
>  #define RTSX_USB_USE_LEDS_CLASS
>
> Best regards,
> Roger Tseng
