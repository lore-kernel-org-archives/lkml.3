Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaFDPnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:43:14 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:50478 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaFDPnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:43:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140604153159.GA27096@infradead.org>
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
	<20140604153159.GA27096@infradead.org>
Date: Wed, 4 Jun 2014 23:43:11 +0800
Message-ID: <CACVXFVNNTPrq29eS9GzJDequtFXCTNWPLJfzB4Z-XJVE5j8+aA@mail.gmail.com>
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 11:31 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jun 04, 2014 at 09:02:19AM -0600, Jens Axboe wrote:
>> >scsi_mq_find_tag only gets the scsi host, which may have multiple
>> >queues.  When called from scsi_find_tag we actually have a scsi device,
>> >so that's not an issue, but when called from scsi_host_find_tag the
>> >driver only provides the host.
>>
>> Only solution I see right now is to have the flush_rq in the shared
>> tags, but that would potentially be a regression for multiple
>> devices and heavy flush uses cases. I'll see if I can come up with
>> something better, or maybe Shaohua has an idea.
>
> What about something like the following (untest, uncompiled, maybe
> pseudo-code):
>
> struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
> {
>         struct request *rq = tags->rqs[tag];
>
>         if ((rq->cmd_flags & REQ_FLUSH_SEQ) && rq->q->flush_rq->tag == tag)
>                 return rq->q->flush_rq;
>         return rq;
> }

Looks we thought it together, :-)

Also maybe the flush_rq->tag need to be cleared in flush_end_io().


Thanks,
-- 
Ming Lei
