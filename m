Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab3IWU6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:58:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:45053 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab3IWU6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:58:37 -0400
Message-ID: <1379969837.11249.24.camel@pasglop>
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
Date: Tue, 24 Sep 2013 06:57:17 +1000
In-Reply-To: <5240819F.4050903@tilera.com>
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
	 <5240819F.4050903@tilera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 13:59 -0400, Chris Metcalf wrote:
> We just came up against this on tilegx with a customer bug report in a
> PREEMPT environment.  On tile, %tp is a GPR that points to the percpu area.
> The following seems to be the right abstraction -- though I'd also argue
> that letting barrier() clobber not just memory, but %tp, might be a better
> solution, but it's not clear what the best way is to do per-architecture
> overrides of per-compiler definitions like barrier().  See also the ARM v7
> code, which has to do something similar, though their percpu pointer is
> not a GPR, which changes the tradeoffs somewhat.

Hrm, if I read correctly what you did is that you read "tp" into another
register *and* also mark that action as clobbering the top int on the stack ?

I don't quite get what the stack clobber brings you here and how it works
around the fact that gcc might still cache that copy of tp into another
register accross preempt_enable/disable...

It's hard to tell with gcc ... the best I've had so far as an option was
something that would mark my per-cpu register (r13) *itself* as clobbered...

Cheers,
Ben.


