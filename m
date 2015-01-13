Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbbAMIS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:18:58 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:36157 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbbAMIS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:18:57 -0500
Message-ID: <54B4D4E7.2030703@de.ibm.com>
Date: Tue, 13 Jan 2015 09:18:47 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>
CC: Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com,
        Pranith Kumar <bobby.prani@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 01/14] rcu: Protect rcu_boost() lockless
 accesses with ACCESS_ONCE()
References: <20150107173215.GA897@linux.vnet.ibm.com> <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com> <20150108094102.GD29390@twins.programming.kicks-ass.net> <20150108152230.GL5280@linux.vnet.ibm.com> <1420785714.25454.1.camel@stgolabs.net> <20150109134954.GO5280@linux.vnet.ibm.com> <20150109135614.GI29390@twins.programming.kicks-ass.net> <54B04F1A.1060401@de.ibm.com> <20150112085957.GA25256@twins.programming.kicks-ass.net> <20150112221232.GG9719@linux.vnet.ibm.com>
In-Reply-To: <20150112221232.GG9719@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011308-0013-0000-0000-00000292EE27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.01.2015 um 23:12 schrieb Paul E. McKenney:
> On Mon, Jan 12, 2015 at 09:59:57AM +0100, Peter Zijlstra wrote:
>> On Fri, Jan 09, 2015 at 10:58:50PM +0100, Christian Borntraeger wrote:
>>> Am 09.01.2015 um 14:56 schrieb Peter Zijlstra:
>>>> On Fri, Jan 09, 2015 at 05:49:54AM -0800, Paul E. McKenney wrote:
>>>>>> That reminds me, I think the new conversion for stores will most likely
>>>>>> introduce silly arg bugs:
>>>>>>
>>>>>> -       ACCESS_ONCE(a) = b;
>>>>>> +       ASSIGN_ONCE(b, a);
>>>>>
>>>>> I was planning to do mine by hand for this sort of reason.
>>>>>
>>>>> Or are you thinking of something more subtle than the case where
>>>>> "b" is an unparenthesized comma-separated expression?
>>>>
>>>> I think he's revering to the wrong way around-ness of the thing.
>>>>
>>>> Its a bit of a mixed bag on assignments, but for instance
>>>> rcu_assign_pointer() takes them the right way around, as does
>>>> atomic_set().
>>>>
>>>> So yes, I think the ASSIGN_ONCE() thing got the arguments the wrong way
>>>> around.
>>>>
>>>> We could maybe still change it, before its in too long ?
>>>
>>> Linus initial proposal was inspired by put_user model which is (val,
>>> ptr) and I took that. 
>>
>> Yeah, like I said, its a bit of a mixed bag. We've got plenty examples
>> of the wrong way around.
>>
>>> As my focus was on avoiding the volatile bug,
>>> all my current conversions are READ_ONCE as no potential ASSIGN_ONCE
>>> user was done on a non-scalar type, so I have no first hand
>>> experience. 
>>
>> So the implication there is that we'd preserve ACCESS_ONCE() for use on
>> scalar types. I don't think we should do that, I think we should just
>> en-mass convert to {READ,WRITE}/{LOAD,STORE}_ONCE() and kill off
>> ACCESS_ONCE().
> 
> Yep.  For one thing, the proposed replacements work much better with
> C11 than does ACCESS_ONCE().

As we agreed there is no perfect interface regarding val,x vs. x,val.
But it seems that there is some consensus that I should push something like the following (still whitespace damaged) to Linus for 3.19?
Peter, Davidlohr, Paul (maybe Linus) can you ACK/NACK?


Subject: Change ASSIGN_ONCE(val, x) to WRITE_ONCE(x, val)

Feedback has shown that WRITE_ONCE(x, val) is easier to use than ASSIGN_ONCE(val,x).
There are no in-tree users yet, so lets change it.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>


diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 84734a7..38865c7 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -215,7 +215,7 @@ static __always_inline void __read_once_size(volatile void *p, void *res, int si
        }
 }
 
-static __always_inline void __assign_once_size(volatile void *p, void *res, int size)
+static __always_inline void __write_once_size(volatile void *p, void *res, int size)
 {
        switch (size) {
        case 1: *(volatile __u8 *)p = *(__u8 *)res; break;
@@ -235,15 +235,15 @@ static __always_inline void __assign_once_size(volatile void *p, void *res, int
 /*
  * Prevent the compiler from merging or refetching reads or writes. The
  * compiler is also forbidden from reordering successive instances of
- * READ_ONCE, ASSIGN_ONCE and ACCESS_ONCE (see below), but only when the
+ * READ_ONCE, WRITE_ONCE and ACCESS_ONCE (see below), but only when the
  * compiler is aware of some particular ordering.  One way to make the
  * compiler aware of ordering is to put the two invocations of READ_ONCE,
- * ASSIGN_ONCE or ACCESS_ONCE() in different C statements.
+ * WRITE_ONCE or ACCESS_ONCE() in different C statements.
  *
  * In contrast to ACCESS_ONCE these two macros will also work on aggregate
  * data types like structs or unions. If the size of the accessed data
  * type exceeds the word size of the machine (e.g., 32 bits or 64 bits)
- * READ_ONCE() and ASSIGN_ONCE()  will fall back to memcpy and print a
+ * READ_ONCE() and WRITE_ONCE()  will fall back to memcpy and print a
  * compile-time warning.
  *
  * Their two major use cases are: (1) Mediating communication between
@@ -257,8 +257,8 @@ static __always_inline void __assign_once_size(volatile void *p, void *res, int
 #define READ_ONCE(x) \
        ({ typeof(x) __val; __read_once_size(&x, &__val, sizeof(__val)); __val; })
 
-#define ASSIGN_ONCE(val, x) \
-       ({ typeof(x) __val; __val = val; __assign_once_size(&x, &__val, sizeof(__val)); __val; })
+#define WRITE_ONCE(x, val) \
+       ({ typeof(x) __val; __val = val; __write_once_size(&x, &__val, sizeof(__val)); __val; })
 
 #endif /* __KERNEL__ */
 
@@ -458,7 +458,7 @@ static __always_inline void __assign_once_size(volatile void *p, void *res, int
  * with an explicit memory barrier or atomic instruction that provides the
  * required ordering.
  *
- * If possible use READ_ONCE/ASSIGN_ONCE instead.
+ * If possible use READ_ONCE/WRITE_ONCE instead.
  */
 #define __ACCESS_ONCE(x) ({ \
         __maybe_unused typeof(x) __var = (typeof(x)) 0; 



