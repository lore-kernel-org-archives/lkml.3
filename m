Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaFBK2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:28:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43652 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaFBK2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:28:31 -0400
Message-ID: <1401704829.4655.13.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCH] regulator: core: allow non-exact matches in
 regulator_set_voltage_time()
From: Lucas Stach <l.stach@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Date: Mon, 02 Jun 2014 12:27:09 +0200
In-Reply-To: <20140601113834.GG5099@sirena.org.uk>
References: <1400691239-21987-1-git-send-email-l.stach@pengutronix.de>
	 <20140601113834.GG5099@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 01.06.2014, 12:38 +0100 schrieb Mark Brown:
> On Wed, May 21, 2014 at 06:53:59PM +0200, Lucas Stach wrote:
> > Currently this function only provides a valid output if both
> > old_uV and new_uV are exact voltages that can be provided by the
> > regulator.
> > This is almost impossible to achive as the consumer has
> > no way to know the exact voltages provided by the regulator.
> 
> Yes it does - this is what regulator_list_voltage() is there for.
> Drivers can enumerate all the voltages supported by a regulator.
> 
> > This breaks the current cpufreq users of this function, as they
> > stick in the raw voltages retrieved from their operating points,
> > which may or may not match one of the regulator voltages.
> 
> At least the code in cpufreq-cpu0 looks a bit confused here.  The use of
> min_uV and max_uV is a bit unclear but probably correct however for some
> reason it appears that what it's doing is stepping through each single
> step transition between two adjacent frequencies, getting the transition
> latency for that and then summing those.  Given that it needs a single
> number I'd expect it to instead be getting the minimum and maximum
> voltages and then working out the highest latency for transitioning
> between those, what it's doing at the minute will be overestimating any
> fixed component of transition latency (from the time taken to issue
> commands to the device for example).
> 
Note the add is not within any loop, so what cpufreq-cpu0 currently does
is getting the lowest and highest voltage and using the transition time
between those two. It's just adding this to a fixed delay used to
represent other delays like PLL relock.

> Incidentally the clock API ought to have a similar thing - at the minute
> the driver just has a fixed number stuffed into it from DT but it really
> ought to be able to ask the clock API in the same way as it asks the
> regulator API.
> 
Right, this should be easily fixable by calling clk_round_rate() on te
OPP defined frequencies.

> > To make this function behave as expected employ the same logic
> > as used when calling set_voltage() and round the voltages to
> > the closest matching voltage supported by the regulator.
> 
> That's not what the set_voltage() code does - what it does is find the
> lowest voltage in the requested range.  
> 
> Your code won't actually do quite what cpufreq-cpu0 is doing since it
> uses set_voltage_tol() which will ask for a range around the voltage
> it's trying to set so the query in cpufreq-cpu0 will come out as
> something different to what the driver actually ends up doing when it
> does transitions.  We should probably add functions to query what the
> actual voltage selected for a given set_voltage() and set_voltage_tol()
> will be then let that be fed into requesting the transition times.

Hm, this sounds a lot like clk_round_rate() for the regulator API which
sounds like a sensible addition. One problem I see here is that the
result is not really a static value, but rather depends on the
consumers. If we call into the regulator API early to ask about the
voltage we will get when asking for a range, the result may well be
different than the real value after other consumers have registered
themselves with a different min_uV.

Regards,
Lucas

-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

