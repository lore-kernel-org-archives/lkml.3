Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab3LJBcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:32:52 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:32780 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3LJBcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:32:47 -0500
X-Originating-IP: 173.246.103.110
Date: Mon, 9 Dec 2013 17:32:31 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v5 tip/core/locking 5/7]
 Documentation/memory-barriers.txt: Downgrade UNLOCK+LOCK
Message-ID: <20131210013231.GA24138@jtriplet-mobl1>
References: <20131210012738.GA24317@linux.vnet.ibm.com>
 <1386638883-25379-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386638883-25379-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386638883-25379-5-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 05:28:01PM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Historically, an UNLOCK+LOCK pair executed by one CPU, by one task,
> or on a given lock variable has implied a full memory barrier.  In a
> recent LKML thread, the wisdom of this historical approach was called
> into question: http://www.spinics.net/lists/linux-mm/msg65653.html,
> in part due to the memory-order complexities of low-handoff-overhead
> queued locks on x86 systems.
> 
> This patch therefore removes this guarantee from the documentation, and
> further documents how to restore it via a new smp_mb__after_unlock_lock()
> primitive.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Waiman Long <waiman.long@hp.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Peter Hurley <peter@hurleysoftware.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  Documentation/memory-barriers.txt | 51 +++++++++++++++++++++++++++++++++------
>  1 file changed, 44 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index a0763db314ff..efb791d33e5a 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -1626,7 +1626,10 @@ for each construct.  These operations all imply certain barriers:
>       operation has completed.
>  
>       Memory operations issued before the LOCK may be completed after the LOCK
> -     operation has completed.
> +     operation has completed.  An smp_mb__before_spinlock(), combined
> +     with a following LOCK, acts as an smp_wmb().  Note the "w",
> +     this is smp_wmb(), not smp_mb().  The smp_mb__before_spinlock()
> +     primitive is free on many architectures.

Gah.  That seems highly error-prone; why isn't that
"smp_wmb__before_spinlock()"?

- Josh Triplett
