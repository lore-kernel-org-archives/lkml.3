Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaAMQln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:41:43 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:30214 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbaAMQlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:41:40 -0500
Message-ID: <52D4172E.6030706@hp.com>
Date: Mon, 13 Jan 2014 11:41:18 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Daniel J Blueman <daniel@numascale.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
References: <52D353C8.4000000@numascale.com>
In-Reply-To: <52D353C8.4000000@numascale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2014 09:47 PM, Daniel J Blueman wrote:
> On Thursday, 9 January 2014 01:10:03 UTC+8, Waiman Long  wrote:
> > This patch modifies the queue_write_unlock() function to use the
> > new smp_store_release() function in another pending patch. It also
> > removes the temporary implementation of smp_load_acquire() and
> > smp_store_release() function in qrwlock.c.
> >
> > This patch should only be merged if PeterZ's linux-arch patch patch
> > was merged.
> >
> > Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  include/asm-generic/qrwlock.h |    4 +---
> >  kernel/locking/qrwlock.c      |   34 
> ----------------------------------
> >  2 files changed, 1 insertions(+), 37 deletions(-)
> >
> > diff --git a/include/asm-generic/qrwlock.h 
> b/include/asm-generic/qrwlock.h
> > index 2b9a7b4..4d4bd04 100644
> > --- a/include/asm-generic/qrwlock.h
> > +++ b/include/asm-generic/qrwlock.h
> > @@ -179,9 +179,7 @@ static inline void queue_write_unlock(struct 
> qrwlock *lock)
> >      /*
> >       * Make sure that none of the critical section will be leaked out.
> >       */
> > -    smp_mb__before_clear_bit();
> > -    ACCESS_ONCE(lock->cnts.writer) = 0;
> > -    smp_mb__after_clear_bit();
> > +    smp_store_release(&lock->cnts.writer, 0)
>
> This will fail compilation, so probably needs further testing with 
> Peter's load_acquire/store_release barrier patches.
>

Peter,

I found out that the build failure was caused by the fact that the 
__native_word() macro (used internally by compiletime_assert_atomic()) 
allows only a size of 4 or 8 for x86-64. The data type that I used is a 
byte. Is there a reason why byte and short are not considered native?

-Longman
