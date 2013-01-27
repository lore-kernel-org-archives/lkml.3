Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab3A0Xwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 18:52:53 -0500
Received: from mga03.intel.com ([143.182.124.21]:14822 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939Ab3A0Xwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 18:52:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,547,1355126400"; 
   d="scan'208";a="195668508"
Date: Mon, 28 Jan 2013 00:52:48 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Kennet Wallden <kennet.wallden@stericsson.com>
Subject: Re: [PATCH 06/26] mfd: ab8500-sysctrl: Provide configuration for
 SysClkReqRfClkBuf registers
Message-ID: <20130127235248.GN1174@sortiz-mobl>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358254566-12419-7-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee, Kennet,

On Tue, Jan 15, 2013 at 12:55:46PM +0000, Lee Jones wrote:
> From: Kennet Wallden <kennet.wallden@stericsson.com>
> 
> Add the possibility to pass configuration settings for
> SysCl1kReqRfClkBuf to SysClk8ReqRfClkBuf via platform data.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Kennet Wallden <kennet.wallden@stericsson.com>
> Reviewed-by: Karl-Johan PERNTZ <karl-johan.perntz@stericsson.com>
> Reviewed-by: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
> ---
>  drivers/mfd/ab8500-sysctrl.c              |   25 +++++++++++++++++++++++++
>  include/linux/mfd/abx500/ab8500-sysctrl.h |    5 +++++
>  include/linux/mfd/abx500/ab8500.h         |    2 ++
>  3 files changed, 32 insertions(+)
> 
> diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
> index cf58f69..19a024e 100644
> --- a/drivers/mfd/ab8500-sysctrl.c
> +++ b/drivers/mfd/ab8500-sysctrl.c
> @@ -113,11 +113,36 @@ int ab8500_sysctrl_write(u16 reg, u8 mask, u8 value)
>  static int __devinit ab8500_sysctrl_probe(struct platform_device *pdev)
>  {
>  	struct ab8500_platform_data *plat;
> +	struct ab8500_sysctrl_platform_data *pdata;
>  
>  	sysctrl_dev = &pdev->dev;
>  	plat = dev_get_platdata(pdev->dev.parent);
>  	if (plat->pm_power_off)
>  		pm_power_off = ab8500_power_off;
> +
> +	pdata = plat->sysctrl;
> +
> +	if (pdata) {
> +		int ret;
> +		int i;
> +		int j;
Cosmetic 
int i, j, ret;


> +		for (i = AB8500_SYSCLKREQ1RFCLKBUF;
> +		     i <= AB8500_SYSCLKREQ8RFCLKBUF; i++) {
> +			j = i - AB8500_SYSCLKREQ1RFCLKBUF;
> +			ret = ab8500_sysctrl_write(i, 0xff,
> +						   pdata->initial_req_buf_config[j]);
> +			dev_dbg(&pdev->dev,
> +				"Setting SysClkReq%dRfClkBuf 0x%X\n",
> +				j + 1,
> +				pdata->initial_req_buf_config[j]);
> +			if (ret < 0) {
> +				dev_err(&pdev->dev,
> +					"unable to set sysClkReq%dRfClkBuf: "
> +					"%d\n", j + 1, ret);
> +			}
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> diff --git a/include/linux/mfd/abx500/ab8500-sysctrl.h b/include/linux/mfd/abx500/ab8500-sysctrl.h
> index 10eb509..ebf12e7 100644
> --- a/include/linux/mfd/abx500/ab8500-sysctrl.h
> +++ b/include/linux/mfd/abx500/ab8500-sysctrl.h
> @@ -37,6 +37,11 @@ static inline int ab8500_sysctrl_clear(u16 reg, u8 bits)
>  	return ab8500_sysctrl_write(reg, bits, 0);
>  }
>  
> +/* Configuration data for SysClkReq1RfClkBuf - SysClkReq8RfClkBuf */
> +struct ab8500_sysctrl_platform_data {
> +	u8 initial_req_buf_config[8];
> +};
> +
>  /* Registers */
>  #define AB8500_TURNONSTATUS		0x100
>  #define AB8500_RESETSTATUS		0x101
> diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
> index 96840c4..3f4e6d1 100644
> --- a/include/linux/mfd/abx500/ab8500.h
> +++ b/include/linux/mfd/abx500/ab8500.h
> @@ -270,6 +270,7 @@ struct regulator_reg_init;
>  struct regulator_init_data;
>  struct ab8500_gpio_platform_data;
>  struct ab8500_codec_platform_data;
> +struct ab8500_sysctrl_platform_data;
>  
>  /**
>   * struct ab8500_platform_data - AB8500 platform data
> @@ -291,6 +292,7 @@ struct ab8500_platform_data {
>  	struct regulator_init_data *regulator;
>  	struct ab8500_gpio_platform_data *gpio;
>  	struct ab8500_codec_platform_data *codec;
> +	struct ab8500_sysctrl_platform_data *sysctrl;
>  };
>  
>  extern int __devinit ab8500_init(struct ab8500 *ab8500,
> -- 
> 1.7.9.5
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
