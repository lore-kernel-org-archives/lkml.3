Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbaDBGRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 02:17:19 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12291 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbaDBGRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 02:17:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 01 Apr 2014 23:12:49 -0700
From: Songhee Baek <sbaek@nvidia.com>
To: Lars-Peter Clausen <lars@metafoo.de>,
        Arun Shamanna Lakshmi <aruns@nvidia.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 1 Apr 2014 23:17:15 -0700
Subject: RE: [PATCH] ASoC: DAPM: Add support for multi register mux
Thread-Topic: [PATCH] ASoC: DAPM: Add support for multi register mux
Thread-Index: Ac9OOLi+YuSchGQKQnaKRDOAUVgPuAAAhSbg
Message-ID: <D6C615D3E4730340AE82D5BD856631C0A26CB3252F@HQMAIL02.nvidia.com>
References: <1396333288-19113-1-git-send-email-aruns@nvidia.com>
 <533A6F4A.2060702@metafoo.de>
 <781A12BB53C15A4BB37291FDE08C03F3A05CDCD63B@HQMAIL02.nvidia.com>
 <781A12BB53C15A4BB37291FDE08C03F3A05CDCD659@HQMAIL02.nvidia.com>
 <533BA779.9010005@metafoo.de>
In-Reply-To: <533BA779.9010005@metafoo.de>
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
> Sent: Tuesday, April 01, 2014 11:00 PM
> To: Arun Shamanna Lakshmi
> Cc: lgirdwood@gmail.com; broonie@kernel.org; swarren@wwwdotorg.org;
> perex@perex.cz; tiwai@suse.de; alsa-devel@alsa-project.org; linux-
> kernel@vger.kernel.org; Songhee Baek
> Subject: Re: [PATCH] ASoC: DAPM: Add support for multi register mux
> 
> On 04/01/2014 08:26 PM, Arun Shamanna Lakshmi wrote:
> [...]
> >>> diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c index
> >>> c8a780d..4d2b35c 100644
> >>> --- a/sound/soc/soc-dapm.c
> >>> +++ b/sound/soc/soc-dapm.c
> >>> @@ -514,9 +514,9 @@ static int dapm_connect_mux(struct
> >> snd_soc_dapm_context *dapm,
> >>>    	unsigned int val, item;
> >>>    	int i;
> >>>
> >>> -	if (e->reg != SND_SOC_NOPM) {
> >>> -		soc_widget_read(dest, e->reg, &val);
> >>> -		val = (val >> e->shift_l) & e->mask;
> >>> +	if (e->reg[0] != SND_SOC_NOPM) {
> >>> +		soc_widget_read(dest, e->reg[0], &val);
> >>> +		val = (val >> e->shift_l) & e->mask[0];
> >>>    		item = snd_soc_enum_val_to_item(e, val);
> >>
> >> This probably should handle the new enum type as well. You'll
> >> probably need some kind of flag in the struct to distinguish between
> >> the two enum types.
> >
> > Any suggestion on the flag name ?
> >
> 
> How about 'onehot'?
> 
> [...]
> >>> +		reg_val = BIT(bit_pos);
> >>> +	}
> >>> +
> >>> +	for (i = 0; i < e->num_regs; i++) {
> >>> +		if (i == reg_idx) {
> >>> +			change = snd_soc_test_bits(codec, e->reg[i],
> >>> +							e->mask[i],
> >> reg_val);
> >>> +
> >>> +		} else {
> >>> +			/* accumulate the change to update the DAPM
> >> path
> >>> +			    when none is selected */
> >>> +			change += snd_soc_test_bits(codec, e->reg[i],
> >>> +							e->mask[i], 0);
> >>
> >> change |=
> >>
> >>> +
> >>> +			/* clear the register when not selected */
> >>> +			snd_soc_write(codec, e->reg[i], 0);
> >>
> >> I think this should happen as part of the DAPM update sequence like
> >> you had earlier. Some special care should probably be take to make
> >> sure that you de-select the previous mux input before selecting the
> >> new one if the new one is in a different register than the previous one.
> >
> > I am not sure I follow this part. We are clearing the 'not selected'
> > registers before we set the one we want. Do you want us to loop the
> > logic of soc_dapm_mux_update_power for each register ? or do you want
> > to change the dapm_update structure so that it takes all the regs,
> > masks, and values together ?
> 
> The idea with the dapm_update struct is that the register updates are done
> in the middle of the power-down and power-up sequence. So yes, change
> the dapm_update struct to be able to hold all register updates and do all
> register updates in dapm_widget_update. I think an earlier version of your
> patch already had this.

Is the change similar to as shown below?

for (reg_idx = 0; reg_idx < e->num_regs; reg_idx++) {
	val = e->values[item * e->num_regs + reg_idx];
	ret = snd_soc_update_bits_locked(codec, e->reg[reg_idx],
				e->mask[reg_idx], val);
	if (ret)
	return ret;
}

During updating of the register's value, the above change can create non-zero
value in two different registers (very short transition) as Mark mentioned for
that change so we need to clear register first before writing the desired value
in the register.

Should we add the clearing all registers and write the mux value in desired
register in the update function?
