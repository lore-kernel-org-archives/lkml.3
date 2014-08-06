Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaHFIPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:15:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbaHFIO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:14:59 -0400
Date: Wed, 6 Aug 2014 10:14:41 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Josh Stone <jistone@redhat.com>
Subject: Re: [PATCH 3.15 33/37] Fix gcc-4.9.0 miscompilation of
 load_balance() in scheduler
Message-ID: <20140806081441.GZ7393@tucnak.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20140730014827.565626091@linuxfoundation.org>
 <20140730014829.344302554@linuxfoundation.org>
 <20140730065312.GA1652@laptop.redhat.com>
 <CA+55aFzr_wJzt6RpojXpDo-ashV_N7sP+j7Ba0ND9mSpr7MKRQ@mail.gmail.com>
 <CA+5PVA5FPD8hp_7=M-VNoUG1Mw9R0Xkn2Yo50eo28ojzrcB5Aw@mail.gmail.com>
 <CA+55aFwvRcr98M=425eCR8K04X-uAVjH2bs3hudkySVKM4VqVg@mail.gmail.com>
 <CA+5PVA79a-BoMMAzryH0O3NFz6KY1f9REAmE=T00ErfcUfCGEg@mail.gmail.com>
 <20140805210728.GH13858@redhat.com>
 <CA+55aFwq72kDdRSWXKhyO1j=_PAKB960+RNOD6Cou0wZTa+5Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwq72kDdRSWXKhyO1j=_PAKB960+RNOD6Cou0wZTa+5Hw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 03:36:39PM -0700, Linus Torvalds wrote:
> On Tue, Aug 5, 2014 at 2:07 PM, Frank Ch. Eigler <fche@redhat.com> wrote:
> >
> > Actually, "perf probe" does (via HAVE_DWARF_SUPPORT), to place probes
> > and to extract variables at those probes, much as systemtap does.
> > Without var-tracking, probes placed at most interior points of
> > functions will make variables inaccessible.
> 
> .. and as mentioned, -O2 already does that for many things, even
> *with* tracking.

Sure, debug info coverage for highly optimized code is never going to be
perfect, but there is a difference if you have 75% of vars <optimized away>
or just 33% of vars (see the numbers I've posted, I've picked ext4.o just
randomly because it was one of the largest modules, can post more numbers if
needed).  BTW, because var-tracking is not performed at -O0, sometimes debug
info is actually worse in -O0 than at higher optimization levels, because
variable locations are bogus in prologues, epilogues and for variables with
register keyword anywhere.
There have been several man-years of work to get from the 25% var coverage
to 67%, several DWARF extensions (most of them to be available in DWARF5 or
work in progress on that) and with -fno-var-tracking-assignments that is
just returned to the old state.

> In other words, anybody who relies on it has already learnt to work
> around it. Or, more likely, there just isn't anybody who relies on it.
> 
> I don't understand how you guys can be so cavalier about a compiler
> bug that has already resulted in actual real problems. You bring up

I have no problem with a -fno-var-tracking-assignments workaround for
compilers that have the PR61801 wrong-code bug.  What I have problem with
is with disabling it even for compilers that have that bug fixed.
That is in essence disabling a useful feature just because it could have
other bugs.  If my memory serves me well, PR61801 is the only wrong-code
I remember caused by -fvar-tracking-assignments during the 5 years since
it has been introduced into gcc.  Sure, there have been several
-fcompare-debug bugs, where we generated slightly different code between
-g and -g0, and as you mentioned we have one still pending (Vladimir is
working on it right now), but that is mainly relevant to the case where
you'd ship -g0 built binaries (== kernel) and then only if bugs appear
wanted someone else to build kernel with -g and get identical binary, so
that you could debug it.  I believe if people build kernel with -g, then
they usually build it with -g from the beginning, and either save the kernel
with debug info somewhere, strip it to file or handle it similarly.
If there is a fear there could be other wrong-code bugs with
-fno-var-tracking-assignments, from the past experience that would be
~ another 5 years to discover it.  Compare that to the frequency of -O2
wrong code issues, with that you'd need to disable -O2 because of the fear
of unknown compiler bugs first.  And, we had various wrong-code bugs even at
-O0, so even that wouldn't help.  Compiler bugs are just that, bugs that
need to be reported, fixed, fixed compiler distributed to users, it is the
same thing with kernel bugs, libc bugs etc.

> theoretical cases that nobody has actually reported, and are
> apparently ignoring the fact that the compiler generates INCORRECT
> CODE. So on one hand we have known breakage, on the other we have

It actually isn't theoretical, actually various -fvar-tracking-assignments
changes have been done because people complained about important variables
in the kernel being optimized away, the whole DW_OP_GNU_entry_value DWARF
extension (DW_OP_entry_value in DWARF5 when it is released) was added
because of bugreports from people trying to debug the kernel.

	Jakub
