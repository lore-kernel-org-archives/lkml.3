Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaLCXxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:53:22 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:45618 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaLCXxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:53:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAEUnVG4qbnNaV26N9AgeKDJkEEvqi1QqdcYh=cLwjxY-aPor4w@mail.gmail.com>
References: <1417531766-29669-1-git-send-email-jay.xu@rock-chips.com>
 <1417591118-18695-1-git-send-email-jay.xu@rock-chips.com> <1417591118-18695-3-git-send-email-jay.xu@rock-chips.com>
 <20141203192024.GL7712@sirena.org.uk> <CAPz6YkXRmRzYpW7xuDsq69A9H-Qm2-j6t-a+B1w9+OLOPf_YnA@mail.gmail.com>
 <20141203200307.GM7712@sirena.org.uk> <CAPz6YkWSQhqX-wAp5hZReo==MuG_Tju_0mk+kGrJo9XhjQ3ttA@mail.gmail.com>
 <CAEUnVG4qbnNaV26N9AgeKDJkEEvqi1QqdcYh=cLwjxY-aPor4w@mail.gmail.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Wed, 3 Dec 2014 15:52:59 -0800
X-Google-Sender-Auth: oKnvBoCJI_SfSYln1k9-Nwp_Za0
Message-ID: <CAPz6YkULCXPL=E+Kabp8S7LuH4dzwtQUb-Hbm+uMzOW8=Scq0A@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v2 2/2] ASoC: rockchip: i2s: add support for
 grabbing output clock to codec
To: Dylan Reid <dgreid@chromium.org>
Cc: Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-rockchip@lists.infradead.org, Jianqun Xu <jay.xu@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 3:22 PM, Dylan Reid <dgreid@chromium.org> wrote:
> On Wed, Dec 3, 2014 at 3:03 PM, Sonny Rao <sonnyrao@chromium.org> wrote:
>> On Wed, Dec 3, 2014 at 12:03 PM, Mark Brown <broonie@kernel.org> wrote:
>>> On Wed, Dec 03, 2014 at 11:38:13AM -0800, Sonny Rao wrote:
>>>> On Wed, Dec 3, 2014 at 11:20 AM, Mark Brown <broonie@kernel.org> wrote:
>>>
>>>> > I would expect that the clock for the CODEC should be managed by the
>>>> > CODEC if at all possible - that seems more logical than having the CPU
>>>> > I2S controller request and manage it if it's a separate clock.  Why add
>>>> > this to the CPU side driver?
>>>
>>>> This output clock has a mux and can either be a fixed 12Mhz output or
>>>> can be derived from the same fractional divider which drives the i2s
>>>> block.   I thought it was simpler to keep them all the same, but need
>>>> to put ownership in the i2s in anticipation of the i2s driver setting
>>>> it's own clock rate.
>>>
>>>> If you think this is an implementation detail and this output clock
>>>> should just be owned by the codec driver, even though I'm guessing it
>>>> will just have to be the same as i2s, then I think we can drop this
>>>> and make sure simple card (or whatever other codec driver) claims this
>>>> clock.
>>>
>>> simple-card obviously isn't a CODEC driver...
>>
>> Yeah, sorry.
>>
>>> For generality I think
>>> the clock does need to be exposed to the CODEC driver, otherwise this
>>> will work differently to how other systems are working and we can't
>>> substitute in a different clock on the CODEC side so easily if it
>>> doesn't happen to use the output from the I2S block.
>>
>> Ok, then I think what we will do is abandon this patch and I will send
>> something that adds this functionality to the particular codec that
>> I'm interested in -- max98090.
>
> Sorry I didn't read this earlier.  I don't think that this belongs in
> the max98090.  The original patch description is a bit confusing.  The
> clock being grabbed here is actually i2s mclk.  My understanding is
> that, on this SoC, the mclk is driven from a different IP block than
> the rest of the i2s signals.  The i2s driver needs to be told about
> the clock and enable/disable it at the appropriate times.  I'm
> assuming it's optional because there are boards using this SoC with
> i2s slave mode that don't drive mclk at all.
>
> Please correct me if I'm wrong on any of the above.

I don't think you're wrong, and I'm an audio/i2s neophyte so I think
you're probably right and hopefully Mark can confirm that this is how
we want it.

One important thing to point out, which might be causing confusion, is
that this driver is claiming a clock which it internally calls "mclk"
but the way it's specified for rk3288 in the DT, that one is just the
one which drives the internal logic and has a gate.

This clock I'm adding is the actual mclk which is being driven to the
i2s slave device, and it has it's own gate and also has a mux, and we
need to claim both to be able to enable proper clock gating.
