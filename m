Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaI3QR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:17:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40973 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbaI3QR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:17:27 -0400
Date: Tue, 30 Sep 2014 18:17:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, ego@linux.vnet.ibm.com,
        Waiman.Long@hp.com
Subject: Re: locking/lockdep: Revert qrwlock recusive stuff
Message-ID: <20140930161723.GA4473@pd.tnic>
References: <20140930124807.GA4241@worktop.programming.kicks-ass.net>
 <20140930132600.GA7444@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140930132600.GA7444@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 03:26:00PM +0200, Peter Zijlstra wrote:
> 
> Now with locking self test reverted too and extra changelog.
> 
> 
> ---
> Subject: locking/lockdep: Revert qrwlock recusive stuff
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Tue, 30 Sep 2014 14:48:07 +0200
> 
> Commit f0bab73cb539 ("locking/lockdep: Restrict the use of recursive
> read_lock() with qrwlock") changed lockdep to try and conform to the
> qrwlock semantics which differ from the traditional rwlock semantics.
> 
> In particular qrwlock is fair outside of interrupt context, but in
> interrupt context readers will ignore all fairness.
> 
> The problem modeling this is that read and write side have different
> lock state (interrupts) semantics but we only have a single
> representation of these. Therefore lockdep will get confused, thinking
> the lock can cause interrupt lock inversions.
> 
> So revert for now; the old rwlock semantics were already imperfectly
> modeled and the qrwlock extra won't fit either.
> 
> If we want to properly fix this, I think we need to resurrect the work
> by Gautham did a few years ago that split the read and write state of
> locks:
> 
>    http://lwn.net/Articles/332801/
> 
> FWIW the locking selftest that would've failed (and was reported by
> Borislav earlier) is something like:
> 
>   RL(X1);	/* IRQ-ON */
>   LOCK(A);
>   UNLOCK(A);
>   RU(X1);
> 
>   IRQ_ENTER();
>   RL(X1);	/* IN-IRQ */
>   RU(X1);
>   IRQ_EXIT();
> 
> At which point it would report that because A is an IRQ-unsafe lock we
> can suffer the following inversion:
> 
> 	CPU0		CPU1
> 
> 	lock(A)
> 			lock(X1)
> 			lock(A)
> 	<IRQ>
> 	 lock(X1)
> 
> And this is 'wrong' because X1 can recurse (assuming the above lock are
> in fact read-lock) but lockdep doesn't know about this.
> 
> Cc: ego@linux.vnet.ibm.com
> Cc: bp@alien8.de

Tested-by: Borislav Petkov <bp@suse.de>

Thanks!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
