Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaLZR0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 12:26:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34595 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaLZR03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 12:26:29 -0500
Date: Fri, 26 Dec 2014 18:26:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Pali Rohar <pali.rohar@gmail.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, lm-sensors@lm-sensors.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 2/3] hwmon: Driver for OMAP3 temperature sensor
Message-ID: <20141226172627.GB24756@amd>
References: <20141226102933.GA28778@amd>
 <1419597294-21487-1-git-send-email-sre@kernel.org>
 <1419597294-21487-3-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419597294-21487-3-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-12-26 13:34:53, Sebastian Reichel wrote:
> OMAP34xx and OMAP36xx processors contain a register in the syscon area,
> which can be used to determine the SoCs temperature. This patch provides
> a DT based driver for the temperature sensor based on an older driver
> written by Peter De Schrijver for the Nokia N900 and N9.
> 
> Signed-off-by: Sebastian Reichel <sre@kernel.org>

> +	if (!data->valid || time_after(jiffies, data->last_updated + HZ)) {
> +		clk_enable(data->clk_32k);

This needs to be clk_prepare_enable()

> +		regmap_update_bits(data->syscon, SYSCON_TEMP_REG,
> +				   soc_mask, soc_mask);
> +
> +		if (!wait_for_eocz(EOCZ_MIN_RISING_DELAY,
> +		    EOCZ_MAX_RISING_DELAY, 1, data)) {
> +			e = -EIO;
> +			goto err;
> +		}
> +
> +		regmap_update_bits(data->syscon, SYSCON_TEMP_REG, soc_mask, 0);
> +
> +		if (!wait_for_eocz(EOCZ_MIN_FALLING_DELAY,
> +		    EOCZ_MAX_FALLING_DELAY, 0, data)) {
> +			e = -EIO;
> +			goto err;
> +		}
> +
> +		regmap_read(data->syscon, SYSCON_TEMP_REG, &temp_sensor_reg);
> +		data->temperature = temp_sensor_reg & ((1<<7) - 1);
> +		data->last_updated = jiffies;
> +		data->valid = true;
> +
> +err:
> +		clk_disable(data->clk_32k);

And this clk_disable_unprepare().

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
