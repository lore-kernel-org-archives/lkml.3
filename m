Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3AONHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:07:55 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:62692 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab3AONHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:07:54 -0500
Message-ID: <50F554A6.3000309@openvz.org>
Date: Tue, 15 Jan 2013 17:07:50 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121123 Firefox/10.0.11 Iceape/2.7.11
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RCU: non-atomic assignment to long/pointer variables in gcc
References: <50F52FC8.4000701@openvz.org> <20130115123250.GK3384@linux.vnet.ibm.com>
In-Reply-To: <20130115123250.GK3384@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Tue, Jan 15, 2013 at 02:30:32PM +0400, Konstantin Khlebnikov wrote:
>> Documentation/atomic_ops.txt (182dd4b277177e8465ad11cd9f85f282946b5578)
>> says that pointers, longs, ints, and chars are stored and loaded atomically.
>>
>> But GCC actually may split assignment to 'long' variable into two instructions.
>> see example in http://gcc.gnu.org/bugzilla/show_bug.cgi?id=55981
>>
>> GCC also splits assignments to 'volatile' variables and this is actually a bug in gcc.
>>
>> volatile unsigned long y;
>>
>> y = 0x100000001ul;
>>
>>    400728:	c7 05 66 06 20 00 01 	movl   $0x1,0x200666(%rip)        # 600d98<y>
>>    40072f:	00 00 00
>>    400732:	c7 05 60 06 20 00 01 	movl   $0x1,0x200660(%rip)        # 600d9c<y+0x4>
>>    400739:	00 00 00
>>
>> fortunately for y = 0; it generates this:
>>
>>    40071d:	48 c7 05 70 06 20 00 	movq   $0x0,0x200670(%rip)        # 600d98<y>
>>    400724:	00 00 00 00
>>
>> Thus NULL is safe, but constant ERR_PTR may be dangerous.
>>
>> Probably rcu_assign_pointer() should use ACCESS_ONCE() around lvalue, because
>> splitting assignment for non-volatile variable seems like completely valid,
>> but this may help only after fixing that bug in GCC.
>
> Good catch!  I has queued the following patch.
>
> 							Thanx, Paul
>
> ------------------------------------------------------------------------
>
> rcu: Add ACCESS_ONCE() to rcu_assign_pointer()
>
> GCC may split assignment to 'long' variable into two instructions:
>
> volatile unsigned long y;
>
> y = 0x100000001ul;
>
> 	movl   $0x1,0x200666(%rip)
> 	movl   $0x1,0x200660(%rip)
>
> This commit fixes this by applying ACCESS_ONCE() within
> __rcu_assign_pointer(), but note that some versions and architectures
> of GCC have a bug that defeats ACCESS_ONCE():
>
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=55981
>
> I added a comment to this bug report asking that the bug be fixed for
> volatiles as well as atomics, citing a device driver storing a constant
> into a 64-bit device register as motivation.
>
> Reported-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> Signed-off-by: Paul E. McKenney<paulmck@linux.vnet.ibm.com>
>
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 9ed2c9a..3435174 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -556,7 +556,7 @@ static inline void rcu_preempt_sleep_check(void)
>   #define __rcu_assign_pointer(p, v, space) \
>   	do { \
>   		smp_wmb(); \
> -		(p) = (typeof(*v) __force space *)(v); \
> +		ACCESS_ONCE(p) = (typeof(*v) __force space *)(v); \
>   	} while (0)

Seems like RCU_INIT_POINTER() need this too.

>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

