Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaBUTlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:41:05 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:56731 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaBUTlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:41:02 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyDQ-9mJJUUXqp+XWrpA8JMP0=exKa=JpiaNM9wAAsCrA@mail.gmail.com>
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
	<CA+55aFyDQ-9mJJUUXqp+XWrpA8JMP0=exKa=JpiaNM9wAAsCrA@mail.gmail.com>
Date: Fri, 21 Feb 2014 11:41:01 -0800
X-Google-Sender-Auth: AIndurfTG5sEFhXRyFiGdX0wGh4
Message-ID: <CA+55aFz4Lhnx9XzMt_X8SOqmoUdiuW_93SAdV58UiEe3g278CQ@mail.gmail.com>
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

On Fri, Feb 21, 2014 at 11:16 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Why would this be any different, especially since it's easy to
> understand both for a human and a compiler?

Btw, the actual data path may actually be semantically meaningful even
at a processor level.

For example, let's look at that gcc bugzilla that got mentioned
earlier, and let's assume that gcc is fixed to follow the "arithmetic
is always meaningful, even if it is only syntactic" the letter.
So we have that gcc bugzilla use-case:

   flag ? *(q + flag - flag) : 0;

and let's say that the fixed compiler now generates the code with the
data dependency that is actually suggested in that bugzilla entry:

        and     w2, w2, #0
        ldr     w0, [x1, w2]

ie the CPU actually sees that address data dependency. Now everything
is fine, right?

Wrong.

It is actually quite possible that the CPU sees the "and with zero"
and *breaks the dependencies on the incoming value*.

Modern CPU's literally do things like that. Seriously. Maybe not that
particular one, but you'll sometimes find that the CPU - int he
instruction decoding phase (ie very early in the pipeline) notices
certain patterns that generate constants, and actually drop the data
dependency on the "incoming" registers.

On x86, generating zero using "xor" on the register with itself is one
such known sequence.

Can you guarantee that powerpc doesn't do the same for "and r,r,#0"?
Or what if the compiler generated the much more obvious

    sub w2,w2,w2

for that "+flag-flag"? Are you really 100% sure that the CPU won't
notice that that is just a way to generate a zero, and doesn't depend
on the incoming values?

Because I'm not. I know CPU designers that do exactly this.

So I would actually and seriously argue that the whole C standard
attempt to use a syntactic data dependency as a determination of
whether two things are serialized is wrong, and that you actually
*want* to have the compiler optimize away false data dependencies.

Because people playing tricks with "+flag-flag" and thinking that that
somehow generates a data dependency - that's *wrong*. It's not just
the compiler that decides "that's obviously nonsense, I'll optimize it
away". The CPU itself can do it.

So my "actual semantic dependency" model is seriously more likely to
be *correct*. Not just t a compiler level.

Btw, any tricks like that, I would also take a second look at the
assembler and the linker. Many assemblers do some trivial
optimizations too. Are you sure that "and     w2, w2, #0" really ends
up being encoded as an "and"? Maybe the assembler says "I can do that
as a "mov w2,#0" instead? Who knows? Even power and ARM have their
variable-sized encodings (there are some "compressed executable"
embedded power processors, and there is obviously Thumb2, and many
assemblers end up trying to use equivalent "small" instructions..

So the whole "fake data dependency" thing is just dangerous on so many levels.

MUCH more dangerous than my "actual real dependency" model.

                   Linus
