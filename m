Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaB0OYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:24:12 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42124 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbaB0OYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:24:09 -0500
Message-ID: <530F4A84.9070906@ti.com>
Date: Thu, 27 Feb 2014 08:24:04 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, Lee Jones <lee.jones@linaro.org>
CC: <florian.vaussard@epfl.ch>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/3] mfd: twl6040: Select i2c fast mode as default with
 regmap patch
References: <1393509410-1640-1-git-send-email-peter.ujfalusi@ti.com> <1393509410-1640-2-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1393509410-1640-2-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 07:56 AM, Peter Ujfalusi wrote:
> All boards using twl6040 configures the i2c bus to 400KHz. While twl6040's
> defaults to normal mode (100KHz). So far twl6040 has no problem with i2c
> communication in this configuration it is safer to select fast i2c mode.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/mfd/twl6040.c       | 9 +++++++--
>  include/linux/mfd/twl6040.h | 1 +
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
> index 6e88f25832fb..2c308750f40f 100644
> --- a/drivers/mfd/twl6040.c
> +++ b/drivers/mfd/twl6040.c
> @@ -87,8 +87,13 @@ static struct reg_default twl6040_defaults[] = {
>  };
>  
>  static struct reg_default twl6040_patch[] = {
> -	/* Select I2C bus access to dual access registers */
> -	{ TWL6040_REG_ACCCTL, 0x09 },
> +	/*
> +	 * Select I2C bus access to dual access registers
> +	 * Interrupt register is cleared on read
> +	 * Select fast mode for i2c (400KHz)
> +	 */
> +	{ TWL6040_REG_ACCCTL,
> +		TWL6040_I2CSEL | TWL6040_INTCLRMODE | TWL6040_I2CMODE(1) },
>  };
>  
>  
> diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
> index 81f639bc1ae6..a69d16b30c18 100644
> --- a/include/linux/mfd/twl6040.h
> +++ b/include/linux/mfd/twl6040.h
> @@ -157,6 +157,7 @@
>  #define TWL6040_I2CSEL			0x01
>  #define TWL6040_RESETSPLIT		0x04
>  #define TWL6040_INTCLRMODE		0x08
> +#define TWL6040_I2CMODE(x)		((x & 0x3) << 4)
>  
>  /* STATUS (0x2E) fields */
>  
> 

we should ideally have been using highspeed for i2c bus.

is'nt it better if i2c_check_functionality (and adding required flags
for func) be used to check the adapter speed and decide this in the
driver instead of hardcoding the bus speed within TWL6040 -
considering that 6040 can infact do max high speed as well?

-- 
Regards,
Nishanth Menon
