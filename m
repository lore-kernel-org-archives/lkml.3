Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaBRWOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:14:55 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:37027 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaBRWOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:14:51 -0500
MIME-Version: 1.0
In-Reply-To: <1392758516.18779.8378.camel@triegel.csb>
References: <20140207180216.GP4250@linux.vnet.ibm.com>
	<1391992071.18779.99.camel@triegel.csb>
	<CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
	<1392183564.18779.2187.camel@triegel.csb>
	<20140212180739.GB4250@linux.vnet.ibm.com>
	<CA+55aFw3S82GYdtnV2nJCvBGcuZf6kXdF5b7Vp9yb21QKr49Jw@mail.gmail.com>
	<20140213002355.GI4250@linux.vnet.ibm.com>
	<1392321837.18779.3249.camel@triegel.csb>
	<20140214020144.GO4250@linux.vnet.ibm.com>
	<1392352981.18779.3800.camel@triegel.csb>
	<20140214172920.GQ4250@linux.vnet.ibm.com>
	<CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
	<CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	<1392486310.18779.6447.camel@triegel.csb>
	<CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	<1392666947.18779.6838.camel@triegel.csb>
	<CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	<530296CD.5050503@warwick.ac.uk>
	<1392737465.18779.7644.camel@triegel.csb>
	<CA+55aFxn2KRXDQ91xRs=bO_6d_nA_PSQvoY1_=OxyJ86+KOO9Q@mail.gmail.com>
	<1392758516.18779.8378.camel@triegel.csb>
Date: Tue, 18 Feb 2014 14:14:50 -0800
X-Google-Sender-Auth: qadNhMSl0g97I9pnPviK0WeF67s
Message-ID: <CA+55aFwOrFyDG_ZcOeh9Y-mQ1jMKA6bbBudh2hde6+jaRy4L_A@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torvald Riegel <triegel@redhat.com>
Cc: Alec Teal <a.teal@warwick.ac.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 1:21 PM, Torvald Riegel <triegel@redhat.com> wrote:
>>
>> So imagine that you have some clever global optimizer that sees that
>> the program never ever actually sets the dirty bit at all in any
>> thread, and then uses that kind of non-local knowledge to make
>> optimization decisions. THAT WOULD BE BAD.
>>
>> Do you see what I'm aiming for?
>
> Yes, I do.  But that seems to be "volatile" territory.  It crosses the
> boundaries of the abstract machine, and thus is input/output.  Which
> fraction of your atomic accesses can read values produced by hardware?
> I would still suppose that lots of synchronization is not affected by
> this.

The "hardware can change things" case is indeed pretty rare.

But quite frankly, even when it isn't hardware, as far as the compiler
is concerned you have the exact same issue - you have TLB faults
happening on other CPU's that do the same thing asynchronously using
software TLB fault handlers. So *semantically*, it really doesn't make
any difference what-so-ever if it's a software TLB handler on another
CPU, a microcoded TLB fault, or an actual hardware path.

So if the answer for all of the above is "use volatile", then I think
that means that the C11 atomics are badly designed.

The whole *point* of atomic accesses is that stuff like above should
"JustWork(tm)"

> Do you perhaps want a weaker form of volatile?  That is, one that, for
> example, allows combining of two adjacent loads of the dirty bits, but
> will make sure that this is treated as if there is some imaginary
> external thread that it cannot analyze and that may write?

Yes, that's basically what I would want. And it is what I would expect
an atomic to be. Right now we tend to use "ACCESS_ONCE()", which is a
bit of a misnomer, because technically we really generally want
"ACCESS_AT_MOST_ONCE()" (but "once" is what we get, because we use
volatile, and is a hell of a lot simpler to write ;^).

So we obviously use "volatile" for this currently, and generally the
semantics we really want are:

 - the load or store is done as a single access ("atomic")

 - the compiler must not try to re-materialize the value by reloading
it from memory (this is the "at most once" part)

and quite frankly, "volatile" is a big hammer for this. In practice it
tends to work pretty well, though, because in _most_ cases, there
really is just the single access, so there isn't anything that it
could be combined with, and the biggest issue is often just the
correctness of not re-materializing the value.

And I agree - memory ordering is a totally separate issue, and in fact
we largely tend to consider it entirely separate. For cases where we
have ordering constraints, we either handle those with special
accessors (ie "atomic-modify-and-test" helpers tend to have some
serialization guarantees built in), or we add explicit fencing.

But semantically, C11 atomic accessors *should* generally have the
correct behavior for our uses.

If we have to add "volatile", that makes atomics basically useless. We
already *have* the volatile semantics, if atomics need it, that just
means that atomics have zero upside for us.

>> But *local* optimizations are fine, as long as they follow the obvious
>> rule of not actually making changes that are semantically visible.
>
> If we assume that there is this imaginary thread called hardware that
> can write/read to/from such weak-volatile atomics, I believe this should
> restrict optimizations sufficiently even in the model as specified in
> the standard.

Well, what about *real* threads that do this, but that aren't
analyzable by the C compiler because they are written in another
language entirely (inline asm, asm, perl, INTERCA:. microcode,
PAL-code, whatever?)

I really don't think that "hardware" is necessary for this to happen.
What is done by hardware on x86, for example, is done by PAL-code
(loaded at boot-time) on alpha, and done by hand-tuned assembler fault
handlers on Sparc. The *effect* is the same: it's not visible to the
compiler. There is no way in hell that the compiler can understand the
hand-tuned Sparc TLB fault handler, even if it parsed it.

>> IOW, I would *revel* in the fact that different machines are
>> different, and basically just describe the "stupid" code generation.
>> You'd get the guaranteed semantic baseline, but you'd *also* be able
>> to know that whatever architecture guarantees you have would remain.
>> Without having to describe those architecture issues.
>
> Would you be okay with this preventing lots of optimizations a compiler
> otherwise could do?  Because AFAICT, this spreads into non-synchronizing
> code via the dependency-tracking, for example.

Actually, it probably wouldn't really hurt code generation.

The thing is, you really have three cases:

 - architectures that have weak memory ordering and fairly stupid
hardware (power, some day maybe ARM)

 - architectures that expose a fairly strong memory ordering, but
reorders aggressively in hardware by tracking cacheline lifetimes
until instruction retirement (x86)

 - slow hardware (current ARM, crap Atom hardware etc embedded devices
that don't really do either)

and let's just agree that anybody who does high-performance work
doesn't really care about the third case, ok?

The compiler really wouldn't be that constrained in ordering on a
weakly ordered machine: sure, you'll have to add "lwsync" on powerpc
pretty much every time you have an ordered atomic read, but then you
could optimize them away for certain cases (like "oh, it was a
'consume' read, and the only consumer is already data-dependent, so
now we can remove the lwsync"), so you'd end up with pretty much the
code you looked for anyway.

And the HPC people who use the "relaxed" model wouldn't see the extra
memory barriers anyway.

And on a non-weakly ordered machine like x86, there are going to be
hardly any barriers in the first place, and the hardware will do the
right thing wrt ordering, so it's not like the compiler has gotten
prevented from any big optimization wins.

So I really think a simpler model that tied to the hardware directly -
which you need to do *anyway* since the memory ordering constraints
really are hw-dependent - would have been preferable. The people who
don't want to take advantage of hardware-specific guarantees would
never know the difference (they'll rely purely on pairing
acquire/release and fences properly - the way they *already* have to
in the current C11 model), and the people who _do_ care about
particular hw guarantees would get them by definition.

         Linus
