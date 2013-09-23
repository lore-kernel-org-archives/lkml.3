Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab3IWElk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 00:41:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:34534 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab3IWElj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 00:41:39 -0400
Message-ID: <1379911234.6625.7.camel@pasglop>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Date: Mon, 23 Sep 2013 14:40:34 +1000
In-Reply-To: <1379799901.24090.6.camel@pasglop>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	 <20130920162603.GA30381@localhost.localdomain>
	 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	 <1379799901.24090.6.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-22 at 07:45 +1000, Benjamin Herrenschmidt wrote:
> What I *can* do that would help I suppose would be to switch to the irq
> stack before irq_enter/exit which would at least mean that softirq would
> run from the top of the irq stack which is better than the current
> situation.
> 
> I'm fact I'll whip up a quick fix see if that might be enough of a band
> aid for RHEL7.

OK I've done that, it seems to work so far. Heads up guys: i386 and sparc
at least seem to need the same treatment. I haven't looked at others except
ARM which doesn't seem to have irq stacks to begin with.

We can also instead apply Fred's series to put back in the switch to the
softirq stack since this is actually a regression , but then, arguably,
making sure irq_exit() is called off the irq stack is better and means
we do one instead of two stack switches.

Fred: Maybe revert partially under an arch #define/Kconfig so we can get
the best of both worlds ?

Cheers,
Ben.


