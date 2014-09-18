Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbaIRKKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 06:10:06 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34700 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886AbaIRKKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 06:10:02 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-95-541aaf768c78
Content-transfer-encoding: 8BIT
Message-id: <1411034996.23919.9.camel@AMDC1943>
Subject: Re: [PATCH v4 4/4] dma: pl330: add Power Management support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Thu, 18 Sep 2014 12:09:56 +0200
In-reply-to: <CAPDyKFqoLQh=FYg33LTSp-HTs-oJDT4y_K6hGRoiu9zDxOX9sw@mail.gmail.com>
References: <1410857494-15936-1-git-send-email-k.kozlowski@samsung.com>
 <1410857494-15936-5-git-send-email-k.kozlowski@samsung.com>
 <CAPDyKFqoLQh=FYg33LTSp-HTs-oJDT4y_K6hGRoiu9zDxOX9sw@mail.gmail.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t/xK7pl66VCDG7NULHYOGM9q8X0qRcY
	LVZP/ctqceDPDkaLs01v2C2WTJ7PajFryl4mi4VtS1gsLu+aw2bxufcIo8Xty7wWa4/cZbd4
	9zLC4u6po2wWb+9MZ7E4c/oSq8WE3xfYLI6vDbd42befxUHYo6W5h81j8wotj8V7XjJ53Lm2
	h81jyZtDrB5brrazeMy++4PRo2/LKkaPFau/s3t83iTnsffzb5YA7igum5TUnMyy1CJ9uwSu
	jN67r9kLZstWdDXeZWxg3CTaxcjJISFgIrFl6zwmCFtM4sK99WxdjFwcQgJLGSX2tbazgSR4
	BQQlfky+x9LFyMHBLCAvceRSNkiYWUBdYtK8RcwQ9Z8ZJd7/3QlVry9x93c/M4gtLOAi8Wfr
	LVYQm03AWGLz8iVgNSICGhJ7Hp5nBWlmFpjAJvF0x1ywIhYBVYm15/6DXcQpECyx/2MvE8SG
	M4wSZxZdYwO5QkJAWaKx320Co8AsJPfNQrhvFpL7FjAyr2IUTS1NLihOSs810itOzC0uzUvX
	S87P3cQIicivOxiXHrM6xCjAwajEwyshIBUixJpYVlyZe4hRgoNZSYT310KgEG9KYmVValF+
	fFFpTmrxIUYmDk6pBsbJy7TEjO6KHS5d0hYeYsItf2ZCcOf8qSrZr954HDLJNtny3zj5y27b
	GXzLVOIZTk6/xaFZVeN66vjTjrYK9Ymen/cabGSsWyvy8Y3csl95irrFBlz9lcs+WjGai7az
	W/hdcAwUcDqV+yXnRa5OiURoY1Z6d6Krmc5qVTv2t0LWP6Rz1qxMV2Ipzkg01GIuKk4EAB1d
	+aqmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-09-17 at 20:42 +0200, Ulf Hansson wrote:
> On 16 September 2014 10:51, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:

[...]

> >
> > @@ -2585,6 +2620,34 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
> >         return 0;
> >  }
> >
> > +/*
> > + * Assume that IRQ safe runtime PM is chosen in probe and amba bus driver
> > + * will only disable/enable the clock in runtime PM suspend/resume.
> > + */
> > +static int __maybe_unused pl330_suspend(struct device *dev)
> > +{
> > +       struct amba_device *pcdev = to_amba_device(dev);
> > +
> > +       if (!pm_runtime_suspended(dev))
> > +               amba_pclk_disable(pcdev);
> 
> I would suggest to use pm_runtime_force_suspend() instead of the above.

Sure, I can change it but... (see below)

> 
> > +       amba_pclk_unprepare(pcdev);
> > +
> > +       return 0;
> > +}
> > +
> > +static int __maybe_unused pl330_resume(struct device *dev)
> > +{
> > +       struct amba_device *pcdev = to_amba_device(dev);
> > +
> > +       amba_pclk_prepare(pcdev);
> > +       if (!pm_runtime_suspended(dev))
> > +               return amba_pclk_enable(pcdev);
> 
> The above if statement could be replaced with pm_runtime_force_resume().

But that would lead to runtime resuming the device even when it is not
needed. We don't have to fully wakeup the device during resume operation
when the device was runtime suspended before suspend.

> 
> Doing that, means the amba_pclk_enable|disable() don't need to be
> exported from the AMBA bus header, but entirely handled by the AMBA
> bus itself.
> 
> > +
> > +       return 0;
> > +}
> > +
> > +static SIMPLE_DEV_PM_OPS(pl330_pm, pl330_suspend, pl330_resume);
> > +
> >  static int
> >  pl330_probe(struct amba_device *adev, const struct amba_id *id)
> >  {
> > @@ -2738,6 +2801,9 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
> >                 pcfg->data_buf_dep, pcfg->data_bus_width / 8, pcfg->num_chan,
> >                 pcfg->num_peri, pcfg->num_events);
> >
> 
> You need pm_runtime_set_active() here as well.

This is done by amba/bus.c. Do I have to do it again?

> 
> > +       pm_runtime_irq_safe(&adev->dev);
> > +       pm_runtime_put_noidle(&adev->dev);
> 
> Why pm_runtime_put_noidle(), that seems like you might end up leaving
> the device in active state - unless you get some request. Likely not
> what you want?

Hmmm... I am sorry but I do not get the point here. It could be
pm_runtime_put() as well because initially we start with counter
incremented by amba/bus.c.


> A final question, have you considered using runtime PM autosuspend
> feature. Any reason to why not?

There is no reason, I just implemented the easier way. I was hoping for
such ideas of improvement. I'll add autosuspend.


Thanks for feedback, I really appreciate it!

Best regards,
Krzysztof

> 
> > +
> >         return 0;
> >  probe_err3:
> >         /* Idle the DMAC */
> > @@ -2764,6 +2830,8 @@ static int pl330_remove(struct amba_device *adev)
> >         struct pl330_dmac *pl330 = amba_get_drvdata(adev);
> >         struct dma_pl330_chan *pch, *_p;
> >
> > +       pm_runtime_get_noresume(pl330->ddma.dev);
> > +
> >         if (adev->dev.of_node)
> >                 of_dma_controller_free(adev->dev.of_node);
> >
> > @@ -2802,6 +2870,7 @@ static struct amba_driver pl330_driver = {
> >         .drv = {
> >                 .owner = THIS_MODULE,
> >                 .name = "dma-pl330",
> > +               .pm = &pl330_pm,
> >         },
> >         .id_table = pl330_ids,
> >         .probe = pl330_probe,
> > --
> > 1.9.1
> >
> 
> Kind regards
> Uffe

