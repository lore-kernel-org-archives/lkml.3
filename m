Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaFEC1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 22:27:47 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41292 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaFEC1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 22:27:46 -0400
Date: Thu, 5 Jun 2014 10:27:38 +0800
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
Message-ID: <20140605022738.GA22826@kernel.org>
References: <20140604142012.GA20056@infradead.org>
 <538F331F.60101@kernel.dk>
 <20140604145803.GA7826@infradead.org>
 <538F34FB.7050003@kernel.dk>
 <20140604153159.GA27096@infradead.org>
 <538F3DC4.4030104@kernel.dk>
 <538F3F82.5060805@kernel.dk>
 <538F4872.7050105@kernel.dk>
 <20140605012701.GA13953@kernel.org>
 <538FD06D.7020200@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538FD06D.7020200@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 08:05:33PM -0600, Jens Axboe wrote:
> On 2014-06-04 19:27, Shaohua Li wrote:
> >On Wed, Jun 04, 2014 at 10:25:22AM -0600, Jens Axboe wrote:
> >>On 06/04/2014 09:47 AM, Jens Axboe wrote:
> >>>On 06/04/2014 09:39 AM, Jens Axboe wrote:
> >>>>On 06/04/2014 09:31 AM, Christoph Hellwig wrote:
> >>>>>On Wed, Jun 04, 2014 at 09:02:19AM -0600, Jens Axboe wrote:
> >>>>>>>scsi_mq_find_tag only gets the scsi host, which may have multiple
> >>>>>>>queues.  When called from scsi_find_tag we actually have a scsi device,
> >>>>>>>so that's not an issue, but when called from scsi_host_find_tag the
> >>>>>>>driver only provides the host.
> >>>>>>
> >>>>>>Only solution I see right now is to have the flush_rq in the shared
> >>>>>>tags, but that would potentially be a regression for multiple
> >>>>>>devices and heavy flush uses cases. I'll see if I can come up with
> >>>>>>something better, or maybe Shaohua has an idea.
> >>>>>
> >>>>>What about something like the following (untest, uncompiled, maybe
> >>>>>pseudo-code):
> >>>>>
> >>>>>struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
> >>>>>{
> >>>>>	struct request *rq = tags->rqs[tag];
> >>>>>
> >>>>>	if ((rq->cmd_flags & REQ_FLUSH_SEQ) && rq->q->flush_rq->tag == tag)
> >>>>>		return rq->q->flush_rq;
> >>>>>	return rq;
> >>>>
> >>>>Ah yes, that'll work, the queue is always assigned. I'll make that change.
> >>>
> >>>Something like this in complete form. Compile tested only, I'll test it
> >>>on dev box. Probably doesn't matter too much, but I prefer to
> >>>potentially have the faster path (non-flush) just fall inline.
> >>
> >>Works for me, committed.
> >
> >Sounds there is a small race here. FUA request has REQ_FLUSH_SEQ set too.
> >Assume its tag is 0. we initialize flush_rq.
> >blk_mq_rq_init->blk_rq_init->memset could set flush_rq tag to 0 in a short
> >time. In that short time, blk_mq_tag_to_rq will return wrong request for the
> >FUA request.
> >
> >we can do (rq->cmd_flags & REQ_FLUSH_SEQ) && !(rq->cmd_flags & REQ_FUA) in
> >is_flush_request to avoid this issue.
> 
> We don't memset the entire request anymore from the rq alloc path.

blk_kick_flush() still calls blk_rq_init()?
