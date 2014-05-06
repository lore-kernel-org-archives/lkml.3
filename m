Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaEFTEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:04:25 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58909 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaEFTEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:04:23 -0400
Message-ID: <53693229.3080705@gmail.com>
Date: Tue, 06 May 2014 21:04:09 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
CC: kgene.kim@samsung.com, Russell King <linux@arm.linux.org.uk>,
        arnd@arndb.de, Wolfram Sang <wsa@the-dreams.de>, t.figa@samsung.com,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 2/6] ARM: EXYNOS: Move SYS_I2C_CFG register save/restore
 to i2c driver
References: <1399366282-4191-1-git-send-email-pankaj.dubey@samsung.com> <1399366282-4191-3-git-send-email-pankaj.dubey@samsung.com>
In-Reply-To: <1399366282-4191-3-git-send-email-pankaj.dubey@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 06.05.2014 10:51, Pankaj Dubey wrote:
> Let's move SYS_I2C_CFG register save/restore during s2r into i2c driver.
> This will help in removing static iodesc based mapping from exynos.c.
> Also will help in removing SoC specific checks in pm.c making it
> more independent of such macros.
>
> CC: Wolfram Sang <wsa@the-dreams.de>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: linux-i2c@vger.kernel.org
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>   arch/arm/mach-exynos/exynos.c           |   12 +-----------
>   arch/arm/mach-exynos/include/mach/map.h |    3 ---
>   arch/arm/mach-exynos/pm.c               |   10 ----------
>   arch/arm/mach-exynos/regs-sys.h         |   22 ----------------------
>   drivers/i2c/busses/i2c-s3c2410.c        |    8 ++++++++
>   5 files changed, 9 insertions(+), 46 deletions(-)
>   delete mode 100644 arch/arm/mach-exynos/regs-sys.h

[snip]

> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
> index 0420150..2095a01 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -133,6 +133,7 @@ struct s3c24xx_i2c {
>   	struct notifier_block	freq_transition;
>   #endif
>   	struct regmap		*sysreg;
> +	unsigned int		syc_cfg;

I suspect this is a typo, as the name syc_cfg looks a bit strange. 
Shouldn't it be sys_i2c_cfg?

>   };
>
>   static struct platform_device_id s3c24xx_driver_ids[] = {
> @@ -1293,6 +1294,9 @@ static int s3c24xx_i2c_suspend_noirq(struct device *dev)
>   	struct platform_device *pdev = to_platform_device(dev);
>   	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
>
> +	if (i2c->sysreg)

IS_ERR() should be used.

> +		regmap_read(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, &i2c->syc_cfg);

Aha, so this is where the reference to the regmap gets used outside the 
probe. I'd say that changes to the i2c driver from this patch should be 
squashed with previous patch and this patch should contain only arch 
changes to remove old code.

However, I wonder if this is really the right approach to this, as now 
you have save and restore duplicated for every instance of s3c24xx-i2c 
IP block. If there are no bits other than interrupt mux selectors in 
this registers then I guess this is fine (I can't look it up in the 
documentation at the moment), but otherwise you can end-up with multiple 
paths doing read-modify-write to this register in parallel possibly with 
different values.

Needless to say, this isn't very elegant, but I'm not opposed too much, 
as I can't really think of anything better right now.

> +
>   	i2c->suspended = 1;
>
>   	return 0;
> @@ -1304,6 +1308,10 @@ static int s3c24xx_i2c_resume(struct device *dev)
>   	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
>
>   	i2c->suspended = 0;
> +
> +	if (i2c->sysreg)
> +		regmap_write(i2c->sysreg, i2c->syc_cfg, EXYNOS5_SYS_I2C_CFG);
> +

I'd say this should be happening before setting i2c->suspended to 0 to 
account for possible i2c transfers being requested in parallel. Also see 
patch [1].

[1] https://lkml.org/lkml/2014/4/11/632

Best regards,
Tomasz
