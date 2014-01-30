Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaA3N03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:26:29 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51839 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbaA3N02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:26:28 -0500
Date: Thu, 30 Jan 2014 05:26:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@fusionio.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] block: rework flush sequencing for blk-mq
Message-ID: <20140130132620.GA6031@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch aims to make the flush sequence for blk-mq work the same
as for the old request path, that is set a special request aside
for the sequenced flushes, which only gets submitted while the parent
request(s) are blocked.  It kinda reverts two earlier patches from me
and Shaohua which tried to hack around the issues we had before.

There's still a few difference from the legacy flush code, the first
one is that we have to submit blk-mq requests from user context and
need a workqueue for it.  For now the code for that is kept in the flush
code, but once blk-mq grows requeueing code as needed e.g. for a proper
SCSI conversion it might get time to life that to common code.  The
second one is that the old code has a way to defer flushes depending on
queue busy status (the flush_queue_delayed flag), but I have no idea
how to create something similar for blk-mq.

Last but not least it might make sense to allocate the special flush
request per hardware context and on the right node, but I'd like to
defer that until someone has actual high performance hardware that
requires flushes, before that the law of premature optimization applies.
