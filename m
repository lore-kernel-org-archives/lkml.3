Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966686Ab3HHVPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:15:33 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:54778 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966651Ab3HHVPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:15:31 -0400
Date: Thu, 8 Aug 2013 14:15:29 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, neilb@suse.de, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 0/22] Immutable biovecs, block layer changes
Message-ID: <20130808211529.GB15409@kmo-pixel>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <20130808150954.GA30092@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808150954.GA30092@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 08:09:54AM -0700, Christoph Hellwig wrote:
> On Wed, Aug 07, 2013 at 02:54:09PM -0700, Kent Overstreet wrote:
> > _However_, I have more patches (that depend on this patch series) to get
> > that back - segment merging improvements that get rid of
> > bi_seg_front_size, bi_seg_back_size, and bi_phys_segments. Once all that
> > is in it should be a net reduction to the size of struct bio.
> 
> What is preventing you from sending those out as well?  While it's not
> absolutely nessecary it would certainly be good if we'd avoid a struct
> bio size regression.

There's still some fairly significant changes, and I don't want to make
too many invasive changes at once.

Main thing is making generic_make_request() take arbitrary size bios.
After this series that's just two simple patches, but then the changes
to make use of that will be changing behaviour in non obvious ways.

The way the merging changes work is it enables multi page bvecs - so a
bvec can point to many physically contiguous pages. This moves segment
merging to bio_add_page(), and gets rid of bi_phys_segments - now
bi_vcnt == bi_phys_segments, we just split the bio if it's too big.

Then, with bio_add_page() building up large bios and the block layer
splitting them as necessary, there shouldn't be any need for segment
merging across bios anymore (because generally when that would've
happened before, now we'd just be sending one larger bio down).

The remaining patches aren't terribly complicated though (less
complicated than this patch series). Trickiest bit is multipage bvecs,
and that's mostly just lots of code auditing - the way I convert
existing code is by adding bio_for_each_page() - analagous to
bio_for_each_segment, but giving you bvecs that point to single pages.
So it's an easy conversion, just have to make sure nothing's missed.
