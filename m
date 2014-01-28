Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbaA1KdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:33:01 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50657 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754712AbaA1KdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:33:00 -0500
Date: Tue, 28 Jan 2014 10:32:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH] clk: divider: fix rate calculation for fractional rates
Message-ID: <20140128103253.GD15937@n2100.arm.linux.org.uk>
References: <1383736008-22764-1-git-send-email-tomi.valkeinen@ti.com> <20131106111534.GW16735@n2100.arm.linux.org.uk> <527A2C9C.4080409@ti.com> <20131106161911.GA16735@n2100.arm.linux.org.uk> <52E76E3A.8030807@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E76E3A.8030807@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 10:45:46AM +0200, Tomi Valkeinen wrote:
> Russell, I'd like to understand why you think the original example is bad:
> 
> 	rate = clk_round_rate(clk, rate);
> 	clk_set_rate(clk, rate);

It's needlessly wasteful.  All the processing for setting the rate is
repeated.

> If the definition of clk_round_rate is basically "clk_set_rate without
> actually setting the rate", I agree that the above code is not good as
> it might not work correctly.
> 
> However, if  the following code you gave should work:
> 
> 	rate = clk_get_rate(clk);
> 	clk_set_rate(clk, rate);
> 	assert(clk_get_rate(clk) == rate);
> 
> then the original example should also always work, as it's almost the
> same as:
> 
> 	/* this is the "round" part */
> 	clk_set_rate(clk, rate);
> 	rate = clk_get_rate(clk);
> 
> 	clk_set_rate(clk, rate);
> 	assert(clk_get_rate(clk) == rate);

Okay, now ask yourself this - would you code the above into your driver
with no processing between the two?  It seems that some people would!

> Why I'm asking this is that for me (and probably for others also if
> you've seen it used in the kernel code) it feels natural to have code like:
> 
> 	rate = clk_round_rate(clk, rate);
> 	
> 	/* Verify the rounded rate here to see it's ok for the IP etc */
> 
> 	/* The rate is ok, so set it */
> 	clk_set_rate(clk, rate);

If you want to do something with the rounded rate, then that's fine,
you have a reason to do it this way.  However, what I was referring to
are drivers which literally do this:

	clk_set_rate(clk, clk_round_rate(clk, rate));

In other words, they think that they must always round the rate before
passing it into clk_set_rate() even though they make no other use of
the rounded rate.  That is completely wasteful and unnecessary.  It
might as well have clk_round_rate() replaced by a udelay() to waste
some CPU cycles just for the hell of it.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
