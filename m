Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab3KSWNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:13:09 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:57938 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab3KSWNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:13:05 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Richard Henderson <rth@twiddle.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Catalin Marinas <Catalin.Marinas@arm.com>, lttng-dev@lists.lttng.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>, "gcc\@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: Multiple local register variables w/ same register
References: <52803E5D.3050109@mentor.com> <52851395.3010306@mentor.com>
	<67652521.68027.1384482849638.JavaMail.zimbra@efficios.com>
	<1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com>
	<20131119160502.GG11778@mudshark.cambridge.arm.com>
	<1656507422.70913.1384880540574.JavaMail.zimbra@efficios.com>
	<20131119173312.GP16796@laptop.programming.kicks-ass.net>
	<528BDEA9.1050708@twiddle.net>
Date: Tue, 19 Nov 2013 22:13:00 +0000
In-Reply-To: <528BDEA9.1050708@twiddle.net> (Richard Henderson's message of
	"Wed, 20 Nov 2013 07:56:57 +1000")
Message-ID: <yw1xsiusqbv7.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Henderson <rth@twiddle.net> writes:

> On 11/20/2013 03:33 AM, Peter Zijlstra wrote:
>> On Tue, Nov 19, 2013 at 05:02:20PM +0000, Mathieu Desnoyers wrote:
>>> Unfortunately I don't have a ARM cross-compiler setup ready. Nathan
>>> could test it for us though.
>>>
>>> It might shuffle things around enough to work around the issue, but
>>> with the approach you propose, I would be concerned about the
>>> compiler being within its rights to reorder the code into the
>>> following sequence:
>>>
>>> struct thread_info *ptra, *ptrb;
>>>
>>> ptra = current_thread_info();
>>> /*
>>>  * each current_thread_info() would have a clobber on *sp, which orders
>>>  * those two wrt each other.
>>>   */
>>> ptrb = current_thread_info();
>>>
>>> load from ptra->preempt_count;
>>> /*
>>>  * however, the following accesses that depend on ptra and ptrb could be
>>>  * reordered if the compiler has no way to know that ptra and ptrb are
>>>  * aliased.
>>>  */
>>> store to ptrb->preempt_count;
>>>
>>> One question that might be worth asking: with the local register variable
>>> extension (http://gcc.gnu.org/onlinedocs/gcc-4.8.2/gcc/Local-Reg-Vars.html#Local-Reg-Vars)
>>> (thanks to Jakub for the pointer), should the compiler consider two
>>> variables bound to the same register as being aliased or not ?
>>> AFAIU, local reg vars appear to be architecture-specific, so maybe
>>> there is something fishy on ARM ?
>
> It appears not:
>
> int __attribute__((noinline)) f(void)
> {
>   {
>     register int x __asm__("eax");
>     x = 1;
>   }
>   {
>     register int y __asm__("eax");
>     return ++y;
>   }
> }
>
> extern void abort(void);
>
> int main(void)
> {
>   if (f() != 2)
>     abort();
>   return 0;
> }
>
> Anyone see anything wrong with the testcase?  Do we thing this sort of
> thing ought to work, perhaps with scopes lengthened?

In general, I see no reason why the compiler should be forced to
preserve a register between blocks like that.  Relying on a value
magically appearing in a general-purpose register seems to me fragile at
best.  Code like this adds inter-block dependencies that would not
normally be there, and I'd rather not gamble on how the various
optimisation passes deal with it, if it is even noticed at all.

What happens if you some code clobbering eax (e.g. a function call)
between those two blocks?  What do you think should happen?

-- 
Måns Rullgård
mans@mansr.com
