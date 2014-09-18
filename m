Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaIRQfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:35:54 -0400
Received: from verein.lst.de ([213.95.11.211]:42057 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298AbaIRQfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:35:53 -0400
Date: Thu, 18 Sep 2014 18:35:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: James Bottomley <JBottomley@parallels.com>, Jens Axboe <axboe@fb.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi-mq: fix hw queue hang caused by timeout
Message-ID: <20140918163549.GB3950@lst.de>
References: <1411055950-28657-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411055950-28657-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 11:59:10PM +0800, Ming Lei wrote:
> If there are two requests or more timed out, the dispatch queue
> is put into stopped state and never be recoverd, and there
> is no such problem in non-mq mode.
> 
> This patch trys to recover the stopped queue when the queue
> becomes unbusy, then the following retries can move on.
> 
> Basically this patch maintains same behavior for this situation
> with non-mq mode.

This looks somewhat similar to the issues that Doug reported, and I remember
when he was last running into boot problems it was timeout related, too.

As far as the implementation is concerned I think the correct fix is
to clear the BLK_MQ_S_STOPPED queue flags in blk_mq_kick_requeue_list.
