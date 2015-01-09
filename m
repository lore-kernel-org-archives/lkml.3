Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbbAIKNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:13:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45650 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbbAIKN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:13:28 -0500
Message-ID: <54AFA9B0.6040405@ti.com>
Date: Fri, 9 Jan 2015 12:13:04 +0200
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, <alsa-devel@alsa-project.org>,
        <devicetree@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
References: <cover.1420628786.git.moinejf@free.fr>	<0084acea5a3475a77531d6a77483f36d3469111a.1420628786.git.moinejf@free.fr>	<54AE99F5.1010404@ti.com> <20150108174257.557f7ea5@armhf>
In-Reply-To: <20150108174257.557f7ea5@armhf>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 06:42 PM, Jean-Francois Moine wrote:
> On Thu, 8 Jan 2015 16:53:41 +0200
> Jyri Sarha <jsarha@ti.com> wrote:
>
>>> +  - audio-ports: must contain one or two values selecting the source
>>> +	in the audio port.
>>> +	The source type is given by the corresponding entry in
>>> +	the audio-port-names property.
>>> +
>>
>> This binding does not allow multi channel i2s setups with multiple i2s
>> pins. It would be nice to support that in the DT binding, even if the
>> code is not yet ready for it.
>>
>> How about having these two optional properties instead of audio-ports
>> and audio-port-names:
>>
>> audio-port-i2s: Upto 4 values for selecting pins for i2s port
>> audio-port-spdif: Value for selecting input pin for spdif port
>>
>> Presence of one of the properties would be mandatory and both are allowed.
>>
>> Sorry to notice this only now, but I have not yet looked the drm side
>> changes too closely.
>
>  From Andrew's datasheet, the TDA998x's which are handled by the tda998x
> driver have only 4 input audio pins, the first two ones being either
> S/PDIF or I2s, the last ones being I2S only.
>

AFAIK, SPDIF is always a single pin connection so only one pin needs to 
be selected. But i2s need for pins for full 8 channel output.

> So, the DT description could be reduced to a simple list indexed by
> the pin number (= DAI number) and defining the protocol type.
>
> Examples:
>
> - for the Cubox:
>
> 	audio-inputs = "i2s", "spdif";
>
> - for some other board with I2S on the pins 3 and 4 only:
>
> 	audio-inputs = "none", "none", "i2s", "i2s";
>
> - for a fully wired TDA9983B (no driver yet):
>
> 	audio-inputs = "i2s", "i2s", "i2s", "i2s", "spdif";
>

If you want to go closer to the original paradigm, then how about 
defining following audio-port-names: i2s0, i2s1, i2s2, i2s3, and spdif. 
With this approach we could go with your original binding with only 
minor changes. A binding in your stereo i2s or spdif case would look 
like this:

	audio-ports = <0x04>, <0x03>;
	audio-port-names = "spdif", "i2s0";

A full 8 channel i2s or spdif output would look like this:

	audio-ports = <0x04>, <0x03>, <0x02>, <0x01>, <0x00>;
	audio-port-names = "spdif", "i2s0", "i2s1", "i2s2", "i2s3";


This would also indicate the channel mapping to the audio pins (i2s0 for 
first two channels, i2s1 for 3-4, etc.)

The code could for now just look for "i2s0" and the port names for 
channels 3-8 could be ignored until they are needed.

Best regards,
Jyri
