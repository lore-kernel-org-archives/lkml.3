Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbaIQQsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:48:54 -0400
Received: from verein.lst.de ([213.95.11.211]:39910 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbaIQQsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:48:53 -0400
Date: Wed, 17 Sep 2014 18:48:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canoical.com>
Subject: Re: [PATCH 2/2] blk-mq: remove unnecessary blk_clear_rq_complete()
Message-ID: <20140917164850.GB18472@lst.de>
References: <1410947278-15733-1-git-send-email-ming.lei@canonical.com> <1410947278-15733-3-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410947278-15733-3-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 05:47:58PM +0800, Ming Lei wrote:
> From: Ming Lei <ming.lei@canoical.com>
> 
> This patch removes two unnecessary blk_clear_rq_complete(),
> the REQ_ATOM_COMPLETE flag is cleared inside blk_mq_start_request(),
> so:
> 
> 	- The blk_clear_rq_complete() in blk_flush_restore_request()
> 	needn't because the request will be freed later, and clearing
> 	it here may open a small race window with timeout.

This one is defintively correct, blk_mq_end_io should take care of this.

> 	- The blk_clear_rq_complete() in blk_mq_requeue_request() isn't
> 	necessary too, even though REQ_ATOM_STARTED is cleared in
> 	__blk_mq_requeue_request(), in theory it still may cause a small
> 	race window with timeout since the two clear_bit() may be
> 	reordered.

Why yo you think it's not nessecary?  The request is not in the drivers
hand at this point, so it should not be marked started.  Maybe I'm missing
something, but this sounds like it could very likely cause regressions.

