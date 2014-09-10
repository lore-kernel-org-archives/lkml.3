Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaIJV0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:26:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55265 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbaIJV0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:26:48 -0400
Message-ID: <5410C222.2020602@wwwdotorg.org>
Date: Wed, 10 Sep 2014 15:26:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Marcel Ziswiler <marcel@ziswiler.com>, alsa-devel@alsa-project.org
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v2 1/2] ARM: tegra: apalis/colibri t30: integrate audio
 support
References: <cover.1410362950.git.marcel@ziswiler.com> <00f249b3d648d3a8d550c5db0737f3aa6d93f07e.1410362950.git.marcel@ziswiler.com>
In-Reply-To: <00f249b3d648d3a8d550c5db0737f3aa6d93f07e.1410362950.git.marcel@ziswiler.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 02:54 PM, Marcel Ziswiler wrote:
> Integrate Freescale SGTL5000 analogue audio codec support.
>
> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

No, definitely not; this patch has significant semantic changes since I 
reviewed it.

> diff --git a/arch/arm/boot/dts/tegra30-apalis.dtsi b/arch/arm/boot/dts/tegra30-apalis.dtsi


> +	sound {
> +		compatible = "simple-audio-card";
...
> +		simple-audio-card,codec {
> +			bitclock-master;
> +			clocks = <&tegra_car TEGRA30_CLK_EXTERN1>;
> +			frame-master;
> +			sound-dai = <&sgtl5000>;
> +		};
> +
> +		simple-audio-card,cpu {
> +			bitclock-master;
> +			clocks = <&tegra_car TEGRA30_CLK_PLL_A>,
> +				 <&tegra_car TEGRA30_CLK_PLL_A_OUT0>;
> +			frame-master;
> +			master-clkdir-out;
> +			sound-dai = <&tegra_i2s2>;
> +		};
> +	};

I'm not sure how this can work. Certainly all 3 clocks that are required 
for audio are mentioned here. However, the PLL_A clock (which then 
trickles down to the other 2) needs to have its rate changed based on 
whether the sample rate is 44.1KHz- or 48KHz-based. Semantically, this 
can't be something that "simple-audio-card" can imply, since 
"simple-audio-card" is something agnostic to any HW, whereas this 
clocking requirement is something specific to Tegra HW.

To see the problem, try encoding some audio stream as both 44.1KHz and 
48KHz, then play a few seconds of each and keep switching back and 
forth. You'll likely find either the playback pitch is wrong, or you get 
drop-outs or stuttering.

I also wonder how "simple-audio-card" can know what rate the EXTERN1 
clock to the CODEC should be set to; each CODEC has a different 
requirement for the minimum clock input and the Fs multiple usually 
varies for different sample rates. See for example 
sound/soc/tegra/tegra_wm8903.c:tegra_wm8903_hw_params(). This could be a 
solved problem though: Perhaps some API has been added to CODECs to 
report this information (or perhaps CODEC drivers now clk_set_rate() on 
their input clocks themselves) since I last looked.

