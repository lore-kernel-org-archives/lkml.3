Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaAIO1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:27:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54399 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbaAIO1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:27:48 -0500
Date: Thu, 9 Jan 2014 14:27:45 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Daniel Matuschek <daniel@matuschek.net>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Dimitris.Papastamos@Wolfsonmicro.com, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8804: Allow fine-grained control
	of the PLL generation
Message-ID: <20140109142745.GB6110@opensource.wolfsonmicro.com>
References: <alpine.DEB.2.02.1401082231260.4025@parallels-Parallels-Virtual-Platform>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401082231260.4025@parallels-Parallels-Virtual-Platform>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 10:36:53PM +0100, Daniel Matuschek wrote:
> Signed-off-by: Daniel Matuschek <daniel@matuschek.net>
>

<snip>

>  			pll_div->freqmode = post_table[i].freqmode;
> -			pll_div->mclkdiv = post_table[i].mclkdiv;
> -			target *= post_table[i].div;
> -			break;
> +			if ((mclk_div == WM8804_MCLKDIV_DONTCARE) ||
> +			    ((post_table[i].mclkdiv == 1) &&
> +				(mclk_div == WM8804_MCLKDIV_1)) ||
> +			    ((post_table[i].mclkdiv == 0) &&
> +				(mclk_div == WM8804_MCLKDIV_0))) {

Would probably be nicer to update the post_table to use the new
defines and directly compare.

> +				pll_div->mclkdiv = post_table[i].mclkdiv;
> +				target *= post_table[i].div;
> +				break;
> +			}
>  		}
>  	}
>
> @@ -388,7 +396,7 @@ static int wm8804_set_pll(struct snd_soc_dai *dai, int pll_id,
>  		int ret;
>  		struct pll_div pll_div;
>
> -		ret = pll_factors(&pll_div, freq_out, freq_in);
> +		ret = pll_factors(&pll_div, freq_out, freq_in, pll_id);

This does feel like a slight abuse of pll_id, it feels to me that
using the set_clkdiv callback would be a little more natural from
a user perspective.

>  		if (ret)
>  			return ret;
>
> diff --git a/sound/soc/codecs/wm8804.h b/sound/soc/codecs/wm8804.h
> index 8ec14f5..0365177 100644
> --- a/sound/soc/codecs/wm8804.h
> +++ b/sound/soc/codecs/wm8804.h
> @@ -58,4 +58,11 @@
>
>  #define WM8804_CLKOUT_DIV			1
>
> +#define WM8804_MCLKDIV_DONTCARE			0
> +#define WM8804_MCLKDIV_0			1
> +#define WM8804_MCLKDIV_1			2
> +#define WM8804_PLL_MCLKDIV_DONTCARE		WM8804_MCLKDIV_DONTCARE
> +#define WM8804_PLL_MCLKDIV_0			WM8804_MCLKDIV_0
> +#define WM8804_PLL_MCLKDIV_1			WM8804_MCLKDIV_1

Do we really need two copies of these?

Thanks,
Charles
