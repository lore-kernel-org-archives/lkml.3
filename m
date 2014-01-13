Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaAMDxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 22:53:15 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59958 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaAMDxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 22:53:12 -0500
Date: Sun, 12 Jan 2014 19:52:40 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jens Axboe <axboe@kernel.dk>
cc: Kent Overstreet <kmo@daterainc.com>, Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: next bio iters break discard?
Message-ID: <alpine.LSU.2.11.1401121909160.1239@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I try to exercise heavy swapping with discard on mmotm 2014-01-09,
I soon hit a NULL pointer dereference in __blk_recalc_rq_segments():

__blk_recalc_rq_segments
blk_recount_segments
ll_back_merge_fn
bio_attempt_back_merge
blk_queue_bio
generic_make_request
submit_bio
blkdev_issue_discard
swap_do_scheduled_discard
scan_swap_map_try_ssd_cluster
scan_swap_map
get_swap_page
add_to_swap
shrink_page_list
etc. etc.

The crash is on the NULL struct page pointer in page_to_pfn(bv.bv_page)
on line 35 of block/blk-merge.c.

The code around there is not very different from 3.13-rc8 (which doesn't
crash), and I didn't notice REQ_DISCARD or bio_has_data() checks removed.

I think it worked before because the old bio_for_each_segment()
iterator was a straightforward "i < bio->bi_vcnt" loop which would
do nothing when bi_vcnt is 0; but the new iterators are relying
(perhaps) on bio->bi_iter.bi_size which is non-0 despite no data?

I expect it would crash in the same way on other recent nexts and
mmotms, I've not tried.

Hugh
