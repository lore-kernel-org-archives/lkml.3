Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab3CPPKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 11:10:37 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55174 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab3CPPKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 11:10:36 -0400
Message-ID: <51448B6C.9010702@gmail.com>
Date: Sat, 16 Mar 2013 16:10:36 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] clk: add si5351 i2c common clock driver
References: <1360414772-12232-1-git-send-email-sebastian.hesselbarth@gmail.com> <1363439447-21336-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1363439447-21336-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: undefined
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On 16.03.2013 14:10, Sebastian Hesselbarth wrote:
> This patch adds a common clock driver for Silicon Labs Si5351a/b/c
> i2c programmable clock generators. Currently, the driver supports
> DT kernels only and VXCO feature of si5351b is not implemented. DT
> bindings selectively allow to overwrite stored Si5351 configuration
> which is very helpful for clock generators with empty eeprom
> configuration. Corresponding device tree binding documentation is
> also added.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Changes from v1:
> - remove .is_enabled functions as they read from i2c
>   (Reported by Daniel Mack)
> - add CLK_SET_RATE_PARENT on clkout reparent if clkout uses
>   its own multisync
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Dom Cobley <popcornmix@gmail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Cc: Rabeeh Khoury <rabeeh@solid-run.com>
> Cc: Daniel Mack <zonque@gmail.com>
> Cc: Jean-Francois Moine <moinejf@free.fr>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  .../devicetree/bindings/clock/silabs,si5351.txt    |  114 ++
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  drivers/clk/Kconfig                                |    9 +
>  drivers/clk/Makefile                               |    1 +
>  drivers/clk/clk-si5351.c                           | 1413 ++++++++++++++++++++
>  drivers/clk/clk-si5351.h                           |  155 +++
>  6 files changed, 1693 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/silabs,si5351.txt
>  create mode 100644 drivers/clk/clk-si5351.c
>  create mode 100644 drivers/clk/clk-si5351.h

[...]

> +static unsigned long si5351_msynth_recalc_rate(struct clk_hw *hw,
> +					       unsigned long parent_rate)
> +{
> +	struct si5351_hw_data *hwdata =
> +		container_of(hw, struct si5351_hw_data, hw);
> +	unsigned char reg = SI5351_CLK0_PARAMETERS +
> +		(SI5351_PARAMETERS_LENGTH * hwdata->num);
> +	unsigned long long rate;
> +	unsigned long m;
> +
> +	if (!hwdata->params.valid)
> +		si5351_read_parameters(hwdata->drvdata, reg, &hwdata->params);
> +
> +	if (hwdata->params.p3 == 0)
> +		return parent_rate;
> +
> +	/*
> +	 * multisync0-5: fOUT = (128 * P3 * fIN) / (P1*P3 + P2 + 512*P3)
> +	 * multisync6-7: fOUT = fIN / P1
> +	 */
> +	rate = parent_rate;
> +	if (hwdata->num > 5)
> +		m = hwdata->params.p1;
> +	else if ((si5351_reg_read(hwdata->drvdata, reg + 2) &
> +		  SI5351_OUTPUT_CLK_DIVBY4) == SI5351_OUTPUT_CLK_DIVBY4)
> +		m = 4;
> +	else {
> +		rate *= 128 * hwdata->params.p3;
> +		m = hwdata->params.p1 * hwdata->params.p3;
> +		m += hwdata->params.p2;
> +		m += 512 * hwdata->params.p3;
> +	}

A nit only, but according to Documentation/CodingStyle, all if/else
blocks need curly brackets if any of them needs them. Maybe there are
more places which are affected.

> +	do_div(rate, m);

I still have the problem that m == 0 in my case as I only set up two
clocks from my DT - which leads to a DIV0. The easiest fix is certainly
to bail here in that case.

Another option would be to only register the clocks to the framework
that are actually set up from DT, but that would require more rework at
the driver's probe level.

Other than that, this driver works perfectly for me - thanks again for
your work!




Daniel

