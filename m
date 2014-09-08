Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaIHMji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:39:38 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43694 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbaIHMjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:39:36 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f156d0000063c7-52-540da383676e
Content-transfer-encoding: 8BIT
Message-id: <1410179970.4300.16.camel@AMDC1943>
Subject: Re: [RFC PATCH] dma: pl330: add Power Management support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 08 Sep 2014 14:39:30 +0200
In-reply-to: <1410163907.4300.5.camel@AMDC1943>
References: <1409929562-29583-1-git-send-email-k.kozlowski@samsung.com>
 <5409D585.1040302@metafoo.de> <1410163907.4300.5.camel@AMDC1943>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xy7rNi3lDDM4eN7fYOGM9q8Xrf9NZ
	LKZPvcBosXrqX1aLs01v2C2WTJ7PanF51xw2i7VH7rJbvHsZYfGybz+LA5fH4j0vmTyWvDnE
	6vHx6S0Wj74tqxg9Pm+S89j7+TdLAFsUl01Kak5mWWqRvl0CV8b7+VfZCmbyV+w4tpe9gfEt
	dxcjB4eEgInE8abiLkZOIFNM4sK99WxdjFwcQgJLGSVmvV3CDpLgFRCU+DH5HgtIPbOAvMSR
	S9kgYWYBdYlJ8xYxQ9R/ZpT49vAVI0S9vsTxLWvZQGxhAUeJ1rUTmUBsNgFjic3Ll4DFRQQ0
	JP6/mcQO0sws8JFJ4vbUd2BFLAKqEg19m1lBlnECDZrx1Q9iQRejxMbfb1kgjlaWaOx3m8Ao
	MAvJebMQzpuF5LwFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MULi4MsOxsXHrA4xCnAw
	KvHwJlzlCRFiTSwrrsw9xCjBwawkwss0mTdEiDclsbIqtSg/vqg0J7X4ECMTB6dUAyNXkeU5
	q9fV22PehzxaMPvx+k2Z20wDhbhecfJrZh5T1VxvsO5meifnj8rk8G83r88qtf+Y/eiaK9t/
	e/uXZ//aBbSGRZVKLrZZpehUPJV146+1h7xP90u6RR2NkmA+pfSX33ph4dbp59QnZ2rMuG2T
	Mbmiwjv7XNKMbpMrQcpiUmnuM6a6CimxFGckGmoxFxUnAgDj4KZWYQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-09-08 at 10:11 +0200, Krzysztof Kozlowski wrote:
> On pią, 2014-09-05 at 17:23 +0200, Lars-Peter Clausen wrote:
> > On 09/05/2014 05:06 PM, Krzysztof Kozlowski wrote:
> > [...]
> > > @@ -2168,11 +2199,23 @@ static void pl330_issue_pending(struct dma_chan *chan)
> > >   {
> > >   	struct dma_pl330_chan *pch = to_pchan(chan);
> > >   	unsigned long flags;
> > > +	bool power_up;
> > >
> > >   	spin_lock_irqsave(&pch->lock, flags);
> > > +	power_up = list_empty(&pch->work_list);
> > >   	list_splice_tail_init(&pch->submitted_list, &pch->work_list);
> > >   	spin_unlock_irqrestore(&pch->lock, flags);
> > >
> > > +	if (power_up) {
> > > +		/*
> > > +		 * Warn on nothing pending. This may break our pm_runtime
> > > +		 * usage counter as it is updated on work_list emptiness
> > > +		 * status.
> > > +		 */
> > > +		WARN_ON(list_empty(&pch->work_list));
> > > +		pm_runtime_get_sync(pch->dmac->ddma.dev);
> > 
> > Unfortunately this does not work. pm_runtime_get_sync() may sleep, where as 
> > the issue_pending callback needs to be able to run from contexts in which 
> > sleeping is not possible.
> 
> Thank you for pointing this out. It seems I'll have to find another
> solution because I really need to runtime suspend this driver...

I found that idea was wrong in few more places. The most important is
that the pl330 is an AMBA device. This means that runtime suspend/resume
callbacks are already implemented (drivers/amba/bus.c) and they are
called instead of my callbacks.

That would be fine... except that these callbacks in amba/bus.c call
clk_preare()/clk_unprepare() which is not safe for atomic context. This
prohibits me from using pm_runtime_irq_safe() which could solve problem
pointed by you. 

Best regards,
Krzysztof


> 
> Best regards,
> Krzysztof
> 
> > 
> > > +	}
> > > +
> > >   	pl330_tasklet((unsigned long)pch);
> > >   }
> > >
> > [...]

