Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3I1O1o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 10:27:44 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39900 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab3I1O1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 10:27:42 -0400
Message-ID: <5246E747.6020103@gmail.com>
Date: Sat, 28 Sep 2013 16:27:19 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: Dove: Add the audio device to the Cubox DT
References: <20130828113521.35c53365@armhf> <521DCD80.9010105@gmail.com> <20130831125128.0e3a23c7@armhf> <140d8d8a23f.2784.107cef0f820c2f5d7b7f41463071c310@gmail.com> <20130926101147.217015e1@armhf> <5243F0CE.9000301@gmail.com> <20130926132859.04ad4407@armhf>
In-Reply-To: <20130926132859.04ad4407@armhf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 01:28 PM, Jean-Francois Moine wrote:
> On Thu, 26 Sep 2013 10:31:10 +0200
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>> On 09/26/2013 10:11 AM, Jean-Francois Moine wrote:
>>> In the Cubox, I changed the audio DT to:
>>>
>>> &i2s1 {
>>> 	status = "okay";
>>> 	clocks = <&gate_clk 13>, <&si5351 1>;

Jean-Francois,

I can confirm the following for CuBox:

AU1_EXTCLK is connected to si5351 clkout 2. For the _current_
(v3.12-rc1) dove-cubox.dts that means that you'll have to exchange
the properties for &i2c0/si5351/clkout[12]. If you leave it the way
it is, clkout2 is not allowed to change the pll inside si5351 and
only try to get close to the requested clk rate by using output
dividers. Would be great if you can provide a corresponding patch
for v3.12 (no need to Cc stable).

Also, as you seem to push kirkwood-i2s DT forward, please get back
to clkout2 (<&si5351 2>) for the audio node as you did correctly in
the first place.

With above changes, SPDIF_EN, and forcing kirkwood-i2s to always use
extclk, I can play SPDIF audio with 44k1 and 48k. Other rates could
also work, but my audio equipment ignores anything else.

>> What about trying to get 48kHz working first? Does it work with
>> internal DCO and 48kHz? External audio clock should be 256*fs as stated
>> in dove datasheet.
>
> I have no input with 48kHz.

If you use e.g. 'mplayer -ao alsa -srate 48000 music.mp3' you can force
output audio rate to 48k. I am sure other tools have similar options.

>>> For more information, I use i2s input in the tda998x with audio rate
>>> 96kHz on HDMI output. The sound is fine with the internal dco (tested
>>> with 44.1kHz only).

What I am wondering here is, why you want to use i2s at all? On CuBox,
HDMI transmitter is connected to both i2s and spdif. IIRC, for the
transmitter it makes no difference if you provide i2s or spdif audio,
_but_ what you are loosing for sure is pass-through, i.e. sending
compressed AC3 directly.

Also, on consumer devices anything else than 44k1 and 48k audio is very
uncommon. Don't expect it to work at all. If you want high quality
audio, always use pass-through. If you are lucky, your audio equipment
will also accept mp3 or at least mp2 over it when using HDMI.

>> Sorry, I don't understand the above "information". How can you have a
>> different input audio rate tested with 44k1 output rate?
>
> The internal dco permits only 44.1, 44 and 96 kHz, so, vlc translates
> the input rates smaller than 44.1 kHz to 44.1 kHz.
>
>> Have you ever tested your audio equipment with something different than
>> 48k and 44k1 SPDIF PCM? Are you actually sure it works at all, i.e. do
>> you have different audio source with SPDIF >48kHz? Can you try optical
>> SPDIF instead of HDMI?
>>
>> Just try to narrow it down, currently I cannot see why this behavior
>> should be limited to either si5351 or dove audio alone.
>
> I have no optical S/PDIF.

As stated above, if you use SPDIF in for HDMI audio, you get the same
audio stream.

> Well, I did more tests:
>
> - i2s or s/pdif input by the tda998x work fine with the internal dco

Based on the patches you sent me, you do not enable SPDIF playback at
all. Are you aware of that?

> - the pinmux seems correct:
>
> device f10b4000.audio-controller
> state default
> type MUX_GROUP (2)
> controlling device f10d0200.pin-ctrl
> group mpp_audio1
> function i2s1/spdifo
>
> device f10b4000.audio-controller
> state default
> type MUX_GROUP (2)
> controlling device f10d0200.pin-ctrl
> group mpp13
> function audio1
>
> - I tried both <&si5351 1> and <&si5351 2>, and I get no sound with the
>    external clock.

As stated above, with <&si5351 2> I can playback both 44k1 and 48k over
optical SPDIF. Haven't tested HDMI, but if that doesn't work, it's not
related to extclk.

Sebastian

> - when running vlc with the external clock, the flux towards the
>    kirkwood driver is blocked and there is no sound interrupt.
>
>   47:          0  main-interrupt-ctrl  21  kirkwood-i2s
>

