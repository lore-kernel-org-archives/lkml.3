Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3EXVl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 17:41:56 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:40267 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab3EXVlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 17:41:55 -0400
Message-ID: <519FDE96.70302@redhat.com>
Date: Fri, 24 May 2013 23:41:42 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org, tj@kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 part1 1/4] sg_io: pass request_queue to blk_verify_command
References: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>    <1369317503-4095-2-git-send-email-pbonzini@redhat.com>   <1369380965.1945.10.camel@dabdike> <519F1A28.6080303@redhat.com>  <1369381857.1945.15.camel@dabdike> <519F1C7A.2030605@redhat.com> <1369382613.1945.19.camel@dabdike> <519F2597.9030208@redhat.com>
In-Reply-To: <519F2597.9030208@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/05/2013 10:32, Paolo Bonzini ha scritto:
> Il 24/05/2013 10:03, James Bottomley ha scritto:
>>>>>>>>>> Does anyone in the real world actually care about this bug?
>>>>>>>>
>>>>>>>> Yes, or I would move on and not waste so much time on this.
>>>>>>
>>>>>> Fine, so produce a simple fix for this bug which we can discuss that's
>>>>>> not tied to this feature.
>>>>
>>>> Honestly, I have no idea how this is even possible.
>> Really?  It looks to me like a simple block on the commands for disk
>> devices in the opcode switch would do it (with a corresponding change to
>> sg.c:sg_allow_access).
> 
> Which switch?  What I can do is something like this in blk_verify_command:
> 
>         if (q->sgio_type == TYPE_ROM)
> 		return 0;
> 	if (rq->cmd[0] == 0xA4)
> 		return -EPERM;
> 	if (!is_write &&
> 	    (req->cmd[0] == ... || rq->cmd[0] == ...))
> 		return -EPERM;
> 
> But then the particular patch you're replying to is still necessary,
> and you're slowing down blk_verify_command.  It may be fine for stable
> and -rc, but IMHO it calls for a better implementation in 3.11.

Ok, so I did a patch along these lines.  And it's just as ugly as
everything else that I've been posting in these threads.  Yes, perhaps
it has a redeeming grace in that it is fine for <= 3.10, but that's it.

Because actually I agree with you.  The rework of the SG_IO command
filter _is_ dubious to say the least; 300 lines of default, immutable
policy don't belong in the kernel.

So why am I posting this crap?  Because I have to work around the nack
of the generic sysfs bitmap patches, which would have beatifully solved
all of this.

In fact, you had proposed that approach.  I posted it in September 2012.
 Then (as usual) silence for one month until it was quickly dismissed by
Tejun.

*You and Jens* failed to review patches, and this rathole is what that
led to.  It's unpleasant for me as it is for everyone else.

Yes, you and Jens are busy, we all are.  But *you and Jens* are the
maintainers.  Please make a decision instead of drawing straws, so that
we can all go back to our regular business.

Paolo
