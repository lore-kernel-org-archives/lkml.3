Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab3BOVb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 16:31:56 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38376 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3BOVby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 16:31:54 -0500
Message-ID: <511EA944.1090900@wwwdotorg.org>
Date: Fri, 15 Feb 2013 14:31:48 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Wolfram Sang <wsa@the-dreams.de>, linux-doc@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Grant Grundler <grundler@chromium.org>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jean Delvare <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        bhushan.r@samsung.com,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        sreekumar.c@samsung.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Prashanth G <prashanth.g@samsung.com>
Subject: Re: [PATCH v3 1/3] i2c: mux: Add i2c-arbitrator-cros-ec 'mux' driver
References: <1360887677-20758-1-git-send-email-dianders@chromium.org> <1360957573-864-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1360957573-864-1-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 12:46 PM, Doug Anderson wrote:
> The i2c-arbitrator-cros-ec driver implements the arbitration scheme
> that the Embedded Controller (EC) on the ARM Chromebook expects to use
> for bus multimastering.  This i2c-arbitrator-cros-ec driver could also
> be used in other places where standard I2C bus arbitration can't be
> used and two extra GPIOs are available for arbitration.
> 
> This driver is based on code that Simon Glass added to the i2c-s3c2410
> driver in the Chrome OS kernel 3.4 tree.  The current incarnation as a
> mux driver is as suggested by Grant Likely.  See
> <https://patchwork.kernel.org/patch/1877311/> for some history.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

> diff --git a/drivers/i2c/muxes/i2c-arbitrator-cros-ec.c b/drivers/i2c/muxes/i2c-arbitrator-cros-ec.c

> +static int i2c_arbitrator_probe(struct platform_device *pdev)

> +	/* Request GPIOs */
> +	ret = of_get_named_gpio_flags(np, "ap-claim-gpio", 0, &gpio_flags);
> +	if (ret == -EPROBE_DEFER || WARN_ON(!gpio_is_valid(ret)))
> +		return ret;

I think by the time that doesn't return -EPROBE_DEFER ...

> +	arb->ap_gpio = ret;
> +	arb->ap_gpio_release = !!(gpio_flags & OF_GPIO_ACTIVE_LOW);
> +	out_init = (gpio_flags & OF_GPIO_ACTIVE_LOW) ?
> +		GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
> +	ret = devm_gpio_request_one(&pdev->dev, arb->ap_gpio, out_init,
> +				    "ap-claim-gpio");
> +	if (ret == -EPROBE_DEFER || WARN_ON(ret))
> +		return ret;

... that won't either, since of_get_named_gpio_flags()'s implementation
requires the relevant GPIO driver to be active already.

Still, there's no harm in the code as it stands, so no need to change.
