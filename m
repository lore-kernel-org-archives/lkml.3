Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3IKPaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:30:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52736 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab3IKPaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:30:22 -0400
Message-ID: <52308C52.9080003@zytor.com>
Date: Wed, 11 Sep 2013 08:29:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 0/7] preempt_count rework -v2
References: <20130910130811.507933095@infradead.org> <20130910135152.GD7537@gmail.com> <20130910135636.GA8268@gmail.com> <CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com> <20130910164519.GL31370@twins.programming.kicks-ass.net> <CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com> <20130910212509.GA18147@laptop.programming.kicks-ass.net> <CA+55aFxsEYQPXnoxNXAeSPEkk3uT8iq-_KJVe2M2qZZbtL=cbA@mail.gmail.com> <20130911131323.GQ31370@twins.programming.kicks-ass.net>
In-Reply-To: <20130911131323.GQ31370@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 06:13 AM, Peter Zijlstra wrote:
> On Tue, Sep 10, 2013 at 02:43:06PM -0700, Linus Torvalds wrote:
>> That said, looking at your patch, I get the *very* strong feeling that
>> we could make a macro that does all the repetitions for us, and then
>> have a
>>
>>   GENERATE_RMW(atomic_sub_and_test, LOCK_PREFIX "subl", "e", "")
> 
> The below seems to compile..
> 
> +
> +#define GENERATE_ADDcc(var, val, lock, cc)				\
> +do {									\
> +	const int add_ID__ = (__builtin_constant_p(val) &&		\
> +			((val) == 1 || (val) == -1)) ? (val) : 0;	\
> +									\
> +	switch (sizeof(var)) {						\
> +	case 4:								\
> +		if (add_ID__ == 1) {					\
> +			asm volatile goto(lock "incl %0;"		\
> +					  "j" cc " %l[cc_label]"	\
> +					  : : "m" (var)			\
> +					  : "memory" : cc_label);	\
> +		} else if (add_ID__ == -1) {				\
> +			asm volatile goto(lock "decl %0;"		\
> +					  "j" cc " %l[cc_label]"	\
> +					  : : "m" (var)			\
> +					  : "memory" : cc_label);	\
> +		} else {						\
> +			asm volatile goto(lock "addl %1, %0;"		\
> +					  "j" cc " %l[cc_label]"	\
> +					  : : "m" (var), "er" (val)	\
> +					  : "memory" : cc_label);	\
> +		}							\
> +		break;							\
> +									\
> +	case 8:								\
> +		if (add_ID__ == 1) {					\
> +			asm volatile goto(lock "incq %0;"		\
> +					  "j" cc " %l[cc_label]"	\
> +					  : : "m" (var)			\
> +					  : "memory" : cc_label);	\
> +		} else if (add_ID__ == -1) {				\
> +			asm volatile goto(lock "decq %0;"		\
> +					  "j" cc " %l[cc_label]"	\
> +					  : : "m" (var)			\
> +					  : "memory" : cc_label);	\
> +		} else {						\
> +			asm volatile goto(lock "addq %1, %0;"		\
> +					  "j" cc " %l[cc_label]"	\
> +					  : : "m" (var), "er" (val)	\
> +					  : "memory" : cc_label);	\
> +		}							\
> +		break;							\
> +									\

At least in the "asm goto" case you can use:

	lock "add%z0 %1,%0;"

... and skip the switch statement.

There was a bug in some old (gcc 3.x?) early x86-64 versions which would
treat %z0 as if it was %Z0 which means it would emit "ll" instead of "q"
but that doesn't apply to any gcc which has "asm goto"...

	-hpa


