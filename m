Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3ISKOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:14:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab3ISKOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:14:24 -0400
Date: Thu, 19 Sep 2013 11:14:18 +0100
From: Mel Gorman <mgorman@suse.de>
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Hannes Reinecke <hare@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Did immutable bvecs accidentally break stable page writes? take 2
Message-ID: <20130919101418.GU22421@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for the resend but Kent's email address changed. Hopefully this
one from last July is still valid.



Commit ffecfd1a (block: optionally snapshot page contents to provide
stable pages during write) uses bounce buffers for stable page writes in
jbd and ext3. Simplistically, __blk_queue_bounce takes a force parameter
that is used when pages must be snapshot.

Commit 6bc454d1 (bounce: Refactor __blk_queue_bounce to not use
bi_io_vec) refactored __blk_queue_bounce and now the start of the
function looks like this

static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
			       mempool_t *pool, int force)
{
	struct bio *bio;
	int rw = bio_data_dir(*bio_orig);
	struct bio_vec *to, *from;
	unsigned i;

	bio_for_each_segment(from, *bio_orig, i)
		if (page_to_pfn(from->bv_page) > queue_bounce_pfn(q))
			goto bounce;

	return;
bounce:
	bio = bio_clone_bioset(*bio_orig, GFP_NOIO, fs_bio_set);

	bio_for_each_segment_all(to, bio, i) {
		struct page *page = to->bv_page;

		if (page_to_pfn(page) <= queue_bounce_pfn(q) && !force)
			continue;

Note that the first bio_for_each_segment is completely ignoring the
force parameter and not snapshotting when requested. This would have been
problematic for ext3 until commit 71368511 ("mm: make snapshotting pages for
stable writes a per-bio operation) but the ignoring of the force parameter
is still suspicious.

Kent, why is it ok to ignore the force parameter even if the original bio
indicated that snapshotting was required in blk_queue_bounce?

-- 
Mel Gorman
SUSE Labs
