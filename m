Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaCHSNc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 13:13:32 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:56946 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaCHSNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 13:13:31 -0500
MIME-Version: 1.0
In-Reply-To: <531B74B6.4070004@suse.de>
References: <20140130132620.GA6031@infradead.org> <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com> <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com> <531B74B6.4070004@suse.de>
From: Mike Snitzer <snitzer@gmail.com>
Date: Sat, 8 Mar 2014 13:13:10 -0500
Message-ID: <CAMM=eLfVpc=B7ZzxBDbKW4GZ_E5rOqrcbyppNBSz_brQaH4VNw@mail.gmail.com>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        msnitzer <msnitzer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 8, 2014 at 2:51 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 03/08/2014 06:33 PM, Mike Snitzer wrote:
>>
>> On Sat, Mar 8, 2014 at 10:52 AM, Christoph Hellwig <hch@infradead.org>
>> wrote:
>>>
>>> On Fri, Mar 07, 2014 at 03:45:09PM -0500, Jeff Moyer wrote:
>>>>
>>>> Hi, Christoph,
>>>>
>>>> Did you mean to switch from list_add to list_add_tail?  That seems like
>>>> a change that warrants mention.
>>>
>>>
>>> No, that wasn't intentional and should be fixed.  Btw, there was another
>>> issue with that commit, in that dm-multipath also needs to allocate
>>> ->flush_rq.  I saw a patch from Hannes fixing it in the SuSE tree, and
>>> would really love to see him submit that for mainline as well.
>>
>>
>> Ugh, rq-based DM calls blk_init_allocated_queue.. (ah, looks like best
>> to move q->flush_rq allocation from blk_init_queue_node to
>> blk_alloc_queue_node?).

The above suggestion would work.  But we'd lose the side-effect
benefit to bio-based DM not needing q->flush_rq allocated at all.

But I'm not immediately seeing a clean way to get that benefit (of not
allocating for bio-based request_queue) while always allocating it for
request-based queues.

Actually, how about moving the flush_rq allocation to
blk_init_allocated_queue(), it'd accomplish both.. what do others
think of that?

>>> Unfortunately SuSE seems to have lots of block and dm fixes and even
>>> features that they don't submit upstream.
>>
>>
>> Yeah, it is certainly disturbing.  No excuse for sitting on fixes like
>> this.
>>
>> Hannes, _please_ get this dm-mpath flush_rq fix for 3.14 posted ASAP.
>> Jens or I will need to get it to Linus next week.
>>
> Hey, calm down.

I'm calm.. was just a bit frustrated.  But this isn't a big deal.
I'll make an effort to reach out to relevant people sooner when
similar stuff is reported against recently upstreamed code.  Would be
cool if you did the same.  I can relate to needing to have the distro
vendor hat on (first needing to determine/answer "is this issue
specific to our hacked distro kernel?", etc).

> I've made the fix just two days ago. And was quite surprised that I've been
> the first hitting that; should've crashed for everybody using dm-multipath.

Yeah, it is surprising that we haven't had any upstream reports.

> And given the pushback I've gotten recently from patches I would have
> thought that it would work for most users; sure the author would've done due
> diligence on the original patchset ...
> Plus I've gotten the reports from S/390, so I put it down to mainframe
> weirdness.
>
> BTW, it not _my_ decision to sit on tons of SUSE specific patches.

I'll take the bait.. this isn't a SUSE specific patch we're talking about. ;)

> I really try to get things upstream. But I cannot do more than sending
> patches upstream, answer patiently any questions, and redo the patchset.
> Which I did. Frequently, But, alas, it's up to the maintainer to apply them.
> And I can only ask and hope. The usual story...

Guess I'm missing context for which patches you're saying people are
sitting on.  (I doubt you're referring to your dm-mpath patchset on
dm-devel.. since it has gone 9ish iterations.  Now that everything is
sorted out I'll be getting it reviewed and staged for 3.15 next week).

> I'll be sending the patch soon, Monday at latest.

OK, looking forward to seeing it.  Would appreciate your feedback on
the questions/suggestions I posed above.

Thanks,
Mike
