Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab3CUJPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:15:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41007 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068Ab3CUJPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:15:34 -0400
Date: Thu, 21 Mar 2013 10:15:31 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: divider: Use DIV_ROUND_CLOSEST
Message-ID: <20130321091531.GN20530@pengutronix.de>
References: <2e77dfe8-8d4f-4b77-bf1b-831ad1572c23@VA3EHSMHS046.ehs.local>
 <20130320001609.8663.21043@quantum>
 <f3ff0545-52cd-4b7b-967e-f81324ba0152@CH1EHSMHS040.ehs.local>
 <20130320185051.GA28349@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130320185051.GA28349@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 20, 2013 at 07:50:51PM +0100, Sascha Hauer wrote:
> On Wed, Mar 20, 2013 at 09:32:51AM -0700, Sören Brinkmann wrote:
> > If the caller
> > doesn't like the returned frequency he can request a different one.
> > And he's eventually happy with the return value he calls
> > clk_set_rate() requesting the frequency clk_round_rate() returned.
> > Always rounding down seems a bit odd to me.
> > 
> > Another issue with the current implmentation:
> > clk_divider_round_rate() calls clk_divider_bestdiv(), which uses the ROUND_UP macro, returning a rather low frequency.
> 
> And that is correct. clk_divider_bestdiv is used to calculate the
> maximum parent frequency for which a given divider value does not
> exceed the desired rate.
The reason for that is that the (more?) usual constraint is like: This
mmc card can handle up to 100 MHz. Or this i2c device can handle up to
this and that frequency. Of course there are different constraints, e.g.
for a UART if the target baud speed is 38400 you better run at 38402
than at 19201.

I wonder if it depends on the clock if you want "best approximation <=
requested value" or "best approximation" or on the caller. In the former
case a flag for the clock would be the right thing (as suggested in this
thread). If however it's the caller of round_rate who knows better which
rounding is preferred than better extend the clk API.

Extending the API could just be a convenience function that doesn't
affect the implementations of the clk API. E.g.:

	long clk_round_rate_nearest(struct clk *clk, unsigned long rate)
	{
		long lower_limit = clk_round_rate(clk, rate);
		long upper_limit = clk_round_rate(clk, rate + (rate - lower_limit));

		if (rate - lower_limit < upper_limit - rate)
			return lower_limit;
		else
			return upper_limit;
	}

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
