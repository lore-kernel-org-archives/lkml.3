Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaJ1RAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:00:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63993 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaJ1RAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:00:46 -0400
MIME-Version: 1.0
In-Reply-To: <20141028154224.GX18557@sirena.org.uk>
References: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
	<20141027193229.GE18557@sirena.org.uk>
	<CAMo8Bf+Z9V8mkiC3JOupPQmi1EJUDKrb1qcNncDbsEbhjigbww@mail.gmail.com>
	<20141028154224.GX18557@sirena.org.uk>
Date: Tue, 28 Oct 2014 20:00:45 +0300
Message-ID: <CAMo8BfLpJ0bdmaFt9+gLQ_kEjB68XdjAJUw8f8s=Owv46h_yDQ@mail.gmail.com>
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

On Tue, Oct 28, 2014 at 6:42 PM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Oct 27, 2014 at 11:38:53PM +0300, Max Filippov wrote:
>> On Mon, Oct 27, 2014 at 10:32 PM, Mark Brown <broonie@kernel.org> wrote:
>> > On Mon, Oct 27, 2014 at 10:07:05PM +0300, Max Filippov wrote:
>
>> >> +config SND_SOC_XTENSA_XTFPGA
>> >> +     tristate "SoC Audio for xtensa xtfpga"
>> >> +     depends on XTENSA_PLATFORM_XTFPGA
>> >> +     select SND_SOC_XTFPGA_I2S
>> >> +     select SND_SOC_TLV320AIC23_SPI
>> >> +     select SND_SIMPLE_CARD
>
>> > I've only got this far in the file and have to leave now so I'll look
>> > properly at the actual code later but the above shouldn't have the CODEC
>> > or card driver selected, if the I2S driver is well written it should be
>> > usable independently of either.
>
>> The above entry is for the whole sound subsystem of that SoC.
>> An entry for I2S driver is above it.
>
> Then this just shouldn't exist at all, adding Kconfig entries for all
> the simple-card devices would defeat the point of having simple-card
> which is why we don't do it for other systems.

sound/soc/sh/Kconfig does that as well.
Not having single config item to enable at once all relevant drivers feels
a bit strange... But ok, I'll drop that.

>> > Some documentation explaining what your RCU usage is all about would
>> > also be good...  I'm not clear why it's being used, none of the FIQ
>> > drivers do this and I can't entirely figure out what we're defending
>> > against other than the tasklet which we should be stopping anyway and
>> > why what we're doing is safe.
>
>> Ok, I'll document it. I'm synchronizing trigger callback with both interrupt
>> handler and the tasklet. All that they need to know is whether we're playing
>> a stream or not, so I protect the stream pointer with RCU. A spinlock for
>> protection of a single pointer seems too big for me.
>
> So atomics don't work?  Simple flags are one of the few cases where they
> might cover it...  again, the fact that this isn't similar to other code
> doing the same thing is worrying.

tx_substream use pattern is the same as of a typical RCU variable.
RCU wrappers combine ACCESS_ONCE and barriers that I'd otherwise
have to write myself.

>> > I would also expect to see the data transfer and I2S bits more split
>> > out, presumably this IP can actually be used in designs with a DMA
>> > controller and one would expect that for practical systems this would be
>> > the common case?
>
>> I don't know of other designs that use this IP block. Can we do it when
>> we get such users?
>
> It's also about ensuring that the code is cleanly split up so that
> someone can actually go in and add the required support later (and TBH

Can you point me to an example of such split, so that I don't write it in
an unusual way?

> it'd be better to just add a DMA controller on the FPGA, everyone will
> be much happier).

Hardware people think different and it's been like that for more than 5
years.

>> >> +     if (int_status & XTFPGA_I2S_INT_UNDERRUN) {
>> >> +             i2s->tx_fifo_sz = 0;
>> >> +             regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
>> >> +                                XTFPGA_I2S_CONFIG_INT_ENABLE |
>> >> +                                XTFPGA_I2S_CONFIG_TX_ENABLE, 0);
>> >> +     } else {
>> >> +             i2s->tx_fifo_sz = i2s->tx_fifo_low;
>> >> +             regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
>> >> +                                XTFPGA_I2S_CONFIG_INT_ENABLE, 0);
>> >> +     }
>
>> > We're trying to implement a NAPI style thing here?
>
>> No, there's no way to retrieve the exact FIFO level from the hardware,
>> there's no such register. But there are two interrupt reasons: one
>> when the FIFO is below preset level and another when FIFO is empty.
>> So this code tracks the FIFO level according to the interrupt reason.
>
> ...and then it appears to try to implement something like NAPI?

If the programmed FIFO level is low enough I refill FIFO right in the
interrupt handler. If I use tasklet for such short FIFOs the sound
becomes choppy.

>> >> +     switch (params_format(params)) {
>> >> +     case SNDRV_PCM_FORMAT_S16_LE:
>> >> +     case SNDRV_PCM_FORMAT_S32_LE:
>> >> +             break;
>
>> > This looks buggy, we're accepting two different formats but not storing
>> > anything or telling the hardware - especially concerning given that this
>> > is a master only driver.
>
>> xtfpga_i2s_push_tx does the right thing based on runtime->sample_bits
>> value.
>
> So add a comment then.  The thing I was saying about the data push code
> being hard to understand apply generally.

Ok.

>> >> +     err = clk_prepare_enable(i2s->clk);
>> >> +     if (err < 0)
>> >> +             return err;
>> >> +     i2s->clk_enabled = true;
>
>> > This stuff with the clock seems complicated, why not just leave it
>> > disabled when not in use and take advantage of the reference counting
>> > the core already has?
>
>> Because this callback is said to be potentially called multiple times per
>> initialization. Is it not?
>
> It can but but I'm not seeing any connection between that and the idea
> of not keeping the clock enabled when the device isn't in use?

hw_params callback can change MCLK rate, so it has to disable and
enable the clock anyway, and since enable can fail it does not guarantee
that the clock will be left in the same state. Or should I adjust MCLK rate
w/o disabling the clock?

>> >> +     i2s->tx_fifo_low = XTFPGA_I2S_FIFO_SIZE / 2;
>> >> +     for (level = 1;
>> >> +          /* period_size * 2: FIFO always gets 2 samples per frame */
>> >> +          i2s->tx_fifo_low / 2 >= period_size * 2;
>> >> +          ++level)
>> >> +             i2s->tx_fifo_low /= 2;
>
>> > This can't come out with a bad value?
>
>> I've tested it in the range of frequencies that we support -- works well.
>
> I'm not sure I find that terribly convincing, I'd like to be able to
> look at the code and tell that it's not going to blow up.  This again
> comes back to the general comment about clarity - the code *looks*
> suspicious (strange indentation of the for loop with a comment in the
> middle of the statement itself for example).

The level field in the control register is 4 bit wide, so the allowed range of
level is 0..15. FIFO size is 8192 entries, level = 1 corresponds to
FIFO size / 2, level = 14 -- to FIFO size of 0. I guess this function
won't get period_size of 0?

-- 
Thanks.
-- Max
