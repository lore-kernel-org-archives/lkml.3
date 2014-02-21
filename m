Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaBUTQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:16:33 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:48285 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaBUTQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:16:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAHWkzRQZ8+gOGMFNyTKjFNzpUv6d_J1G9KL0x_iCa=YCgvEojQ@mail.gmail.com>
References: <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	<20140218030002.GA15857@linux.vnet.ibm.com>
	<CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
	<CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
	<1392740258.18779.7732.camel@triegel.csb>
	<CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
	<1392752867.18779.8120.camel@triegel.csb>
	<CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
	<20140220040102.GM4250@linux.vnet.ibm.com>
	<CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
	<20140220083032.GN4250@linux.vnet.ibm.com>
	<CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
	<CAHWkzRQZ8+gOGMFNyTKjFNzpUv6d_J1G9KL0x_iCa=YCgvEojQ@mail.gmail.com>
Date: Fri, 21 Feb 2014 11:16:30 -0800
X-Google-Sender-Auth: knC962WRcH1KSTdHgKcunzGxj6w
Message-ID: <CA+55aFyDQ-9mJJUUXqp+XWrpA8JMP0=exKa=JpiaNM9wAAsCrA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "p796231 ." <Peter.Sewell@cl.cam.ac.uk>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>, Mark Batty <mbatty@cantab.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 10:25 AM, Peter Sewell
<Peter.Sewell@cl.cam.ac.uk> wrote:
>
> If one thinks this is too fragile, then simply using memory_order_acquire
> and paying the resulting barrier cost (and perhaps hoping that compilers
> will eventually be able to optimise some cases of those barriers to
> hardware-level dependencies) is the obvious alternative.

No, the obvious alternative is to do what we do already, and just do
it by hand. Using acquire is *worse* than what we have now.

Maybe for some other users, the thing falls out differently.

> Many concurrent things will "accidentally" work on x86 - consume is not
> special in that respect.

No. But if you have something that is mis-designed, easy to get wrong,
and untestable, any sane programmer will go "that's bad".

> There are two difficulties with this, if I understand correctly what you're
> proposing.
>
> The first is knowing where to stop.

No.

Read my suggestion. Knowing where to stop is *trivial*.

Either the dependency is immediate and obvious, or you treat it like an acquire.

Seriously. Any compiler that doesn't turn the dependency chain into
SSA or something pretty much equivalent is pretty much a joke. Agreed?

So we can pretty much assume that the compiler will have some
intermediate representation as part of optimization that is basically
SSA.

So what you do is,

 - build the SSA by doing all the normal parsing and possible
tree-level optimizations you already do even before getting to the SSA
stage

 - do all the normal optimizations/simplifications/cse/etc that you do
normally on SSA

 - add *one* new rule to your SSA simplification that goes something like this:

   * when you see a load op that is marked with a "consume" barrier,
just follow the usage chain that comes from that.
   * if you hit a normal arithmetic op, just follow the result chain of that
   * if you hit a memory operation address use, stop and say "looks good"
   * it you hit anything else (including a copy/phi/whatever), abort
   * if nothing aborted as part of the walk, you can now just remove
the "consume" barrier.

You can fancy it up and try to follow more cases, but realistically
the only case that really matters is the "consume" being fed directly
into one or more loads, with possibly an offset calculation in
between. There are certainly more cases you could *try* to remove the
barrier, but the thing is, it's never incorrect to not remove it, so
any time you get bored or hit any complication at all, just do the
"abort" part.

I *guarantee* that if you describe this to a compiler writer, he will
tell you that my scheme is about a billion times simpler than the
current standard wording. Especially after you've pointed him to that
gcc bugzilla entry and explained to him about how the current standard
cares about those kinds of made-up syntactic chains that he likely
removed quite early, possibly even as he was generating the semantic
tree.

Try it. I dare you. So if you want to talk about "difficulties", the
current C standard loses.

> The second is the proposal in later mails to use some notion of  "semantic"
> dependency instead of this syntactic one.

Bah.

The C standard does that all over. It's called "as-is". The C standard
talks about how the compiler can do pretty much whatever it likes, as
long as the end result acts the same in the virtual C machine.

So claiming that "semantics" being meaningful is somehow complex is
bogus. People do that all the time. If you make it clear that the
dependency chain is through the *value*, not syntax, and that the
value can be optimized all the usual ways, it's quite clear what the
end result is. Any operation that actually meaningfully uses the value
is serialized with the load, and if there is no meaningful use that
would affect the end result in the virtual machine, then there is no
barrier.

Why would this be any different, especially since it's easy to
understand both for a human and a compiler?

               Linus
