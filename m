Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3IXCor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 22:44:47 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:47431 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3IXCoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 22:44:46 -0400
Date: Tue, 24 Sep 2013 04:44:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
Message-ID: <20130924024422.GA13923@localhost.localdomain>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
 <20130920162603.GA30381@localhost.localdomain>
 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
 <1379799901.24090.6.camel@pasglop>
 <1379911234.6625.7.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379911234.6625.7.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 02:40:34PM +1000, Benjamin Herrenschmidt wrote:
> On Sun, 2013-09-22 at 07:45 +1000, Benjamin Herrenschmidt wrote:
> > What I *can* do that would help I suppose would be to switch to the irq
> > stack before irq_enter/exit which would at least mean that softirq would
> > run from the top of the irq stack which is better than the current
> > situation.
> > 
> > I'm fact I'll whip up a quick fix see if that might be enough of a band
> > aid for RHEL7.
> 
> OK I've done that, it seems to work so far. Heads up guys: i386 and sparc
> at least seem to need the same treatment. I haven't looked at others except
> ARM which doesn't seem to have irq stacks to begin with.
> 
> We can also instead apply Fred's series to put back in the switch to the
> softirq stack since this is actually a regression , but then, arguably,
> making sure irq_exit() is called off the irq stack is better and means
> we do one instead of two stack switches.
> 
> Fred: Maybe revert partially under an arch #define/Kconfig so we can get
> the best of both worlds ?

Aye, I did not realize that's indeed a regression, caused by
("irq: Sanitize invoke_softirq") facd8b80c67a3cf64a467c4a2ac5fb31f2e6745b
which converted do_softirq() to __do_softirq() on irq_exit(). It indeed
looked like the macro-conditional call was only there for irq disability
reasons. But then these crashes...

So the safest way to fix this is to unconditionally call do_softirq() from irq_exit().
A performance penalty may come along but safety primes.

We should probably do that and work on longer term solutions (Kconfig based arch switch, etc...)
for the next merge window?

I'll respin the series plus the regression fix, unless somebody has a better solution.

Thanks.
