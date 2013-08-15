Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab3HON4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:56:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602Ab3HON4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:56:33 -0400
Date: Thu, 15 Aug 2013 14:56:27 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan@kernel.org>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: kswapd skips compaction if reclaim order drops to zero?
Message-ID: <20130815135627.GX2296@suse.de>
References: <CAJd=RBBF2h_tRpbTV6OkxQOfkvKt=ebn_PbE8+r7JxAuaFZxFQ@mail.gmail.com>
 <20130815104727.GT2296@suse.de>
 <20130815134139.GC8437@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130815134139.GC8437@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 10:41:39PM +0900, Minchan Kim wrote:
> Hey Mel,
> 
> On Thu, Aug 15, 2013 at 11:47:27AM +0100, Mel Gorman wrote:
> > On Thu, Aug 15, 2013 at 06:02:53PM +0800, Hillf Danton wrote:
> > > If the allocation order is not high, direct compaction does nothing.
> > > Can we skip compaction here if order drops to zero?
> > > 
> > 
> > If the allocation order is not high then
> > 
> > pgdat_needs_compaction == (order > 0) == false == no calling compact_pdatt
> > 
> > In the case where order is reset to 0 due to fragmentation then it does
> > call compact_pgdat but it does no work due to the cc->order check in
> > __compact_pgdat.
> > 
> 
> I am looking at mmotm-2013-08-07-16-55 but couldn't find cc->order
> check right before compact_zone in __comact_pgdat.
> Could you pinpoint code piece?
> 

Thanks, I screwed up as that check happens too late. However, it still
ends up not mattering because it does this

compact_pgdat
  -> __compact_pgdat
    -> compact_zone
      -> compaction_suitable

For order == 0, compaction_suitable will return either COMPACT_SKIPPED
(if the watermarks are not met) and COMPACT_PARTIAL otherwise. Either
way, compaction doesn't run.

-- 
Mel Gorman
SUSE Labs
