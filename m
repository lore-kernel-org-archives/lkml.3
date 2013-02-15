Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3BOQjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:39:39 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44001 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3BOQjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:39:35 -0500
Message-ID: <511E64C0.9090500@wwwdotorg.org>
Date: Fri, 15 Feb 2013 09:39:28 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Wolfram Sang <wolfram@the-dreams.de>, linux-doc@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Guenter Roeck <linux@roeck-us.net>,
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
        linux-kernel@vger.kernel.org,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Prashanth G <prashanth.g@samsung.com>
Subject: Re: [PATCH v2 1/3] i2c: mux: Add i2c-arbitrator-cros-ec 'mux' driver
References: <1360887677-20758-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1360887677-20758-1-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 05:21 PM, Doug Anderson wrote:
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

> diff --git a/drivers/i2c/muxes/i2c-arbitrator-cros-ec.c b/drivers/i2c/muxes/i2c-arbitrator-cros-ec.c

> +static int i2c_arbitrator_probe(struct platform_device *pdev)

> +	arb->parent = of_find_i2c_adapter_by_node(parent_np);
> +	if (WARN_ON(!arb->parent))
> +		return -EINVAL;

I think for all error paths after this point, a call to
i2c_put_adapter() is needed.

> +	/* Request GPIOs */
> +	ret = of_get_named_gpio_flags(np, "ap-claim-gpio", 0, &gpio_flags);
> +	if (WARN_ON(!gpio_is_valid(ret)))
> +		return ret;

You shouldn't warn in all cases; -EPROBE_DEFER can quite legitimately
happen and only temporarily prevents probe() - it's retried later.

> +	arb->ap_gpio = ret;

Nit: Perhaps simply assign arb->ap_gpio directly from the
of_get_named_gpio_flags call? It would make that call slightly clearer.

> +	arb->ap_gpio_release = !!(gpio_flags & OF_GPIO_ACTIVE_LOW);
> +	out_init = (gpio_flags & OF_GPIO_ACTIVE_LOW) ?
> +		GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;

Nit: I'd be tempted to test arb->ap_gpio_release here, rather than
extracting the value from the flags again. Semantically equivalent, but
it seems to slightly more directly show why it's being tested.

> +subsys_initcall(i2c_arbitrator_init);

You mentioned that you only saw problems using
module_init/module_platform_driver in your downstream tree, so the
problem doesn't affect upstream. Presumably those problems would be
fixed when upstreaming any other drivers into the mainline kernel. I'd
still be tempted to just use module_platform_driver here. But, I guess
I'm fine with the patch either way; I'll leave the call to Wolfram.

