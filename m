Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaF3RV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:21:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37106 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756AbaF3RV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:21:27 -0400
Date: Mon, 30 Jun 2014 18:21:15 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Dan Murphy <dmurphy@ti.com>
Cc: "linux-sound@vger.kernel.org" <linux-sound@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2] ASoC: tas2552: Support TI TAS2552 Amplifier
Message-ID: <20140630172115.GE28740@leverpostej>
References: <1404148259-17305-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404148259-17305-1-git-send-email-dmurphy@ti.com>
Thread-Topic: [PATCH v2] ASoC: tas2552: Support TI TAS2552 Amplifier
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 30, 2014 at 06:10:59PM +0100, Dan Murphy wrote:
> Support the TI TAS2552 Class D amplifier.
> 
> The TAS2552 is a high efficiency Class-D audio
> power amplifier with advanced battery current
> management and an integrated Class-G boost
> The device constantly measures the
> current and voltage across the load and provides a
> digital stream of this information.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
> 
> v2 - Address RFC comments- Added regmap, and snd_soc calls
> removed debug code, address checkpatch errors -https://patchwork.kernel.org/patch/4378281/
> 
>  .../devicetree/bindings/sound/tas2552.txt          |   22 +
>  include/sound/tas2552-plat.h                       |   25 ++
>  sound/soc/codecs/Kconfig                           |    5 +
>  sound/soc/codecs/Makefile                          |    2 +
>  sound/soc/codecs/tas2552.c                         |  462 ++++++++++++++++++++
>  sound/soc/codecs/tas2552.h                         |   75 ++++
>  6 files changed, 591 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/sound/tas2552.txt
>  create mode 100644 include/sound/tas2552-plat.h
>  create mode 100644 sound/soc/codecs/tas2552.c
>  create mode 100644 sound/soc/codecs/tas2552.h
> 
> diff --git a/Documentation/devicetree/bindings/sound/tas2552.txt b/Documentation/devicetree/bindings/sound/tas2552.txt
> new file mode 100644
> index 0000000..58e931b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/sound/tas2552.txt
> @@ -0,0 +1,22 @@
> +Texas Instruments - tas2552 Codec module
> +
> +The tas2552 serial control bus communicates through I2C protocols
> +
> +Required properties:
> +
> +- compatible - "string" - One of:
> +    "ti,tas2552" - TAS2552

Drop the "string". The compatible list is a standard property and its
type (string list) is well-known.

You could change "One of:" to "should contain:", which will look less
weird with a single entry.

> +- reg - <int> -  I2C slave address

Similarly to "string" we can get rid of <int> here. i2c addresses are
well-known to be described in a single u32 cell.

> +
> +Optional properties:
> +
> +- power-gpio - gpio pin to enable/disable the device

The code below seems to look for "enable-gpio". Searching for
"power-gpio" only hits in the line above and the example below. I assume
the code is in error?

> +
> +Example:
> +
> +tas2552: tas2552@41 {
> +       compatible = "ti,tas2552";
> +       reg = <0x41>;
> +       power-gpio = <&gpio4 2 GPIO_ACTIVE_HIGH>;
> +};

[...]

> +       if (pdata) {
> +               data->power_gpio = pdata->power_gpio;
> +       } else if (np) {
> +               data->power_gpio = of_get_named_gpio(np, "enable-gpio", 0);

Usually I see this logic the other way around, looking for DT data first
then falling back to platform data if no DT information was present.

Cheers,
Mark.
