Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab3IRXTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 19:19:05 -0400
Received: from smtprelay0127.hostedemail.com ([216.40.44.127]:51262 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752283Ab3IRXTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 19:19:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:421:541:599:966:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2525:2553:2560:2563:2
X-HE-Tag: coat45_313c1385f392f
X-Filterd-Recvd-Size: 3825
Message-ID: <1379546336.1787.95.camel@joe-AO722>
Subject: Re: [PATCH v2] clk: si570: Add a driver for SI570 oscillators
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hyun Kwon <hyunk@xilinx.com>
Date: Wed, 18 Sep 2013 16:18:56 -0700
In-Reply-To: <0da25c5c-660c-4836-8179-6e7c51fd0d9f@CO9EHSMHS005.ehs.local>
References: <1379544219-23579-1-git-send-email-soren.brinkmann@xilinx.com>
	 <1379545361.1787.87.camel@joe-AO722>
	 <0da25c5c-660c-4836-8179-6e7c51fd0d9f@CO9EHSMHS005.ehs.local>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 16:09 -0700, Sören Brinkmann wrote:
> On Wed, Sep 18, 2013 at 04:02:41PM -0700, Joe Perches wrote:
> > On Wed, 2013-09-18 at 15:43 -0700, Soren Brinkmann wrote:
> > > Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
> > > The devices generate low-jitter clock signals and are reprogrammable via
> > > an I2C interface.
> > []
> > > v2:
> > []
> > >  - use 10000 as MIN and MAX value in usleep_range
> > []
> > > diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
> > []
> > > +static int si570_set_frequency(struct clk_si570 *data, unsigned long frequency)
> > > +{
> > []
> > > +	/* Applying a new frequency can take up to 10ms */
> > > +	usleep_range(10000, 10000);
> > 
> > Generally it's nicer to have an actual range for usleep_range.
> Well, as I said in the discussion with Guenther. I'm flexible and nobody
> objected when I said to make both equal. A real range doesn't make sense
> here though, but I don't know what's common practice for cases like
> this.

udelay is normal, but I guess you don't need atomic context.
 
> > Is there a bit you could periodically poll to see
> > if the new frequency has been set or is stable so
> > that a 10ms delay isn't always used?

> Unfortunately not.

Thanks.  I suppose I should read the datasheets before asking.

http://www.silabs.com/Support%20Documents/TechnicalDocs/si570.pdf
(page 12)

Anyway, perhaps si570_set_frequency_small needs a delay too.'

The 570 datasheet says it needs a 100uS delay.

> On Wed, 2013-09-18 at 15:43 -0700, Soren Brinkmann wrote:
> Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
> The devices generate low-jitter clock signals and are reprogrammable via
> an I2C interface.
> []
> +static int si570_set_frequency_small(struct clk_si570 *data,
> +				     unsigned long frequency)
> +{
> +	/*
> +	 * This is a re-implementation of DIV_ROUND_CLOSEST
> +	 * using the div64_u64 function lieu of letting the compiler
> +	 * insert EABI calls
> +	 */
> +	data->rfreq = div64_u64((data->rfreq * frequency) +
> +			div_u64(data->frequency, 2), data->frequency);
> +	regmap_write(data->regmap, SI570_REG_CONTROL, SI570_CNTRL_FREEZE_M);
> +	si570_update_rfreq(data);
> +	regmap_write(data->regmap, SI570_REG_CONTROL, 0);
> +
> +	return 0;
> +}


