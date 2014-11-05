Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaKEItF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:49:05 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21641 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaKEItA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:49:00 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-33-5459e4794291
Message-id: <1415177336.15850.14.camel@AMDC1943>
Subject: Re: [PATCH v9 2/4] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 05 Nov 2014 09:48:56 +0100
In-reply-to: <CAPDyKFo6o8v9u6+MdGSRMmHeMcODqCcdToHXoJqVGcsRVgQwdA@mail.gmail.com>
References: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
 <1415105570-7871-3-git-send-email-k.kozlowski@samsung.com>
 <CAPDyKFo6o8v9u6+MdGSRMmHeMcODqCcdToHXoJqVGcsRVgQwdA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t/xy7qVTyJDDOa+tLbYOGM9q8WTA+2M
	FtOnXmC0WD31L6vF082PmSzONr1ht1gyeT6rRefEJewWs6bsZbK4vGsOm8Xn3iOMFrcv81qs
	PXKX3eLdywiLu6eOslmcOX2J1WLC7wtsFsfXhlu87NvP4iDs0dLcw+Yxu2Mmq8fiPS+ZPDat
	6mTzuHNtD5vH4r7JrB5L3hxi9dhytZ3FY/bdH4wefVtWMXqsWP2d3ePzJjmPvZ9/swTwRnHZ
	pKTmZJalFunbJXBlrJ8xh6VgvXDFhFOzWRoYr/B3MXJySAiYSJzetJINwhaTuHBvPZDNxSEk
	sJRRYsLsCVDOZ0aJxWv6wap4BQwkeo6sYgGxhQUyJVqOn2AHsdkEjCU2L18CViMioCGx5+F5
	VpBmZoEWNon7X3cygyRYBFQl3l24AtTMwcEpECzR+IARYsEpRomDPSeYQGqYBdQlJs1bxAxS
	IyGgLNHY7waxV1Dix+R7LBAl8hKb17xlnsAoMAtJxywkZbOQlC1gZF7FKJpamlxQnJSea6hX
	nJhbXJqXrpecn7uJERKpX3YwLj5mdYhRgINRiYfXoykyRIg1say4MvcQowQHs5IIL+cloBBv
	SmJlVWpRfnxRaU5q8SFGJg5OqQbGRSkHO5g6Y95vnXXBJ7RC5GFt7MqCmDMBv9U/W/7b/UKN
	v2HTN59Dp10erC0vcJ9+p6virNn8pH9du2ze39podSw1vrqx4oKPtHv5w5QPqhEPxN7v7ag9
	uiW4+efnzyuNXPep6p534NGqnrfDQGmXt32H5YH/bEzZ17lWyjZc3Z3Nr3Tzz6yLSizFGYmG
	WsxFxYkAxUFTJrICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-11-04 at 20:06 +0100, Ulf Hansson wrote:
> On 4 November 2014 13:52, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > The AMBA bus driver defines runtime Power Management functions which
> > disable and unprepare AMBA bus clock. This is problematic for runtime PM
> > because unpreparing a clock might sleep so it is not interrupt safe.
> >
> > However some drivers may want to implement runtime PM functions in
> > interrupt-safe way (see pm_runtime_irq_safe()). In such case the AMBA
> > bus driver should only disable/enable the clock in runtime suspend and
> > resume callbacks.
> >
> > Detect the device driver behavior during runtime suspend. During runtime
> > resume deal with clocks according to stored value.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/amba/bus.c       | 24 ++++++++++++++++++++----
> >  include/linux/amba/bus.h |  1 +
> >  2 files changed, 21 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> > index 47bbdc1b5be3..27ec8882ec8e 100644
> > --- a/drivers/amba/bus.c
> > +++ b/drivers/amba/bus.c
> > @@ -85,6 +85,13 @@ static struct device_attribute amba_dev_attrs[] = {
> >  };
> >
> >  #ifdef CONFIG_PM
> > +
> > +#ifdef CONFIG_PM_RUNTIME
> > +#define get_pm_runtime_irq_safe(dev)   ((dev)->power.irq_safe)
> > +#else
> > +#define get_pm_runtime_irq_safe(dev)   1
> 
> No, this doesn't work for those drivers that isn't configured as
> irq_safe. The pm_runtime_force_suspend() invoked from the driver's
> system PM suspend callback, will expect clocks to be unprepared when
> CONFIG_PM_RUNTIME is unset.

D'oh! You're right... 

> To address this issue, in principle we need to know whether the driver
> has invoked pm_runtime_irq_safe(), even when CONFIG_PM_RUNTIME is
> unset.
> 
> This may be solved by the help of PM core:
> 1) Move the irq_safe member in the struct dev_pm_info, outside the
> #ifdef CONFIG_PM_RUNTIME.
> 2) Let the pm_runtime_irq_safe() function be implemented for CONFIG_PM
> instead of CONFIG_PM_RUNTIME.

Before I'll start implementing this - could PM maintainers share their
opinion on such change?

Best regards,
Krzysztof


> If the PM core maintainers don't like that approach we can always add
> an amba specific wrapper function for pm_runtime_irq_safe() and store
> the information needed in the struct amba_device.
> 
> Kind regards
> Uffe


