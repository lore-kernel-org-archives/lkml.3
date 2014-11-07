Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaKGNV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:21:59 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33775 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaKGNVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:21:53 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-1e-545cc76e77ba
Content-transfer-encoding: 8BIT
Message-id: <1415366508.31102.10.camel@AMDC1943>
Subject: Re: [PATCH v9 2/4] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Pavel Machek <pavel@ucw.cz>
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
Date: Fri, 07 Nov 2014 14:21:48 +0100
In-reply-to: <20141107122850.GB20419@amd>
References: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
 <1415105570-7871-3-git-send-email-k.kozlowski@samsung.com>
 <20141104201834.GC15071@amd> <1415176978.15850.11.camel@AMDC1943>
 <20141107121320.GA20419@amd> <1415362683.31102.6.camel@AMDC1943>
 <20141107122850.GB20419@amd>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t/xy7p5x2NCDBbt5bPYOGM9q8WTA+2M
	FtOnXmC0WD31L6vF082PmSzONr1ht1gyeT6rRefEJewWs6bsZbK4vGsOm8Xn3iOMFrcv81qs
	PXKX3eLdywiLu6eOslmcOX2J1WLC7wtsFsfXhlu87NvP4iDs0dLcw+Yxu2Mmq8fiPS+ZPDat
	6mTzuHNtD5vH4r7JrB5L3hxi9dhytZ3FY/bdH4wefVtWMXqsWP2d3ePzJjmPvZ9/swTwRnHZ
	pKTmZJalFunbJXBlfFrpU7BauuLYyVWMDYyfRboYOTkkBEwk3p+/yw5hi0lcuLeerYuRi0NI
	YCmjROvlO6wgCV4BQYkfk++xdDFycDALyEscuZQNEmYWUJeYNG8RM0T9Z0aJuffmMUPUG0h0
	H9gAZgsLZEq0HD8BtoBNwFhi8/IlbCC2CNCcrX0rwJqZBU6zStxqm88CkmARUJXoXd8FVsQp
	oCnxduclJogNK5kkplz8DHaFhICyRGO/2wRGgVlI7puFcN8sJPctYGRexSiaWppcUJyUnmuo
	V5yYW1yal66XnJ+7iRESpV92MC4+ZnWIUYCDUYmHt1MoJkSINbGsuDL3EKMEB7OSCG/BPqAQ
	b0piZVVqUX58UWlOavEhRiYOTqkGxtni6aJzcvavZ3FXybCZl+KwbP2uiRPv8X/dUuL1ct+a
	166cS6pqnNOXZFRKLvlRumuOz1WWNxtqBYIiTjTMyKljnlSyoCxC+IHcTJXXkfqHHmVfED/B
	zfTnvzGXwaeEkqPSCve2P8s0uiIb85NH5VVsfiXLti8ChpZvxeecfvVDLZlNvOjvNyWW4oxE
	Qy3mouJEAOBlaRKwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-11-07 at 13:28 +0100, Pavel Machek wrote:
> On Fri 2014-11-07 13:18:03, Krzysztof Kozlowski wrote:
> > On pią, 2014-11-07 at 13:13 +0100, Pavel Machek wrote:
> > > On Wed 2014-11-05 09:42:58, Krzysztof Kozlowski wrote:
> > > > On wto, 2014-11-04 at 21:18 +0100, Pavel Machek wrote:
> > > > > On Tue 2014-11-04 13:52:48, Krzysztof Kozlowski wrote:
> > > > > > The AMBA bus driver defines runtime Power Management functions which
> > > > > > disable and unprepare AMBA bus clock. This is problematic for runtime PM
> > > > > > because unpreparing a clock might sleep so it is not interrupt safe.
> > > > > > 
> > > > > > However some drivers may want to implement runtime PM functions in
> > > > > > interrupt-safe way (see pm_runtime_irq_safe()). In such case the AMBA
> > > > > > bus driver should only disable/enable the clock in runtime suspend and
> > > > > > resume callbacks.
> > > > > 
> > > > > 
> > > > > 
> > > > > >  /*
> > > > > >   * Hooks to provide runtime PM of the pclk (bus clock).  It is safe to
> > > > > >   * enable/disable the bus clock at runtime PM suspend/resume as this
> > > > > > @@ -95,8 +102,14 @@ static int amba_pm_runtime_suspend(struct device *dev)
> > > > > >  	struct amba_device *pcdev = to_amba_device(dev);
> > > > > >  	int ret = pm_generic_runtime_suspend(dev);
> > > > > >  
> > > > > > -	if (ret == 0 && dev->driver)
> > > > > > -		clk_disable_unprepare(pcdev->pclk);
> > > > > > +	if (ret == 0 && dev->driver) {
> > > > > > +		pcdev->irq_safe = get_pm_runtime_irq_safe(dev);
> > > > > > +
> > > > > > +		if (pcdev->irq_safe)
> > > > > > +			clk_disable(pcdev->pclk);
> > > > > > +		else
> > > > > > +			clk_disable_unprepare(pcdev->pclk);
> > > > > > +	}
> > > > > 
> > > > > So you can handle the case of !pcdev->irq_safe. What is the penalty
> > > > > for always assuming !pcdev->irq_safe?
> > > > 
> > > > The penalty (for pl330 driver) would be that the runtime resume/suspend
> > > > cannot happen from atomic context
> > > >   => pm_runtime_get_sync() cannot be called from atomic context
> > > >     => complete rework of runtime PM for pl330 DMA driver because now
> > > >        one of pm_runtime_get_sync() calls is in device_issue_pending
> > > >        callback which may not sleep. And by "rework" I also mean that
> > > >        I do not know how to do this... yet.
> > > 
> > > I still don't get it. You say that you don't know how to handle
> > > !pcdev->irq_safe case... Yet have code above that tries to handle it.
> > > 
> > > If that case can't be sanely handled, I'd expect
> > > BUG_ON(!pcdev->irq_safe).
> > 
> > Hmmm... I could misunderstand your question. The amba/bus.c driver can
> > handle both cases. However this varies for child drivers (which use
> > these runtime PM callbacks too). For pl330 cannot handle non-irq-safe.
> > Other drivers can.
> 
> Ok, so pl330 can't handle non-irq-safe callbacks. What about the other
> solution preserving consistency -- can we make sure all callbacks are
> irq-safe with acceptable penalty?

Aaahhh, I get it. We could revert 5303c0f46c87 ("ARM: 7916/1: amba: Add
clk_prepare|unprepare in runtime PM callbacks"). After quick grep
through amba drivers it seems that this should work and the only impact
would be that less energy could be saved on other drivers (clock only
disabled, not unprepared).

However someone more experienced in amba drivers should confirm this.

Best regards,
Krzysztof


