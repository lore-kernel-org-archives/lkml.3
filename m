Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaBKJ3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:29:08 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:49175 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaBKJ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:29:04 -0500
Date: Tue, 11 Feb 2014 01:29:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: error returns from ->queue_rq
Message-ID: <20140211092904.GA6229@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

seems like with the SCSI work I introduced the first
BLK_MQ_RQ_QUEUE_ERROR error return in the tree, and immediately ran into
the first pitfall.  The code as-is expects rq->errors set to an error
value, which otherwise is an  internal field used by the block layer and
some drivers, but not part of the communication protocol between the
two.

We can either make it part of the protocol for blk-mq, which would
require documenting and praying driver writers get it right, or
alternatively we could map BLK_MQ_RQ_QUEUE_ERROR to -EIO and if
nessecary introduce other return values if we need to return other
errors.  The third option would be to remove BLK_MQ_RQ_QUEUE_ERROR
entirely and require drivers to call blk_mq_end_io themselves from
->queue_rq, mirroring the ->queuecommand error handling.  I'm undecided
between options 2 and 3, but I'd rather avoid the current pitfall.
