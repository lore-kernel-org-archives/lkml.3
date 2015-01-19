Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbbAST2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:28:33 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:39198 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbAST2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 14:28:32 -0500
Date: Mon, 19 Jan 2015 19:28:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ray Jui <rjui@broadcom.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Scott Branden <sbranden@broadcom.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
Message-ID: <20150119192805.GF26493@n2100.arm.linux.org.uk>
References: <20150115084119.GN22880@pengutronix.de>
 <54B98C18.4080807@broadcom.com>
 <20150117160113.GA22880@pengutronix.de>
 <54BABEE9.8070801@broadcom.com>
 <20150117201849.GC22880@pengutronix.de>
 <54BACB66.6040909@broadcom.com>
 <20150117211017.GD22880@pengutronix.de>
 <54BAD391.9080909@broadcom.com>
 <20150117224021.GA26493@n2100.arm.linux.org.uk>
 <54BAFEA9.9040900@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BAFEA9.9040900@broadcom.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 04:30:33PM -0800, Ray Jui wrote:
> 
> 
> On 1/17/2015 2:40 PM, Russell King - ARM Linux wrote:
> > On Sat, Jan 17, 2015 at 01:26:41PM -0800, Ray Jui wrote:
> >> 	time_left = wait_for_completion_timeout(&iproc_i2c->done, time_left);
> >>
> >> 	/* disable all interrupts */
> >> 	writel(0, iproc_i2c->base + IE_OFFSET);
> >>
> >> 	if (!time_left && !atomic_read(&iproc_i2c->transfer_is_successful)) {
> > 
> > Why are you using atomic_read() here?
> > 
> transfer_is_successful 1) will be reset to 0 in this function (before
> kick start the I2C transfer), 2) will be set to 1 in the ISR (to signal
> completion of the I2C transfer), and 3) will be checked in this function
> here. I thought that means I should declare it volatile, because it can
> be modified in both the process context and interrupt context (and I use
> atomic because I remember Linux checkpatch warns against using volatile)?

You don't need volatile or atomic_t for that.

Rather than switching to atomic_t when seeing the checkpatch warning,
you'd do better to read Documentation/volatile-considered-harmful.txt
to understand why checkpatch issues the warning, and realise that you
don't need it for the above.

Note that in the above code, the compiler can't make an assumption
about iproc_i2c->transfer_is_successful because it can't tell whether
a called function (eg, wait_for_completion_timeout()) could modify it.

Another possible issue with the above code are these lines:

	/* disable all interrupts */
	writel(0, iproc_i2c->base + IE_OFFSET);

It would be nice to think that would hit the hardware immediately, but
that's making assumptions about hardware which are not necessary true.
Your interrupt handler could even be running on another CPU after you've
asked for that register to be written.

Depending on what you're trying to achieve here, you may need:

	/* disable all interrupts */
	writel(0, iproc_i2c->base + IE_OFFSET);
	/* read it back to ensure the write has hit */
	readl(iproc_i2c->base + IE_OFFSET);

	/* make sure the interrupt handler isn't running */
	synchronize_irq(...->irq);

if what you're trying to do is to ensure that the interrupt handler has
finished running.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
