Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaJCIfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:35:25 -0400
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:47806 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbaJCIfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:35:21 -0400
Date: Fri, 3 Oct 2014 03:35:18 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Leon Romanovsky <leon@leon.nu>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Linux-MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch resend] mm: page_alloc: fix zone allocation fairness on
 UP
In-Reply-To: <CALq1K=KYYXgtK5mRvBO_+Kdxt8nHmq-cquo1Qqj=UdB+TDrueA@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1410030333080.7898@gentwo.org>
References: <20140909131540.GA10568@cmpxchg.org> <CALq1K=LFd_MWYUMGhZxu4yb-u5WcDqb=DvY4N3P+wV0WO3Zq_g@mail.gmail.com> <20140911123632.GA8296@cmpxchg.org> <CALq1K=KYYXgtK5mRvBO_+Kdxt8nHmq-cquo1Qqj=UdB+TDrueA@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Leon Romanovsky wrote:

> >> I think the better way will be to apply Mel's patch
> >> https://lkml.org/lkml/2014/9/8/214 which fix zone_page_state shadow casting
> >> issue and convert all atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH])) to
> >> zone_page__state(zone, NR_ALLOC_BATCH). This move will unify access to
> >> vm_stat.
> >
> > It's not as simple.  The counter can go way negative and we need that
> > negative number, not 0, to calculate the reset delta.  As I said in
> > response to Mel's patch, we could make the vmstat API signed but I'm
> > not convinced that is reasonable, given the 99% majority of usecases.
> You are right, I missed that NR_ALLOC_BATCH is in use as a part of calculations
> +                       high_wmark_pages(zone) - low_wmark_pages(zone) -
> +                       atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]));

How about creating __zone_page_state for zone_page_state without the 0
check? That would be much nicer and would move the stuff to a central
place. Given the nastiness of this issue there are bound to be more fixes
coming up.

