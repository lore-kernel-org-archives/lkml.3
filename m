Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaBEJTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:19:24 -0500
Received: from smtp-out-092.synserver.de ([212.40.185.92]:1089 "EHLO
	smtp-out-089.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751367AbaBEJTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:19:21 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13615
Message-ID: <52F2021A.9020804@metafoo.de>
Date: Wed, 05 Feb 2014 10:19:22 +0100
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
References: <cover.1391274627.git.moinejf@free.fr> <1b15025671d9099863a3091346536e45891e4a26.1391274628.git.moinejf@free.fr> <20140204180625.GM22609@sirena.org.uk> <20140205101134.4591e5c3@armhf>
In-Reply-To: <20140205101134.4591e5c3@armhf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 10:11 AM, Jean-Francois Moine wrote:
> On Tue, 4 Feb 2014 18:06:25 +0000
> Mark Brown <broonie@kernel.org> wrote:
>
>> On Mon, Jan 27, 2014 at 09:48:54AM +0100, Jean-Francois Moine wrote:
>>
>>> +		/* change the snd_soc_pcm_stream values of the driver */
>>> +		stream->rates = rate_mask;
>>> +		stream->channels_max = max_channels;
>>> +		stream->formats = formats;
>>
>>> +	/* copy the DAI driver to a writable area */
>>> +	dai_drv = devm_kzalloc(&pdev->dev, sizeof(tda998x_dai), GFP_KERNEL);
>>> +	if (!dai_drv)
>>> +		return -ENOMEM;
>>> +	memcpy(dai_drv, tda998x_dai, sizeof(tda998x_dai));
>>> +
>>
>> The code should be doing this by setting constraints based on the
>> current setup rather than by editing the data structure - the expecation
>> is very much that the data won't change so this prevents surprises with
>> future work on the core.
>
> As it is done in the soc core, in soc_pcm_open(), the runtime hw_params
> are initialized after the call to the CODEC startup, and the next CODEC
> event is hw_params() when the user has already chosen all the parameters.
>
> So, in the CODEC, I don't see how I could update the parameters
> dictated by the EDID otherwise in changing the DAI driver parameters.
>

The startup function is the right place. But instead of modifying the DAI 
use snd_pcm_hw_constraint_mask64(), snd_pcm_hw_constraint_list(), etc. to 
setup the additional constraints that come from the EDID.

Bonus points for making this a generic helper function that takes a runtime 
and a EDID and then applies the EDID constraints on the runtime.

- Lars
