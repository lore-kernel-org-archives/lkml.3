Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaKUWKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:10:47 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34696 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaKUWKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:10:45 -0500
Date: Fri, 21 Nov 2014 23:10:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141121221040.GD9198@lerouge>
References: <20141120122339.GA14877@htj.dyndns.org>
 <alpine.DEB.2.11.1411202204030.3950@nanos>
 <20141120221122.GA25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411202315230.3950@nanos>
 <20141120230514.GB25393@htj.dyndns.org>
 <CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
 <20141120233920.GC25393@htj.dyndns.org>
 <CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
 <20141121162742.GB15461@htj.dyndns.org>
 <CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 08:38:07AM -0800, Andy Lutomirski wrote:
> On Nov 21, 2014 8:27 AM, "Tejun Heo" <tj@kernel.org> wrote:
> >
> > Hello, Andy.
> >
> > On Thu, Nov 20, 2014 at 03:55:09PM -0800, Andy Lutomirski wrote:
> > > That doesn't appear to have anything to with nmi though, right?
> >
> > I thought that was the main offender but, apparently, not any more.
> >
> > > Wouldn't this issue be fixed by moving the vmalloc_fault check into
> > > do_page_fault before exception_enter?
> >
> > Can you please elaborate why that'd fix the issue?  I'm not
> > intimiately familiar with the fault handling so it'd be great if you
> > can give me some pointers in terms of where to look at.
> 
> do_page_fault is called directly from asm.  It does:
> 
>     prev_state = exception_enter();
>     __do_page_fault(regs, error_code, address);
>     exception_exit(prev_state);
> 
> The vmalloc fixup is in __do_page_fault.
> 
> exception_enter does various accounting and tracing things, and I
> think that the recursion in stack trace I saw was in exception_enter.
> 
> If you move the vmalloc fixup before exception_enter() and return if
> the fault was from vmalloc, then you can't recurse.  You need to be
> careful not to touch anything that uses RCU before exception_enter,
> though.

That fixes the exception_enter() recursion but surely more issues with
per cpu memory faults are lurking somewhere now or in the future.

I'm going to add recursion protection to user_exit()/user_enter() anyway.
