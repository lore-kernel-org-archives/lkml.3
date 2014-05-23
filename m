Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaEWFfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 01:35:20 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:44361 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaEWFfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 01:35:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140522103039.GD12304@sirena.org.uk>
References: <1400750228-13750-1-git-send-email-tushar.behera@linaro.org>
	<1400750228-13750-2-git-send-email-tushar.behera@linaro.org>
	<20140522103039.GD12304@sirena.org.uk>
Date: Fri, 23 May 2014 11:05:17 +0530
Message-ID: <CAHbNUh2QHv8n7Y19qfO7BagX5AWe0i17MjDvr7yOpHf6YNGW4A@mail.gmail.com>
Subject: Re: [PATCH 1/2] ASoC: max98090: Add master clock handling
From: Tushar Behera <tushar.behera@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Linux-ALSA <alsa-devel@alsa-project.org>,
        lkml <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Doug Anderson <dianders@chromium.org>,
        "jerry.wong" <jerry.wong@maximintegrated.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 May 2014 16:00, Mark Brown <broonie@kernel.org> wrote:
> On Thu, May 22, 2014 at 02:47:07PM +0530, Tushar Behera wrote:
>
>> +     max98090->mclk = devm_clk_get(codec->dev, "mclk");
>> +     if (!IS_ERR(max98090->mclk))
>> +             clk_prepare_enable(max98090->mclk);
>> +
>
> Ths doesn't handle deferred probe, we need to at least return an error
> if we get -EPROBE_DEFER.
>

Ok.

> It'd also be better to move the enabling to set_bias_level() if possible
> (I don't know if the clock is needed for register access) though less
> essential.

I tested with moving clk_enable/clk_disable calls to set_bias_level():
SND_SOC_BIAS_PREPARE. That works well for me. Does it look okay?

@@ -1801,6 +1801,25 @@ static int max98090_set_bias_level(struct
snd_soc_codec *codec,
                break;

        case SND_SOC_BIAS_PREPARE:
+               /*
+                * SND_SOC_BIAS_PREPARE is called while preparing for a
+                * transition to ON or away from ON. If current bias_level
+                * is SND_SOC_BIAS_ON, then it is preparing for a transition
+                * away from ON. Disable the clock in that case, otherwise
+                * enable it.
+                */
+               if (!IS_ERR(max98090->mclk)) {
+                       if (codec->dapm.bias_level == SND_SOC_BIAS_ON)
+                               clk_disable(max98090->mclk);
+                       else
+                               clk_enable(max98090->mclk);
+               }
                break;

-- 
Tushar Behera
