Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbaCSXoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:44:04 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11783 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbaCSXoB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:44:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 19 Mar 2014 16:38:31 -0700
From: Arun Shamanna Lakshmi <aruns@nvidia.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Songhee Baek <sbaek@nvidia.com>
Date: Wed, 19 Mar 2014 16:44:00 -0700
Subject: RE: [PATCH] ASoC: Add support for multi register mux
Thread-Topic: [PATCH] ASoC: Add support for multi register mux
Thread-Index: Ac9DBjlvf/hFfIKwTpuE+uWjBYyROAAxszJw
Message-ID: <781A12BB53C15A4BB37291FDE08C03F3A05CB21E46@HQMAIL02.nvidia.com>
References: <1395186692-11735-1-git-send-email-aruns@nvidia.com>
 <20140318235941.GT11706@sirena.org.uk>
In-Reply-To: <20140318235941.GT11706@sirena.org.uk>
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

If each bit of a 32 bit register maps to an input of a mux, then with the current 'soc_enum' structure we cannot have more than 64 inputs for the mux (because of reg and reg2 only).
In such cases, we need more than 2 registers to select the input of the mux. This is referred to as 'multi register mux' 

For instance, the audio xbar (AXBAR) module acts as a mux selecting various inputs (reference: Tegra K1 manual).

The number of such inputs increases with future Tegra chips and so will be the need to control multiple registers per mux in DAPM.  We have 2 options to achieve that.

Option 1: Using custom get and put functions something similar to below inside AXBAR tegra driver.

	int tegra_xbar_get_value_enum(struct snd_kcontrol *kcontrol,
				struct snd_ctl_elem_value *ucontrol)
	{
		struct snd_soc_dapm_widget_list *wlist = snd_kcontrol_chip(kcontrol);
		struct snd_soc_dapm_widget *widget = wlist->widgets[0];
		struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
		unsigned int reg_val, mux, find, reg_idx;
		unsigned int num_regs = 3, regs[3];

		/* control 3 registers that has a common STRIDE */
		regs[0] = e-> reg;
		regs[1] = regs[0] + MUX_REG_STRIDE;
		regs[2] = regs[1] + MUX_REG_STRIDE;

		for (mux = 0; mux < e->max; mux++) {
			find = 0;
			for (reg_idx = 0; reg_idx < num_regs; reg_idx++) {
				regmap_read(widget->codec->control_data,
						regs[reg_idx], &reg_val);
				if (reg_val ==  e->values[mux * num_regs + reg_idx])
					find++;
			}
			if (find == num_regs)
				break;
		}
		ucontrol->value.enumerated.item[0] = mux;
		return 0;
	}

	int tegra_xbar_put_value_enum(struct snd_kcontrol *kcontrol,
				struct snd_ctl_elem_value *ucontrol)
	{
		struct snd_soc_dapm_widget_list *wlist = snd_kcontrol_chip(kcontrol);
		struct snd_soc_dapm_widget *widget = wlist->widgets[0];
		struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
		unsigned int value, mux, old, reg_idx;
		struct snd_soc_dapm_update update;
		   unsigned int num_regs = 3, regs[3], masks[3] = { 0xf1f03ff, 0x3f30031f, 0xff1cf313};
		int wi;

		regs[0] = e-> reg;
		regs[1] = regs[0] + MUX_REG_STRIDE;
		regs[2] = regs[1] + MUX_REG_STRIDE;

		if (ucontrol->value.enumerated.item[0] > e->max - 1)
			return -EINVAL;

		mux = ucontrol->value.enumerated.item[0];

		for (reg_idx = 0; reg_idx < num_regs; reg_idx++) {
			value = e->values[ucontrol->value.enumerated.item[0] * num_regs + reg_idx];
			regmap_read(widget->codec->control_data, regs[reg_idx], &old);

			if (value != old) {
				for (wi = 0; wi < wlist->num_widgets; wi++) {
					widget = wlist->widgets[wi];
					widget->value = value;
					update.kcontrol = kcontrol;
					update.widget = widget;
					update.reg = regs[reg_idx];
					update.mask = masks[reg_idx];
					update.val = value;
					widget->dapm->update = &update;
					snd_soc_dapm_mux_update_power(widget, kcontrol, mux, e);
					widget->dapm->update = NULL;
				}
			}
		}
		return 0;
	}

Option 2: Modify soc_enum structure and make 'reg' variable as reg[MAX_REG]

This would also mean that we should edit all the macros in soc.h, soc-dapm.c and soc-core.c to use 'reg[0]' instead of 'reg'
Our goal is to eventually add support to do multi register mux in get and put handlers inside soc-dapm.c upstream.

With Option1, we don't need to change any code in upstream as each register among the multiple registers has a common STRIDE (address offset). Thus, option1 is not generic enough.
If you suggest Option1, we wanted to check if upstream will be okay with such a structure. (it will be tegra specific though).

With Option2, it  becomes easy to add new macros for multi register mux in soc.h and then, add new get and put handlers in dapm.c

Thanks,
Arun

-----Original Message-----
From: Mark Brown [mailto:broonie@kernel.org] 
Sent: Tuesday, March 18, 2014 5:00 PM
To: Arun Shamanna Lakshmi
Cc: lgirdwood@gmail.com; perex@perex.cz; tiwai@suse.de; alsa-devel@alsa-project.org; linux-kernel@vger.kernel.org; Songhee Baek
Subject: Re: [PATCH] ASoC: Add support for multi register mux

* PGP Signed by an unknown key

On Tue, Mar 18, 2014 at 04:51:32PM -0700, Arun Shamanna Lakshmi wrote:

> Currently soc_enum structure supports only 2 registers (reg, reg2) for 
> kcontrol. However, it is possible to have multiple registers per mux. 
> This change allows us to control these multiple registers.

I'd want to see a user along with this and...

> @@ -1093,6 +1093,9 @@ struct soc_enum {
>  	unsigned int mask;
>  	const char * const *texts;
>  	const unsigned int *values;
> +	unsigned int *regs;
> +	unsigned int *masks;
> +	unsigned int num_regs;

...it duplicates and generally isn't joined up with the existing members of the structure, and has no support in the helpers (for example, converting the existing stereo controls to be two element arrays which I'd expect to see).  Helpers would count as users here.

Note that we don't support double register enums or muxes - only numerical controls are supported.  It's not clear what a multi-register enum would mean.

* Unknown Key
* 0x7EA229BD
