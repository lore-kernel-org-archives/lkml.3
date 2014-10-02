Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaJBIGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:06:51 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:36654 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaJBIGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:06:45 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: cf@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <6a3c04475d220913b3f22d19aa9cec86>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <542D078D.2000103@rock-chips.com>
Date: Thu, 02 Oct 2014 16:06:37 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Jianqun <jay.xu@rock-chips.com>
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, heiko@sntech.de,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        huangtao@rock-chips.com, cf@rock-chips.com
Subject: Re: [PATCH] ASoC: rockchip-max98090: add driver for rockchip board
 using a max98090
References: <1410506806-15327-1-git-send-email-jay.xu@rock-chips.com> <1410507588-15719-1-git-send-email-jay.xu@rock-chips.com> <20140912135247.GU7960@sirena.org.uk>
In-Reply-To: <20140912135247.GU7960@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark:

I'm still try to use simple-card driver but it hasn't do work from now on,
could I to update rockchip-max98090.c at the same time ?

在 09/12/2014 09:52 PM, Mark Brown 写道:
> On Fri, Sep 12, 2014 at 03:39:48PM +0800, Jianqun wrote:
>
>> +#define RK_PLAT_CLK_12M      12000000
> I'm not sure a define is adding anything here...  it's just a define
> saying 12MHz that has the value 12MHz.
>
Okay
>> +	struct snd_soc_dai *codec_dai = rtd->codec_dai;
>> +
>> +/* Set max98090 as master, i2s clock output 12MHz for max98090 */
>> +	ret = snd_soc_dai_set_sysclk(cpu_dai, 0,
> Coding style, comments aren't aligned with the code.
Okay
>
>> +	ret = snd_soc_add_card_controls(card, rk_mc_controls,
>> +					ARRAY_SIZE(rk_mc_controls));
>> +	if (ret) {
>> +		pr_err("unable to add card controls\n");
>> +		return ret;
>> +	}
> Use card->controls.
Okay
>
>> +	snd_soc_dapm_enable_pin(dapm, "Headset Mic");
>> +	snd_soc_dapm_enable_pin(dapm, "Headphone");
>> +	snd_soc_dapm_enable_pin(dapm, "Ext Spk");
>> +	snd_soc_dapm_enable_pin(dapm, "Int Mic");
>> +
>> +	snd_soc_dapm_sync(dapm);
> All pins are enabled by default and sync doesn't do anything during
> init.
okay, will to remove sync in next version
>> +#ifdef CONFIG_PM_SLEEP
>> +static int snd_rk_prepare(struct device *dev)
>> +{
>> +	struct snd_soc_card *card = dev_get_drvdata(dev);
>> +	struct rk_mc_private *drv = snd_soc_card_get_drvdata(card);
>> +
>> +	snd_soc_jack_free_gpios(&drv->hp_jack, 1, &hp_jack_gpio);
>> +	snd_soc_jack_free_gpios(&drv->mic_jack, 1, &mic_jack_gpio);
>> +
>> +	return snd_soc_suspend(dev);
>> +}
> Why are you freeing the GPIOs over suspend, that doesn't seem good?
Okay , will to remove them in next version
>
>> +	hp_jack_gpio.gpio = of_get_named_gpio(np, "rockchip,hp-det-gpios", 0);
>> +	if (hp_jack_gpio.gpio == -EPROBE_DEFER)
>> +		return -EPROBE_DEFER;
>> +
>> +	mic_jack_gpio.gpio = of_get_named_gpio(np, "rockchip,mic-det-gpios", 0);
>> +	if (mic_jack_gpio.gpio == -EPROBE_DEFER)
>> +		return -EPROBE_DEFER;
> This ignores errors other than probe deferral but the init code assumed
> that these would've succeeded.  Either the init code should handle
> failure or all errors should be treated as fatal.
dev_warn will be ok ?
>> +	platform_set_drvdata(pdev, &card);
>> +
>> +	ret = snd_soc_of_parse_card_name(card, "rockchip,model");
>> +	if (ret)
>> +		return ret;
> These need to happen before we register the card since they could be
> used as soon as we probe.
okay
>> +	snd_soc_card_set_drvdata(soc_card, NULL);
> No need to clear driver data, the core will do it anyway and anything
> relying on pre-set driver data is broken.

okay

-- 
Jianqun Xu

****************************************************************************
*IMPORTANT NOTICE:*This email is from Fuzhou Rockchip Electronics Co.,
Ltd .The contents of this email and any attachments may contain
information that is privileged, confidential and/or exempt from
disclosure under applicable law and relevant NDA. If you are not the
intended recipient, you are hereby notified that any disclosure,
copying, distribution, or use of the information is STRICTLY PROHIBITED.
Please immediately contact the sender as soon as possible and destroy
the material in its entirety in any format. Thank you.
****************************************************************************


