Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbaFCOOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:14:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35552 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaFCOOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:14:49 -0400
Date: Tue, 3 Jun 2014 07:14:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Daniel Phillips <daniel@phunq.net>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
Message-ID: <20140603141444.GA21273@infradead.org>
References: <538B9DEE.20800@phunq.net>
 <20140602031526.GS14410@dastard>
 <538CD855.90804@phunq.net>
 <20140603033322.GA14410@dastard>
 <538D72B7.3010700@phunq.net>
 <20140603075209.GD14410@dastard>
 <20140603140531.GB30706@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603140531.GB30706@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 04:05:31PM +0200, Jan Kara wrote:
> So we currently flush inodes in first dirtied first written back order when
> superblock is not specified in writeback work. That completely ignores the
> fact to which superblock inode belongs but I don't see per-sb fairness to
> actually make any sense when
> 1) flushing old data (to keep promise set in dirty_expire_centisecs)
> 2) flushing data to reduce number of dirty pages
> And these are really the only two cases where we don't do per-sb flushing.
> 
> Now when filesystems want to do something more clever (and I can see
> reasons for that e.g. when journalling metadata, even more so when
> journalling data) I agree we need to somehow implement the above two types
> of writeback using per-sb flushing. Type 1) is actually pretty easy - just
> tell each sb to writeback dirty data upto time T. Type 2) is more difficult
> because that is more openended task - it seems similar to what shrinkers do
> but that would require us to track per sb amount of dirty pages / inodes
> and I'm not sure we want to add even more page counting statistics...
> Especially since often bdi == fs. Thoughts?

Honestly I think doing per-bdi writeback has been a major mistake.  As
you said it only even matters when we have filesystems on multiple
partitions on a single device, and even then only in a simple setup,
as soon as we use LVM or btrfs this sort of sharing stops to happen
anyway.  I don't even see much of a benefit except that we prevent
two flushing daemons to congest a single device for that special case
of multiple filesystems on partitions of the same device, and that could
be solved in other ways.

The major benefit of the per-bdi writeback was that for the usual case
of one filesystem per device we get exactly one flusher thread per
filesystems intead of multiple competing ones, but per-sb writeback
would solve that just as fine.

