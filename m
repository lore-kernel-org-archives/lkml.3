Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaC3GMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 02:12:34 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19722 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaC3GMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 02:12:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 29 Mar 2014 23:06:10 -0700
From: Arun Shamanna Lakshmi <aruns@nvidia.com>
To: Lars-Peter Clausen <lars@metafoo.de>, Songhee Baek <sbaek@nvidia.com>
CC: "'lgirdwood@gmail.com'" <lgirdwood@gmail.com>,
        "'broonie@kernel.org'" <broonie@kernel.org>,
        "'swarren@wwwdotorg.org'" <swarren@wwwdotorg.org>,
        "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "'tiwai@suse.de'" <tiwai@suse.de>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Sat, 29 Mar 2014 23:12:30 -0700
Subject: RE: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
Thread-Topic: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
Thread-Index: Ac9LPPk4yDIpYEmuTxG4wQ0MT0bwRgAnYfgQ
Message-ID: <781A12BB53C15A4BB37291FDE08C03F3A05CC6A11A@HQMAIL02.nvidia.com>
References: <1395792156-4178-1-git-send-email-aruns@nvidia.com>
 <53332CC7.6060800@metafoo.de>
 <D6C615D3E4730340AE82D5BD856631C0A26CB319B2@HQMAIL02.nvidia.com>
 <5333ED3A.7040908@metafoo.de>
 <5571431004A69147BCABABE4E097D66BA3EFF70CFC@HQMAIL02.nvidia.com>
 <D6C615D3E4730340AE82D5BD856631C0A26CB31F48@HQMAIL02.nvidia.com>
 <5336A619.5030007@metafoo.de>
In-Reply-To: <5336A619.5030007@metafoo.de>
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
> Sent: Saturday, March 29, 2014 3:53 AM
> To: Songhee Baek
> Cc: Arun Shamanna Lakshmi; 'lgirdwood@gmail.com'; 'broonie@kernel.org';
> 'swarren@wwwdotorg.org'; 'alsa-devel@alsa-project.org'; 'tiwai@suse.de';
> 'linux-kernel@vger.kernel.org'
> Subject: Re: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
> 
> On 03/29/2014 03:30 AM, Songhee Baek wrote:
> >> -----Original Message-----
> >> From: Songhee Baek
> >> Sent: Friday, March 28, 2014 11:10 AM
> >> To: 'Lars-Peter Clausen'
> >> Cc: Arun Shamanna Lakshmi; 'lgirdwood@gmail.com';
> >> 'broonie@kernel.org'; 'swarren@wwwdotorg.org';
> >> 'alsa-devel@alsa-project.org'; 'tiwai@suse.de'; 'linux-
> kernel@vger.kernel.org'
> >> Subject: RE: [alsa-devel] [PATCH] ASoC: Add support for multi
> >> register mux
> >>
> >>
> >>>> On 03/26/2014 11:41 PM, Songhee Baek wrote:
> >>>>>> On 03/26/2014 01:02 AM, Arun Shamanna Lakshmi wrote:
> >>>>>>
> >>>>>> The way you describe this it seems to me that a value array for
> >>>>>> this kind of mux would look like.
> >>>>>>
> >>>>>> 0x00000000, 0x00000000, 0x00000001 0x00000000, 0x00000000,
> >>>>>> 0x00000002 0x00000000, 0x00000000, 0x00000003 0x00000000,
> >>>>>> 0x00000000, 0x00000004 0x00000000, 0x00000000, 0x00000008 ...
> >>>>>>
> >>>>>> That seems to be extremely tedious. If the MUX uses a one hot
> >>>>>> encoding how about storing the index of the bit in the values
> >>>>>> array and use (1 << value) when writing the value to the register?
> >>>>>
> >>>>> If we store the index of the bit, the value will be duplicated for
> >>>>> each
> >>>> registers inputs since register has 0 to 31bits to shift, then we
> >>>> need to decode the index to interpret value for which registers to
> >>>> set. If we need to interpret the decoded value of index, it is
> >>>> better to have custom put/get function in our driver, isn't it?
> >>>>>
> >>>>
> >>>> I'm not sure I understand. If you use (val / 32) to pick the
> >>>> register and (val %
> >>>> 32) to pick the bit in the register this should work just fine.
> >>>> Maybe I'm missing something. Do you have a real world code example
> >>>> of of the this type of enum is used?
> >>>>
> >>>
> >>> I can use val/32 and val%32 for this multi register mux.
> >>
> > With this logic, put function would be easy however get function
> > becomes tedious due to looping on each bit per register for 3 of them in our
> case. Rather, it would be easy to identify a unique MUX_OFFSET to distinguish
> between the 3 registers as shown in the code below.
> 
> I'm not sure I understand how that MUX_OFFSET would work. To get the
> selected mux output you can use the ffs instruction.
> 
> foreach(reg) {
> 	reg_val = read(reg) & mask;
> 	if (reg_val != 0) {
> 		val = __ffs(reg_val);
> 		break;
> 	}
> }
> 

There are 2 options to do this. The first option is what you specified above, in which case I think we cannot share get and put functions as they use the reg_val directly inside snd_soc_enum_val_to_item API (not the bit position being set). If we change to bit position like above, then the current users of these APIs should also change their soc_enum value table. And, the second option being the one that we proposed.

That being said, MUX_OFFSET which is the second option works in the following way. We know that reg_val is a power of 2 (2^0  to 2^31) which is one hot code. This method adds a unique offset for this reg_val for each incremental register that we want to set (say 2^n + MUX_OFFSET(reg_id)) inside get function and does the reverse of it in put function. For current users of only one register, it doesn't change anything as we use reg_val.

> 	if (e->reg[0] != SND_SOC_NOPM) {
> 		for (reg_idx = 0; reg_idx < e->num_regs; reg_idx++) {
> 	    		reg_val = snd_soc_read(codec, e->reg[reg_idx]);
> 			val = (reg_val >> e->shift_l) & e->mask[reg_idx];
> 			if (val) {
> 				val += MULTI_MUX_INPUT_OFFSET(reg_idx);
> 				break;
> 			}
> 		}
> 	} else {
> 		reg_val = dapm_kcontrol_get_value(kcontrol);
> 		val = (reg_val >> e->shift_l) & e->mask[0];
> 	}

Both the options are the same. The first one adds 32 or 64 to the bit position to identify uniquely for each register and the other adds a MUX_OFFSET to reg_val to achieve the same. The only advantage of the latter being that we can share the code with get_enum_double and put_enum_double which has been our goal since the beginning of this discussion (as we share the soc_enum struct)

We have tested the second option to work well for our use case. Please let us know what works for you and we will make the necessary changes quickly.

- Arun
