Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaDCUL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:11:26 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5177 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbaDCULZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:11:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 03 Apr 2014 13:06:52 -0700
From: Arun Shamanna Lakshmi <aruns@nvidia.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Songhee Baek <sbaek@nvidia.com>
Date: Thu, 3 Apr 2014 13:11:24 -0700
Subject: RE: [PATCH] ASoC: dapm: Add support for multi register mux
Thread-Topic: [PATCH] ASoC: dapm: Add support for multi register mux
Thread-Index: Ac9PFmi77ZvgT4FEQu66TyNXC2BlLwAYbY1A
Message-ID: <781A12BB53C15A4BB37291FDE08C03F3A05CDCDF9F@HQMAIL02.nvidia.com>
References: <1396494710-20944-1-git-send-email-aruns@nvidia.com>
 <533D1B65.3030405@metafoo.de>
In-Reply-To: <533D1B65.3030405@metafoo.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Lars-Peter Clausen [mailto:lars@metafoo.de]
> Sent: Thursday, April 03, 2014 1:27 AM
> To: Arun Shamanna Lakshmi
> Cc: lgirdwood@gmail.com; broonie@kernel.org;
swarren@wwwdotorg.org;
> perex@perex.cz; tiwai@suse.de; alsa- devel@alsa-project.org;
> linux-kernel@vger.kernel.org; Songhee Baek
> Subject: Re: [PATCH] ASoC: dapm: Add support for multi register mux
>
> On 04/03/2014 05:11 AM, Arun Shamanna Lakshmi wrote:
>
> This looks essentially good to me. A few minor issues, once those are
> fixed things should be good to go.
>
> [...]
> > @@ -2984,6 +3002,112 @@ int
> snd_soc_dapm_put_enum_double(struct snd_kcontrol *kcontrol,
> >   EXPORT_SYMBOL_GPL(snd_soc_dapm_put_enum_double);
> >
> >   /**
> > + * snd_soc_dapm_get_enum_onehot - dapm enumerated onehot
> mixer get
> > +callback
> > + * @kcontrol: mixer control
> > + * @ucontrol: control element information
> > + *
> > + * Callback to get the value of a dapm enumerated onehot encoded
> > +mixer control
> > + *
> > + * Returns 0 for success.
> > + */
> > +int snd_soc_dapm_get_enum_onehot(struct snd_kcontrol *kcontrol,
> > +			struct snd_ctl_elem_value *ucontrol) {
> > +	struct snd_soc_codec *codec =
> snd_soc_dapm_kcontrol_codec(kcontrol);
> > +	struct soc_enum *e = (struct soc_enum *)kcontrol-
> >private_value;
> > +	unsigned int reg_val, val, bit_pos = -1, reg_idx;
>
> Here as well, default for bit_pos should be 0.

This means when 'None' of the options are selected, by default, it
enumerates to 0. Since we are using __ffs, BIT(0) of Register-0 also
enumerates to 0. That's the reason why I used just ffs in the first place.
Let me know your opinion. My value table looks like below.

#define MUX_VALUE(npart, nbit)	(nbit + 32 * npart)
static const int mux_values[] = {
	0,
	MUX_VALUE(0, 0),
	.
	.
	.
	MUX_VALUE(0, 31),
	/* above inputs are for part0 mux */
	MUX_VALUE(1, 0),
	.
	.
	.
	MUX_VALUE(1, 31),
	/* above inputs are for part1 mux */
	MUX_VALUE(2, 0),
	.
	.
	.
	MUX_VALUE(2, 31),
	/* above inputs are for part2 mux */
};

>
> > +
> > +	for (reg_idx = 0; reg_idx < e->num_regs; reg_idx++) {
> > +		reg_val = snd_soc_read(codec, e->reg[reg_idx]);
> > +		val = reg_val & e->mask[reg_idx];
> > +		if (val != 0) {
> > +			bit_pos = __ffs(val) + (8 * codec->val_bytes *
> reg_idx);
> > +			break;
> > +		}
> > +	}
> > +
> > +	ucontrol->value.enumerated.item[0] =
> > +			snd_soc_enum_val_to_item(e, bit_pos);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(snd_soc_dapm_get_enum_onehot);
> > +
> > +/**
> > +

