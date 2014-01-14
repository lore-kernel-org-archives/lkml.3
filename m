Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaANPZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:25:40 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:1099 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaANPZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:25:25 -0500
Message-ID: <52D556DC.7030501@hp.com>
Date: Tue, 14 Jan 2014 10:25:16 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Daniel J Blueman <daniel@numascale.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
References: <52D353C8.4000000@numascale.com> <52D4172E.6030706@hp.com> <52D4A0C7.5070601@numascale.com> <20140114110307.GW7572@laptop.programming.kicks-ass.net>
In-Reply-To: <20140114110307.GW7572@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 06:03 AM, Peter Zijlstra wrote:
> On Tue, Jan 14, 2014 at 10:28:23AM +0800, Daniel J Blueman wrote:
>>> Peter,
>>>
>>> I found out that the build failure was caused by the fact that the
>>> __native_word() macro (used internally by compiletime_assert_atomic())
>>> allows only a size of 4 or 8 for x86-64. The data type that I used is a
>>> byte. Is there a reason why byte and short are not considered native?
>> It seems likely it was implemented like that since there was no existing
>> need; long can be relied on as the largest native type, so this should
>> suffice and works here:
> There's Alphas that cannot actually atomically adres a byte; I do not
> konw if Linux cares about them, but if it does, we cannot in fact rely
> on this in generic primitives like this.

Thank for the explanation.

Can we allow architectural override of __native_word() macro? Like

#ifdef __arch_native_word
#define __native_word(t)    __arch_native_word(t)
#else
#define __native_word(t)    (sizeof(t) == sizeof(int) || sizeof(t) == 
sizeof(long))
#endif

In this way, we can allow x86 to support byte-based atomic type while 
restricting the generic macro to int and long only. I will also modify 
the code to use cmpxchg() when byte is not an atomic type.

-Longman


