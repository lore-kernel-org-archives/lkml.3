Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3IXD5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 23:57:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34208 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3IXD5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 23:57:00 -0400
Message-ID: <52410D89.8010801@wwwdotorg.org>
Date: Mon, 23 Sep 2013 21:56:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Johannes Thumshirn <morbidrsa@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [RFC] PWM: Add support for pwm-bcm2835
References: <1379758142-7302-1-git-send-email-morbidrsa@gmail.com>
In-Reply-To: <1379758142-7302-1-git-send-email-morbidrsa@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2013 04:09 AM, Johannes Thumshirn wrote:
> Add support for the PWM controller of the BCM2835 SoC found on Raspberry PI
> 
> The driver isn't as much tested as I wanted it to be and devicetree
> support is still missing, but I thought it would be nice to have some
> comments if I'm in the right direction.

Presumably if DT support is missing, the driver can't have been tested
at all?

> diff --git a/drivers/pwm/pwm-bcm2835.c b/drivers/pwm/pwm-bcm2835.c

> +/* Address Mappings (offsets) from Broadcom BCM2835 ARM Periperals Manual
> + * Section 9.6 Page 141ff

s/141ff/141/

> +/* Control registers 0 and 1 are mirrored on a distance of 4 bits */
> +#define HWPWM(x) ((x) << 4)

Distances between registers aren't really measured in bits although
admittedly a certain minimum number of bits would be required to
represent that distance. I would suggest s/4 bits/16 bytes/. People are
likely to be familiar with "<< 4" being equivalent to "* 16".

> +/* TODO: We only need this register set once and use HWPWM macro to
> + * access 2nd output
> + */

I don't really understand what the TODO message says still needs to be
done. The comment format is wrong; /* should be on its own line.

> +static inline u32 bcm2835_readl(struct bcm2835_pwm_dev *chip,
> +				unsigned int hwpwm, unsigned int num)
> +{
> +	num <<= HWPWM(hwpwm);

This doesn't work for hwpwm==1; HWPWM() already shifted the ID left, so
you want "num += HWPWM(hwpwm)" here, I think. But as Thierry said, this
function really doesn't need to do anything other than take an offset.

Same comment for bcm2835_writel().

BTW, bcm2835_readl() isn't a good name for a PWM-specific function,
since it's pretty generic. While the name is static, so it won't cause
linker problems, it might confuse a symbolic debugger. Better make it
bcm2835_pwm_readl().

> +static int bcm2835_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +			      int duty_ns, int period_ns)

> +	/* write period */
> +	bcm2835_writel(bcm, pwm->hwpwm, BCM2835_PWM_RNG1, period_ns);
> +
> +	/* write duty */
> +	bcm2835_writel(bcm, pwm->hwpwm, BCM2835_PWM_DAT1, duty_ns);

Presumably those registers are a count of clock cycles, not an absolute
time in ns. The two are only equal if the PWM module clock runs at 1GHz.
So, don't you need to convert time to clock cycle count here, using
clk_get_rate(pwm_clk) as the ratio?

> +static int bcm2835_pwm_probe(struct platform_device *pdev)
...
> +	bcm = devm_kzalloc(&pdev->dev, sizeof(*bcm), GFP_KERNEL);
> +	if (!bcm)
> +		return -ENOMEM;
...
> +	ret = pwmchip_add(&bcm->chip);
> +	if (ret < 0)
> +		return ret;
> +
> +	platform_set_drvdata(pdev, bcm);

You should really set the drvdata as soon as you've allocated it, and at
least before calling pwmchip_add(); as soon as you've added the PWM
chip, the PWM core could call functions on the PWM object, and if those
callbacks rely on the drvdata, then they're going to fail if the drvdata
hasn't been set yet.

> +static const struct of_device_id bcm2835_pwm_of_match[] = {
> +	{ .compatible = "brcm,bcm2835-pwm" },
> +	{},
> +};

You need to write a DT binding document if you're going to ad DT support.
