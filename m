Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab3ISJc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:32:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab3ISJcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:32:55 -0400
Date: Thu, 19 Sep 2013 10:32:50 +0100
From: Mel Gorman <mgorman@suse.de>
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Did immutable bvecs accidentally break stable page writes?
Message-ID: <20130919093250.GS22421@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
force parameter and hence snapshotting. This is particularly problematic
for ext3 which forces the use of MS_SNAP_STABLE.

I have not actually reproduced any problem, this is just code inspection
but it looks like commit 6bc454d1 broke ext3. Kent, why was the force
paramter ignored in that commit?

-- 
Mel Gorman
SUSE Labs
