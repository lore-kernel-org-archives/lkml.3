Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaFCPWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:22:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43609 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbaFCPWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:22:01 -0400
Date: Tue, 3 Jun 2014 17:21:55 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Daniel Phillips <daniel@phunq.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
Message-ID: <20140603152155.GD30706@quack.suse.cz>
References: <538B9DEE.20800@phunq.net>
 <20140602031526.GS14410@dastard>
 <538CD855.90804@phunq.net>
 <20140603033322.GA14410@dastard>
 <538D72B7.3010700@phunq.net>
 <20140603075209.GD14410@dastard>
 <20140603140531.GB30706@quack.suse.cz>
 <20140603141444.GA21273@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603141444.GA21273@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 03-06-14 07:14:44, Christoph Hellwig wrote:
> On Tue, Jun 03, 2014 at 04:05:31PM +0200, Jan Kara wrote:
> > So we currently flush inodes in first dirtied first written back order when
> > superblock is not specified in writeback work. That completely ignores the
> > fact to which superblock inode belongs but I don't see per-sb fairness to
> > actually make any sense when
> > 1) flushing old data (to keep promise set in dirty_expire_centisecs)
> > 2) flushing data to reduce number of dirty pages
> > And these are really the only two cases where we don't do per-sb flushing.
> > 
> > Now when filesystems want to do something more clever (and I can see
> > reasons for that e.g. when journalling metadata, even more so when
> > journalling data) I agree we need to somehow implement the above two types
> > of writeback using per-sb flushing. Type 1) is actually pretty easy - just
> > tell each sb to writeback dirty data upto time T. Type 2) is more difficult
> > because that is more openended task - it seems similar to what shrinkers do
> > but that would require us to track per sb amount of dirty pages / inodes
> > and I'm not sure we want to add even more page counting statistics...
> > Especially since often bdi == fs. Thoughts?
> 
> Honestly I think doing per-bdi writeback has been a major mistake.  As
> you said it only even matters when we have filesystems on multiple
> partitions on a single device, and even then only in a simple setup,
> as soon as we use LVM or btrfs this sort of sharing stops to happen
> anyway.  I don't even see much of a benefit except that we prevent
> two flushing daemons to congest a single device for that special case
> of multiple filesystems on partitions of the same device, and that could
> be solved in other ways.
  So I agree per-bdi / per-sb matters only in simple setups but machines
with single rotating disk with several partitions and without LVM aren't
that rare AFAICT from my experience. And I agree we went for per-bdi
flushing to avoid two threads congesting a single device leading to
suboptimal IO patterns during background writeback.

So currently I'm convinced we want to go for per-sb dirty tracking. That
also makes some speedups in that code noticeably simpler. I'm not convinced
about the per-sb flushing thread - if we don't regress the multiple sb on
bdi case when we just let the threads from different superblocks contend
for IO, then that would be a natural thing to do. But once we have to
introduce some synchronization between threads to avoid regressions, I
think it might be easier to just stay with per-bdi thread which switches
between superblocks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
