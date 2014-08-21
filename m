Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaHURou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:44:50 -0400
Received: from smtprelay0104.hostedemail.com ([216.40.44.104]:57680 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752065AbaHURos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:44:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:4321:4605:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13149:13161:13229:13230:13311:13357:13894:14040:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL
X-HE-Tag: oil96_c7f7388f1631
X-Filterd-Recvd-Size: 2772
Message-ID: <1408643084.23250.84.camel@joe-AO725>
Subject: Re: [PATCH] ioat: Use time_before()
From: Joe Perches <joe@perches.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>
Cc: Manuel =?ISO-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Date: Thu, 21 Aug 2014 10:44:44 -0700
In-Reply-To: <CAPcyv4gnMVHd6R=WuN84TLxrAgsBAq8u9_PcmpgD8QECZMZAQw@mail.gmail.com>
References: <1400789466-11156-1-git-send-email-manuel.schoelling@gmx.de>
	 <CAPcyv4gnMVHd6R=WuN84TLxrAgsBAq8u9_PcmpgD8QECZMZAQw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 10:10 -0700, Dan Williams wrote:
> On Thu, May 22, 2014 at 1:11 PM, Manuel Schölling
> <manuel.schoelling@gmx.de> wrote:
> > To be future-proof and for better readability the time comparisons are modified
> > to use time_before() instead of plain, error-prone math.
[]
> > diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
[]
> > @@ -735,7 +735,8 @@ int ioat2_check_space_lock(struct ioat2_dma_chan *ioat, int num_descs)
> >          * called under bh_disabled so we need to trigger the timer
> >          * event directly
> >          */
> > -       if (jiffies > chan->timer.expires && timer_pending(&chan->timer)) {
> > +       if (time_before(chan->timer.expires, jiffies)
> > +           && timer_pending(&chan->timer)) {
> >                 struct ioatdma_device *device = chan->device;
> 
> Thanks, let's use time_is_before_jiffies() for this cleanup... I'll
> fix up and apply.

There are thousands of uses of time_before( and time_after(
with jiffies, and 6 years after being added, a little more
than a dozen or so of time_is_[before|after]_jiffies.

I also think the "time_is_[before|after]_jiffies" macros are
not very well named.

Using them is more text than using jiffies directly.
There is a small benefit in argument ordering correctness.

	time_after(jiffies, foo)
	time_is_after_jiffies(foo)

I'd rather just drop jiffies altogether
	time_is_after(foo)
or maybe add and use
	jiffies_is_after(foo)

(all the other after_eq/before/before_eq variants too).

