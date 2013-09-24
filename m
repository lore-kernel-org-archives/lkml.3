Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3IXU7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 16:59:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:60882 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab3IXU7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 16:59:21 -0400
Message-ID: <1380056293.5443.63.camel@pasglop>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
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
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 25 Sep 2013 06:58:13 +1000
In-Reply-To: <5241E7A1.3010800@tilera.com>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	 <20130920162603.GA30381@localhost.localdomain>
	 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	 <1379799901.24090.6.camel@pasglop>	<523E4F8A.7020708@zytor.com>
	 <1379824754.24090.11.camel@pasglop>	<1379824861.24090.12.camel@pasglop>
	 <20130922162410.GA10649@laptop.programming.kicks-ass.net>
	 <1379887000.24090.19.camel@pasglop>
	 <CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
	 <5240819F.4050903@tilera.com> <1379969837.11249.24.camel@pasglop>
	 <5241E7A1.3010800@tilera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-24 at 15:27 -0400, Chris Metcalf wrote:
> > It's hard to tell with gcc ... the best I've had so far as an option was
> > something that would mark my per-cpu register (r13) *itself* as clobbered...
> 
> Well, as I said above, that would be better, but it requires providing an
> alternate definition of barrier() that is per-architecture, not just
> per-compiler.  

My compiler people tell me "clobbered" is wrong. It will tell the
compiler that barrier() damages r13 (or whatever other register you use)
and instead make it do exactly the wrong thing which is to back it up
before the barrier and use the backup :-)

I'm told what we need is an empty asm that marks r13 as an *output* (and
possible an input as well to be safe).

I will experiment.

> If there's interest in pursuing a solution like that, it
> would be technically somewhat better; in particular, with PREEMPT_NONE,
> you could treat the "tp" register int as locally scoped in an inline, and
> the compiler wouldn't have to reload it after function calls.  Presumably
> we'd need to pick an asm header that could provide an arch_barrier_clobbers
> string that would be added to barrier() for gcc if it were defined.

My idea was to add a preempt_barrier() and put that in preempt_enable/disable
and the various irq enable/disable.

Cheers,
Ben.


