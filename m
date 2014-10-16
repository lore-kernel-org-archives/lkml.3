Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaJPPbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:31:10 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:59364 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaJPPbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:31:08 -0400
MIME-Version: 1.0
In-Reply-To: <20141016114917.GD25025@nazgul.tnic>
References: <cover.1413323611.git.luto@amacapital.net> <808fa43ef6e24d1df47c2666174d997105b9582d.1413323611.git.luto@amacapital.net>
 <20141016114917.GD25025@nazgul.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 16 Oct 2014 08:30:46 -0700
Message-ID: <CALCETrUxKqNnJQWQUbR-MSzEPj+cvxYgwBA9k9=1n_JOMAx1Ag@mail.gmail.com>
Subject: Re: [RFC 2/5] x86: Store a per-cpu shadow copy of CR4
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 16, 2014 4:49 AM, "Borislav Petkov" <bp@alien8.de> wrote:
>
> On Tue, Oct 14, 2014 at 03:57:36PM -0700, Andy Lutomirski wrote:
> > Context switches and TLB flushes can change individual bits of CR4.
> > CR4 reads take several cycles, so store a shadow copy of CR4 in a
> > per-cpu variable.
> >
> > To avoid wasting a cache line, I added the CR4 shadow to
> > cpu_tlbstate, which is already touched during context switches.
>
> So does this even show in any workloads as any improvement?
>

Unlear.  Assuming that mov from cr4 is more expensive than a cache
miss (which may or may not be true), then kernel TLB flushes will get
cheaper.  The main reason I did this is to make switching TSD and PCE
a little cheaper, which might be worthwhile.

I think this may be a huge win on many workloads when running as an
SVM guest.  IIUC SVM doesn't have accelerated guest CR4 access.

> Also, what's the rule with reading the shadow CR4? kvm only? Because
> svm_set_cr4() in svm.c reads the host CR4 too.

Whoops.

>
> Should we make all code access the shadow CR4 maybe...

That was the intent.  In v2, I'll probably rename read_cr4 to
__read_cr4 to make it difficult to miss things.

>
> --
> Regards/Gruss,
>     Boris.
> --
