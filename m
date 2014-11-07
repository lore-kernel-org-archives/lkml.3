Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaKGIGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 03:06:49 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52182 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaKGIGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 03:06:47 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-ae-545c7d93108a
Message-id: <1415347601.8532.7.camel@AMDC1943>
Subject: Re: [PATCH v10 1/5] PM / Runtime: Allow accessing irq_safe if no
 PM_RUNTIME
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
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
Date: Fri, 07 Nov 2014 09:06:41 +0100
In-reply-to: <2475860.cssHTQVJGf@vostro.rjw.lan>
References: <1415263010-7992-1-git-send-email-k.kozlowski@samsung.com>
 <1415263010-7992-2-git-send-email-k.kozlowski@samsung.com>
 <2475860.cssHTQVJGf@vostro.rjw.lan>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t/xK7qTa2NCDO5OMbTYOGM9q8X0qRcY
	LVZP/ctq8XTzYyaLs01v2C2WTJ7PatE5cQm7xawpe5ksLu+aw2bxufcIo8Xty7wWa4/cZbd4
	9zLC4u6po2wWZ05fYrWY8PsCm8XxteEWL/v2szgIebQ097B5zO6YyeqxeM9LJo9NqzrZPO5c
	28PmseTNIVaPLVfbWTxm3/3B6NG3ZRWjx4rV39k9Pm+S89j7+TdLAE8Ul01Kak5mWWqRvl0C
	V8b8VzfZC9aLV9yc9J+lgXGfUBcjJ4eEgInE1Jlf2CFsMYkL99azgdhCAksZJf789uhi5AKy
	PzNKrFqyCKyIV0BP4vrVU6wgtrBAmETT0j0sIDabgLHE5uVLwJpFBLQl5vacYgZpZhaYyypx
	afpusCIWAVWJhXdPgjVzChhIbLk0mRliw0pGiZ4tfWBFzALqEpPmLQJKcACdpCzR2O8GsVhQ
	4sfke1Al8hKb17xlnsAoMAtJxywkZbOQlC1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJ
	ERKVX3cwLj1mdYhRgINRiYf3gUhMiBBrYllxZe4hRgkOZiURXqkgoBBvSmJlVWpRfnxRaU5q
	8SFGJg5OqQbGaJ82x8jFMgXaobIhZTef9X8LyFu9cl1H679t5nb75G7ErVt2OGVF8+Xu2RoP
	9I86ZdRzdUj06R+erfcv+cWh4OYfv6ptW3L99suKFPyWO/7PaMaMjD8BpqcC4jZ7lZRP+fP4
	T1XZ/++py03nHn0zz/H5DaelH9lNmbkOtlh4L5m+Q52zSd5ZiaU4I9FQi7moOBEAjRYBS6gC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-11-06 at 23:51 +0100, Rafael J. Wysocki wrote:
> On Thursday, November 06, 2014 09:36:46 AM Krzysztof Kozlowski wrote:
> > Some drivers (e.g. bus drivers) may want to check if power.irq_safe was
> > called by child driver, regardless of CONFIG_PM_RUNTIME.
> > 
> > An example scenario is amba/bus.c and dma/pl330.c drivers. The runtime
> > suspend/resume callbacks in amba bus driver act differently if irq_safe
> > was set by child driver (in irq_safe mode bus clock is only disabled).
> > 
> > The pl330 driver sets irq_safe and assumes that amba bus driver will
> > only disable the clock in runtime PM. So in system sleep suspend
> > callback the pl330 driver unprepares the clock after calling
> > pm_runtime_force_suspend().
> > 
> > However inconsistency would appear if CONFIG_PM_RUNTIME is not set and
> > child drivers do not want the irq_safe runtime PM. In such case amba bus
> > driver still has to know whether child driver wanted irq_safe - by
> > looking at dev->power.irq_safe field.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  include/linux/pm.h         | 2 +-
> >  include/linux/pm_runtime.h | 5 ++++-
> >  2 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/pm.h b/include/linux/pm.h
> > index 383fd68aaee1..b05fa954f50d 100644
> > --- a/include/linux/pm.h
> > +++ b/include/linux/pm.h
> > @@ -566,6 +566,7 @@ struct dev_pm_info {
> >  	bool			ignore_children:1;
> >  	bool			early_init:1;	/* Owned by the PM core */
> >  	bool			direct_complete:1;	/* Owned by the PM core */
> > +	unsigned int		irq_safe:1;	/* PM runtime */
> >  	spinlock_t		lock;
> >  #ifdef CONFIG_PM_SLEEP
> >  	struct list_head	entry;
> > @@ -590,7 +591,6 @@ struct dev_pm_info {
> >  	unsigned int		run_wake:1;
> >  	unsigned int		runtime_auto:1;
> >  	unsigned int		no_callbacks:1;
> > -	unsigned int		irq_safe:1;
> >  	unsigned int		use_autosuspend:1;
> >  	unsigned int		timer_autosuspends:1;
> >  	unsigned int		memalloc_noio:1;
> 
> Well, that is a good reason to introduce a wrapper around power.irq_safe in my
> view.
> 
> And define the wrapper so that it always returns false for CONFIG_PM_RUNTIME
> unset.
> 
> This way not only you wouldn't need to move the flag from under the #ifdef,
> but also you would make the compiler skip the relevant pieces of code
> entiretly for CONFIG_PM_RUNTIME unset.

Few days ago I would be happy with your opinion :), but know I think
this is better solution than wrapper. Consider case:
1. PM_RUNTIME unset.
2. System suspends.
3. The pl330 in its suspend callback calls force_runtime_suspend which
leads us to amba/bus.
4. The amba/bus.c in runtime suspend checks for irq_safe (it is FALSE),
so it disables and unprepares the clock.
5. The pl330 in probe requested irq_safe so it assumes amba/bus will
only disable the clock. So the pl330 unprepares the clock. Again.

Best regards,
Krzysztof


