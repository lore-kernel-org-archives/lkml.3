Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbaDGLYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 07:24:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42927 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaDGLYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 07:24:20 -0400
Date: Mon, 7 Apr 2014 13:24:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, tglx@linutronix.de, ben@decadent.org.uk,
        mkl@pengutronix.de, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] net: sched: dev_deactivate_many(): use msleep(1) instead
 of yield() to wait for outstanding qdisc_run callsb
Message-ID: <20140407112413.GI11096@twins.programming.kicks-ass.net>
References: <20140402110743.GG27965@twins.programming.kicks-ass.net>
 <1396437459.3989.39.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140404151942.GI10526@twins.programming.kicks-ass.net>
 <20140404.112850.1541183418380443600.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140404.112850.1541183418380443600.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 11:28:50AM -0400, David Miller wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri, 4 Apr 2014 17:19:42 +0200
> 
> > And the above loop in tcp_output() is a plain memory deadlock, you
> > should not loop on allocations like that. If the allocation fails;
> > propagate the error.
> 
> There is nothing to "propagate" it to.  We have no "event" that will
> trigger so that we have a second chance to send the FIN out, it really
> must go out before we progress any further at this stage.

>From what I remember of TCP/IP the FIN packet is used once per
connection; to terminate said connection. So if we pre-allocate one per
connection, at establishment time (where we can still easily fail) we
should be good and safe.

Now, I suppose there's valid arguments against this -- wasted memory
being one I suspect.

Also, seeing how this code has basically been this way forever and has
not caused (afaik) any actual memory deadlocks (they're hard anyway). We
might just get away with not touching it.

That said, at the very least we want a comment here stating that this is
a potential memory deadlock and why the alternatives aren't any good, so
that future readers (possibly us again) know this has been considered.
