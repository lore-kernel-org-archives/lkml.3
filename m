Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaBTTpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:45:33 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:64404 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaBTTpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:45:31 -0500
MIME-Version: 1.0
In-Reply-To: <20140220185608.GX4250@linux.vnet.ibm.com>
References: <1392740258.18779.7732.camel@triegel.csb>
	<CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
	<1392752867.18779.8120.camel@triegel.csb>
	<CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
	<20140220040102.GM4250@linux.vnet.ibm.com>
	<CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
	<20140220083032.GN4250@linux.vnet.ibm.com>
	<CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
	<20140220181116.GT4250@linux.vnet.ibm.com>
	<CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
	<20140220185608.GX4250@linux.vnet.ibm.com>
Date: Thu, 20 Feb 2014 11:45:29 -0800
X-Google-Sender-Auth: fvMam0lkm6MdezUxTOmWitojhIQ
Message-ID: <CA+55aFw4inow5B-JAg-NtZigJ90yDbksddr00RoMKytzDAEa8A@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
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

On Thu, Feb 20, 2014 at 10:56 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> The example gcc breakage was something like this:
>
>         i = atomic_load(idx, memory_order_consume);
>         x = array[0 + i - i];
>
> Then gcc optimized this to:
>
>         i = atomic_load(idx, memory_order_consume);
>         x = array[0];
>
> This same issue would hit control dependencies.  You are free to argue
> that this is the fault of ARM and PowerPC memory ordering, but the fact
> remains that your suggested change has -exactly- the same vulnerability
> as memory_order_consume currently has.

No it does not, for two reasons, first the legalistic (and bad) reason:

As I actually described it, the "consume" becomes an "acquire" by
default. If it's not used as an address to the dependent load, then
it's an acquire. The use "going away" in no way makes the acquire go
away in my simplistic model.

So the compiler would actually translate that to a load-with-acquire,
not be able to remove the acquire, and we have end of story. The
actual code generation would be that "ld + sync + ld" on powerpc, or
"ld.acq" on ARM.

Now, the reason I claim that reason was "legalistic and bad" is that
it's actually a cop-out, and if you had made the example be something
like this:

   p = atomic_load(&ptr, memory_order_consume);
   x = array[0 + p - p];
   y = p->val;

then yes, I actually think that the order of loads of 'x' and 'p' are
not enforced by the "consume". The only case that is clear is the
order of 'y' and 'p', because that is the only one that really *USES*
the value.

The "use" of "+p-p" is syntactic bullshit. It's very obvious to even a
slightly developmentally challenged hedgehog that "+p-p" doesn't have
any actual *semantic* meaning, it's purely syntactic.

And the syntactic meaning is meaningless and doesn't matter. Because I
would just get rid of the whole "dependency chain" language
ALTOGETHER.

So in fact, in my world, I would consider your example to be a
non-issue. In my world, there _is_ no "dependency chain" at a
syntactic level. In my SANE world, none of that insane crap language
exists. That language is made-up and tied to syntax exactly because it
*cannot* be tied to semantics.

In my sane world, "consume" has a much simpler meaning, and has no
legalistic syntactic meaning: only real use matters. If the value can
be optimized away, the so can the barrier, and so can the whole load.
The value isn't "consumed", so it has no meaning.

So if you write

   i = atomic_load(idx, memory_order_consume);
   x = array[0+i-i];

then in my world that "+i-i" is meaningless. It's semantic fluff, and
while my naive explanation would have left it as an acquire (because
it cannot be peep-holed away), I actually do believe that the compiler
should be obviously allowed to optimize the load away entirely since
it's meaningless, and if no use of 'i' remains, then it has no
consumer, and so there is no dependency.

Put another way: "consume" is not about getting a lock, it's about
getting a *value*. Only the dependency on the *value* matters, and if
the value is optimized away, there is no dependency.

And the value itself does not have any semantics. There's nothing
"volatile" about the use of the value that would mean that the
compiler cannot re-order it or remove it entirely. There's no barrier
"carried around" by the value per se. The barrier is between the load
and use. That's the *point* of "consume" after all.

The whole "chain of dependency" language is pointless. It's wrong.
It's complicated, it is illogical, and it causes subtle problems
exactly because it got tied to the language *syntax* rather than to
any logical use.

Don't try to re-introduce the whole issue. It was a mistake for the C
standard to talk about dependencies in the first place, exactly
because it results in these idiotic legalistic practices.

You do realize that that whole "*(q+flag-flag)" example in the
bugzilla comes from the fact that the programmer tried to *fight* the
fact that the C standard got the control dependency wrong?

In other words, the *deepest* reason for that bugzilla is that the
programmer tried to force the logical dependency by rewriting it as a
(fake, and easily optimizable) data dependency.

In *my* world, the stupid data-vs-control dependency thing goes away,
the test of the value itself is a use of it, and "*p ? *q :0" just
does the right thing, there's no reason to do that "q+flag-flag" thing
in the first place, and if you do, the compiler *should* just ignore
your little games.

              Linus
