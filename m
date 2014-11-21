Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbaKUQia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:38:30 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:46728 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbaKUQi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:38:29 -0500
MIME-Version: 1.0
In-Reply-To: <20141121162742.GB15461@htj.dyndns.org>
References: <alpine.DEB.2.11.1411200002330.3909@nanos> <20141119235033.GE11386@lerouge>
 <20141120122339.GA14877@htj.dyndns.org> <alpine.DEB.2.11.1411202204030.3950@nanos>
 <20141120221122.GA25393@htj.dyndns.org> <alpine.DEB.2.11.1411202315230.3950@nanos>
 <20141120230514.GB25393@htj.dyndns.org> <CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
 <20141120233920.GC25393@htj.dyndns.org> <CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
 <20141121162742.GB15461@htj.dyndns.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Nov 2014 08:38:07 -0800
Message-ID: <CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 21, 2014 8:27 AM, "Tejun Heo" <tj@kernel.org> wrote:
>
> Hello, Andy.
>
> On Thu, Nov 20, 2014 at 03:55:09PM -0800, Andy Lutomirski wrote:
> > That doesn't appear to have anything to with nmi though, right?
>
> I thought that was the main offender but, apparently, not any more.
>
> > Wouldn't this issue be fixed by moving the vmalloc_fault check into
> > do_page_fault before exception_enter?
>
> Can you please elaborate why that'd fix the issue?  I'm not
> intimiately familiar with the fault handling so it'd be great if you
> can give me some pointers in terms of where to look at.

do_page_fault is called directly from asm.  It does:

    prev_state = exception_enter();
    __do_page_fault(regs, error_code, address);
    exception_exit(prev_state);

The vmalloc fixup is in __do_page_fault.

exception_enter does various accounting and tracing things, and I
think that the recursion in stack trace I saw was in exception_enter.

If you move the vmalloc fixup before exception_enter() and return if
the fault was from vmalloc, then you can't recurse.  You need to be
careful not to touch anything that uses RCU before exception_enter,
though.

--Andy

>
> Thanks.
>
> --
> tejun
