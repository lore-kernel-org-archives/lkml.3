Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaI2Wij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:38:39 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35093 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbaI2Wig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:38:36 -0400
Message-ID: <5429DF69.8000201@gmail.com>
Date: Tue, 30 Sep 2014 00:38:33 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Abhilash Kesavan <a.kesavan@samsung.com>,
        linux-arm-kernel@lists.infradead.org
CC: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, jslaby@suse.cz,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: Re: [PATCH] serial: samsung: Fix serial config dependencies for exynos7
References: <1411967817-8423-1-git-send-email-a.kesavan@samsung.com>
In-Reply-To: <1411967817-8423-1-git-send-email-a.kesavan@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhilash,

The patch itself seems fine, but I wonder if those config options aren't
really just leftovers from the past and couldn't be completely removed.

On 29.09.2014 07:16, Abhilash Kesavan wrote:
> From: Pankaj Dubey <pankaj.dubey@samsung.com>
> 
> Exynos7 has a similar serial controller to that present in older Samsung
> SoCs. To re-use the existing serial driver on Exynos7 we need to have
> SERIAL_SAMSUNG_UARTS_4 and SERIAL_SAMSUNG_UARTS selected. This is not
> possible because these symbols are dependent on PLAT_SAMSUNG which is
> not present for the ARMv8 based exynos7.
> 
> Change the dependency of these symbols from PLAT_SAMSUNG to the serial
> driver thus making it available on exynos7. As the existing platform
> specific code making use of these symbols is related to uart driver this
> change in dependency should not cause any issues.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Build tested with s3c6400_defconfig, exynos_defconfig and arm64's defconfig
> with and without the serial driver enabled.
> 
>  drivers/tty/serial/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 81f6ee7..e6c0bcb 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -249,14 +249,14 @@ config SERIAL_SAMSUNG
>  
>  config SERIAL_SAMSUNG_UARTS_4
>  	bool
> -	depends on PLAT_SAMSUNG
> +	depends on SERIAL_SAMSUNG
>  	default y if !(CPU_S3C2410 || CPU_S3C2412 || CPU_S3C2440 || CPU_S3C2442)
>  	help
>  	  Internal node for the common case of 4 Samsung compatible UARTs

The only place where this symbol is used is below.

>  
>  config SERIAL_SAMSUNG_UARTS
>  	int
> -	depends on PLAT_SAMSUNG
> +	depends on SERIAL_SAMSUNG
>  	default 4 if SERIAL_SAMSUNG_UARTS_4 || CPU_S3C2416
>  	default 3
>  	help
> 

With this symbol the situation isn't that easy, but still should be
manageable.

Looking at the serial-samsung driver, all occurrences of
CONFIG_SERIAL_SAMSUNG_UARTS could be simply replaced with a locally
defined number equal to the maximum value - in this case 4.

There are also two places in arch/arm where this symbol is used:

1) In arch/arm/mach-s3c64xx/irq-pm.c it's used as the number of serial
ports which need suspend/resume handling. Since on s3c64xx the number is
always 4, it can be simply defined locally as a constant.

2) In arch/arm/plat-samsung/init.c it is used to determine size of a
static array of UART ports and to check whether the UART driver is
enabled. In former case I believe it should be safe to hardcode it to 4
as well, in latter CONFIG_SERIAL_SAMSUNG can be used.

Best regards,
Tomasz
