Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaC1SKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:10:12 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14064 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaC1SKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:10:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 28 Mar 2014 11:03:54 -0700
From: Songhee Baek <sbaek@nvidia.com>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>
CC: Arun Shamanna Lakshmi <aruns@nvidia.com>,
        "'lgirdwood@gmail.com'" <lgirdwood@gmail.com>,
        "'broonie@kernel.org'" <broonie@kernel.org>,
        "'swarren@wwwdotorg.org'" <swarren@wwwdotorg.org>,
        "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "'tiwai@suse.de'" <tiwai@suse.de>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Fri, 28 Mar 2014 11:10:06 -0700
Subject: RE: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
Thread-Topic: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
Thread-Index: Ac9JnZ4bEiXBcSqTTAecdagshdjWDQASdvDAADHMt3A=
Message-ID: <D6C615D3E4730340AE82D5BD856631C0A26CB31DFA@HQMAIL02.nvidia.com>
References: <1395792156-4178-1-git-send-email-aruns@nvidia.com>
 <53332CC7.6060800@metafoo.de>
 <D6C615D3E4730340AE82D5BD856631C0A26CB319B2@HQMAIL02.nvidia.com>
 <5333ED3A.7040908@metafoo.de>
 <5571431004A69147BCABABE4E097D66BA3EFF70CFC@HQMAIL02.nvidia.com>
In-Reply-To: <5571431004A69147BCABABE4E097D66BA3EFF70CFC@HQMAIL02.nvidia.com>
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


> > On 03/26/2014 11:41 PM, Songhee Baek wrote:
> > >> On 03/26/2014 01:02 AM, Arun Shamanna Lakshmi wrote:
> > >>
> > >> The way you describe this it seems to me that a value array for
> > >> this kind of mux would look like.
> > >>
> > >> 0x00000000, 0x00000000, 0x00000001
> > >> 0x00000000, 0x00000000, 0x00000002
> > >> 0x00000000, 0x00000000, 0x00000003
> > >> 0x00000000, 0x00000000, 0x00000004
> > >> 0x00000000, 0x00000000, 0x00000008
> > >> ...
> > >>
> > >> That seems to be extremely tedious. If the MUX uses a one hot
> > >> encoding how about storing the index of the bit in the values array
> > >> and use (1 << value) when writing the value to the register?
> > >
> > > If we store the index of the bit, the value will be duplicated for
> > > each
> > registers inputs since register has 0 to 31bits to shift, then we need
> > to decode the index to interpret value for which registers to set. If
> > we need to interpret the decoded value of index, it is better to have
> > custom put/get function in our driver, isn't it?
> > >
> >
> > I'm not sure I understand. If you use (val / 32) to pick the register
> > and (val %
> > 32) to pick the bit in the register this should work just fine. Maybe
> > I'm missing something. Do you have a real world code example of of the
> > this type of enum is used?
> >
> 
> I can use val/32 and val%32 for this multi register mux.

With this logic, put function would be easy however get function becomes tedious due to looping on each bit per register for 3 of them in our case. Rather, it would be easy to identify a unique MUX_OFFSET to distinguish between the 3 registers as shown in the code below.

#define MULTI_MUX_INPUT_OFFSET(n)	(5 * n)

int snd_soc_dapm_get_enum_double(struct snd_kcontrol *kcontrol,
	struct snd_ctl_elem_value *ucontrol)
{
	struct snd_soc_codec *codec = snd_soc_dapm_kcontrol_codec(kcontrol);
	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
	unsigned int reg_val, val, reg_idx;

	if (e->reg[0] != SND_SOC_NOPM) {
		for (reg_idx = 0; reg_idx < e->num_regs; reg_idx) {
	    		reg_val = snd_soc_read(codec, e->reg[reg_idx]);
			val = (reg_val >> e->shift_l) & e->mask[reg_idx];
			if (val)
				val += MULTI_MUX_INPUT_OFFSET(reg_idx);
		}
	} else {
		reg_val = dapm_kcontrol_get_value(kcontrol);
		val = (reg_val >> e->shift_l) & e->mask[0];
	}

        	ucontrol->value.enumerated.item[0] = snd_soc_enum_val_to_item(e, val);
   	if (e->shift_l != e->shift_r) {
    		val = (reg_val >> e->shift_r) & e->mask[0];
   		val = snd_soc_enum_val_to_item(e, val);
     		ucontrol->value.enumerated.item[1] = val;
       	} 

	return 0;
}

int snd_soc_dapm_put_enum_double(struct snd_kcontrol *kcontrol,
	struct snd_ctl_elem_value *ucontrol)
{
	struct snd_soc_codec *codec = snd_soc_dapm_kcontrol_codec(kcontrol);
	struct snd_soc_card *card = codec->card;
	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
	unsigned int *item = ucontrol->value.enumerated.item;
	unsigned int change, i, value, update_idx = 0;
	unsigned int mask;
	struct snd_soc_dapm_update update;
	int ret = 0, reg_val;

	if (item[0] >= e->items)
		return -EINVAL;

	value = snd_soc_enum_item_to_val(e, item[0]) << e->shift_l;
        	mask = e->mask[0] << e->shift_l;
	if (e->shift_l != e->shift_r) {
    		if (item[1] > e->items)
	    		return -EINVAL;
    	    	value |= snd_soc_enum_item_to_val(e, item[1]) << e->shift_l;
        		mask |= e->mask[0] << e->shift_r;
	}

	if (e->num_regs < 2) {
		goto update_reg;
	}

   	for (i = 0; i < e->num_regs; i++) {
		reg_val = value - MULTI_MUX_INPUT_OFFSET(i);

		/* checking reg_val is power of 2 : one-hot code */
		/* if reg_val after subtract MULTI_MUX_INPUT_OFFSET is not power of 2, reg[i] should be zero */ 
		if (reg_val & (reg_val - 1)) {
			/* clear the current input register */
			snd_soc_write(codec, e->reg[i], 0);
		} else {
			/* reg_val is power of 2, store updated info */
			value = reg_val;
			mask = e->mask[i];
			update_idx = i;
		}
	}

update_reg:
	mutex_lock_nested(&card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);

	if (e->reg[update_idx] != SND_SOC_NOPM)
        		change = snd_soc_test_bits(codec, e->reg[update_idx], mask, value);
	else
        		change = dapm_kcontrol_set_value(kcontrol, value);

    	if (change) {
    		if (e->reg[update_idx] != SND_SOC_NOPM) {
	    	    update.kcontrol = kcontrol;
				update.reg = e->reg[update_idx];
        		update.mask= mask;
	        	update.val = value;
				card->update = &update;
        	}
        	ret = soc_dapm_mux_update_power(card, kcontrol, item[0], e);

			card->update = NULL;
	}
	mutex_unlock(&card->dapm_mutex);

	if (ret > 0)
		soc_dpcm_runtime_update(card);

	return change;
}

> > >>> -	int reg;
> > >>> +	int reg[SOC_ENUM_MAX_REGS];
> > >>>    	unsigned char shift_l;
> > >>>    	unsigned char shift_r;
> > >>>    	unsigned int items;
> > >>> -	unsigned int mask;
> > >>> +	unsigned int mask[SOC_ENUM_MAX_REGS];
> > >>
> > >> If you make mask and reg pointers instead of arrays this should be
> > >> much more flexible and not be limited to 3 registers.

We will make reg* and mask* instead of arrays and since we use the same structure, the plan is to share the get and put function code.

Thanks.
Songhee.


