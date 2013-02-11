Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab3BKR6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:58:07 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:64808 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758466Ab3BKR6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:58:06 -0500
MIME-Version: 1.0
In-Reply-To: <5118EF75.30107@ti.com>
References: <CABYxbz5ECxoWZtkfL3UbZ=R4LVoNeMVxjYbPdZoarstCod-gQw@mail.gmail.com>
	<5118EF75.30107@ti.com>
Date: Mon, 11 Feb 2013 23:28:04 +0530
Message-ID: <CABYxbz7HcZTK+y20mtDR+1coRUbUMgNHNDdJ3O7Ln7U7d0LEzA@mail.gmail.com>
Subject: Re: Sound record on Devkit8000 with DT boot issue
From: Anil Kumar <anilk4.v@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        alsa-devel@alsa-project.org, tony@atomide.com, thomas@tomweber.eu,
        perex@perex.cz, tiwai@suse.de,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for helping me. please see my comment inline

On Mon, Feb 11, 2013 at 6:47 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> On 02/10/2013 04:21 PM, Anil Kumar wrote:
>> Hi All,
>>
>> I am working on Devkit8000 and adding DT support for that. I am trying
>> to add sound DT node support for this boards.
>> I have nearly done with this but facing issue on record. I do not have
>> much knowledge of twl4030 audio codec but with
>> small Hack[1] (as MainMic connected to the input jack)  i am able to
>> record sound on Devkit8000.
>> I do not know that MICBIAS1_EN can be enable by amixer commands.
>> Could you please help me to get out of this ?
>
> You need to pass the routing information via DT for Devkit8000. This is not
> done for the BeagleBoard since it works without it (no need for MICBIAS for
> example)
>
>>
>>
>> 1) Hack [1]
>>
>> diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
>> index 63b280b..6780681 100644
>> --- a/sound/soc/codecs/twl4030.c
>> +++ b/sound/soc/codecs/twl4030.c
>> @@ -1473,7 +1473,7 @@ static const struct snd_soc_dapm_widget
>> twl4030_dapm_widgets[] = {
>>         SND_SOC_DAPM_SUPPLY("micbias2 select", TWL4030_REG_MICBIAS_CTL, 6, 0,
>>                             NULL, 0),
>>
>> -       SND_SOC_DAPM_MICBIAS("Mic Bias 1", TWL4030_REG_MICBIAS_CTL, 0, 0),
>> +       SND_SOC_DAPM_MICBIAS("Mic Bias 1", TWL4030_REG_MICBIAS_CTL, 0, 1),
>
> Yes, this is HACK and it is wrong at the same time.

Agree

>
>>         SND_SOC_DAPM_MICBIAS("Mic Bias 2", TWL4030_REG_MICBIAS_CTL, 1, 0),
>>         SND_SOC_DAPM_MICBIAS("Headset Mic Bias", TWL4030_REG_MICBIAS_CTL, 2, 0),
>>
>>
>> 2) Sound DT node patch for Devkit8000
>>
>> diff --git a/arch/arm/boot/dts/omap3-
>> devkit8000.dts b/arch/arm/boot/dts/omap3-devkit8000.dts
>> index dc59272..5f3eec0 100644
>> --- a/arch/arm/boot/dts/omap3-devkit8000.dts
>> +++ b/arch/arm/boot/dts/omap3-devkit8000.dts
>> @@ -44,11 +44,22 @@
>>                  };
>>
>>         };
>> +
>> +       sound {
>> +               compatible = "ti,omap-twl4030";
>> +               ti,model = "devkit8000";
>> +
>> +               ti,mcbsp = <&mcbsp2>;
>> +               ti,codec = <&twl_audio>;
>
> Here you should have something like:
> ti,audio-routing =
>         "Ext Spk", "PREDRIVEL",
>         "Ext Spk", "PREDRIVER",
>         "MAINMIC", "Main Mic",
>         "Main Mic", "Mic Bias 1";
>
> So you connect the MicBias1 to Main Mic. When you start playback MicBias1 will
> be turned on for you.

I tried with this routing (next-20130211 tag kernel). But it is not
working for me.
So i have gone through other board and found snd_soc_dapm_route for

1) zoom2.c
       {"MAINMIC", NULL, "Mic Bias 1"},
       {"Mic Bias 1", NULL, "Ext Mic"},

2) omap3pandora.c
        {"MAINMIC", NULL, "Mic Bias 1"},
        {"Mic Bias 1", NULL, "Mic (internal)"},

But for omap-twl4030.c it is
        {"MAINMIC", NULL, "Main Mic"},
        {"Main Mic", NULL, "Mic Bias 1"},

 It Should will be as ?
        {"MAINMIC", NULL, "Mic Bias 1"},
        {"Mic Bias 1", NULL, "Main Mic"},

Because with this i am able to get audio on Devkit8000 as
             ti,audio-routing =
                        "Ext Spk", "PREDRIVEL",
                        "Ext Spk", "PREDRIVER",
                        "MAINMIC", "Mic Bias 1",
                        "Mic Bias 1", "Main Mic";

Sorry if i am saying nonsense.

Thanks,
Anil
[...]
