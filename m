Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945945Ab3BGW4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:56:54 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:53086 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945894Ab3BGW4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:56:53 -0500
Message-ID: <1360277809.28557.60.camel@edumazet-glaptop>
Subject: Re: [RFC PATCH 1/6] kernel: implement queue spinlock API
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org
Date: Thu, 07 Feb 2013 14:56:49 -0800
In-Reply-To: <20130207223434.GG2545@linux.vnet.ibm.com>
References: <1358896415-28569-1-git-send-email-walken@google.com>
	 <1358896415-28569-2-git-send-email-walken@google.com>
	 <20130207223434.GG2545@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 14:34 -0800, Paul E. McKenney wrote:
> On Tue, Jan 22, 2013 at 03:13:30PM -0800, Michel Lespinasse wrote:
> > Introduce queue spinlocks, to be used in situations where it is desired
> > to have good throughput even under the occasional high-contention situation.
> > 
> > This initial implementation is based on the classic MCS spinlock,
> > because I think this represents the nicest API we can hope for in a
> > fast queue spinlock algorithm. The MCS spinlock has known limitations
> > in that it performs very well under high contention, but is not as
> > good as the ticket spinlock under low contention. I will address these
> > limitations in a later patch, which will propose an alternative,
> > higher performance implementation using (mostly) the same API.
> > 
> > Sample use case acquiring mystruct->lock:
> > 
> >   struct q_spinlock_node node;
> > 
> >   q_spin_lock(&mystruct->lock, &node);
> >   ...
> >   q_spin_unlock(&mystruct->lock, &node);
> 
> It is possible to keep the normal API for MCS locks by having the lock
> holder remember the parameter in the lock word itself.  While spinning,
> the node is on the stack, is not needed once the lock is acquired.
> The pointer to the next node in the queue -is- needed, but this can be
> stored in the lock word.
> 
> I believe that John Stultz worked on something like this some years back,
> so added him to CC.
> 

Hmm...

This could easily break if the spin_lock() is embedded in a function,
and the unlock done in another one.

(storage for the node would disappear at function epilogue )



