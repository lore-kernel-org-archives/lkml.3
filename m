Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaBKDkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 22:40:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:46960 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbaBKDkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 22:40:15 -0500
Message-ID: <1392089915.3996.60.camel@pasglop>
Subject: Re: [PATCH v2] powerpc ticket locks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Torsten Duwe <duwe@lst.de>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Wood <scottwood@freescale.com>, Tom Musta <tommusta@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Feb 2014 14:38:35 +1100
In-Reply-To: <20140211025645.GJ18016@ZenIV.linux.org.uk>
References: <20140207165801.GC2107@lst.de>
	 <1392001823.3996.21.camel@pasglop> <20140210155217.GF2107@lst.de>
	 <1392086660.3996.50.camel@pasglop>
	 <20140211025645.GJ18016@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 02:56 +0000, Al Viro wrote:
> > So the question is, is it reasonable to have the ref smaller than
> > 32-bit...
> 
> Every time you open a file, you bump dentry refcount.  Something like
> libc or ld.so will be opened on just about every execve(), so I'd say
> that 16 bits is far too low.  If nothing else, 32 bits might be too
> low on 64bit boxen...

So back to square 1 ... we can't implement together lockref, ticket
locks, and our lock confer mechanism within 64-bit.

I see two options at this stage. Both require a custom implementation
of lockref for powerpc, so some ifdef's such that we can replace the
generic implementation completely.

 - We can use a small ref, and when it's too big, overflow into a larger
one, falling back to the "old style" lock + ref (an overflow bit or a
compare with ffff)

 - We can have lockref "build" it's own lock out of the ticketpair and
ref, keeping the owner in a separate word. The owner doesn't strictly
need to be atomic.

Both are gross though :(

Anybody has a better idea ?

Ben.


