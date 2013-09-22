Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3IVWBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:01:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:48068 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab3IVWBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:01:07 -0400
Message-ID: <1379887206.24090.22.camel@pasglop>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Date: Mon, 23 Sep 2013 08:00:06 +1000
In-Reply-To: <523F2D21.5070505@zytor.com>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	 <20130920162603.GA30381@localhost.localdomain>
	 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	 <1379799901.24090.6.camel@pasglop> <523E4F8A.7020708@zytor.com>
	 <1379824754.24090.11.camel@pasglop> <1379824861.24090.12.camel@pasglop>
	 <20130922162410.GA10649@laptop.programming.kicks-ass.net>
	 <523F2D21.5070505@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-22 at 10:47 -0700, H. Peter Anvin wrote:
> On 09/22/2013 09:24 AM, Peter Zijlstra wrote:
> > 
> > As to the problem of GCC moving r13 about, some archs have some
> > exceptions in the register allocator and leave some registers alone.
> > IIRC MIPS has this and uses one of those (istr there's 2) for the
> > per cpu base address.
> > 
> 
> You can force gcc to leave a register alone with the command line option
> -ffixed-r13.

Haven't tried that in a while but iirc, from the discussions I had with
the gcc folks, it didn't work the way we wanted.

Basically, it still assumes that it's not going to change at random
points, I can't have something like

register volatile unsigned long pre_cpu_offset asm("r13")

It will barf on the "volatile" and if I don't have it, it will make
assumptions that r13 doesn't change, and thus might copy its value
in another cpu accross preempt_enable/disable.

I think I need another sessions with gcc folks on that one.

Cheers,
Ben.


