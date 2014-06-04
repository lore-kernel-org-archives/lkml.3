Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaFDPcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:32:01 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49159 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaFDPcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:32:00 -0400
Date: Wed, 4 Jun 2014 08:31:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
Message-ID: <20140604153159.GA27096@infradead.org>
References: <20140509120733.GA27918@kernel.org>
 <20140509150018.GA26215@infradead.org>
 <20140510040023.GA13788@kernel.org>
 <5388912F.7010609@kernel.dk>
 <20140604111133.GA7826@infradead.org>
 <538F2A11.4060800@kernel.dk>
 <20140604142012.GA20056@infradead.org>
 <538F331F.60101@kernel.dk>
 <20140604145803.GA7826@infradead.org>
 <538F34FB.7050003@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538F34FB.7050003@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 09:02:19AM -0600, Jens Axboe wrote:
> >scsi_mq_find_tag only gets the scsi host, which may have multiple
> >queues.  When called from scsi_find_tag we actually have a scsi device,
> >so that's not an issue, but when called from scsi_host_find_tag the
> >driver only provides the host.
> 
> Only solution I see right now is to have the flush_rq in the shared
> tags, but that would potentially be a regression for multiple
> devices and heavy flush uses cases. I'll see if I can come up with
> something better, or maybe Shaohua has an idea.

What about something like the following (untest, uncompiled, maybe
pseudo-code):

struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
{
	struct request *rq = tags->rqs[tag];

	if ((rq->cmd_flags & REQ_FLUSH_SEQ) && rq->q->flush_rq->tag == tag)
		return rq->q->flush_rq;
	return rq;
}

