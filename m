Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbaDAHrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:47:39 -0400
Received: from smtp-out-019.synserver.de ([212.40.185.19]:1072 "EHLO
	smtp-out-024.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751061AbaDAHri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:47:38 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 24274
Message-ID: <533A6F4A.2060702@metafoo.de>
Date: Tue, 01 Apr 2014 09:48:26 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Arun Shamanna Lakshmi <aruns@nvidia.com>
CC: lgirdwood@gmail.com, broonie@kernel.org, swarren@wwwdotorg.org,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Songhee Baek <sbaek@nvidia.com>
Subject: Re: [PATCH] ASoC: DAPM: Add support for multi register mux
References: <1396333288-19113-1-git-send-email-aruns@nvidia.com>
In-Reply-To: <1396333288-19113-1-git-send-email-aruns@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 08:21 AM, Arun Shamanna Lakshmi wrote:
> Modify soc_enum struct to handle pointers for reg and mask. Add
> dapm get and put APIs for multi register mux with one hot encoding.
>
> Signed-off-by: Arun Shamanna Lakshmi <aruns@nvidia.com>
> Signed-off-by: Songhee Baek <sbaek@nvidia.com>

Looks in my opinion much better than the previous version :) Just a few 
minor issues, comments inline

> ---
>   include/sound/soc-dapm.h |   10 ++++
>   include/sound/soc.h      |   22 +++++--
>   sound/soc/soc-core.c     |   12 ++--
>   sound/soc/soc-dapm.c     |  143 +++++++++++++++++++++++++++++++++++++++++-----
>   4 files changed, 162 insertions(+), 25 deletions(-)
>
> diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
> index ef78f56..983b0ab 100644
> --- a/include/sound/soc-dapm.h
> +++ b/include/sound/soc-dapm.h
> @@ -305,6 +305,12 @@ struct device;
>    	.get = snd_soc_dapm_get_enum_double, \
>    	.put = snd_soc_dapm_put_enum_double, \
>     	.private_value = (unsigned long)&xenum }
> +#define SOC_DAPM_ENUM_WIDE(xname, xenum) \

maybe just call it ENUM_ONEHOT, since it doesn't actually have to be more 
than one register.

[...]
> diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
> index cd52d52..aba0094 100644
> --- a/sound/soc/soc-core.c
> +++ b/sound/soc/soc-core.c
> @@ -2601,12 +2601,12 @@ int snd_soc_get_enum_double(struct snd_kcontrol *kcontrol,
>   	unsigned int val, item;
>   	unsigned int reg_val;
>
> -	reg_val = snd_soc_read(codec, e->reg);
> -	val = (reg_val >> e->shift_l) & e->mask;
> +	reg_val = snd_soc_read(codec, e->reg[0]);
> +	val = (reg_val >> e->shift_l) & e->mask[0];
>   	item = snd_soc_enum_val_to_item(e, val);
>   	ucontrol->value.enumerated.item[0] = item;
>   	if (e->shift_l != e->shift_r) {
> -		val = (reg_val >> e->shift_l) & e->mask;
> +		val = (reg_val >> e->shift_l) & e->mask[0];
>   		item = snd_soc_enum_val_to_item(e, val);
>   		ucontrol->value.enumerated.item[1] = item;
>   	}
> @@ -2636,15 +2636,15 @@ int snd_soc_put_enum_double(struct snd_kcontrol *kcontrol,
>   	if (item[0] >= e->items)
>   		return -EINVAL;
>   	val = snd_soc_enum_item_to_val(e, item[0]) << e->shift_l;
> -	mask = e->mask << e->shift_l;
> +	mask = e->mask[0] << e->shift_l;
>   	if (e->shift_l != e->shift_r) {
>   		if (item[1] >= e->items)
>   			return -EINVAL;
>   		val |= snd_soc_enum_item_to_val(e, item[1]) << e->shift_r;
> -		mask |= e->mask << e->shift_r;
> +		mask |= e->mask[0] << e->shift_r;
>   	}
>
> -	return snd_soc_update_bits_locked(codec, e->reg, mask, val);
> +	return snd_soc_update_bits_locked(codec, e->reg[0], mask, val);
>   }
>   EXPORT_SYMBOL_GPL(snd_soc_put_enum_double);
>
> diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
> index c8a780d..4d2b35c 100644
> --- a/sound/soc/soc-dapm.c
> +++ b/sound/soc/soc-dapm.c
> @@ -514,9 +514,9 @@ static int dapm_connect_mux(struct snd_soc_dapm_context *dapm,
>   	unsigned int val, item;
>   	int i;
>
> -	if (e->reg != SND_SOC_NOPM) {
> -		soc_widget_read(dest, e->reg, &val);
> -		val = (val >> e->shift_l) & e->mask;
> +	if (e->reg[0] != SND_SOC_NOPM) {
> +		soc_widget_read(dest, e->reg[0], &val);
> +		val = (val >> e->shift_l) & e->mask[0];
>   		item = snd_soc_enum_val_to_item(e, val);

This probably should handle the new enum type as well. You'll probably need 
some kind of flag in the struct to distinguish between the two enum types.

>   	} else {
>   		/* since a virtual mux has no backing registers to
[...]
>   /**
> + * snd_soc_dapm_get_enum_wide - dapm semi enumerated multiple registers

What's a semi-enumerated register?

> + *					mixer get callback
> + * @kcontrol: mixer control
> + * @ucontrol: control element information
> + *
> + * Callback to get the value of a dapm semi enumerated multiple register mixer
> + * control.
> + *
> + * semi enumerated multiple registers mixer:
> + * the mixer has multiple registers to set the enumerated items. The enumerated
> + * items are referred as values.
> + * Can be used for handling bit field coded enumeration for example.
> + *
> + * Returns 0 for success.
> + */
> +int snd_soc_dapm_get_enum_wide(struct snd_kcontrol *kcontrol,
> +			struct snd_ctl_elem_value *ucontrol)
> +{
> +	struct snd_soc_codec *codec = snd_soc_dapm_kcontrol_codec(kcontrol);
> +	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
> +	unsigned int reg_val, val, bit_pos = 0, reg_idx;
> +
> +	for (reg_idx = 0; reg_idx < e->num_regs; reg_idx++) {
> +		reg_val = snd_soc_read(codec, e->reg[reg_idx]);
> +		val = reg_val & e->mask[reg_idx];
> +		if (val != 0) {
> +			bit_pos = ffs(val) + (e->reg_width * reg_idx);

Should be __ffs. __ffs returns the bits zero-indexed and ffs one-indexed. 
That will work better for cases where there is not additional value table 
necessary, since it means bit 1 maps to value 0.

> +			break;
> +		}
> +	}
> +
> +	ucontrol->value.enumerated.item[0] =
> +			snd_soc_enum_val_to_item(e, bit_pos);
> +
> +	return 0;
> +}
[...]
> +int snd_soc_dapm_put_enum_wide(struct snd_kcontrol *kcontrol,
> +			struct snd_ctl_elem_value *ucontrol)
> +{
> +	struct snd_soc_codec *codec = snd_soc_dapm_kcontrol_codec(kcontrol);
> +	struct snd_soc_card *card = codec->card;
> +	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
> +	unsigned int *item = ucontrol->value.enumerated.item;
> +	unsigned int change = 0, reg_idx = 0, value, bit_pos;
> +	struct snd_soc_dapm_update update;
> +	int ret = 0, reg_val = 0, i;
> +
> +	if (item[0] >= e->items)
> +		return -EINVAL;
> +
> +	value = snd_soc_enum_item_to_val(e, item[0]);
> +
> +	if (value) {
> +		/* get the register index and value to set */
> +		reg_idx = (value - 1) / e->reg_width;
> +		bit_pos = (value - 1) % e->reg_width;

Changing the ffs to __ffs also means you can drop the ' - 1' here.

Also e->reg_width should be (codec->val_bytes * 8) and reg_width field 
should be dropped from the enum struct.

> +		reg_val = BIT(bit_pos);
> +	}
> +
> +	for (i = 0; i < e->num_regs; i++) {
> +		if (i == reg_idx) {
> +			change = snd_soc_test_bits(codec, e->reg[i],
> +							e->mask[i], reg_val);
> +
> +		} else {
> +			/* accumulate the change to update the DAPM path
> +			    when none is selected */
> +			change += snd_soc_test_bits(codec, e->reg[i],
> +							e->mask[i], 0);

change |=

> +
> +			/* clear the register when not selected */
> +			snd_soc_write(codec, e->reg[i], 0);

I think this should happen as part of the DAPM update sequence like you had 
earlier. Some special care should probably be take to make sure that you 
de-select the previous mux input before selecting the new one if the new one 
is in a different register than the previous one.

> +		}
> +	}
> +
> +	mutex_lock_nested(&card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
> +
[...]

