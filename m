Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaJ1SLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:11:36 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36303 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaJ1SLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:11:34 -0400
MIME-Version: 1.0
In-Reply-To: <20141028173853.GD18557@sirena.org.uk>
References: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
	<20141027193229.GE18557@sirena.org.uk>
	<CAMo8Bf+Z9V8mkiC3JOupPQmi1EJUDKrb1qcNncDbsEbhjigbww@mail.gmail.com>
	<20141028154224.GX18557@sirena.org.uk>
	<CAMo8BfLpJ0bdmaFt9+gLQ_kEjB68XdjAJUw8f8s=Owv46h_yDQ@mail.gmail.com>
	<20141028173853.GD18557@sirena.org.uk>
Date: Tue, 28 Oct 2014 21:11:34 +0300
Message-ID: <CAMo8BfL+vW7BjC1bQPNjhuBMTcRTkf8_DDS3NO2HmBUnfHYAFQ@mail.gmail.com>
Subject: Re: [PATCH] ASoC: add xtensa xtfpga I2S interface and platform
From: Max Filippov <jcmvbkbc@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 8:38 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Oct 28, 2014 at 08:00:45PM +0300, Max Filippov wrote:
>> On Tue, Oct 28, 2014 at 6:42 PM, Mark Brown <broonie@kernel.org> wrote:
>> > So atomics don't work?  Simple flags are one of the few cases where they
>> > might cover it...  again, the fact that this isn't similar to other code
>> > doing the same thing is worrying.
>
>> tx_substream use pattern is the same as of a typical RCU variable.
>> RCU wrappers combine ACCESS_ONCE and barriers that I'd otherwise
>> have to write myself.
>
> You *really* need to explain how it's supposed to work - right now it's
> not at all obvious, like I say the fact that this is a rarely used idiom
> is not helping.  For example when we tear down the stream we just assign
> the pointer in _stop() but don't bother with a sync until the stream is
> closed - why?

Because we can't wait in stop and syncing is not time critical, we can
do it any time before the stream becomes invalid.

> We also appear to be doing several different dereferences
> of the pointer inside a single rcu_read_lock() for some reason which is
> worrying.

I've cleaned that up.

>> > it'd be better to just add a DMA controller on the FPGA, everyone will
>> > be much happier).
>
>> Hardware people think different and it's been like that for more than 5
>> years.
>
> They appear to be the only hardware people who think this way, while we

The whole audio subsystem on xtfpga boards is there for, I think, a single
purpose: for the demonstration of CPU audio processing capabilities.
That's why it's that simple.

> do have some FIQ based PIO stuff in mainline all the examples I can
> think of are there because people didn't work out how to drive the DMA
> controller yet (and even there we're using FIQs not bashing things in
> from a regular interrupt).

Currently we don't support fast interrupt handlers written in C on xtensa.

>> >> Because this callback is said to be potentially called multiple times per
>> >> initialization. Is it not?
>
>> > It can but but I'm not seeing any connection between that and the idea
>> > of not keeping the clock enabled when the device isn't in use?
>
>> hw_params callback can change MCLK rate, so it has to disable and
>> enable the clock anyway, and since enable can fail it does not guarantee
>> that the clock will be left in the same state. Or should I adjust MCLK rate
>> w/o disabling the clock?
>
> So yet again: why not just enable the clock only when the device is in
> use?  If it's being configured it stands to reason that the device isn't
> actively in use...

Mark, I don't get it, sorry ): My clock synthesizer is I2C controlled, so
I can't prepare/unprepare it in the trigger callback. When should I do it?

>> > I'm not sure I find that terribly convincing, I'd like to be able to
>> > look at the code and tell that it's not going to blow up.  This again
>> > comes back to the general comment about clarity - the code *looks*
>> > suspicious (strange indentation of the for loop with a comment in the
>> > middle of the statement itself for example).
>
>> The level field in the control register is 4 bit wide, so the allowed range of
>> level is 0..15. FIFO size is 8192 entries, level = 1 corresponds to
>> FIFO size / 2, level = 14 -- to FIFO size of 0. I guess this function
>> won't get period_size of 0?
>
> So if the IP gets changed and the code gets blown up this could well
> explode then...  which doesn't seem entirely unlikely considering this
> is a FPGA platform so presumably this is easy to update.  To repeat this
> is about clarity and the code looking like it's probably hiding bugs as
> much as if the code actually works if you really sit down and study it.

The calculation does not depend on the actual hardware, but on the
constant definitions in the same file. They need to be updated if the
hardware changes. I'll try to rewrite it in a cleaner way.

-- 
Thanks.
-- Max
