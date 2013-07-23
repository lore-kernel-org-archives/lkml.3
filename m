Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab3GWM7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:59:13 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:55552 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab3GWM7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:59:12 -0400
Message-ID: <51EE7E1A.3040301@gmail.com>
Date: Tue, 23 Jul 2013 14:59:06 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [alsa-devel] [PATCH v3] ARM: kirkwood: extend the kirkwood i2s
 driver for DT usage
References: <20130723104615.3696f1a9@armhf> <20130723123444.GW9858@sirena.org.uk>
In-Reply-To: <20130723123444.GW9858@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/13 14:34, Mark Brown wrote:
> On Tue, Jul 23, 2013 at 10:46:15AM +0200, Jean-Francois Moine wrote:
>
>> +	np = pdev->dev.of_node;
>> +	if (np) {
>> +		struct of_phandle_args clkspec;
>> +
>> +		priv->burst = 128;			/* might be 32 or 128 */
>
> The comment says this needs to be variable (depending on what?) but it's
> hard coded.
>
>> +		priv->clk = of_clk_get(np, 0);	/* internal clock */
>> +		err = of_parse_phandle_with_args(np,
>> +					"clocks", "#clock-cells", 1,
>> +					&clkspec);
>
> As others have pointed out if you need to change the clock get code
> there's something wrong here, DT should be handled transparently by the
> clock API.

IMHO the reason why of_clk_get() was/is mis-used in that way is mostly
compatibility with legacy platform_data based setup.

Kirkwood-i2s never knew about anything else than internal clock, then
Dove allows additional external clock input, aso. All changes are
incremental and more or less sane. But now is a good opportunity to
clean up this.

As Sascha Hauer pointed out, clocks should be distinguished by names
(clock-names property) instead of position and then use
devm_clk_get(&pdev->dev, "internal") and
devm_clk_get(&pdev->dev, "external") respectively.

This will possibly also require to update platform_data and legacy
users of kirkwood-i2s or have different setup functions for non-DT
and DT.

Also, while ASoC API separates the audio-controller into cpu-side
and codec-side parts, the DT should not. IIRC and as Russell repeated
again, we mentioned to merge kirkwood-i2s.c and kirkwood-dma.c into
a single file, didn't we?

I know we didn't care that much in the past, but one last thing that I
catched while reading another thead about compatible strings:

We should really be more careful about those. The correct usage
of compatible strings should be "marvell,mvebu-i2s" as common fallback,
but also "marvell,dove-i2s" and "marvell,kirkwood-i2s" for the SoC dtsi
files. We do not need to have all possible compatible strings in the
_driver's_ of_device_id table but the dtsi should contain them.

Finally, I2S DT node will end up as:

i2s1: audio-controller@b4000 {
	compatible = "marvell,dove-i2s", "marvell,mvebu-i2s";
	reg = <0xb4000 0x2210>;
	interrupts = <21>, <22>;
	clocks = <&gate_clk 13>, <&si5351a 1>;
	clock-names = "internal", "external";
};

Jean-Francois, can you re-spin your patches with the comments made by
others and the above summary? I really like to see i2s for DT soon,
although we will not be able to support multiple codecs per DAI, yet.

Sebastian
