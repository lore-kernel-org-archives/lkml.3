Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab3H1M64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:58:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab3H1M6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:58:53 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: axboe@kernel.dk, JBottomley@parallels.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>
Subject: Re: [patch|rfc] block: fix race between request completion and timeout handling
References: <x49ppszqkbg.fsf@segfault.boston.devel.redhat.com>
	<521DA0F0.7060501@suse.de> <521DA913.1010505@suse.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 28 Aug 2013 08:58:41 -0400
In-Reply-To: <521DA913.1010505@suse.de> (Hannes Reinecke's message of "Wed, 28
	Aug 2013 09:38:59 +0200")
Message-ID: <x49sixuynsu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Reinecke <hare@suse.de> writes:

>> So, looked into things a bit more.
>> It looks as if you're on the right track, although I doubt your
>> patch will fix the issue for me :-(
>> 
>> Thing is, you're right there is a race window between requeuing
>> and softirq triggering, which could well be fixed by your patch.
>> So for that reason alone I would like to take it.
>> 
>> However, including your patch will end up opening another can of
>> worms: the softirq might now be triggering _while the request is
>> queued on the request queue_.
>> blk_requeue_request will be putting the request back on the request
>> queue, where it'll be stuck until being pulled off from
>> scsi_request_fn().
>> So if the softirq triggers during that condition we'll end up
>> calling the BUG_ON((!list_empty(&req->queuelist)) in
>> __blk_put_request().
>> 
>> Guess we'd need to fix that one, too ...
>> 
> Ah. Now I see it.
>
> We're requeuing from the softirq context, ie after the completion
> has triggered. So the above scenario can't actually happen and the
> patch is valid.

Do you still think it won't solve the issue you're seeing?  What issue
is that, btw?

>
> So:
>
> Acked-by: Hannes Reinecke <hare@suse.de>

Thanks, I guess I'll have to send a properly signed-off patch, now.  ;-)

Cheers,
Jeff
