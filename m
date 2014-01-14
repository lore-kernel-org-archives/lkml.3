Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaANC2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 21:28:41 -0500
Received: from numascale.com ([213.162.240.84]:59248 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbaANC2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 21:28:38 -0500
Message-ID: <52D4A0C7.5070601@numascale.com>
Date: Tue, 14 Jan 2014 10:28:23 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Waiman Long <waiman.long@hp.com>, Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
References: <52D353C8.4000000@numascale.com> <52D4172E.6030706@hp.com>
In-Reply-To: <52D4172E.6030706@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/2014 00:41, Waiman Long wrote:
> On 01/12/2014 09:47 PM, Daniel J Blueman wrote:
>> On Thursday, 9 January 2014 01:10:03 UTC+8, Waiman Long  wrote:
>> > This patch modifies the queue_write_unlock() function to use the
>> > new smp_store_release() function in another pending patch. It also
>> > removes the temporary implementation of smp_load_acquire() and
>> > smp_store_release() function in qrwlock.c.
>> >
>> > This patch should only be merged if PeterZ's linux-arch patch patch
>> > was merged.
>> >
>> > Signed-off-by: Waiman Long <Waiman.Long@hp.com>
>> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> > ---
>> >  include/asm-generic/qrwlock.h |    4 +---
>> >  kernel/locking/qrwlock.c      |   34
>> ----------------------------------
>> >  2 files changed, 1 insertions(+), 37 deletions(-)
>> >
>> > diff --git a/include/asm-generic/qrwlock.h
>> b/include/asm-generic/qrwlock.h
>> > index 2b9a7b4..4d4bd04 100644
>> > --- a/include/asm-generic/qrwlock.h
>> > +++ b/include/asm-generic/qrwlock.h
>> > @@ -179,9 +179,7 @@ static inline void queue_write_unlock(struct
>> qrwlock *lock)
>> >      /*
>> >       * Make sure that none of the critical section will be leaked out.
>> >       */
>> > -    smp_mb__before_clear_bit();
>> > -    ACCESS_ONCE(lock->cnts.writer) = 0;
>> > -    smp_mb__after_clear_bit();
>> > +    smp_store_release(&lock->cnts.writer, 0)
>>
>> This will fail compilation, so probably needs further testing with
>> Peter's load_acquire/store_release barrier patches.
>>
>
> Peter,
>
> I found out that the build failure was caused by the fact that the
> __native_word() macro (used internally by compiletime_assert_atomic())
> allows only a size of 4 or 8 for x86-64. The data type that I used is a
> byte. Is there a reason why byte and short are not considered native?

It seems likely it was implemented like that since there was no existing 
need; long can be relied on as the largest native type, so this should 
suffice and works here:

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index fe7a686..dac91d7 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -299,8 +299,8 @@ void ftrace_likely_update(struct ftrace_branch_data 
*f, int val, int expect);
  #endif

  /* Is this type a native word size -- useful for atomic operations */
-#ifndef __native_word
-# define __native_word(t) (sizeof(t) == sizeof(int) || sizeof(t) == 
sizeof(long))
+#ifndef __native_type
+# define __native_type(t) (sizeof(t) <= sizeof(long))
  #endif

  /* Compile time object size, -1 for unknown */
@@ -343,8 +343,8 @@ void ftrace_likely_update(struct ftrace_branch_data 
*f, int val, int expect);
  	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)

  #define compiletime_assert_atomic_type(t)				\
-	compiletime_assert(__native_word(t),				\
-		"Need native word sized stores/loads for atomicity.")
+	compiletime_assert(__native_type(t),				\
+		"Need native sized stores/loads for atomicity.")

  /*
   * Prevent the compiler from merging or refetching accesses.  The compiler

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
