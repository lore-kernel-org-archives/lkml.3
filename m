Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbaCKUUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:20:53 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:48261 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbaCKUUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:20:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140311194959.GB28112@sirena.org.uk>
References: <1394541891-26469-1-git-send-email-jcmvbkbc@gmail.com>
	<1394541891-26469-2-git-send-email-jcmvbkbc@gmail.com>
	<20140311194959.GB28112@sirena.org.uk>
Date: Wed, 12 Mar 2014 00:20:49 +0400
Message-ID: <CAMo8BfLTn+pneF6_7XkP66+LzpZgcefnAo_FkwxpvtYdt9yduA@mail.gmail.com>
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

On Tue, Mar 11, 2014 at 11:49 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Mar 11, 2014 at 04:44:49PM +0400, Max Filippov wrote:
>
>> +static inline int xtfpga_spi_wait_busy(struct xtfpga_spi *xspi)
>> +{
>> +     unsigned long timeout = jiffies + msecs_to_jiffies(100);
>> +     while (xtfpga_spi_read32(xspi, XTFPGA_SPI_BUSY)) {
>> +             if (!time_before(jiffies, timeout))
>> +                     return -EBUSY;
>> +             else
>> +                     cpu_relax();
>> +     }
>> +     return 0;
>> +}
>
> So we'll busy wait for up to 100ms - that seems like an awfully long
> time.  Perhaps fall back to msleep() if the delay is non-trivial (or
> just reduce the timeout)?

The timeout is here for the unlikely case everything went wrong. Normally
transfers get completed in about 10 useconds on 50 MHz hardware, it
doesn't seem worth msleeping here. I put the timeout here just because
otherwise infinite loop polling the device register looks scary.

>  If there are large enough FIFOs dead
> reckoning a sleep for the expected transfer time might be helpful but it
> seems like there's no meaningful FIFO.

Right, there's no FIFO in that device.

>> +/* Unused: this device controls its only CS automatically,
>> + * deactivating it after every 16 bit transfer completion.
>> + */
>
> This is too limited to use with most SPI clients, they'll want to be
> able to transmit more than one word (and the fact that only 16 bit words
> are supported is also an issue, though that's easy enough to handle for
> a bitbanging driver - I'd really strongly suggest supporting 8 bits per
> word as well).  Clients are pretty much going to need to use GPIO based
> chip select, you should make sure that's supported and covered in the
> binding.

There's no hardware for that. This device is really dumb, it is specifically
suited to control TLV320AIC23 which expects exactly 16 bit words, SPI
mode 0.

>> +static void xtfpga_spi_chipselect(struct spi_device *spi, int is_on)
>> +{
>> +}
>
> Omit this since it's empty.

The bitbang side doesn't like when this callback is NULL and returns
-EINVAL from spi_bitbang_start.

-- 
Thanks.
-- Max
