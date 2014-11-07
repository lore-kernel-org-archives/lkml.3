Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaKGM24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:28:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48327 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbaKGM2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:28:53 -0500
Date: Fri, 7 Nov 2014 13:28:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v9 2/4] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
Message-ID: <20141107122850.GB20419@amd>
References: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
 <1415105570-7871-3-git-send-email-k.kozlowski@samsung.com>
 <20141104201834.GC15071@amd>
 <1415176978.15850.11.camel@AMDC1943>
 <20141107121320.GA20419@amd>
 <1415362683.31102.6.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415362683.31102.6.camel@AMDC1943>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-07 13:18:03, Krzysztof Kozlowski wrote:
> On pią, 2014-11-07 at 13:13 +0100, Pavel Machek wrote:
> > On Wed 2014-11-05 09:42:58, Krzysztof Kozlowski wrote:
> > > On wto, 2014-11-04 at 21:18 +0100, Pavel Machek wrote:
> > > > On Tue 2014-11-04 13:52:48, Krzysztof Kozlowski wrote:
> > > > > The AMBA bus driver defines runtime Power Management functions which
> > > > > disable and unprepare AMBA bus clock. This is problematic for runtime PM
> > > > > because unpreparing a clock might sleep so it is not interrupt safe.
> > > > > 
> > > > > However some drivers may want to implement runtime PM functions in
> > > > > interrupt-safe way (see pm_runtime_irq_safe()). In such case the AMBA
> > > > > bus driver should only disable/enable the clock in runtime suspend and
> > > > > resume callbacks.
> > > > 
> > > > 
> > > > 
> > > > >  /*
> > > > >   * Hooks to provide runtime PM of the pclk (bus clock).  It is safe to
> > > > >   * enable/disable the bus clock at runtime PM suspend/resume as this
> > > > > @@ -95,8 +102,14 @@ static int amba_pm_runtime_suspend(struct device *dev)
> > > > >  	struct amba_device *pcdev = to_amba_device(dev);
> > > > >  	int ret = pm_generic_runtime_suspend(dev);
> > > > >  
> > > > > -	if (ret == 0 && dev->driver)
> > > > > -		clk_disable_unprepare(pcdev->pclk);
> > > > > +	if (ret == 0 && dev->driver) {
> > > > > +		pcdev->irq_safe = get_pm_runtime_irq_safe(dev);
> > > > > +
> > > > > +		if (pcdev->irq_safe)
> > > > > +			clk_disable(pcdev->pclk);
> > > > > +		else
> > > > > +			clk_disable_unprepare(pcdev->pclk);
> > > > > +	}
> > > > 
> > > > So you can handle the case of !pcdev->irq_safe. What is the penalty
> > > > for always assuming !pcdev->irq_safe?
> > > 
> > > The penalty (for pl330 driver) would be that the runtime resume/suspend
> > > cannot happen from atomic context
> > >   => pm_runtime_get_sync() cannot be called from atomic context
> > >     => complete rework of runtime PM for pl330 DMA driver because now
> > >        one of pm_runtime_get_sync() calls is in device_issue_pending
> > >        callback which may not sleep. And by "rework" I also mean that
> > >        I do not know how to do this... yet.
> > 
> > I still don't get it. You say that you don't know how to handle
> > !pcdev->irq_safe case... Yet have code above that tries to handle it.
> > 
> > If that case can't be sanely handled, I'd expect
> > BUG_ON(!pcdev->irq_safe).
> 
> Hmmm... I could misunderstand your question. The amba/bus.c driver can
> handle both cases. However this varies for child drivers (which use
> these runtime PM callbacks too). For pl330 cannot handle non-irq-safe.
> Other drivers can.

Ok, so pl330 can't handle non-irq-safe callbacks. What about the other
solution preserving consistency -- can we make sure all callbacks are
irq-safe with acceptable penalty?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
