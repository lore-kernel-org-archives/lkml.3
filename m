Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaHXSs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 14:48:27 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:38528 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaHXSs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 14:48:26 -0400
Date: Sun, 24 Aug 2014 21:48:21 +0300
From: Dan Aloni <dan@kernelim.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        stable@vger.kernel.org
Subject: Re: Revert "aio: fix aio request leak when events are reaped by user
 space"
Message-ID: <20140824184821.GA5449@gmail.com>
References: <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org>
 <20140819163733.GA10132@gmail.com>
 <20140819165404.GD13858@kvack.org>
 <20140819171426.GA11811@gmail.com>
 <20140820004651.GJ13858@kvack.org>
 <20140822160111.GD20391@kvack.org>
 <20140822161502.GA30392@gmail.com>
 <20140822162630.GF20391@kvack.org>
 <20140822185110.GA2333@gmail.com>
 <20140824180531.GC4376@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140824180531.GC4376@kvack.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 02:05:31PM -0400, Benjamin LaHaise wrote:
> On Fri, Aug 22, 2014 at 09:51:10PM +0300, Dan Aloni wrote:
> > Ben, seems that the test program needs some twidling to make the bug
> > appear still by setting MAX_IOS to 256 (and it still passes on a
> > kernel with the original patch reverted). Under this condition the
> > ring buffer size remains 128 (here, 32*4 CPUs), and it is overrun on
> > the second attempt.
> 
> Thanks for checking that.  I've made some further changes to your test 
> program to be able to support both userspace event reaping and using the 
> io_getevents() syscall.  I also added a --max-ios= parameter to allow 
> using different values of MAX_IOS for testing.  A copy of the modified 
> source is available at http://www.kvack.org/~bcrl/20140824-aio_bug.c .  
> With this version of the patch, both means of reaping events now work 
> corectly.  The aio_bug.c code still needs to be added to libaio's set 
> of tests, but that's a separate email.

I like your extension to the test program. I have a suggestion for
the integration inside libaio's harness, since the original issue
depended on the size of the ring buffer, let's have max_ios be picked
from {ring->nr + 1, ring->nr - 1, ring->nr}*{1,2,3,4} for the various
test cases. I guess Jeff who is maintaining it will have some ideas
too.
 
>[snip] 
> If you can have a quick look and acknowledge with your Signed-off-by, I'll 
> add it to the commit and send a pull request.  With these changes and the 
> modified aio_bug.c, the test passes using various random values for 
> max_ios, as well as both with and without --user_getevents validating that
> both regressions involved have now been fixed.

I haven't tested it yet due to lack of more time today (will give it a
try tomorrow), but I've reviewed and didn't find any problem.

Signed-off-by: Dan Aloni <dan@kernelim.com>

> 
> ...
> > BTW, I am not an expert on this code so I am still not sure that
> > 'ctx->completed_events' wouldn't get wrong if for instance - one SMP
> > core does userspace event reaping and another calls io_submit(). Do
> > you think it would work alright in that case?
> 
> This should be SMP safe: both ctx->completed_events and ctx->tail are 
> protected ctx->completion_lock.  Additionally, possible races with 
> grabbing the value of ring->head should also be safe, and I added a 
> comment explaining why.  Does that address your concerns?  Cheers,

Yes, thanks.

-- 
Dan Aloni
