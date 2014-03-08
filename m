Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaCHRdm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 12:33:42 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:41199 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaCHRdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 12:33:41 -0500
MIME-Version: 1.0
In-Reply-To: <20140308155240.GA32297@infradead.org>
References: <20140130132620.GA6031@infradead.org> <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com> <20140308155240.GA32297@infradead.org>
From: Mike Snitzer <snitzer@redhat.com>
Date: Sat, 8 Mar 2014 12:33:20 -0500
X-Google-Sender-Auth: YBpmdNYqHKp6kbJfjxH8HVfciW0
Message-ID: <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        msnitzer <msnitzer@redhat.com>, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 8, 2014 at 10:52 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Mar 07, 2014 at 03:45:09PM -0500, Jeff Moyer wrote:
>> Hi, Christoph,
>>
>> Did you mean to switch from list_add to list_add_tail?  That seems like
>> a change that warrants mention.
>
> No, that wasn't intentional and should be fixed.  Btw, there was another
> issue with that commit, in that dm-multipath also needs to allocate
> ->flush_rq.  I saw a patch from Hannes fixing it in the SuSE tree, and
> would really love to see him submit that for mainline as well.

Ugh, rq-based DM calls blk_init_allocated_queue.. (ah, looks like best
to move q->flush_rq allocation from blk_init_queue_node to
blk_alloc_queue_node?).  Anyway, this all makes sense given the
crashes we've been dealing with.. we couldn't immediately understand
how the q->flush_rq would be NULL... grr.  I guess I should've checked
with you sooner.  I reverted commit 1874198 "blk-mq: rework flush
sequencing logic" from RHEL7 just yesterday because we were seeing
crashes on flush with dm-mpath.  But can easily re-apply for RHEL7.1
(since the request_queue's embedded flush_rq takes up so much space we
get ample kABI padding).

Not overly proud of the revert, but I deemed easier to revert than
hunt down the fix given RHEL7 won't actually be providing any blk-mq
enabled drivers.  That'll change for RHEL7.1.

> Unfortunately SuSE seems to have lots of block and dm fixes and even
> features that they don't submit upstream.

Yeah, it is certainly disturbing.  No excuse for sitting on fixes like this.

Hannes, _please_ get this dm-mpath flush_rq fix for 3.14 posted ASAP.
Jens or I will need to get it to Linus next week.

Thanks,
Mike
