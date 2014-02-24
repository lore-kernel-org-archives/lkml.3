Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaBXP53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:57:29 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:62051 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaBXP50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:57:26 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
References: <20140220083032.GN4250@linux.vnet.ibm.com>
	<CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
	<20140220181116.GT4250@linux.vnet.ibm.com>
	<CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
	<1392922421.28840.36.camel@triegel.csb>
	<CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
	<1393095223.28840.4914.camel@triegel.csb>
	<CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
	<20140223003933.GQ4250@linux.vnet.ibm.com>
	<CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
	<20140223063426.GT4250@linux.vnet.ibm.com>
	<CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
Date: Mon, 24 Feb 2014 07:57:24 -0800
X-Google-Sender-Auth: _JflJg7mWN1Lzz84hbJKe-O5E5c
Message-ID: <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
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

On Sun, Feb 23, 2014 at 11:31 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Let me think about it some more, but my gut feel is that just tweaking
> the definition of what "ordered" means is sufficient.
>
> So to go back to the suggested ordering rules (ignoring the "restrict"
> part, which is just to clarify that ordering through other means to
> get to the object doesn't matter), I suggested:
>
>  "the consume ordering guarantees the ordering between that
>   atomic read and the accesses to the object that the pointer
>   points to"
>
> and I think the solution is to just say that this ordering acts as a
> fence. It doesn't say exactly *where* the fence is, but it says that
> there is *some* fence between the load of the pointer and any/all
> accesses to the object through that pointer.

I'm wrong. That doesn't work. At all. There is no ordering except
through the pointer chain.

So I think saying just that, and nothing else (no magic fences, no
nothing) is the right thing:

 "the consume ordering guarantees the ordering between that
  atomic read and the accesses to the object that the pointer
  points to directly or indirectly through a chain of pointers"

The thing is, anything but a chain of pointers (and maybe relaxing it
to "indexes in tables" in addition to pointers) doesn't really work.

The current standard tries to break it at "obvious" points that can
lose the data dependency (either by turning it into a control
dependency, or by just dropping the value, like the left-hand side of
a comma-expression), but the fact is, it's broken.

It's broken not just because the value can be lost other ways (ie the
"p-p" example), it's broken because the value can be turned into a
control dependency so many other ways too.

Compilers regularly turn arithmetic ops with logical comparisons into
branches. So an expression like "a = !!ptr" carries a dependency in
the current C standard, but it's entirely possible that a compiler
ends up turning it into a compare-and-branch rather than a
compare-and-set-conditional, depending on just exactly how "a" ends up
being used. That's true even on an architecture like ARM that has a
lot of conditional instructions (there are way less if you compile for
Thumb, for example, but compilers also do things like "if there are
more than N predicated instructions I'll just turn it into a
branch-over instead").

So I think the C standard needs to just explicitly say that you can
walk a chain of pointers (with that possible "indexes in arrays"
extension), and nothing more.

                    Linus
