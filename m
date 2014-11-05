Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaKEInH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:43:07 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21235 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaKEInD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:43:03 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-6b-5459e3142362
Message-id: <1415176978.15850.11.camel@AMDC1943>
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
Date: Wed, 05 Nov 2014 09:42:58 +0100
In-reply-to: <20141104201834.GC15071@amd>
References: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
 <1415105570-7871-3-git-send-email-k.kozlowski@samsung.com>
 <20141104201834.GC15071@amd>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t/xa7oijyNDDLZcUrDYOGM9q8WTA+2M
	FtOnXmC0WD31L6vF082PmSzONr1ht1gyeT6rRefEJewWs6bsZbK4vGsOm8Xn3iOMFrcv81qs
	PXKX3eLdywiLu6eOslmcOX2J1WLC7wtsFsfXhlu87NvP4iDs0dLcw+Yxu2Mmq8fiPS+ZPDat
	6mTzuHNtD5vH4r7JrB5L3hxi9dhytZ3FY/bdH4wefVtWMXqsWP2d3ePzJjmPvZ9/swTwRnHZ
	pKTmZJalFunbJXBl7G7ZwlRwgK/iWt9ipgbG5dxdjJwcEgImEpeXNLBA2GISF+6tZ+ti5OIQ
	EljKKNF0+hA7hPOZUeLU0Z9sIFW8AgYSz5e/ZAWxhQUyJVqOn2AHsdkEjCU2L18CViMiIC+x
	tW8FM0gzs8BpVolbbfPBVrAIqEo8XdcHVsQpoCnR37QBasMiRokv/yeBJZgF1CUmzVsE1M0B
	dJOyRGO/G8RiQYkfk++xQJTIS2xe85Z5AqPALCQds5CUzUJStoCReRWjaGppckFxUnqukV5x
	Ym5xaV66XnJ+7iZGSKx+3cG49JjVIUYBDkYlHl6PpsgQIdbEsuLK3EOMEhzMSiK8nJeAQrwp
	iZVVqUX58UWlOanFhxiZODilGhhvLi97xxv95BlDYo3r3MX1914f8W/2ul3d0O5k8ej2ibdi
	6X/V8g8Uv7k+feI3oaK/QTfk60JumE5nKgq9+SrtZ/SxZe3pKj7JHjnrxWafPNsafTR0+p/D
	jRNqs414Xk8yvnEphquu9rWUzquQtYtlj4f+meL4qXuJvd3OpVnPjzjofXZIXjFNiaU4I9FQ
	i7moOBEA6qg4drMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-11-04 at 21:18 +0100, Pavel Machek wrote:
> On Tue 2014-11-04 13:52:48, Krzysztof Kozlowski wrote:
> > The AMBA bus driver defines runtime Power Management functions which
> > disable and unprepare AMBA bus clock. This is problematic for runtime PM
> > because unpreparing a clock might sleep so it is not interrupt safe.
> > 
> > However some drivers may want to implement runtime PM functions in
> > interrupt-safe way (see pm_runtime_irq_safe()). In such case the AMBA
> > bus driver should only disable/enable the clock in runtime suspend and
> > resume callbacks.
> 
> 
> 
> >  /*
> >   * Hooks to provide runtime PM of the pclk (bus clock).  It is safe to
> >   * enable/disable the bus clock at runtime PM suspend/resume as this
> > @@ -95,8 +102,14 @@ static int amba_pm_runtime_suspend(struct device *dev)
> >  	struct amba_device *pcdev = to_amba_device(dev);
> >  	int ret = pm_generic_runtime_suspend(dev);
> >  
> > -	if (ret == 0 && dev->driver)
> > -		clk_disable_unprepare(pcdev->pclk);
> > +	if (ret == 0 && dev->driver) {
> > +		pcdev->irq_safe = get_pm_runtime_irq_safe(dev);
> > +
> > +		if (pcdev->irq_safe)
> > +			clk_disable(pcdev->pclk);
> > +		else
> > +			clk_disable_unprepare(pcdev->pclk);
> > +	}
> 
> So you can handle the case of !pcdev->irq_safe. What is the penalty
> for always assuming !pcdev->irq_safe?

The penalty (for pl330 driver) would be that the runtime resume/suspend
cannot happen from atomic context
  => pm_runtime_get_sync() cannot be called from atomic context
    => complete rework of runtime PM for pl330 DMA driver because now
       one of pm_runtime_get_sync() calls is in device_issue_pending
       callback which may not sleep. And by "rework" I also mean that
       I do not know how to do this... yet.

Best regards,
Krzysztof





