Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbaKUQtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:49:01 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:59931 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbaKUQs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:48:59 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
References: <alpine.DEB.2.11.1411200002330.3909@nanos>
	<20141119235033.GE11386@lerouge>
	<20141120122339.GA14877@htj.dyndns.org>
	<alpine.DEB.2.11.1411202204030.3950@nanos>
	<20141120221122.GA25393@htj.dyndns.org>
	<alpine.DEB.2.11.1411202315230.3950@nanos>
	<20141120230514.GB25393@htj.dyndns.org>
	<CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
	<20141120233920.GC25393@htj.dyndns.org>
	<CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
	<20141121162742.GB15461@htj.dyndns.org>
	<CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
Date: Fri, 21 Nov 2014 08:48:58 -0800
X-Google-Sender-Auth: nz8ARmMqrMxvv8Nokbi2h-ZRJDU
Message-ID: <CA+55aFxU2q_-PVx+6fXGkXdAt3oaxvqxzy29Nrn989uTiVXvCg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 8:38 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> If you move the vmalloc fixup before exception_enter() and return if
> the fault was from vmalloc, then you can't recurse.  You need to be
> careful not to touch anything that uses RCU before exception_enter,
> though.

This is probably the right thing to do anyway.

The vmalloc fixup is purely about filling in hardware structures, so
there really shouldn't be any need for RCU or anything else. It should
probably be done first, before *anything* else (like the whole
kmemcheck/kmmio fault etc handling)

That said, the whole vmalloc_fault fixup routine does some odd things,
over and beyond just filling in the page tables. So I'm not 100% sure
that is safe as-is. The 32-bit version looks fine, but the x86-64
version is very very dubious.

The x86-64 version does crazy things like:

 - uses "current->active_mm", which is very dubious
 - flush lazy mmu mode
 - walk down further in the page tables

and those are just bugs, imnsho. Get rid of that crap. The 32-bit code
does it right.

(The 64-bit mode also has a "WARN_ON_ONCE(in_nmi())", which I guess is
good - but it's good because the 64-bit version is written the way it
is).

                    Linus
