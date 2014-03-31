Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaCaLzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:55:00 -0400
Received: from smtp-out-225.synserver.de ([212.40.185.225]:1090 "EHLO
	smtp-out-024.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751310AbaCaLy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:54:59 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 24890
Message-ID: <533957C8.2030105@metafoo.de>
Date: Mon, 31 Mar 2014 13:55:52 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Arun Shamanna Lakshmi <aruns@nvidia.com>, Songhee Baek <sbaek@nvidia.com>,
        "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "'swarren@wwwdotorg.org'" <swarren@wwwdotorg.org>,
        "'tiwai@suse.de'" <tiwai@suse.de>,
        "'lgirdwood@gmail.com'" <lgirdwood@gmail.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
References: <1395792156-4178-1-git-send-email-aruns@nvidia.com> <53332CC7.6060800@metafoo.de> <D6C615D3E4730340AE82D5BD856631C0A26CB319B2@HQMAIL02.nvidia.com> <5333ED3A.7040908@metafoo.de> <5571431004A69147BCABABE4E097D66BA3EFF70CFC@HQMAIL02.nvidia.com> <D6C615D3E4730340AE82D5BD856631C0A26CB31F48@HQMAIL02.nvidia.com> <5336A619.5030007@metafoo.de> <781A12BB53C15A4BB37291FDE08C03F3A05CC6A11A@HQMAIL02.nvidia.com> <20140331112140.GO2269@sirena.org.uk>
In-Reply-To: <20140331112140.GO2269@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 01:21 PM, Mark Brown wrote:
> On Sat, Mar 29, 2014 at 11:12:30PM -0700, Arun Shamanna Lakshmi wrote:
>
> Fix your mailer to word wrap within paragraphs, your mails are
> excessively hard to read.
>
>>> I'm not sure I understand how that MUX_OFFSET would work. To get the
>>> selected mux output you can use the ffs instruction.
>
>>> foreach(reg) {
>>> 	reg_val = read(reg) & mask;
>>> 	if (reg_val != 0) {
>>> 		val = __ffs(reg_val);
>>> 		break;
>>> 	}
>>> }
>
>> There are 2 options to do this. The first option is what you specified
>> above, in which case I think we cannot share get and put functions as
>> they use the reg_val directly inside snd_soc_enum_val_to_item API (not
>> the bit position being set). If we change to bit position like above,
>> then the current users of these APIs should also change their soc_enum
>> value table. And, the second option being the one that we proposed.
>
> Sharing the functions isn't the goal, coming up with a usable API is.
>
>> That being said, MUX_OFFSET which is the second option works in the
>> following way. We know that reg_val is a power of 2 (2^0  to 2^31)
>> which is one hot code. This method adds a unique offset for this
>> reg_val for each incremental register that we want to set (say 2^n +
>> MUX_OFFSET(reg_id)) inside get function and does the reverse of it in
>> put function. For current users of only one register, it doesn't
>> change anything as we use reg_val.
>
> I'm afraid I can't understand the above at all, sorry.  The code below
> is quoted like Lars wrote it but I think it's actually written by you,
> please check your quoting when replying:\
>
>>> 	if (e->reg[0] != SND_SOC_NOPM) {
>>> 		for (reg_idx = 0; reg_idx < e->num_regs; reg_idx++) {
>>> 	    		reg_val = snd_soc_read(codec, e->reg[reg_idx]);
>>> 			val = (reg_val >> e->shift_l) & e->mask[reg_idx];
>>> 			if (val) {
>>> 				val += MULTI_MUX_INPUT_OFFSET(reg_idx);
>>> 				break;
>>> 			}
>>> 		}
>>> 	} else {
>>> 		reg_val = dapm_kcontrol_get_value(kcontrol);
>>> 		val = (reg_val >> e->shift_l) & e->mask[0];
>>> 	}
>
> The above is a bit confusing...  partly this is because of a lack of
> context (what is MULTI_MUX_INPUT_OFFSET?) and partly because it isn't
> entirely obvious that stopping as soon as we see any value set is the
> right choice, especially given the addition to rather than setting of
> val.

I think the idea is that since we know that for one-hot encodings only 
powers of two are valid values the other bits are used to encode the 
register number. E.g 0x4 means bit 3 in register 0, 0x5 means bit 3 in 
register 1, 0x6 means bit 3 in register 2 and so on. I guess it is possible 
to make it work. But this seems to be quite hack-ish to me. You'd have to be 
careful that MULTI_MUX_INPUT_OFFSET(reg_idx) never evaluates to a power of 
two and there are probably some more pitfalls.

- Lars
