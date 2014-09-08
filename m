Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaIHIMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:12:00 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12418 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbaIHIL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:11:57 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-49-540d64c4eced
Content-transfer-encoding: 8BIT
Message-id: <1410163907.4300.5.camel@AMDC1943>
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
Date: Mon, 08 Sep 2014 10:11:47 +0200
In-reply-to: <5409D585.1040302@metafoo.de>
References: <1409929562-29583-1-git-send-email-k.kozlowski@samsung.com>
 <5409D585.1040302@metafoo.de>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xa7pHU3hDDJYvZrLYOGM9q8Xrf9NZ
	LKZPvcBosXrqX1aLs01v2C2WTJ7PanF51xw2i7VH7rJbvHsZYfGybz+LA5fH4j0vmTyWvDnE
	6vHx6S0Wj74tqxg9Pm+S89j7+TdLAFsUl01Kak5mWWqRvl0CV8aD7SfYC1q5KmY86mNrYHzF
	3sXIySEhYCJx489FZghbTOLCvfVsXYxcHEICSxklGubsAkvwCghK/Jh8j6WLkYODWUBe4sil
	bJAws4C6xKR5i5gh6j8zSizb2cgKUa8n8e7ATSYQW1jAUaJ17UQwm03AWGLz8iVsILaIgIbE
	/zeT2EGamQU+MkncnvoOrIhFQFXi9su5YDangJbExa//GUFsIYF0iaWHdjGBHCEhoCzR2O82
	gVFgFpLzZiGcNwvJeQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihETC1x2MS49ZHWIU
	4GBU4uFNuMoTIsSaWFZcmXuIUYKDWUmElyGMN0SINyWxsiq1KD++qDQntfgQIxMHp1QDo/+l
	2ljxzN87plpHqrLk8R34f+dQddW0XbPnmrUr/xL9G/vvVuHJ6XcrNxZfzJ2zUa960zVDjoNy
	Tlt1znDO8py/9WvEliql822/UpRfy5eUX1szY82r1cGW7IvOcL5e5eH7jTs5Z+FnT+WNHKaB
	O81bNHIncDILntvy5FbPPzGBhqmZBtn3PymxFGckGmoxFxUnAgAfMeilYgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-09-05 at 17:23 +0200, Lars-Peter Clausen wrote:
> On 09/05/2014 05:06 PM, Krzysztof Kozlowski wrote:
> [...]
> > @@ -2168,11 +2199,23 @@ static void pl330_issue_pending(struct dma_chan *chan)
> >   {
> >   	struct dma_pl330_chan *pch = to_pchan(chan);
> >   	unsigned long flags;
> > +	bool power_up;
> >
> >   	spin_lock_irqsave(&pch->lock, flags);
> > +	power_up = list_empty(&pch->work_list);
> >   	list_splice_tail_init(&pch->submitted_list, &pch->work_list);
> >   	spin_unlock_irqrestore(&pch->lock, flags);
> >
> > +	if (power_up) {
> > +		/*
> > +		 * Warn on nothing pending. This may break our pm_runtime
> > +		 * usage counter as it is updated on work_list emptiness
> > +		 * status.
> > +		 */
> > +		WARN_ON(list_empty(&pch->work_list));
> > +		pm_runtime_get_sync(pch->dmac->ddma.dev);
> 
> Unfortunately this does not work. pm_runtime_get_sync() may sleep, where as 
> the issue_pending callback needs to be able to run from contexts in which 
> sleeping is not possible.

Thank you for pointing this out. It seems I'll have to find another
solution because I really need to runtime suspend this driver...

Best regards,
Krzysztof

> 
> > +	}
> > +
> >   	pl330_tasklet((unsigned long)pch);
> >   }
> >
> [...]

