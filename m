Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbbAADjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 22:39:04 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63994 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbbAADjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 22:39:00 -0500
Date: Wed, 31 Dec 2014 19:38:56 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Kevin Tsai <ktsai@capellamicro.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Archana Patni <archana.patni@linux.intel.com>,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 1/1] iio: Added Capella cm3232 ambient light sensor
 driver.
Message-ID: <20150101033856.GB10710@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Kevin Tsai <ktsai@capellamicro.com>,
	Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Grant Likely <grant.likely@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Antti Palosaari <crope@iki.fi>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Archana Patni <archana.patni@linux.intel.com>,
	linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1420071030-888-1-git-send-email-ktsai@capellamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420071030-888-1-git-send-email-ktsai@capellamicro.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin,

On Wed, Dec 31, 2014 at 04:10:30PM -0800, Kevin Tsai wrote:
> CM3232 is an advanced ambient light sensor with I2C protocol interface.
> The I2C slave address is internally hardwired as 0x10 (7-bit).  Writing
> to configure register is byte mode, but reading ALS register requests to
> use word mode for 16-bit resolution.
> 
> Signed-off-by: Kevin Tsai <ktsai@capellamicro.com>
> ---
>  .../devicetree/bindings/i2c/trivial-devices.txt    |   1 +
>  MAINTAINERS                                        |   6 +
>  drivers/iio/light/Kconfig                          |  11 +
[...]
> +static int cm3232_get_lux(struct cm3232_chip *chip);
> +static int cm3232_read_als_it(struct cm3232_chip *chip, int *val2);
> +
> +/**
> + * cm3232_reg_init() - Initialize CM3232 registers
> + * @chip:	pointer of struct cm3232.
> + *
> + * Initialize CM3232 ambient light sensor register to default values.
> + *
> +  Return: 0 for success; otherwise for error code.
Is a '*' missing?

> + */
> +static int cm3232_reg_init(struct cm3232_chip *chip)
> +{
> +	struct i2c_client *client = chip->client;
> +	struct cm3232_als_info *als_info;
> +	s32 ret;
> +
> +	/* Identify device */
[...]
> +
> +	/* Calculate mlux per bit based on als_it */
> +	ret = cm3232_read_als_it(chip, &als_it);
> +	if (ret < 0)
> +		return -EINVAL;
> +	tmp = (__force u64)als_info->mlux_per_bit;
> +	tmp *= als_info->mlux_per_bit_base_it;
> +	tmp = div_u64 (tmp, als_it);
                 ^
         no space after function
> +
> +	/* Get als_raw */
> +	als_info->als_raw = i2c_smbus_read_word_data(
> +				client,
> +				CM3232_REG_ADDR_ALS);
> +	if (als_info->als_raw < 0)
> +		return als_info->als_raw;
> +
> +	tmp *= als_info->als_raw;
> +	tmp *= als_info->calibscale;
> +	tmp = div_u64(tmp, CM3232_CALIBSCALE_RESOLUTION);
> +	tmp = div_u64(tmp, CM3232_MLUX_PER_LUX);
[...]

It builds clean and there are no checkpatch or sparse errors.
Overall it looks good.

-- 
- Jeremiah Mahler
