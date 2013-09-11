Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3IKPd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:33:26 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:59954 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab3IKPdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:33:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130911131323.GQ31370@twins.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
	<20130910135152.GD7537@gmail.com>
	<20130910135636.GA8268@gmail.com>
	<CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com>
	<20130910164519.GL31370@twins.programming.kicks-ass.net>
	<CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com>
	<20130910212509.GA18147@laptop.programming.kicks-ass.net>
	<CA+55aFxsEYQPXnoxNXAeSPEkk3uT8iq-_KJVe2M2qZZbtL=cbA@mail.gmail.com>
	<20130911131323.GQ31370@twins.programming.kicks-ass.net>
Date: Wed, 11 Sep 2013 08:33:21 -0700
X-Google-Sender-Auth: WkOr5S_XUdLyoeKdUu2s8p326Cw
Message-ID: <CA+55aFyxcHvQUe_h8cyQrNbGJ6-G_NQnK9pVenABLjCF-7WMXg@mail.gmail.com>
Subject: Re: [PATCH 0/7] preempt_count rework -v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 6:13 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Sep 10, 2013 at 02:43:06PM -0700, Linus Torvalds wrote:
>> That said, looking at your patch, I get the *very* strong feeling that
>> we could make a macro that does all the repetitions for us, and then
>> have a
>>
>>   GENERATE_RMW(atomic_sub_and_test, LOCK_PREFIX "subl", "e", "")
>
> The below seems to compile..

You have that horrible duplication in the macro itself now, though.

The only difference between the 4-byte and the 8-byte one is the "l"
vs "q". And the counter increment/decrement argument (by the caller)
defines whether it's add/dec/inc. Why not just add those as parameters
to the macro, and suddenly the macro becomes 10x smaller.

An excessively complex macro that makes the arguments trivially
simpler is not worth it.

Especially since that excessive macro complexity now means that your
macro is useless for things that the *simpler* macro could have done,
like the bit-test-and-modify cases.

So your complexity actually makes things worse.

So just pass in the operation name and size. Then somebody will use it
for test_and_set_bit() and friends too.

              Linus
