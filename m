Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaEVRvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:51:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50304 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaEVRu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:50:59 -0400
Message-ID: <537E38FF.9000407@wwwdotorg.org>
Date: Thu, 22 May 2014 11:50:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Tushar Behera <tushar.behera@linaro.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        tiwai@suse.de, perex@perex.cz, dianders@chromium.org,
        jerry.wong@maximintegrated.com
Subject: Re: [PATCH 1/2] ASoC: max98090: Add master clock handling
References: <1400750228-13750-1-git-send-email-tushar.behera@linaro.org> <1400750228-13750-2-git-send-email-tushar.behera@linaro.org> <537E1D0A.6020303@wwwdotorg.org> <20140522173403.GL12304@sirena.org.uk>
In-Reply-To: <20140522173403.GL12304@sirena.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 11:34 AM, Mark Brown wrote:
> On Thu, May 22, 2014 at 09:51:38AM -0600, Stephen Warren wrote:
>> On 05/22/2014 03:17 AM, Tushar Behera wrote:
> 
>>> +	if (!IS_ERR(max98090->mclk)) {
>>> +		freq = clk_round_rate(max98090->mclk, freq);
>>> +		clk_set_rate(max98090->mclk, freq);
>>> +	}
> 
>> What are the intended semantics of set_sysclk()?
>> sound/soc/tegra/tegra_wm98090.c assumes that set_sysclk() is a
>> notification to the CODEC driver to tell it what rate the MCLK input is
>> set to (the rate is set before calling set_sysclk), whereas the code
>> above assumes that this function is to tell the CODEC to somehow
>> configure its input clock to be a particular rate. I have a feeling the
>> code above might fail on Tegra.
>
> It's a bit of both.  Since we've never had a generic clock API (and
> still don't really due to everything being a shambles) it's generally
> just a notification to the CODEC that it's at the specified rate,
> however if the CODEC knows about its dependencies it seems sensible for
> it to tell the clock API about what was asked.  Ideally we want to
> remove all the ASoC specific clock control and use the clock API.

I think we should nail down exactly what set_sysclk() means. Since it
takes an explicit MCLK clock rate (rather than e.g. sample rate) right
now, surely it's a notification of what the clock /is/, not a request
for the CODEC to set up its input clock. If we expect the CODEC to go to
the clock driver and request an MCLK for itself (e.g. based on sample
rate), surely that should happen from some function besides
set_sysclk(), with different semantics e.g. hw_params().

I'm not convinced that the CODEC can trigger its input clock changes in
general. In Tegra, there needs to be centralized clock management, e.g.
to prevent one audio stream using a 44.1KHz-based rate and another using
a 48KHz-based rate. That's because the main audio PLL can't generate
both sets of frequencies at once. This can't be done in individual CODEC
drivers, since they shouldn't know about the Tegra restrictions. Doing
it in the clock driver in response to the CODEC's request for a specific
input clock, might work, but then the CODEC would have to call into the
clk driver from e.g. hw_params() rather than set_sysclk(). If that's how
it's supposed to work, then this patch is adding code in the wrong
place. If set_sysclk() doesn't get removed from the CODEC API, then
doing all this clock setup logic in the machine driver, as the
tegra_wm89090.c machine driver does, seems to make the most sense for now.

> The Tegra driver will presumably succeed unless someone does the
> appropriate clock hookup in DT, at which point clk_set_rate() for the
> rate the clock is already at really ought to succeed so things should
> continue to work.

Ah yes, if we don't add the clock to DT, this code won't do anything, so
nothing will break.
