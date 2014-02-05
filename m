Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaBESVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:21:24 -0500
Received: from smtp-out-092.synserver.de ([212.40.185.92]:1027 "EHLO
	smtp-out-089.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753410AbaBESVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:21:23 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12887
Message-ID: <52F28123.1080102@metafoo.de>
Date: Wed, 05 Feb 2014 19:21:23 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH v3 4/5] ASoC: tda998x: adjust the audio hw
 parameters from EDID
References: <cover.1391274627.git.moinejf@free.fr> <1b15025671d9099863a3091346536e45891e4a26.1391274628.git.moinejf@free.fr> <20140204180625.GM22609@sirena.org.uk> <20140205101134.4591e5c3@armhf> <52F2021A.9020804@metafoo.de> <20140205190732.5617f200@armhf>
In-Reply-To: <20140205190732.5617f200@armhf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 07:07 PM, Jean-Francois Moine wrote:
> On Wed, 05 Feb 2014 10:19:22 +0100
> Lars-Peter Clausen <lars@metafoo.de> wrote:
>
>>> So, in the CODEC, I don't see how I could update the parameters
>>> dictated by the EDID otherwise in changing the DAI driver parameters.
>>>
>>
>> The startup function is the right place. But instead of modifying the DAI
>> use snd_pcm_hw_constraint_mask64(), snd_pcm_hw_constraint_list(), etc. to
>> setup the additional constraints that come from the EDID.
>
> It is more complicated, but it works. Nevertheless, I have 2 problems:
>
> - snd_pcm_hw_constraint_list() keeps a pointer to the list, so, it
>    cannot be in the stack. It fix this with static struct and rate array.
>

Right. If the struct is modified though it should be per device and not 
global. I think the best way to implement this is to make the array static 
and specify a mask for the constraint based on the EDID. E.g.

static unsigned int hdmi_rates[] = {
	32000,
	44100,
	48000,
	88200,
	96000,
	176400,
	192000,
};

rate_mask = 0;

while (...) {
	...
	rate_mask |= 1 << sad[1];
}

rate_constraints->list = hdmi_rates;
rate_constraints->count = ARRAY_SIZE(hdmi_rates);
rate_constraints->mask = rate_mask;

> - snd_pcm_hw_constraint_mask64() is not exported.
>    Is there an other way to set constraints on the formats/sample widths?

I think that's a bug. Both snd_pcm_hw_constraint_mask() and 
snd_pcm_hw_constraint_mask64() should be exported. Can you send a patch?

- Lars


