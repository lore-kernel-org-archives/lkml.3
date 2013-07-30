Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3G3RpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 13:45:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34973 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3G3RpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 13:45:17 -0400
Message-ID: <51F7FBA8.6080400@wwwdotorg.org>
Date: Tue, 30 Jul 2013 11:45:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH v6 2/8] ASoC: atmel: machine driver for at91sam9x5-wm8731
 boards
References: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com> <1375180329-4860-3-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1375180329-4860-3-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 04:32 AM, Richard Genoud wrote:
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Description of the Asoc machine driver for an at91sam9x5 based board
> with a wm8731 audio DAC. Wm8731 is clocked by a crystal and used as a
> master on the SSC/I2S interface. Its connections are a headphone jack
> and an Line input jack.
> 
> [Richard: this is based on an old patch from Nicolas that I forward
> ported and reworked to use only device tree]

> diff --git a/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt b/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt

> +* Atmel at91sam9x5ek wm8731 audio complex
> +
> +Required properties:
> +  - compatible: "atmel,sam9x5-wm8731-audio"
> +  - atmel,model: The user-visible name of this sound complex.
> +  - atmel,ssc-controller: The phandle of the SSC controller
> +  - atmel,audio-codec: The phandle of the WM8731 audio codec
> +  - atmel,audio-routing: A list of the connections between audio components.
> +    Each entry is a pair of strings, the first being the connection's sink,
> +    the second being the connection's source.
> +
> +Available audio endpoints for the audio-routing table:
> +
> +Board connectors:
> + * Headphone Jack
> + * Line In Jack
> +
> +wm8731 pins:
> +cf Documentation/devicetree/bindings/sound/wm8731.txt

In the Tegra bindings, I deliberately put the list of CODEC pins into
the audio complex binding rather than the CODEC binding. That's because
I'm not sure that in the long-term we want to use strings to identify
the CODEC pins, rather than using integers. By putting the list orf
CODEC pins in the audio complex binding rather than the CODEC binding, I
didn't lumber the CODEC binding with a list of strings that it had to
support forever.

One reason that strings are problematic is because they can't be mixed
with integers/phandles in the same property, so if we ever end up with
more generic audio bindings where the routing table is expressed more like:

audio-routes = <&component_a $a_pin &component_b $b_pin>;

... in order to allow completely arbitrary and fully name-spaced routing
specification[1], then $a_pin and $b_pin need to be integers not strings.

[1] and perhaps we can get rid of properties like
audio-codec/ssc-controller, and automatically deduce which components
are needed simply by finding all phandles in the audio-routes property.

Perhaps the solution here is to allow mixing phandles/integers/strings
in one property, but that's potentially quite a large change to the DTB
format; we'd need to introduce type fields into the property data, and
other data format changes.
