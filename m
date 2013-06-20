Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab3FTGSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 02:18:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48986 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab3FTGSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 02:18:48 -0400
Message-ID: <51C29EA5.5050507@ti.com>
Date: Thu, 20 Jun 2013 11:48:13 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/7] ARM: davinci: creation of gpio platform device
 for dmxxx platforms
References: <1371202532-14628-1-git-send-email-avinashphilip@ti.com> <1371202532-14628-5-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1371202532-14628-5-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2013 3:05 PM, Philip Avinash wrote:
> gpio controller resource information being associated with
> davinci_soc_info structure and not created any device. Hence davinci
> gpio didn't fall under proper device model. This patch creates gpio
> davinci as a platform device for dmxxx platforms.
> Also add daivinci_register_gpio API to create platform device for dmxxx
> platforms.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> ---
>  arch/arm/mach-davinci/devices.c             |   13 +++++++++++++
>  arch/arm/mach-davinci/include/mach/common.h |    2 ++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
> index a7068a3..b4f345b 100644
> --- a/arch/arm/mach-davinci/devices.c
> +++ b/arch/arm/mach-davinci/devices.c
> @@ -313,6 +313,19 @@ static void davinci_init_wdt(void)
>  	platform_device_register(&davinci_wdt_device);
>  }
>  
> +static struct platform_device davinci_gpio_device = {
> +	.name		= "davinci_gpio",
> +	.id		= -1,
> +};
> +
> +int davinci_gpio_register(struct resource *res, int size, void *pdata)
> +{
> +	davinci_gpio_device.resource = res;
> +	davinci_gpio_device.num_resources = size;
> +	davinci_gpio_device.dev.platform_data = pdata;
> +	return platform_device_register(&davinci_gpio_device);
> +}
> +
>  /*-------------------------------------------------------------------------*/
>  
>  /*-------------------------------------------------------------------------*/
> diff --git a/arch/arm/mach-davinci/include/mach/common.h b/arch/arm/mach-davinci/include/mach/common.h
> index b124b77..bd389ba 100644
> --- a/arch/arm/mach-davinci/include/mach/common.h
> +++ b/arch/arm/mach-davinci/include/mach/common.h
> @@ -14,6 +14,7 @@
>  
>  #include <linux/compiler.h>
>  #include <linux/types.h>
> +#include <linux/ioport.h>
>  
>  extern void davinci_timer_init(void);
>  
> @@ -83,6 +84,7 @@ extern void davinci_common_init(struct davinci_soc_info *soc_info);
>  extern void davinci_init_ide(void);
>  void davinci_restart(char mode, const char *cmd);
>  void davinci_init_late(void);
> +int davinci_gpio_register(struct resource *res, int size, void *pdata);

This declaration should not be inserted into this globally visible header.
There is a local davinci.h for the same purpose.

I did the fix for you. Here is the updated patch I am committing.
I fixed the description in a manner similar to 3/7.

Thanks,
Sekhar

>From 505ac35b131a90c721bf82bd1236da7a4f46ba12 Mon Sep 17 00:00:00 2001
From: Philip Avinash <avinashphilip@ti.com>
Date: Fri, 14 Jun 2013 15:05:29 +0530
Subject: [PATCH 1/1] ARM: davinci: devices.c: support gpio platform device

DaVinci GPIO driver now uses platform device model.
Add a GPIO platform register API to convert the
traditional DaVinci  SoCs to use the new model.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
[nsekhar@ti.com: move function declaration to local header,
simplify commit message]
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/mach-davinci/davinci.h |    2 ++
 arch/arm/mach-davinci/devices.c |   13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
index 1ab3df4..5c0f0c1 100644
--- a/arch/arm/mach-davinci/davinci.h
+++ b/arch/arm/mach-davinci/davinci.h
@@ -53,6 +53,8 @@ extern void __iomem *davinci_sysmod_base;
 #define DAVINCI_SYSMOD_VIRT(x)	(davinci_sysmod_base + (x))
 void davinci_map_sysmod(void);
 
+int davinci_gpio_register(struct resource *res, int size, void *pdata);
+
 /* DM355 base addresses */
 #define DM355_ASYNC_EMIF_CONTROL_BASE	0x01e10000
 #define DM355_ASYNC_EMIF_DATA_CE0_BASE	0x02000000
diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index a7068a3..b4f345b 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -313,6 +313,19 @@ static void davinci_init_wdt(void)
 	platform_device_register(&davinci_wdt_device);
 }
 
+static struct platform_device davinci_gpio_device = {
+	.name		= "davinci_gpio",
+	.id		= -1,
+};
+
+int davinci_gpio_register(struct resource *res, int size, void *pdata)
+{
+	davinci_gpio_device.resource = res;
+	davinci_gpio_device.num_resources = size;
+	davinci_gpio_device.dev.platform_data = pdata;
+	return platform_device_register(&davinci_gpio_device);
+}
+
 /*-------------------------------------------------------------------------*/
 
 /*-------------------------------------------------------------------------*/
