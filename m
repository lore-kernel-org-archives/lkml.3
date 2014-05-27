Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaE0IoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:44:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaE0IoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:44:11 -0400
Date: Tue, 27 May 2014 10:44:00 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, jet.chen@intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [jet.chen@intel.com: [bio] kernel BUG at
 drivers/block/virtio_blk.c:166!]
Message-ID: <20140527084359.GD2205@dhcp-27-189.brq.redhat.com>
References: <20140526194347.GB2271@dhcp-27-189.brq.redhat.com>
 <CACVXFVOaF-EOioE38sy9=2f-+rKECJnzUCSHrL-VZJi1Ycj_wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOaF-EOioE38sy9=2f-+rKECJnzUCSHrL-VZJi1Ycj_wA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 12:03:29PM +0800, Ming Lei wrote:
> On Tue, May 27, 2014 at 3:43 AM, Maurizio Lombardi <mlombard@redhat.com> wrote:
> > Hi Jens,
> >
> > looks like that commit 3979ef4dcf3d1de55a560a3a4016c30a835df44d ("bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3")
> > introduces a regression, as reported by Jet Chan.
> >
> > Do you have any idea about the possible problem with this patch?
> >
> > it is the one that performs a recount of the segments in case of failure in __bio_add_page()
> >
> > http://www.spinics.net/lists/mm-commits/msg103684.html
> >
> > I would not be surprised if the bug was introduced by fceb38f36f, because it
> > contained a mystake that commit 3979ef4dcf supposedly fixed.
> > But learning that commit 3979ef4dcf is introducing a regression leaves
> > me quite puzzled.
> 
> From code of __blk_recalc_rq_segments(), looks it
> won't check if recounted physical segment number is
> bigger than queue_max_segments(), so wondering if
> blk_recount_segments() can always decrease
> physical segment number.
>

This is what __bio_add_page() did before both fceb38f36f and 3979ef4dcf at line 757


        while (bio->bi_phys_segments >= queue_max_segments(q)) {

                if (retried_segments)
                        return 0;

                retried_segments = 1;
                blk_recount_segments(q, bio);
        }

so it is possible, in case of error, to return from the function even if the recounted
physical segments are bigger than queue_max_segments(q).

---------

But now I'm suspicious of this part of commit 3979ef4dcf:

 failed:
        bvec->bv_page = NULL;
        bvec->bv_len = 0;
        bvec->bv_offset = 0;
        bio->bi_vcnt--;  <----------------
        blk_recount_segments(q, bio);
        return 0;

Is decreasing bi_vcnt sufficient to guarantee that blk_recount_segments()
recalculates the correct number of physical segments?
Looking at the __blk_recalc_rq_segments() it appears it may not be the case.

The question is how can we restore the correct number of physical segments in case
of failure without breaking anything...

Regards,
Maurizio Lombardi

