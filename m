Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbbA0Nmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:42:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38275 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbbA0Nmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:42:38 -0500
Message-ID: <54C79597.40105@ti.com>
Date: Tue, 27 Jan 2015 15:41:43 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: =?windows-1252?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <linux-omap@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Sebastian Reichel <sre@debian.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] ASoC: rx51: do not fail if could not get jack detection
 gpio
References: <1422305507-10533-1-git-send-email-pali.rohar@gmail.com> <54C7925E.3020303@ti.com> <20150127133227.GA25306@amd>
In-Reply-To: <20150127133227.GA25306@amd>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 03:32 PM, Pavel Machek wrote:
> On Tue 2015-01-27 15:27:58, Peter Ujfalusi wrote:
>> Hi,
>>
>> On 01/26/2015 10:51 PM, Pali Rohár wrote:
>>> qemu does not emulate it
>>
>> Not sure about this... How does qemu emulate tlv320aic3106, tpa6130a2a, McBSP,
>> sDMA for audio to work? What about the other three GPIOs in this machine driver?
>>
>> The "nokia,n900-audio" compatible mandates that the jack-detection GPIO must
>> be provided (Documentation/devicetree/bindings/sound/nokia,rx51.txt) since it
>> means that the driver is running on the Nokia n900 HW.
> 
> Fix the documentation, then :-).

You mean document a workaround for qemu, right? AFAIK the documentation is fine ;)

> [Actually, GPIO is provided, it just can't be requested, AFAICT.]

So what about the other GPIOs in the machine driver? Why is this
jack-detection GPIO is special for qemu?

> 
> It is quite important to keep qemu working, really. Debugging early
> boot on hardware is very hard, for example.

I understand, but looking at the history of the driver, if it fails now with
the jack-detection GPIO, it should have been failing in the past as well. What
triggered this sudden qemu does not like jack-detection GPIO?
Before the devm_gpiod_get() conversion the driver should have failed in
snd_soc_jack_add_gpios() phase.

-- 
Péter


> And yes, some day we may need different dts for n900-qemu
> (vs. n900-hw), but lets not do it just yet.
> 							Pavel
> 
>>
>>> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>>> ---
>>>  sound/soc/omap/rx51.c |   45 +++++++++++++++++++++++++--------------------
>>>  1 file changed, 25 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
>>> index 04896d6..a689021 100644
>>> --- a/sound/soc/omap/rx51.c
>>> +++ b/sound/soc/omap/rx51.c
>>> @@ -310,25 +310,27 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
>>>  		return err;
>>>  	}
>>>  
>>> -	/* AV jack detection */
>>> -	err = snd_soc_jack_new(codec, "AV Jack",
>>> -			       SND_JACK_HEADSET | SND_JACK_VIDEOOUT,
>>> -			       &rx51_av_jack);
>>> -	if (err) {
>>> -		dev_err(card->dev, "Failed to add AV Jack\n");
>>> -		return err;
>>> -	}
>>> +	if (!IS_ERR(pdata->jack_detection_gpio)) {
>>> +		/* AV jack detection */
>>> +		err = snd_soc_jack_new(codec, "AV Jack",
>>> +				       SND_JACK_HEADSET | SND_JACK_VIDEOOUT,
>>> +				       &rx51_av_jack);
>>> +		if (err) {
>>> +			dev_err(card->dev, "Failed to add AV Jack\n");
>>> +			return err;
>>> +		}
>>>  
>>> -	/* prepare gpio for snd_soc_jack_add_gpios */
>>> -	rx51_av_jack_gpios[0].gpio = desc_to_gpio(pdata->jack_detection_gpio);
>>> -	devm_gpiod_put(card->dev, pdata->jack_detection_gpio);
>>> +		/* prepare gpio for snd_soc_jack_add_gpios */
>>> +		rx51_av_jack_gpios[0].gpio = desc_to_gpio(pdata->jack_detection_gpio);
>>> +		devm_gpiod_put(card->dev, pdata->jack_detection_gpio);
>>>  
>>> -	err = snd_soc_jack_add_gpios(&rx51_av_jack,
>>> -				     ARRAY_SIZE(rx51_av_jack_gpios),
>>> -				     rx51_av_jack_gpios);
>>> -	if (err) {
>>> -		dev_err(card->dev, "Failed to add GPIOs\n");
>>> -		return err;
>>> +		err = snd_soc_jack_add_gpios(&rx51_av_jack,
>>> +					     ARRAY_SIZE(rx51_av_jack_gpios),
>>> +					     rx51_av_jack_gpios);
>>> +		if (err) {
>>> +			dev_err(card->dev, "Failed to add GPIOs\n");
>>> +			return err;
>>> +		}
>>>  	}
>>>  
>>>  	return err;
>>> @@ -336,8 +338,11 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
>>>  
>>>  static int rx51_card_remove(struct snd_soc_card *card)
>>>  {
>>> -	snd_soc_jack_free_gpios(&rx51_av_jack, ARRAY_SIZE(rx51_av_jack_gpios),
>>> -				rx51_av_jack_gpios);
>>> +	struct rx51_audio_pdata *pdata = snd_soc_card_get_drvdata(card);
>>> +
>>> +	if (!IS_ERR(pdata->jack_detection_gpio))
>>> +		snd_soc_jack_free_gpios(&rx51_av_jack, ARRAY_SIZE(rx51_av_jack_gpios),
>>> +					rx51_av_jack_gpios);
>>>  
>>>  	return 0;
>>>  }
>>> @@ -470,8 +475,8 @@ static int rx51_soc_probe(struct platform_device *pdev)
>>>  	pdata->jack_detection_gpio = devm_gpiod_get(card->dev,
>>>  						    "jack-detection");
>>>  	if (IS_ERR(pdata->jack_detection_gpio)) {
>>> +		/* Do not fail, qemu does not emulate jack detection gpio */
>>>  		dev_err(card->dev, "could not get jack detection gpio\n");
>>> -		return PTR_ERR(pdata->jack_detection_gpio);
>>>  	}
>>>  
>>>  	pdata->eci_sw_gpio = devm_gpiod_get(card->dev, "eci-switch");
>>>
>>
>>
> 



