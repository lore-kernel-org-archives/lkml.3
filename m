Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaBRQI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:08:56 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:58783 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbaBRQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:08:54 -0500
MIME-Version: 1.0
Reply-To: Peter.Sewell@cl.cam.ac.uk
In-Reply-To: <20140218125357.GC27965@twins.programming.kicks-ass.net>
References: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
	<20140218125357.GC27965@twins.programming.kicks-ass.net>
Date: Tue, 18 Feb 2014 16:08:53 +0000
X-Google-Sender-Auth: YPJmrBbbDBFJuohSLQTcpnCmQnE
Message-ID: <CAHWkzRQZoWsc5SAJHnbDZckuo9fzt_t88F1K+2U11_mdLyQNxg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Peter Sewell <Peter.Sewell@cl.cam.ac.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mark.batty@cl.cam.ac.uk" <Mark.Batty@cl.cam.ac.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Torvald Riegel <triegel@redhat.com>,
        torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        "ramana.radhakrishnan" <Ramana.Radhakrishnan@arm.com>,
        dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mingo@kernel.org, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 February 2014 12:53, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Feb 18, 2014 at 12:12:06PM +0000, Peter Sewell wrote:
>> Several of you have said that the standard and compiler should not
>> permit speculative writes of atomics, or (effectively) that the
>> compiler should preserve dependencies.
>
> The example below only deals with control dependencies; so I'll limit
> myself to that.

Data/address dependencies are, if anything, even less clear - see a
paragraph on that in my reply to Paul.

>> In simple examples it's easy
>> to see what that means, but in general it's not so clear what the
>> language should guarantee, because dependencies may go via non-atomic
>> code in other compilation units, and we have to consider the extent to
>> which it's desirable to limit optimisation there.
>>
>> For example, suppose we have, in one compilation unit:
>>
>>     void f(int ra, int*rb) {
>>       if (ra==42)
>>         *rb=42;
>>       else
>>         *rb=42;
>>     }
>>
>> and in another compilation unit the bodies of two threads:
>>
>>     // Thread 0
>>     r1 = x;
>>     f(r1,&r2);
>>     y = r2;
>>
>>     // Thread 1
>>     r3 = y;
>>     f(r3,&r4);
>>     x = r4;
>>
>> where accesses to x and y are annotated C11 atomic
>> memory_order_relaxed or Linux ACCESS_ONCE(), accesses to
>> r1,r2,r3,r4,ra,rb are not annotated, and x and y initially hold 0.
>
> So I'm intuitively ok with this, however I would expect something like:
>
>   void f(_Atomic int ra, _Atomic int *rb);
>
> To preserve dependencies and not make the conditional go away, simply
> because in that case the:
>
>   if (ra == 42)
>
> the 'ra' usage can be seen as an atomic load.
>
>> So as far as we can see, either:
>>
>> 1) if you can accept the latter behaviour (if the Linux codebase does
>>    not rely on its absence), the language definition should permit it,
>>    and current compiler optimisations can be used,
>
> Currently there's exactly 1 site in the Linux kernel that relies on
> control dependencies as far as I know -- the one I put in.

ok, thanks

> And its
> limited to a single function, so no cross translation unit funnies
> there.

One can imagine a language definition that treats code that lies
entirely within a single compilation unit specially (e.g. if it's
somehow annotated as relying on dependencies).  But I imagine it would
be pretty unappealing to work with.

> Of course, nobody is going to tell me when or where they'll put in the
> next one; since its now documented as accepted practise.

Is that not fragile?

> However, PaulMck and our RCU usage very much do cross all sorts of TU
> boundaries; but those are data dependencies.

yes - though again see my reply to Paul's note

thanks,
Peter

> ~ Peter
