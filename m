Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3IXBTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 21:19:50 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:51474 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3IXBTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 21:19:48 -0400
MIME-Version: 1.0
In-Reply-To: <1379981427.5443.8.camel@pasglop>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	<CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	<alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	<20130920162603.GA30381@localhost.localdomain>
	<CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	<CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	<1379799901.24090.6.camel@pasglop>
	<523E4F8A.7020708@zytor.com>
	<1379824754.24090.11.camel@pasglop>
	<1379824861.24090.12.camel@pasglop>
	<20130922162410.GA10649@laptop.programming.kicks-ass.net>
	<1379887000.24090.19.camel@pasglop>
	<CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
	<1379981427.5443.8.camel@pasglop>
Date: Mon, 23 Sep 2013 18:19:47 -0700
X-Google-Sender-Auth: PNR1AkvlC0Np0IskoJUpP4qd6PA
Message-ID: <CA+55aFwyVG4DXOEvaVTp0gE-H2Zy0Kx7Mg7RWzpxzwm_RSWEYQ@mail.gmail.com>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 5:10 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> BTW, that boils down to a choice between using r13 as either a TLS for
> current or current_thread_info, or as a per-cpu pointer, which one is
> the most performance critical ?

I think you can tune most of the architecture setup to best suit your needs.

For example, on x86, we don't have much choice: the per-cpu accessors
are going to be faster than the alternatives, and there are patches
afoot to tune the preempt and rcu-readside counters to use the percpu
area (and then save/restore things at task switch time). But having
the counters natively in the thread_info struct is fine too and is
what we do now.

Generally, we've put the performance-critical stuff into
"current_thread_info" as opposed to "current", so it's likely that if
the choice is between those two, then you might want to pick %r13
pointing to the thread-info rather than the "struct task_struct" (ie
things like low-level thread flags). But which is better probably
depends on load, and again, some of it you can tweak by just making
per-architecture structure choices and making the macros point at one
or the other.

There's a few things that really depend on per-cpu areas, but I don't
think it's a huge performance issue if you have to indirect off memory
to get that. Most of the performance issues with per-cpu stuff is
about avoiding cachelines ping-ponging back and forth, not so much
about fast direct access. Of course, if some load really uses a *lot*
of percpu accesses, you get both.

The advantage of having %r13 point to thread data (which is "stable"
as far as the compiler is concerned) as opposed to having it be a
per-cpu pointer (which can change randomly due to task switching) is
that from a correctness standpoint I really do think that either
thread-info or current is *much* easier to handle than using it for
the per-cpu base pointer.

             Linus
