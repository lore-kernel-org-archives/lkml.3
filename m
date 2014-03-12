Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaCLJbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:31:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56957 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaCLJbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:31:01 -0400
Message-ID: <5320280C.6080004@ti.com>
Date: Wed, 12 Mar 2014 11:25:32 +0200
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Nicolin Chen <Guangyu.Chen@freescale.com>, <broonie@kernel.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <lgirdwood@gmail.com>,
        <kuninori.morimoto.gx@renesas.com>, <devicetree@vger.kernel.org>,
        <Li.Xiubo@freescale.com>, <moinejf@free.fr>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH v2] ASoC: simple-card: overwrite cpu_dai->fmt with codec_dai->fmt
References: <1394593331-22867-1-git-send-email-Guangyu.Chen@freescale.com>
In-Reply-To: <1394593331-22867-1-git-send-email-Guangyu.Chen@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 05:02 AM, Nicolin Chen wrote:
> The current simple-card driver separates the daimft for cpu_dai and codec_dai.
> So we might get different values for them (0x4003 and 0x1003 for example):
>
> asoc-simple-card sound-cs42888.12: cpu : 2024000.esai / 4003 / 132000000
> asoc-simple-card sound-cs42888.12: codec : cs42888 / 1003 / 24576000
> asoc-simple-card sound-cs42888.12: cs42888 <-> 2024000.esai mapping ok
>
> This is not allowed at all as we need to keep the DAIFMT settings identical
> for both the ends of the link.
>
> Thus this patch fixes it by overwriting the cpu_dai->fmt with codec_dai->fmt
> since we defined the DAIFMT_MASTER basing on CODEC at the first place while
> the other bits are same.
>
> Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> ---
Hi Nicolin,
This patch is an improvement, but in my opinion the binding is still a 
bit confusing.

How about changing 'frame-master' and 'bitclock-master' to 
'codec-frame-master' and 'codec-bitclock-master'. We could possibly keep 
the old names as aliases until all the .dts files out there have been fixed.

At the same go we could add SND_SOC_DAIFMT_MASTER_MASK here:

 > /* get CPU/CODEC common format via simple-audio-card,format */
 > priv->daifmt = snd_soc_of_parse_daifmt(node, "simple-audio-card,") &
 >		(SND_SOC_DAIFMT_FORMAT_MASK | SND_SOC_DAIFMT_INV_MASK);

or leave the masking out all together. Can't see why 
SND_SOC_DAIFMT_CONT/GATED could not be defined at dai-link level too.

This way the norm would be defining the daifmt at link level. We could 
still keep the possibility to overwrite the setting at dai level if 
there is need for that.

Best regards,
Jyri
