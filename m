Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935183AbaKNOW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:22:59 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61266 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbaKNOW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:22:57 -0500
MIME-Version: 1.0
In-Reply-To: <1415972831.25433.3.camel@AMDC1943>
References: <1415955033-29093-1-git-send-email-k.kozlowski@samsung.com>
	<1415955033-29093-6-git-send-email-k.kozlowski@samsung.com>
	<CAPDyKFr+DVd0qZ=ra5W-HxHDqauX6ZwBK8S8t_fboJfk_BUTaA@mail.gmail.com>
	<1415972831.25433.3.camel@AMDC1943>
Date: Fri, 14 Nov 2014 15:22:56 +0100
Message-ID: <CAPDyKFpfZZ95s-4XW-tXnD2YgEC_UECxsAdfKbMTokADWEL8hw@mail.gmail.com>
Subject: Re: [PATCH v12 5/6] dmaengine: pl330: Add PM sleep support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 November 2014 14:47, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> On pią, 2014-11-14 at 14:31 +0100, Ulf Hansson wrote:
>> On 14 November 2014 09:50, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
>> > Add system suspend/resume capabilities to the pl330 driver so the amba
>> > bus clock could be also unprepared to conserve energy.
>> >
>> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> > ---
>> >  drivers/dma/pl330.c | 41 +++++++++++++++++++++++++++++++++++++++++
>> >  1 file changed, 41 insertions(+)
>> >
>> > diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
>> > index c3bd3584f261..e499bb118f0a 100644
>> > --- a/drivers/dma/pl330.c
>> > +++ b/drivers/dma/pl330.c
>> > @@ -2627,6 +2627,46 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
>> >         return 0;
>> >  }
>> >
>> > +/*
>> > + * Runtime PM callbacks are provided by amba/bus.c driver.
>> > + *
>> > + * It is assumed here that IRQ safe runtime PM is chosen in probe and amba
>> > + * bus driver will only disable/enable the clock in runtime PM callbacks.
>> > + */
>> > +static int __maybe_unused pl330_suspend(struct device *dev)
>> > +{
>> > +       struct amba_device *pcdev = to_amba_device(dev);
>> > +
>> > +       pm_runtime_disable(dev);
>> > +
>> > +       if (!pm_runtime_status_suspended(dev)) {
>> > +               /* amba did not disable the clock */
>> > +               amba_pclk_disable(pcdev);
>> > +       }
>> > +       amba_pclk_unprepare(pcdev);
>>
>> I would also invoke pm_runtime_set_suspended() here, to reflect that's
>> the current runtime PM state of the device.
>
> Strictly speaking the device is not runtime suspended in that moment. PM
> runtime callbacks were not called. Although the device status looks like
> runtime suspended (clocks disabled) but I think the whole goal here was
> to avoid touching runtime PM because this is system sleep.

If someone outside, like a PM domain monitors the runtime PM status of
the device it would get the wrong impression of the device.

This is quite similar to why the amba bus needs to update the runtime
PM status during probe(), using pm_runtime_set_active(). Shouldn't we
do that either?

>
>
>> I guess I sounds like broken record :-), but using
>> pm_runtime_force_suspend() would help to prevent some code duplication
>> here.
>>
>> Something like this:
>>
>> pm_runtime_force_suspend()
>> if (pm_runtime_is_irq_safe())
>>    amba_pclk_unprepare(pcdev);
>
> With !CONFIG_PM_RUNTIME this would leave clocks prepared...

No.

pm_runtime_is_irq_safe() returns false, and thus the amba bus do a
clk_disable_unprepare() from it's runtime PM suspend callback when
it's invoked via pm_runtime_force_suspend().

Kind regards
Uffe
