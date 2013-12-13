Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab3LMTRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:17:48 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61643 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3LMTRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:17:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXs16E1WZ4FL=r9BkLBF-q7B432pzpVoGiH-53HZxVx-Q@mail.gmail.com>
References: <20131213145657.265414969@infradead.org>
	<20131213150640.846368594@infradead.org>
	<CAMuHMdXs16E1WZ4FL=r9BkLBF-q7B432pzpVoGiH-53HZxVx-Q@mail.gmail.com>
Date: Fri, 13 Dec 2013 20:17:46 +0100
X-Google-Sender-Auth: 9CZV-aObsg1zUPk2auzP4vsKlFw
Message-ID: <CAMuHMdU1d8T=A2dM8rY86xrZ5WYj9pLme6pc08ypxwCAUC123g@mail.gmail.com>
Subject: Fwd: [PATCH 3/4] arch: Clean up asm/barrier.h implementations using asm-generic/barrier.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Woops, misspelling of kernel.org in the original email...

---------- Forwarded message ----------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, Dec 13, 2013 at 8:16 PM
Subject: Re: [PATCH 3/4] arch: Clean up asm/barrier.h implementations
using asm-generic/barrier.h
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
linux-kernel@vger.kerne.org, Paul McKenney
<paulmck@linux.vnet.ibm.com>, Linus Torvalds
<torvalds@linux-foundation.org>, Victor Kaplansky
<VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>, Anton Blanchard
<anton@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
Frédéric Weisbecker <fweisbec@gmail.com>, Mathieu Desnoyers
<mathieu.desnoyers@polymtl.ca>, Michael Ellerman
<michael@ellerman.id.au>, Michael Neuling <mikey@neuling.org>, Russell
King <linux@arm.linux.org.uk>, Martin Schwidefsky
<schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>,
Tony Luck <tony.luck@intel.com>


Hi Peter,

On Fri, Dec 13, 2013 at 3:57 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> There are a few architectures (m32r, m68k) that could probably
> do away with their barrier.h file entirely but are kept for now due to
> their unconventional nop() implementation.

m32r uses `__asm__ __volatile__ ("nop" : : )' instead of
`asm volatile ("nop")'. Isn't the latter just a shorthand of the former?

m68k has an additional `barrier()', which I think is unneeded.
I looked at the asm output for drivers/block/ataflop.c and
drivers/video/macfb.c, with and without the barrier.
For ataflop, there were no differences.
For macfb, removing the barrier allowed the compiler to keep the base
addresses of the MMIO registers in registers, but there were no changes
to the register accesses themselves.

So IMHO both m32r and m68k can switch to the asm-generic version.

I'm wondering whether we can just drop nop() from the in-kernel API?
There are few users outside arch/:

drivers/block/ataflop.c
drivers/net/ethernet/amd/am79c961a.c
drivers/tty/serial/crisv10.c
drivers/video/macfb.c

>From a quick glance, all of them (ab)use nop() instead of one of the other
primitives. For the macfb case, it seems to be due to missing ordering
inside the nubus_*() I/O accessors.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds


-- 
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
