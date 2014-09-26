Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaIZOrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:47:20 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:13400 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbaIZOrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:47:19 -0400
Message-ID: <54257C70.50008@atmel.com>
Date: Fri, 26 Sep 2014 16:47:12 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Olof Johansson <olof@lixom.net>, <arm@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: soc for 3.18 #2
References: <1411391733-28891-1-git-send-email-nicolas.ferre@atmel.com> <201409261250.02565.arnd@arndb.de>
In-Reply-To: <201409261250.02565.arnd@arndb.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/09/2014 12:50, Arnd Bergmann :
> On Monday 22 September 2014, Nicolas Ferre wrote:
> 
>> Nicolas Ferre (4):
>>       ARM: at91: introduce basic SAMA5D4 support
>>       ARM: at91: SAMA5D4 SoC detection code and low level routines
> 
> This resulted in build failures both in at91x40_defconfig and some
> randconfigs with MMU disabled. I've applied the patch below on top
> to fix it.

Ok, I see: sorry for the inconvenience.
What about taking the patch that I sent about removing completely the
at91x40 as it is "Acked" by everybody now? The would prevent from adding
these unneeded values.

> I'm not exactly happy about the soc detection code anyway after I
> had to look at that. Why do you even hardcode the physical register
> location rather than getting it from DT?
>
> Also, why do you care about which SoC version you have for the
> modern SAMA5 chips? All I see is a sama5d4_map_io() callback
> that maps a lot of completely unused registers along with
> the uart that you normally get from the implicit debug_ll_io_init,
> and the SRAM that should probably be turned into a normal driver.

Yes, as said by Alexandre, we are aware of the flaws of AT91 SoC
initialization, but last time I tried, our code was called too early.
Now with the work from Maxime with the timer (in 3.18) it might be
possible to reorder all this.
But please, I would really like to remove all !DT *and* !CCF material
before starting this work, otherwise we will again have a double path
for sam9's and I'd like to avoid this.

Your thoughts?

Bye,

> 8<-------
>>From 45aeea29c360551519edd8e041b36d8a4d5f6a23 Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Fri, 26 Sep 2014 12:27:00 +0200
> Subject: [PATCH] ARM: at91: fix nommu build regression
> 
> The newly introduced support for SAMA5D4 added access to the
> 'AT91_ALT_BASE_SYS' register area, but failed to define the
> symbols in the case when CONFIG_MMU is disabled.
> 
> We really should not hardwire addresses like this any more,
> but as a small fixup, this patch just adds the missing
> definitions for the nommu case, which gets at91x40_defconfig
> and any configuration of sam9 and sama5 with MMU disabled
> back to work.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 726d32bf79ef4 ("ARM: at91: SAMA5D4 SoC detection code and low ...")
> 
> diff --git a/arch/arm/mach-at91/include/mach/hardware.h b/arch/arm/mach-at91/include/mach/hardware.h
> index d84776f6b8ac..c13797352688 100644
> --- a/arch/arm/mach-at91/include/mach/hardware.h
> +++ b/arch/arm/mach-at91/include/mach/hardware.h
> @@ -51,11 +51,12 @@
>   */
>  #define AT91_BASE_SYS	0xffffc000
>  
> +#endif
> +
>  /*
>   * On sama5d4 there is no system controller, we map some needed peripherals
>   */
>  #define AT91_ALT_BASE_SYS	0xfc069000
> -#endif
>  
>  /*
>   * On all at91 have the Advanced Interrupt Controller starts at address
> @@ -90,6 +91,9 @@
>   */
>  #define AT91_IO_PHYS_BASE	AT91_BASE_SYS
>  #define AT91_IO_VIRT_BASE	IOMEM(AT91_IO_PHYS_BASE)
> +
> +#define AT91_ALT_IO_PHYS_BASE	AT91_ALT_BASE_SYS
> +#define AT91_ALT_IO_VIRT_BASE	IOMEM(AT91_ALT_BASE_SYS)
>  #endif
>  
>  #define AT91_IO_SIZE		(0xFFFFFFFF - AT91_IO_PHYS_BASE + 1)
> 
> 


-- 
Nicolas Ferre
