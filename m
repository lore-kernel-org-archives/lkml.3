Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaAIP3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:29:22 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54771 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaAIP3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:29:18 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8804: Allow fine-grained control of the PLL generation
From: Daniel Matuschek <daniel@matuschek.net>
In-Reply-To: <20140109142745.GB6110@opensource.wolfsonmicro.com>
Date: Thu, 9 Jan 2014 16:29:13 +0100
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Dimitris.Papastamos@Wolfsonmicro.com, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9DF5D0F7-F5A7-4705-8ACB-286B49D668C1@matuschek.net>
References: <alpine.DEB.2.02.1401082231260.4025@parallels-Parallels-Virtual-Platform> <20140109142745.GB6110@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09.01.2014, at 15:27, Charles Keepax <ckeepax@opensource.wolfsonmicro.com> wrote:

> On Wed, Jan 08, 2014 at 10:36:53PM +0100, Daniel Matuschek wrote:
>> Signed-off-by: Daniel Matuschek <daniel@matuschek.net>
>> 
> 
> <snip>
> 
>> 			pll_div->freqmode = post_table[i].freqmode;
>> -			pll_div->mclkdiv = post_table[i].mclkdiv;
>> -			target *= post_table[i].div;
>> -			break;
>> +			if ((mclk_div == WM8804_MCLKDIV_DONTCARE) ||
>> +			    ((post_table[i].mclkdiv == 1) &&
>> +				(mclk_div == WM8804_MCLKDIV_1)) ||
>> +			    ((post_table[i].mclkdiv == 0) &&
>> +				(mclk_div == WM8804_MCLKDIV_0))) {
> 
> Would probably be nicer to update the post_table to use the new
> defines and directly compare.

Yes, this is an option.

> 
>> +				pll_div->mclkdiv = post_table[i].mclkdiv;
>> +				target *= post_table[i].div;
>> +				break;
>> +			}
>> 		}
>> 	}
>> 
>> @@ -388,7 +396,7 @@ static int wm8804_set_pll(struct snd_soc_dai *dai, int pll_id,
>> 		int ret;
>> 		struct pll_div pll_div;
>> 
>> -		ret = pll_factors(&pll_div, freq_out, freq_in);
>> +		ret = pll_factors(&pll_div, freq_out, freq_in, pll_id);
> 
> This does feel like a slight abuse of pll_id, it feels to me that
> using the set_clkdiv callback would be a little more natural from
> a user perspective.

Good idea, I will move it to set_clkdiv.

> 
>> 		if (ret)
>> 			return ret;
>> 
>> diff --git a/sound/soc/codecs/wm8804.h b/sound/soc/codecs/wm8804.h
>> index 8ec14f5..0365177 100644
>> --- a/sound/soc/codecs/wm8804.h
>> +++ b/sound/soc/codecs/wm8804.h
>> @@ -58,4 +58,11 @@
>> 
>> #define WM8804_CLKOUT_DIV			1
>> 
>> +#define WM8804_MCLKDIV_DONTCARE			0
>> +#define WM8804_MCLKDIV_0			1
>> +#define WM8804_MCLKDIV_1			2
>> +#define WM8804_PLL_MCLKDIV_DONTCARE		WM8804_MCLKDIV_DONTCARE
>> +#define WM8804_PLL_MCLKDIV_0			WM8804_MCLKDIV_0
>> +#define WM8804_PLL_MCLKDIV_1			WM8804_MCLKDIV_1
> 
> Do we really need two copies of these?

Not really ;-) I will remove the duplicates.

