Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab3IXTQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 15:16:40 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38139 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3IXTQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 15:16:38 -0400
Date: Tue, 24 Sep 2013 12:16:35 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, neilb@suse.de, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 0/22] Immutable biovecs, block layer changes
Message-ID: <20130924191635.GA2636@kmo-pixel>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <20130808150954.GA30092@infradead.org>
 <20130808211529.GB15409@kmo-pixel>
 <20130924110012.GA7160@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924110012.GA7160@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 04:00:12AM -0700, Christoph Hellwig wrote:
> Just curious, what's the state of the remaining immutable bio work?

Mostly just waiting for Jens to pull it, though I did discover an issue
with the "generic bio chaining" patch last time I was testing it - but
that's towards the end of the series and the rest could be pulled now.

Going to work on the series more today - the reworked segment merging
patches is what lets us shrink struct bio; those patches aren't ready
yet (and they're more invasive than some other cleanup I was planning on
getting in first) but I think they're logically independent from most of
the other patches, I'll see if I can mail out a short series on top of
this one for you to look at.

> 
> On Thu, Aug 08, 2013 at 02:15:29PM -0700, Kent Overstreet wrote:
> > > What is preventing you from sending those out as well?  While it's not
> > > absolutely nessecary it would certainly be good if we'd avoid a struct
> > > bio size regression.
> > 
> > There's still some fairly significant changes, and I don't want to make
> > too many invasive changes at once.
> > 
> > Main thing is making generic_make_request() take arbitrary size bios.
> > After this series that's just two simple patches, but then the changes
> > to make use of that will be changing behaviour in non obvious ways.
> > 
> > The way the merging changes work is it enables multi page bvecs - so a
> > bvec can point to many physically contiguous pages. This moves segment
> > merging to bio_add_page(), and gets rid of bi_phys_segments - now
> > bi_vcnt == bi_phys_segments, we just split the bio if it's too big.
> > 
> > Then, with bio_add_page() building up large bios and the block layer
> > splitting them as necessary, there shouldn't be any need for segment
> > merging across bios anymore (because generally when that would've
> > happened before, now we'd just be sending one larger bio down).
> > 
> > The remaining patches aren't terribly complicated though (less
> > complicated than this patch series). Trickiest bit is multipage bvecs,
> > and that's mostly just lots of code auditing - the way I convert
> > existing code is by adding bio_for_each_page() - analagous to
> > bio_for_each_segment, but giving you bvecs that point to single pages.
> > So it's an easy conversion, just have to make sure nothing's missed.
> ---end quoted text---
