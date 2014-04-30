Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaD3HAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 03:00:52 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:60046 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaD3HAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 03:00:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roger <rogerable@realtek.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, micky <micky_ching@realsil.com.cn>,
        Chris Ball <chris@printf.net>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: [PATCH] mmc: rtsx: usb backend needs LED support
Date: Wed, 30 Apr 2014 09:00:33 +0200
Message-ID: <5378270.XmQGrvIcFE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53606F49.1000401@realtek.com>
References: <cover.1398735435.git.micky_ching@realsil.com.cn> <201404300228.s3U2S7WA026782@rtits1.realtek.com> <53606F49.1000401@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:NwnBUcVm2UT/c0jRRTuVQLQ1qEXUmy+JLW3LvzHo/4Q
 QFoqiCvJKlO9vo6zSxX5lw//j3UJSeALPVLA3VdW5kun077eLO
 BcVYQv08XqtiaifBy0ak6crzukUXroSyfNvY7OOTu4WJNyueEC
 IUnsYOlAqgvHaPe0xYYuFlq+NlbKH4aQj9+l+EgIuskdei956b
 8T6/xszzSVCNQgKECbRhXhdD4aswDXCZj0gHwmEOnDMI2Jn0mx
 ku9R4C0wXFFCS+0so+solGwkiMrqsrtQMadvsKGS65SvrseBzF
 LfJQA7FlJK+RpBi7QuI4qLi4KrVTzaEEBNcTYv09SP8xC85AWz
 +qTHniYLy2HyvNUi8qyY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 April 2014 11:34:33 Roger wrote:
> I think Ulf's idea is to fix the bug by modifying the .c files.
> I really found the problem of my ifdef hackery and it should do 
> something similar in sdhci.c as:
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
>    LD      init/built-in.o
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

Yes, that should work, too.

Acked-by: Arnd Bergmann <arnd@arndb.de>


> ---
>   drivers/mmc/host/rtsx_usb_sdmmc.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c 
> b/drivers/mmc/host/rtsx_usb_sdmmc.c
> index e11fafa..38bdda5 100644
> --- a/drivers/mmc/host/rtsx_usb_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
> @@ -34,7 +34,8 @@
>   #include <linux/mfd/rtsx_usb.h>
>   #include <asm/unaligned.h>
> 
> -#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
> +#if defined(CONFIG_LEDS_CLASS) || (defined(CONFIG_LEDS_CLASS_MODULE) && \
> +       defined(CONFIG_MMC_REALTEK_USB_MODULE))
>   #include <linux/leds.h>
>   #include <linux/workqueue.h>
>   #define RTSX_USB_USE_LEDS_CLASS
> 

