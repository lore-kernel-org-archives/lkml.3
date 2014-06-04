Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaFDQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:25:28 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:53151 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbaFDQZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:25:25 -0400
Message-ID: <538F4872.7050105@kernel.dk>
Date: Wed, 04 Jun 2014 10:25:22 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
References: <20140509120733.GA27918@kernel.org> <20140509150018.GA26215@infradead.org> <20140510040023.GA13788@kernel.org> <5388912F.7010609@kernel.dk> <20140604111133.GA7826@infradead.org> <538F2A11.4060800@kernel.dk> <20140604142012.GA20056@infradead.org> <538F331F.60101@kernel.dk> <20140604145803.GA7826@infradead.org> <538F34FB.7050003@kernel.dk> <20140604153159.GA27096@infradead.org> <538F3DC4.4030104@kernel.dk> <538F3F82.5060805@kernel.dk>
In-Reply-To: <538F3F82.5060805@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 09:47 AM, Jens Axboe wrote:
> On 06/04/2014 09:39 AM, Jens Axboe wrote:
>> On 06/04/2014 09:31 AM, Christoph Hellwig wrote:
>>> On Wed, Jun 04, 2014 at 09:02:19AM -0600, Jens Axboe wrote:
>>>>> scsi_mq_find_tag only gets the scsi host, which may have multiple
>>>>> queues.  When called from scsi_find_tag we actually have a scsi device,
>>>>> so that's not an issue, but when called from scsi_host_find_tag the
>>>>> driver only provides the host.
>>>>
>>>> Only solution I see right now is to have the flush_rq in the shared
>>>> tags, but that would potentially be a regression for multiple
>>>> devices and heavy flush uses cases. I'll see if I can come up with
>>>> something better, or maybe Shaohua has an idea.
>>>
>>> What about something like the following (untest, uncompiled, maybe
>>> pseudo-code):
>>>
>>> struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
>>> {
>>> 	struct request *rq = tags->rqs[tag];
>>>
>>> 	if ((rq->cmd_flags & REQ_FLUSH_SEQ) && rq->q->flush_rq->tag == tag)
>>> 		return rq->q->flush_rq;
>>> 	return rq;
>>
>> Ah yes, that'll work, the queue is always assigned. I'll make that change.
> 
> Something like this in complete form. Compile tested only, I'll test it
> on dev box. Probably doesn't matter too much, but I prefer to
> potentially have the faster path (non-flush) just fall inline.

Works for me, committed.

-- 
Jens Axboe

