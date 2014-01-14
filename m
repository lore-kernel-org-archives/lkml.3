Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaANCdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 21:33:51 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:32797 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaANCdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 21:33:49 -0500
Date: Mon, 13 Jan 2014 18:33:46 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: next bio iters break discard?
Message-ID: <20140114023346.GN9037@kmo>
References: <alpine.LSU.2.11.1401121909160.1239@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1401121909160.1239@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 07:52:40PM -0800, Hugh Dickins wrote:
> When I try to exercise heavy swapping with discard on mmotm 2014-01-09,
> I soon hit a NULL pointer dereference in __blk_recalc_rq_segments():
> 
> __blk_recalc_rq_segments
> blk_recount_segments
> ll_back_merge_fn
> bio_attempt_back_merge
> blk_queue_bio
> generic_make_request
> submit_bio
> blkdev_issue_discard
> swap_do_scheduled_discard
> scan_swap_map_try_ssd_cluster
> scan_swap_map
> get_swap_page
> add_to_swap
> shrink_page_list
> etc. etc.
> 
> The crash is on the NULL struct page pointer in page_to_pfn(bv.bv_page)
> on line 35 of block/blk-merge.c.
> 
> The code around there is not very different from 3.13-rc8 (which doesn't
> crash), and I didn't notice REQ_DISCARD or bio_has_data() checks removed.
> 
> I think it worked before because the old bio_for_each_segment()
> iterator was a straightforward "i < bio->bi_vcnt" loop which would
> do nothing when bi_vcnt is 0; but the new iterators are relying
> (perhaps) on bio->bi_iter.bi_size which is non-0 despite no data?
> 
> I expect it would crash in the same way on other recent nexts and
> mmotms, I've not tried.
> 
> Hugh

Ugh, discards. Wonder why this wasn't seen sooner, I can't figure out what the
null pointer deref actually was but if it was __blk_recalc_rq_segments() blowing
up, that shouldn't have had to wait for two discards to get merged to get
called.

(calling bio_for_each_segment() on REQ_DISCARD/REQ_WRITE_SAME bios should in
general work; bio_advance_iter() checks against BIO_NO_ADVANCE_ITER_MASK to
determine whether to advance down the bvec or just decrement bi_size. But for
counting segments bio_for_each_segment() is definitely not what we want.)

I think for discards we can deal with this easily enough -
__blk_recalc_rq_segments() will have to special case them - but there's a
similar (but worse) issue with WRITE_SAME, and looking at the code it does
attempt to merge WRITE_SAME requests too.

Jens, Martin - are we sure we want to merge WRITE_SAME requests? I'm not sure I
even see how that makes sense, at the very least it's a potential minefield.
