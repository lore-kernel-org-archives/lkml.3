Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbaHVSvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 14:51:17 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:58183 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaHVSvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:51:15 -0400
Date: Fri, 22 Aug 2014 21:51:10 +0300
From: Dan Aloni <dan@kernelim.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        stable@vger.kernel.org
Subject: Re: Revert "aio: fix aio request leak when events are reaped by user
 space"
Message-ID: <20140822185110.GA2333@gmail.com>
References: <cover.1403632276.git.bcrl@kvack.org>
 <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org>
 <20140819163733.GA10132@gmail.com>
 <20140819165404.GD13858@kvack.org>
 <20140819171426.GA11811@gmail.com>
 <20140820004651.GJ13858@kvack.org>
 <20140822160111.GD20391@kvack.org>
 <20140822161502.GA30392@gmail.com>
 <20140822162630.GF20391@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822162630.GF20391@kvack.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 12:26:30PM -0400, Benjamin LaHaise wrote:
> On Fri, Aug 22, 2014 at 07:15:02PM +0300, Dan Aloni wrote:
> > Sorry, I was waiting for a new patch from your direction, I should
> > have replied earlier. What bothered me about the patch you sent is that
> > completed_events is added as a new field but nothing assigns to it, so I 
> > wonder how it can be effective.
> 
> Ah, that was missing a hunk then.  Try this version instead.

Ben, seems that the test program needs some twidling to make the bug
appear still by setting MAX_IOS to 256 (and it still passes on a
kernel with the original patch reverted). Under this condition the
ring buffer size remains 128 (here, 32*4 CPUs), and it is overrun on
the second attempt.

    $ ./aio_bug 
    Submitting: 256
    Submitted: 126
    Submitting: 130
    Submitted too much, that's okay
    Completed: 126
    Submitting: 130
    Submitted: 130
    <stuck>

I think I have found two problems with your patch: first, the
completed_events field is never decremented so it goes up until 2^32
wraparound. So I tested with 'ctx->completed_events -= completed;'
there (along with some prints), but testing revealed that this didn't
solve the problem, so secondly, I also fixed the 'avail = ' line. The
case where the 'head > tail' case didn't look correct to me.

So the good news is that it works now with fix below and MAX_IOS=256
and even with MAX_IOS=512. You can git-amend this it to your patch I
guess.

Signed-off: Dan Aloni <dan@kernelim.com>

diff --git a/fs/aio.c b/fs/aio.c
index 6982357d9372..eafc96c60a8c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -893,12 +893,20 @@ static void refill_reqs_available(struct kioctx *ctx)
 		tail = ACCESS_ONCE(ring->tail);
 		kunmap_atomic(ring);
 
-		avail = (head <= tail ?  tail : ctx->nr_events) - head;
+		if (head <= tail)
+			avail = tail - head;
+		else
+			avail = ctx->nr_events - (head - tail);
+
 		completed = ctx->completed_events;
+		pr_debug("%u %u  h%u t%u\n", avail, completed, head, tail);
 		if (avail < completed)
 			completed -= avail;
 		else
 			completed = 0;
+		pr_debug("completed %u\n", completed);
+
+		ctx->completed_events -= completed;
 		put_reqs_available(ctx, completed);
 	}
 

BTW, I am not an expert on this code so I am still not sure that
'ctx->completed_events' wouldn't get wrong if for instance - one SMP
core does userspace event reaping and another calls io_submit(). Do
you think it would work alright in that case?


-- 
Dan Aloni
