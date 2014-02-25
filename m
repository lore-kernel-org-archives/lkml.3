Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaBYGFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 01:05:55 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:53721 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaBYGFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 01:05:53 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxGaKtvx5YnOFC5hU9+ischxn=LN_yWiqjXwpNZePvWmw@mail.gmail.com>
References: <CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
	<20140223003933.GQ4250@linux.vnet.ibm.com>
	<CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
	<20140223063426.GT4250@linux.vnet.ibm.com>
	<CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
	<CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
	<20140224172110.GO8264@linux.vnet.ibm.com>
	<CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
	<20140224185341.GU8264@linux.vnet.ibm.com>
	<CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
	<20140224223701.GC8264@linux.vnet.ibm.com>
	<CA+55aFxGaKtvx5YnOFC5hU9+ischxn=LN_yWiqjXwpNZePvWmw@mail.gmail.com>
Date: Mon, 24 Feb 2014 22:05:52 -0800
X-Google-Sender-Auth: EWsw8WqPHI6KtGCOdnY5wHjCg3k
Message-ID: <CA+55aFwo9ZKxyN76cnkN7iQi7pKB+_tVD=re+RoMP4MiSajC8w@mail.gmail.com>
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

On Mon, Feb 24, 2014 at 3:35 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Litmus test 1:
>
>     p = atomic_read(pp, consume);
>     if (p == &variable)
>         return p->val;
>
>    is *NOT* ordered

Btw, don't get me wrong. I don't _like_ it not being ordered, and I
actually did spend some time thinking about my earlier proposal on
strengthening the 'consume' ordering.

I have for the last several years been 100% convinced that the Intel
memory ordering is the right thing, and that people who like weak
memory ordering are wrong and should try to avoid reproducing if at
all possible. But given that we have memory orderings like power and
ARM, I don't actually see a sane way to get a good strong ordering.
You can teach compilers about cases like the above when they actually
see all the code and they could poison the value chain etc. But it
would be fairly painful, and once you cross object files (or even just
functions in the same compilation unit, for that matter), it goes from
painful to just "ridiculously not worth it".

So I think the C semantics should mirror what the hardware gives us -
and do so even in the face of reasonable optimizations - not try to do
something else that requires compilers to treat "consume" very
differently.

If people made me king of the world, I'd outlaw weak memory ordering.
You can re-order as much as you want in hardware with speculation etc,
but you should always *check* your speculation and make it *look* like
you did everything in order. Which is pretty much the intel memory
ordering (ignoring the write buffering).

               Linus
