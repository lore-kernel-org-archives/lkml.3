Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaKLPxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:53:39 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26850 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbaKLPxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:53:37 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f956d000005ed7-65-5463827ec5b7
Content-transfer-encoding: 8BIT
Message-id: <1415807612.20177.6.camel@AMDC1943>
Subject: Re: [PATCH v11 5/6] dmaengine: pl330: Add PM sleep support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
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
Date: Wed, 12 Nov 2014 16:53:32 +0100
In-reply-to: <CAPDyKFoBdq0Vdh-RELGMX_oud2PaDofqBHgc-ViReYwP9-=y2w@mail.gmail.com>
References: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
 <1415802748-30530-6-git-send-email-k.kozlowski@samsung.com>
 <CAPDyKFoBdq0Vdh-RELGMX_oud2PaDofqBHgc-ViReYwP9-=y2w@mail.gmail.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4Vd26puQQg8br/BYbZ6xntZg+9QKj
	xeqpf1ktnm5+zGRxtukNu0XnxCXsFrOm7GWyuLxrDpvF594jjBa3L/NarD1yl93i7qmjbBZn
	Tl9itZjw+wKbxfG14RYv+/azOAh4tDT3sHnM7pjJ6rF4z0smj02rOtk87lzbw+ax5Wo7i8fs
	uz8YPfq2rGL0WLH6O7vH501yAVxRXDYpqTmZZalF+nYJXBl9LRtYCh4KVSw8d5ypgbGZv4uR
	k0NCwERie99kdghbTOLCvfVsXYxcHEICSxklevYcBEvwCghK/Jh8j6WLkYODWUBe4silbJAw
	s4C6xKR5i5hBbCGBz4wS936lQJTrS6yYeYMJxBYWcJb4d2sSmM0mYCyxefkSNhBbREBDYs/D
	86wgu5gFJrBKnNv/gxUkwSKgKvH61AWwoZwCwRKPvk5hhTjoDKPE5wfTmEGOkBBQlmjsd5vA
	KDALyXmzEM6bheS8BYzMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCYu3rDsalx6wOMQpw
	MCrx8H7QSg4RYk0sK67MPcQowcGsJMLrXw8U4k1JrKxKLcqPLyrNSS0+xMjEwSnVwNgj3B+1
	WqhqQeIau605r/6qf+uIObBEn9P8VAL/jf7jov7FjC8u3Tcy1T7qs4jRXCXb+5rojxPmH6y/
	/54hvfzHW8EJSwIXNsqn1yxydWheIF37/VMr06Pbct9OszyxDQtJP5+QGN/0IGf3g/LCXA8r
	mys2JaELZu2Otv7987LzkmbZQMvZv5RYijMSDbWYi4oTAc7qT0eTAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-11-12 at 16:28 +0100, Ulf Hansson wrote:
> On 12 November 2014 15:32, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > Add system suspend/resume capabilities to the pl330 driver so the amba
> > bus clock could be also unprepared to conserve energy.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/dma/pl330.c | 37 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> >
> > diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> > index c3bd3584f261..fd71777fc565 100644
> > --- a/drivers/dma/pl330.c
> > +++ b/drivers/dma/pl330.c
> > @@ -2627,6 +2627,42 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
> >         return 0;
> >  }
> >
> > +/*
> > + * Runtime PM callbacks are provided by amba/bus.c driver.
> > + *
> > + * It is assumed here that IRQ safe runtime PM is chosen in probe and amba
> > + * bus driver will only disable/enable the clock in runtime PM callbacks.
> > + */
> > +static int __maybe_unused pl330_suspend(struct device *dev)
> > +{
> > +       struct amba_device *pcdev = to_amba_device(dev);
> > +
> > +       if (!pm_runtime_status_suspended(dev)) {
> 
> No, this wont work. Consider this scenario:
> 
> pm_runtime_status_suspended() returns "true", which means you consider
> the device to be runtime PM suspended, thus you will unprepare the
> clock below.
> 
> Later, a call to pm_runtime_get_sync() is invoked from "somewhere" and
> before this driver's system PM resume callback has been invoked. That
> will trigger the runtime PM resume callback to be invoked, causing
> clock unbalance issues.

If during system resume the device runtime resume is called BEFORE
normal resume of device, then you're right: clock will be unbalanced. 

But such case does not make sense. pm_runtime_get_sync() is called when
someone wants to use the dmaengine/pl330... but the pl330 driver is
still suspended in that time!

If runtime resume is called AFTER normal resume of device - then it is
fine with my code.

> You need a pm_runtime_disable() prior checking the runtime PM status
> using pm_runtime_status_suspended(). That will prevent this from
> happen.
> 
> I guess you may see where this is leading. I think
> pm_runtime_force_suspend|resume() is well suited for this situation.

I've been there... :)



