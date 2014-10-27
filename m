Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaJ0Ui4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:38:56 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:39169 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaJ0Uiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:38:54 -0400
MIME-Version: 1.0
In-Reply-To: <20141027193229.GE18557@sirena.org.uk>
References: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
	<20141027193229.GE18557@sirena.org.uk>
Date: Mon, 27 Oct 2014 23:38:53 +0300
Message-ID: <CAMo8Bf+Z9V8mkiC3JOupPQmi1EJUDKrb1qcNncDbsEbhjigbww@mail.gmail.com>
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

On Mon, Oct 27, 2014 at 10:32 PM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Oct 27, 2014 at 10:07:05PM +0300, Max Filippov wrote:
>
>> +config SND_SOC_XTENSA_XTFPGA
>> +     tristate "SoC Audio for xtensa xtfpga"
>> +     depends on XTENSA_PLATFORM_XTFPGA
>> +     select SND_SOC_XTFPGA_I2S
>> +     select SND_SOC_TLV320AIC23_SPI
>> +     select SND_SIMPLE_CARD
>
> I've only got this far in the file and have to leave now so I'll look
> properly at the actual code later but the above shouldn't have the CODEC
> or card driver selected, if the I2S driver is well written it should be
> usable independently of either.

The above entry is for the whole sound subsystem of that SoC.
An entry for I2S driver is above it.

>> +++ b/sound/soc/xtensa/Makefile
>> @@ -0,0 +1 @@
>> +obj-$(CONFIG_SND_SOC_XTFPGA_I2S) += xtfpga-i2s.o
>
> Please follow the style for all other ASoC drivers and name the module
> snd-soc-foo.

Ok.

>> +static void xtfpga_i2s_push_tx(struct xtfpga_i2s *i2s)
>> +{
>> +     struct snd_pcm_substream *tx_substream;
>> +     struct snd_pcm_runtime *runtime;
>> +
>> +     rcu_read_lock();
>> +     tx_substream = rcu_dereference(i2s->tx_substream);
>> +     runtime = tx_substream->runtime;
>> +#define xtfpga_i2s_tx_loop(i2s, runtime, channels, sample_bits) \
>> +     do { \
>> +             const u##sample_bits (*p)[channels] = \
>> +                     (void *)runtime->dma_area; \
>> +             for (; i2s->tx_fifo_sz < i2s->tx_fifo_high; \
>> +                  i2s->tx_fifo_sz += 2) { \
>> +                     iowrite32(p[i2s->tx_ptr][0], \
>> +                               i2s->regs + XTFPGA_I2S_CHAN0_DATA); \
>> +                     iowrite32(p[i2s->tx_ptr][channels - 1], \
>> +                               i2s->regs + XTFPGA_I2S_CHAN0_DATA); \
>> +                     if (++i2s->tx_ptr >= runtime->buffer_size) \
>> +                             i2s->tx_ptr = 0; \
>> +             } \
>> +     } while (0)
>> +
>> +     switch (runtime->sample_bits | (runtime->channels << 8)) {
>> +     case 0x110:
>> +             xtfpga_i2s_tx_loop(i2s, runtime, 1, 16);
>> +             break;
>
> This really needs some rework to be legible.  I'd suggest making your
> macro an inline function and either replacing these magic numbers in the
> switch statement with defines or just writing the code clearly and
> letting the compiler figure it out.

Ok, I'll rewrite it.

> Some documentation explaining what your RCU usage is all about would
> also be good...  I'm not clear why it's being used, none of the FIQ
> drivers do this and I can't entirely figure out what we're defending
> against other than the tasklet which we should be stopping anyway and
> why what we're doing is safe.

Ok, I'll document it. I'm synchronizing trigger callback with both interrupt
handler and the tasklet. All that they need to know is whether we're playing
a stream or not, so I protect the stream pointer with RCU. A spinlock for
protection of a single pointer seems too big for me.

> I would also expect to see the data transfer and I2S bits more split
> out, presumably this IP can actually be used in designs with a DMA
> controller and one would expect that for practical systems this would be
> the common case?

I don't know of other designs that use this IP block. Can we do it when
we get such users?

>> +     if (int_status & XTFPGA_I2S_INT_UNDERRUN) {
>> +             i2s->tx_fifo_sz = 0;
>> +             regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
>> +                                XTFPGA_I2S_CONFIG_INT_ENABLE |
>> +                                XTFPGA_I2S_CONFIG_TX_ENABLE, 0);
>> +     } else {
>> +             i2s->tx_fifo_sz = i2s->tx_fifo_low;
>> +             regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
>> +                                XTFPGA_I2S_CONFIG_INT_ENABLE, 0);
>> +     }
>
> We're trying to implement a NAPI style thing here?

No, there's no way to retrieve the exact FIFO level from the hardware,
there's no such register. But there are two interrupt reasons: one
when the FIFO is below preset level and another when FIFO is empty.
So this code tracks the FIFO level according to the interrupt reason.

>> +     if (tx_active) {
>> +             if (i2s->tx_fifo_high < 256)
>> +                     xtfpga_i2s_refill_fifo(i2s);
>> +             else
>> +                     tasklet_hi_schedule(&i2s->refill_fifo);
>
> How does the interrupt handler avoid getting into a fight with the
> tasklet if the interrupt line is shared?

IRQ is masked in the I2S controller once we're in the interrupt
handler and is not re-enabled until we're done with FIFO, which
happens at the very end of a tasklet. But if the line could ever be
shared interrupt handler logic that checks if IRQ came from our
device needs an additional check. Thanks for pointing that out.

>> +static int xtfpga_i2s_hw_params(struct snd_pcm_substream *substream,
>> +                                struct snd_pcm_hw_params *params,
>> +                                struct snd_soc_dai *dai)
>> +{
>> +     struct xtfpga_i2s *i2s = snd_soc_dai_get_drvdata(dai);
>> +     unsigned srate = params_rate(params);
>> +     unsigned channels = params_channels(params);
>> +     unsigned period_size = params_period_size(params);
>> +     unsigned sample_size = snd_pcm_format_width(params_format(params));
>> +     unsigned freq, ratio, level;
>> +     int err;
>> +
>> +     switch (params_format(params)) {
>> +     case SNDRV_PCM_FORMAT_S16_LE:
>> +     case SNDRV_PCM_FORMAT_S32_LE:
>> +             break;
>
> This looks buggy, we're accepting two different formats but not storing
> anything or telling the hardware - especially concerning given that this
> is a master only driver.

xtfpga_i2s_push_tx does the right thing based on runtime->sample_bits
value.

>> +     regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
>> +                        XTFPGA_I2S_CONFIG_RES_MASK,
>> +                        sample_size << XTFPGA_I2S_CONFIG_RES_BASE);
>> +
>> +     if (i2s->clk_enabled) {
>> +             clk_disable_unprepare(i2s->clk);
>> +             i2s->clk_enabled = false;
>> +     }
>> +     freq = 256 * srate;
>> +     err = clk_set_rate(i2s->clk, freq);
>> +     if (err < 0)
>> +             return err;
>> +
>> +     err = clk_prepare_enable(i2s->clk);
>> +     if (err < 0)
>> +             return err;
>> +     i2s->clk_enabled = true;
>
> This stuff with the clock seems complicated, why not just leave it
> disabled when not in use and take advantage of the reference counting
> the core already has?

Because this callback is said to be potentially called multiple times per
initialization. Is it not?

>> +     ratio = (freq - srate * sample_size * 8) /
>> +             (srate * sample_size * 4);
>
> What ratio exactly?  This needs more brackets in the first line and a
> comment explaining what it's calculating.

It controls the divider in the I2S controller that derives I2S bus frequency
from the master clock. The manual basically says 'use the following
equation to determine the ratio value'.

>> +     i2s->tx_fifo_low = XTFPGA_I2S_FIFO_SIZE / 2;
>> +     for (level = 1;
>> +          /* period_size * 2: FIFO always gets 2 samples per frame */
>> +          i2s->tx_fifo_low / 2 >= period_size * 2;
>> +          ++level)
>> +             i2s->tx_fifo_low /= 2;
>
> This can't come out with a bad value?

I've tested it in the range of frequencies that we support -- works well.

-- 
Thanks.
-- Max
