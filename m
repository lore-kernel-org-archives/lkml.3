Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173Ab3EXIch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:32:37 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:37695 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759985Ab3EXIce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:32:34 -0400
Message-ID: <519F2597.9030208@redhat.com>
Date: Fri, 24 May 2013 10:32:23 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, tj@kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 part1 1/4] sg_io: pass request_queue to blk_verify_command
References: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>    <1369317503-4095-2-git-send-email-pbonzini@redhat.com>   <1369380965.1945.10.camel@dabdike> <519F1A28.6080303@redhat.com>  <1369381857.1945.15.camel@dabdike> <519F1C7A.2030605@redhat.com> <1369382613.1945.19.camel@dabdike>
In-Reply-To: <1369382613.1945.19.camel@dabdike>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/05/2013 10:03, James Bottomley ha scritto:
>>>>> > >>> Does anyone in the real world actually care about this bug?
>>>> > >>
>>>> > >> Yes, or I would move on and not waste so much time on this.
>>> > > 
>>> > > Fine, so produce a simple fix for this bug which we can discuss that's
>>> > > not tied to this feature.
>> > 
>> > Honestly, I have no idea how this is even possible.
> Really?  It looks to me like a simple block on the commands for disk
> devices in the opcode switch would do it (with a corresponding change to
> sg.c:sg_allow_access).

Which switch?  What I can do is something like this in blk_verify_command:

        if (q->sgio_type == TYPE_ROM)
		return 0;
	if (rq->cmd[0] == 0xA4)
		return -EPERM;
	if (!is_write &&
	    (req->cmd[0] == ... || rq->cmd[0] == ...))
		return -EPERM;

But then the particular patch you're replying to is still necessary,
and you're slowing down blk_verify_command.  It may be fine for stable
and -rc, but IMHO it calls for a better implementation in 3.11.

(Besides, I did it like this because it is what Tejun suggested).

Paolo
