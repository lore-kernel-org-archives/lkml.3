Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab3CZWpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:45:30 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:41027
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281Ab3CZWp1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:45:27 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432I1521Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah906i1155h)
Date: Tue, 26 Mar 2013 15:45:22 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: divider: Use DIV_ROUND_CLOSEST
References: <20130320001609.8663.21043@quantum>
 <f3ff0545-52cd-4b7b-967e-f81324ba0152@CH1EHSMHS040.ehs.local>
 <20130320185051.GA28349@pengutronix.de>
 <20130321091531.GN20530@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130321091531.GN20530@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <cffdea50-cadf-4662-a4fb-c61ab853fc4c@VA3EHSMHS014.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 10:15:31AM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Wed, Mar 20, 2013 at 07:50:51PM +0100, Sascha Hauer wrote:
> > On Wed, Mar 20, 2013 at 09:32:51AM -0700, Sören Brinkmann wrote:
> > > If the caller
> > > doesn't like the returned frequency he can request a different one.
> > > And he's eventually happy with the return value he calls
> > > clk_set_rate() requesting the frequency clk_round_rate() returned.
> > > Always rounding down seems a bit odd to me.
> > > 
> > > Another issue with the current implmentation:
> > > clk_divider_round_rate() calls clk_divider_bestdiv(), which uses the ROUND_UP macro, returning a rather low frequency.
> > 
> > And that is correct. clk_divider_bestdiv is used to calculate the
> > maximum parent frequency for which a given divider value does not
> > exceed the desired rate.
> The reason for that is that the (more?) usual constraint is like: This
> mmc card can handle up to 100 MHz. Or this i2c device can handle up to
> this and that frequency. Of course there are different constraints, e.g.
> for a UART if the target baud speed is 38400 you better run at 38402
> than at 19201.
> 
> I wonder if it depends on the clock if you want "best approximation <=
> requested value" or "best approximation" or on the caller. In the former
> case a flag for the clock would be the right thing (as suggested in this
> thread). If however it's the caller of round_rate who knows better which
> rounding is preferred than better extend the clk API.
> 
> Extending the API could just be a convenience function that doesn't
> affect the implementations of the clk API. E.g.:
> 
> 	long clk_round_rate_nearest(struct clk *clk, unsigned long rate)
> 	{
> 		long lower_limit = clk_round_rate(clk, rate);
> 		long upper_limit = clk_round_rate(clk, rate + (rate - lower_limit));
> 
> 		if (rate - lower_limit < upper_limit - rate)
> 			return lower_limit;
> 		else
> 			return upper_limit;
> 	}
> 
I guess both approaches may work. Anybody has a preference?

	Sören


