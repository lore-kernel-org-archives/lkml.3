Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbaCLA7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 20:59:49 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:59032 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbaCLA7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 20:59:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140312003401.GE28112@sirena.org.uk>
References: <1394541891-26469-1-git-send-email-jcmvbkbc@gmail.com>
	<1394541891-26469-2-git-send-email-jcmvbkbc@gmail.com>
	<20140311194959.GB28112@sirena.org.uk>
	<CAMo8BfLTn+pneF6_7XkP66+LzpZgcefnAo_FkwxpvtYdt9yduA@mail.gmail.com>
	<20140312003401.GE28112@sirena.org.uk>
Date: Wed, 12 Mar 2014 04:59:47 +0400
Message-ID: <CAMo8Bf+dePYf0jW6zaH-4Qiy5oF-bBzHjkfzL1u6pyTS1OE46w@mail.gmail.com>
Subject: Re: [PATCH 1/3] spi: add xtfpga SPI controller driver
From: Max Filippov <jcmvbkbc@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        linux-spi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 4:34 AM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Mar 12, 2014 at 12:20:49AM +0400, Max Filippov wrote:
>> On Tue, Mar 11, 2014 at 11:49 PM, Mark Brown <broonie@kernel.org> wrote:
>> > On Tue, Mar 11, 2014 at 04:44:49PM +0400, Max Filippov wrote:
>
>> >> +     unsigned long timeout = jiffies + msecs_to_jiffies(100);
>> >> +     while (xtfpga_spi_read32(xspi, XTFPGA_SPI_BUSY)) {
>> >> +             if (!time_before(jiffies, timeout))
>> >> +                     return -EBUSY;
>> >> +             else
>> >> +                     cpu_relax();
>> >> +     }
>
>> > So we'll busy wait for up to 100ms - that seems like an awfully long
>> > time.  Perhaps fall back to msleep() if the delay is non-trivial (or
>> > just reduce the timeout)?
>
>> The timeout is here for the unlikely case everything went wrong. Normally
>> transfers get completed in about 10 useconds on 50 MHz hardware, it
>> doesn't seem worth msleeping here. I put the timeout here just because
>> otherwise infinite loop polling the device register looks scary.
>
> I appreciate that but even with 5MHz that's three orders of magnitude
> longer busy waiting in the error case than the operation is expected to
> take.  If you must wait for that long busy wait for a bit then start
> sleeping.

Ok, I'll fix that.

>> >> +/* Unused: this device controls its only CS automatically,
>> >> + * deactivating it after every 16 bit transfer completion.
>> >> + */
>
>> > This is too limited to use with most SPI clients, they'll want to be
>> > able to transmit more than one word (and the fact that only 16 bit words
>> > are supported is also an issue, though that's easy enough to handle for
>> > a bitbanging driver - I'd really strongly suggest supporting 8 bits per
>> > word as well).  Clients are pretty much going to need to use GPIO based
>> > chip select, you should make sure that's supported and covered in the
>> > binding.
>
>> There's no hardware for that. This device is really dumb, it is specifically
>> suited to control TLV320AIC23 which expects exactly 16 bit words, SPI
>> mode 0.
>
> This driver is not actually compatible with the tlv320aic23 driver since
> it needs 8 bit words, you need to at least support that.  You don't need

That's strange, because the codec datasheet says the following (section
3.1.1):

A control word consists of 16 bits, starting with the MSB. The data bits are
latched on the rising edge of SCLK. A rising edge on CS after the 16th rising
clock edge latches the data word into the AIC (see Figure 3-1).

And tlv320aic23 has the following regmap:

const struct regmap_config tlv320aic23_regmap = {
        .reg_bits = 7,
        .val_bits = 9,

and its SPI interface accordingly does the following in .probe:

        spi->bits_per_word = 16
        spi->mode = SPI_MODE_0;
        ret = spi_setup(spi);

> hardware in the controller to support a GPIO chip select, the whole
> point is that the controller chip select isn't wired up and a GPIO is
> used instead.

Actually it's not GPIO. The controller asserts CS line once we set the
start bit while the busy bit is cleared and deasserts it after 16 SCK
pulses.

>> >> +static void xtfpga_spi_chipselect(struct spi_device *spi, int is_on)
>> >> +{
>> >> +}
>
>> > Omit this since it's empty.
>
>> The bitbang side doesn't like when this callback is NULL and returns
>> -EINVAL from spi_bitbang_start.
>
> So fix that, but really it's trying to tell you that the hardware is far
> too limited to work with many things.

Ok. It's not designed to work with many things. Should I just move this
driver to the rest of the platform code under arch/xtensa/platform/xtfpga?

-- 
Thanks.
-- Max
