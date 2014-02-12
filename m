Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaBLSbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:31:53 -0500
Received: from mx02a.posteo.de ([89.146.194.168]:45860 "EHLO mx02a.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbaBLSbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:31:52 -0500
Message-ID: <52FBBE08.5030902@posteo.de>
Date: Wed, 12 Feb 2014 19:31:36 +0100
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: perex@perex.cz, david.henningsson@canonical.com, hui.wang@canonical.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG]3.14-rc2 [PATCH] Revert "ALSA: hda/realtek - Avoid invalid
 COEFs for ALC271X"
References: <1392221363-5447-1-git-send-email-martink@posteo.de> <s5h4n445mm2.wl%tiwai@suse.de> <s5hwqh046w5.wl%tiwai@suse.de>
In-Reply-To: <s5hwqh046w5.wl%tiwai@suse.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-02-12 17:45, schrieb Takashi Iwai:
> At Wed, 12 Feb 2014 17:20:21 +0100,
> Takashi Iwai wrote:
>>
>> At Wed, 12 Feb 2014 17:09:23 +0100,
>> Martin Kepplinger wrote:
>>>
>>> This reverts commit d3c56568f43807135f2c2a09582a69f809f0d8b7.
>>>
>>> The reverted commit breaks audio through headphone line out on
>>> the Acer TravelMate B113 (Type1Sku0) Notebook, my main work
>>> machine. I don't know much about it but this fixes my problem.
>>> Bisected and tested.
>>>
>>> Tested-by: Martin Kepplinger <martink@posteo.de>
>>> Signed-off-by: Martin Kepplinger <martink@posteo.de>
>>
>> Too bad, we need COEF for some machine but it breaks for some.
>> Since reverting breaks obviously another machine, we need a different
>> approach, e.g. checking the machine ID.  Please give alsa-info.sh
>> output of your machine.
> 
> Thinking it again, I'll take your patch as is, and put an additional
> fix for AO725 as below.  Could you try it to see whether it brings any
> regressions?  It's to be applied after your revert patch.
> 
> 
> thanks,
> 
> Takashi
> 
> -- 8< --
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] ALSA: hda - Better fix for invalid COEF setup on Acer AO725
> 
> Instead of disabling the COEF setup for all ALC271X codec (like commit
> d3c56568), do it only if needed.  Currently, Acer AO725 is known to
> show the problem, so clear the bad init_hook in the fixup.
> 
> The explicit call of alc269_fill_coef() in patch_alc269() is also
> removed, since the function will be called anyway at init callback.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=52181
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/pci/hda/patch_realtek.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
> index a9a83b85517a..eaff10598f67 100644
> --- a/sound/pci/hda/patch_realtek.c
> +++ b/sound/pci/hda/patch_realtek.c
> @@ -3817,6 +3817,14 @@ static void alc290_fixup_mono_speakers(struct hda_codec *codec,
>  	}
>  }
>  
> +static void alc_fixup_clear_init_hook(struct hda_codec *codec,
> +				      const struct hda_fixup *fix, int action)
> +{
> +	struct alc_spec *spec = codec->spec;
> +	if (action == HDA_FIXUP_ACT_PROBE)
> +		spec->init_hook = NULL;
> +}
> +
>  /* for hda_fixup_thinkpad_acpi() */
>  #include "thinkpad_helper.c"
>  
> @@ -3858,6 +3866,7 @@ enum {
>  	ALC271_FIXUP_HP_GATE_MIC_JACK,
>  	ALC271_FIXUP_HP_GATE_MIC_JACK_E1_572,
>  	ALC269_FIXUP_ACER_AC700,
> +	ALC271_FIXUP_ACER_AO725,
>  	ALC269_FIXUP_LIMIT_INT_MIC_BOOST,
>  	ALC269VB_FIXUP_ASUS_ZENBOOK,
>  	ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A,
> @@ -4250,13 +4259,19 @@ static const struct hda_fixup alc269_fixups[] = {
>  		.type = HDA_FIXUP_FUNC,
>  		.v.func = alc_fixup_headset_mode_alc255,
>  	},
> +	[ALC271_FIXUP_ACER_AO725] = {
> +		.type = HDA_FIXUP_FUNC,
> +		.v.func = alc_fixup_clear_init_hook,
> +		.chained = true,
> +		.chain_id = ALC271_FIXUP_HP_GATE_MIC_JACK,
> +	},
>  };
>  
>  static const struct snd_pci_quirk alc269_fixup_tbl[] = {
>  	SND_PCI_QUIRK(0x1025, 0x029b, "Acer 1810TZ", ALC269_FIXUP_INV_DMIC),
>  	SND_PCI_QUIRK(0x1025, 0x0349, "Acer AOD260", ALC269_FIXUP_INV_DMIC),
>  	SND_PCI_QUIRK(0x1025, 0x047c, "Acer AC700", ALC269_FIXUP_ACER_AC700),
> -	SND_PCI_QUIRK(0x1025, 0x0740, "Acer AO725", ALC271_FIXUP_HP_GATE_MIC_JACK),
> +	SND_PCI_QUIRK(0x1025, 0x0740, "Acer AO725", ALC271_FIXUP_ACER_AO725),
>  	SND_PCI_QUIRK(0x1025, 0x0742, "Acer AO756", ALC271_FIXUP_HP_GATE_MIC_JACK),
>  	SND_PCI_QUIRK_VENDOR(0x1025, "Acer Aspire", ALC271_FIXUP_DMIC),
>  	SND_PCI_QUIRK(0x1025, 0x0775, "Acer Aspire E1-572", ALC271_FIXUP_HP_GATE_MIC_JACK_E1_572),
> @@ -4523,7 +4538,6 @@ static int patch_alc269(struct hda_codec *codec)
>  		if (err < 0)
>  			goto error;
>  		spec->init_hook = alc269_fill_coef;
> -		alc269_fill_coef(codec);
>  		break;
>  
>  	case 0x10ec0280:
> 

So my alsa-info.sh is
http://www.alsa-project.org/db/?f=3e9c5d39ff057106d6ae307f9b86c1e562056c1b
and I'm running your patch on top of mine without any problems.

thanks,

            martin
