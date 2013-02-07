Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3BGXxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:53:24 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47698 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3BGXxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:53:23 -0500
Date: Thu, 7 Feb 2013 15:53:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org
Subject: Re: [RFC PATCH 1/6] kernel: implement queue spinlock API
Message-ID: <20130207235318.GJ2545@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1358896415-28569-1-git-send-email-walken@google.com>
 <1358896415-28569-2-git-send-email-walken@google.com>
 <20130207223434.GG2545@linux.vnet.ibm.com>
 <1360277809.28557.60.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360277809.28557.60.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020723-3620-0000-0000-00000122BDBA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 02:56:49PM -0800, Eric Dumazet wrote:
> On Thu, 2013-02-07 at 14:34 -0800, Paul E. McKenney wrote:
> > On Tue, Jan 22, 2013 at 03:13:30PM -0800, Michel Lespinasse wrote:
> > > Introduce queue spinlocks, to be used in situations where it is desired
> > > to have good throughput even under the occasional high-contention situation.
> > > 
> > > This initial implementation is based on the classic MCS spinlock,
> > > because I think this represents the nicest API we can hope for in a
> > > fast queue spinlock algorithm. The MCS spinlock has known limitations
> > > in that it performs very well under high contention, but is not as
> > > good as the ticket spinlock under low contention. I will address these
> > > limitations in a later patch, which will propose an alternative,
> > > higher performance implementation using (mostly) the same API.
> > > 
> > > Sample use case acquiring mystruct->lock:
> > > 
> > >   struct q_spinlock_node node;
> > > 
> > >   q_spin_lock(&mystruct->lock, &node);
> > >   ...
> > >   q_spin_unlock(&mystruct->lock, &node);
> > 
> > It is possible to keep the normal API for MCS locks by having the lock
> > holder remember the parameter in the lock word itself.  While spinning,
> > the node is on the stack, is not needed once the lock is acquired.
> > The pointer to the next node in the queue -is- needed, but this can be
> > stored in the lock word.
> > 
> > I believe that John Stultz worked on something like this some years back,
> > so added him to CC.
> > 
> 
> Hmm...
> 
> This could easily break if the spin_lock() is embedded in a function,
> and the unlock done in another one.
> 
> (storage for the node would disappear at function epilogue )

But that is OK -- the storage is used only for spinning on.  Once a given
task has actually acquired the lock, that storage is no longer needed.
What -is- needed is the pointer to the next CPU's node, and that node
is guaranteed to persist until the next CPU acquires the lock, which
cannot happen until this CPU releases that lock.

							Thanx, Paul

