Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030585AbaLLQOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:14:05 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:54254 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968152AbaLLQNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:13:46 -0500
Date: Fri, 12 Dec 2014 17:15:36 +0100
From: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Michael Welling <mwelling@ieee.org>,
        Philippe Reynes <tremyfr@yahoo.fr>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [PATCH v2 2/2] iio: add driver for the TI DAC8554
Message-ID: <20141212161536.GC1142@avionic-0071.adnet.avionic-design.de>
References: <1416858614-32265-1-git-send-email-nikolaus.schulz@avionic-design.de>
 <1416858614-32265-2-git-send-email-nikolaus.schulz@avionic-design.de>
 <5482EA33.7020305@gmx.de>
 <548AD814.2060206@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <548AD814.2060206@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:pnI4l/ZnAQeNTvA0A6nT7d+e6aKY4gKpzsAQ2TjCixY4XPGZfSg
 U37NWlQjLGcfgPh4zkL4JMdsvjVFbpY/zabVNInL1L9V25sQyLjjqmY3o1MATtXKKvBXIzQ
 9QsZeRF5jp03ba3JY6y6+YS/KCJiKA/sektDmfuyFWg48C0bTNWgeVKIvNXObi2J7/HeUhS
 Mtu9HVDwaR24ZPehLEMxg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 11:57:08AM +0000, Jonathan Cameron wrote:
> On 06/12/14 11:36, Hartmut Knaack wrote:
> > Nikolaus Schulz schrieb am 24.11.2014 um 20:50:
> >> The TI DAC8554 is a quad-channel Digital-to-Analog Converter with an SPI
> >> interface.
> >>
> >> Changes in v2:
> >> * Use DMA-safe buffer for SPI transfer
> >> * Normalize powerdown_mode name "hi-z" to "three_state" as per
> >>   ABI/testing/sysfs-bus-iio
> >> * Register device late in probe function
> >> * Avoid powerdown broadcast update, which touches all DAC on the bus
> > There are a few issues left, please see my comments inline.
> 1 little one from me...
> >>
> >> Signed-off-by: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
> >> ---
> >>  drivers/iio/dac/Kconfig      |  10 ++
> >>  drivers/iio/dac/Makefile     |   1 +
> >>  drivers/iio/dac/ti-dac8554.c | 374 +++++++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 385 insertions(+)
> >>  create mode 100644 drivers/iio/dac/ti-dac8554.c
[...]
> >> diff --git a/drivers/iio/dac/ti-dac8554.c b/drivers/iio/dac/ti-dac8554.c
> >> new file mode 100644
> >> index 0000000..fca751f
> >> --- /dev/null
> >> +++ b/drivers/iio/dac/ti-dac8554.c
[...]
> >> +static int dac8554_powerdown(struct dac8554_state *st,
> >> +			     u8 powerdown_mode)
> >> +{
> >> +	int chan, cmd, ret;
> >> +
> >> +	for (chan = DAC8554_DAC_CHANNELS-1; chan >= 0; --chan) {
> > Please mind spaces around operators.
> >> +		cmd = chan ? DAC8554_CMD_STORE_DAC_N
> >> +			   : DAC8554_CMD_STORE_DAC_N_UPDATE_ALL;
> >> +		ret = dac8554_spi_write(st, cmd, chan,
> >> +				DAC8554_PWRDN_TO_SR(powerdown_mode));
> >> +		if (ret)
> >> +			return ret;
> >> +	}
> >> +
> >> +	memset(st->powerdown_mode, powerdown_mode, sizeof(st->powerdown_mode));
> >> +	memset(st->powerdown, true, sizeof(st->powerdown));
> Whilst this probably works, I think for the boolean case it is less
> than entirely obvious, so probably better to have a simple loop.

Yeah, I agree it's better to keep it as simple and obvious as possible.
Fixed in v3.

> >> +
> >> +	return 0;
> >> +}

-- 
Avionic Design GmbH
Nikolaus Schulz
Wragekamp 10
D-22397 Hamburg
Germany

Tel.:  +49 40 88187-163
Fax:   +49 40 88187-150
Email: nikolaus.schulz@avionic-design.de

Avionic Design GmbH
Amtsgericht Hamburg HRB 82598
Geschäftsführung: Cornelis Broers
Ust.-Ident-Nr.: DE813378254
