Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaBJNmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:42:50 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57487 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752726AbaBJNmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:42:47 -0500
Date: Mon, 10 Feb 2014 13:42:38 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stefan =?utf-8?B?U8O4cmVuc2Vu?= <stefan.sorensen@spectralink.com>
Cc: "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] dp83640: Get gpio and master/slave configuration from
 DT
Message-ID: <20140210134237.GF29080@e106331-lin.cambridge.arm.com>
References: <1392037240-30913-1-git-send-email-stefan.sorensen@spectralink.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392037240-30913-1-git-send-email-stefan.sorensen@spectralink.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 01:00:40PM +0000, Stefan Sørensen wrote:
> This patch removes the module parameters gpio_tab and chosen_phy in favour of
> retrieving the configuration from DT through the properties
> 	dp83640,slave
> 	dp83640,calibrate-gpio
> 	dp83640,perout-gpios
> 	dp83640,extts-gpios
> The configuration is now stored for each master clock device, allowing different 
> gpio setups for each master.
> 
> Furthermore the code is enhanced to handle more than one periodic output.

Binding document please.

I have some basic comments below, but without a description of what the
properties mean, it's difficult to provide any meaningful review.

[...]

> +static int dp83640_probe_dt(struct device_node *node,
> +			    struct dp83640_private *dp83640)
> +{
> +	struct dp83640_clock *clock = dp83640->clock;
> +	struct property *prop;
> +	int err, proplen;
> +
> +	if (!node)
> +		return 0;
> +
> +	if (of_find_property(node, "dp83640,slave", NULL))
> +		dp83640->slave = true;

Use of_property_read_bool.

> +	if (!dp83640->slave && clock->chosen) {
> +		pr_err("dp83640,slave must be set if more than one device on the same bus");
> +		return -EINVAL;
> +	}
> +
> +	prop = of_find_property(node, "dp83640,perout-gpios", &proplen);
> +	if (prop) {
> +		if (dp83640->slave) {
> +			pr_err("dp83640,perout-gpios property can not be set together with dp83640,slave");
> +			return -EINVAL;
> +		}
> +
> +		clock->caps.n_per_out = proplen / sizeof(u32);
> +		if (clock->caps.n_per_out > N_EXT) {
> +			pr_err("dp83640,perout-gpios may not have more than %d entries",
> +			       N_EXT);
> +			return -EINVAL;
> +		}
> +		err = of_property_read_u32_array(node, "dp83640,perout-gpios",
> +						 clock->perout_gpios,
> +						 clock->caps.n_per_out);
> +		if (err < 0)
> +			return err;
> +	}

This looks nothing like the standard gpio bindings. What _exactly_ is
this property describing?

If this is not using the standard gpio bindings then this should be
renamed.

Either way this must be documented.

> +
> +	prop = of_find_property(node, "dp83640,extts-gpios", &proplen);
> +	if (prop) {
> +		if (dp83640->slave) {
> +			pr_err("dp83640,extts-gpios property can not be set together with dp83640,slave");
> +			return -EINVAL;
> +		}
> +
> +		clock->caps.n_ext_ts = proplen / sizeof(u32);
> +		if (clock->caps.n_ext_ts > N_EXT) {
> +			pr_err("dp83640,extts-gpios may not have more than %d entries",
> +			       N_EXT);
> +			return -EINVAL;
> +		}
> +		err = of_property_read_u32_array(node, "dp83640,extts-gpios",
> +						 clock->extts_gpios,
> +						 clock->caps.n_ext_ts);
> +		if (err < 0)
> +			return err;
> +	}

Similarly this does not look right for parsing a standard -gpios property.

> +
> +	prop = of_find_property(node, "dp83640,calibrate-gpio", &proplen);
> +	if (prop) {
> +		if (dp83640->slave) {
> +			pr_err("dp83640,calibrate-gpio property can not be set together with dp83640,slave");
> +			return -EINVAL;
> +		}
> +		clock->calibrate_gpio = -1;
> +		of_property_read_u32(node, "dp83640,calibrate-gpio",
> +				     &clock->calibrate_gpio);
> +	}

And again, this doesn't look right.

Thanks,
Mark.
