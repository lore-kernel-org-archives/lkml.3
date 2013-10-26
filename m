Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3JZLqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 07:46:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59785 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3JZLqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 07:46:21 -0400
Date: Sat, 26 Oct 2013 04:46:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org
Subject: blk-mq flush fix
Message-ID: <20131026114612.GA8576@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just ran into an issue where I ran out of blk-mq tags on my virtio
setup on what appears a heavy fsync workload.  When drilling it down it
seemed to be a tag leak.  This reminded me of a commit I had seen in
the scsi-mq tree but never on any mailinglist (and neither in my Inbox
despite the Cc tag) which turned out to be in Jens' blk-mq tree either.

https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?h=scsi-mq&id=620fe5a562440a823e7a25ae99dc19a6fbd53949

>From a quick look over the patch I'm not entirely sure it's correct, but
it's at least going in the right direction.  The reason for the issue
that Alexander and I saw is the following:

The flush state machine takes in a struct request, which then is
submitted multiple times to the underling driver.  The old block code
requeses the same request for each of those, so it does not have an
issue with tapping into the request pool.  The new one on the other hand
allocates a new request for each of the actualy steps of the flush
sequence.

In theory this should make the patch from Alexander the right fix,
except that we do have a corner case where we do not do the above steps:
In case the state machine doesn't need to be run we issue the request
directly.  This either happens if the driver doesn't need any cache
flushes, or we only requested force unit access and the driver supports
that natively.

It seems like we should set simply not require a tag at all for those
sub requests and solve the issue that way.

And Alexander and Nick: how did this patch end up in Nick's tree?  I'm a
bit curious at all as there's been no visibility at all, despite Cc tags
to Jens and me.
