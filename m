Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaJRTcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 15:32:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:33919 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbaJRTcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 15:32:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,745,1406617200"; 
   d="scan'208";a="621115108"
Message-ID: <5442C045.2040909@linux.intel.com>
Date: Sat, 18 Oct 2014 14:32:21 -0500
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
CC: Matteo Franchin <Matteo.Franchin@arm.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH] futex: Ensure get_futex_key_refs() always implies a barrier
References: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/14 11:38, Catalin Marinas wrote:
> Commit b0c29f79ecea (futexes: Avoid taking the hb->lock if there's
> nothing to wake up) changes the futex code to avoid taking a lock when
> there are no waiters. This code has been subsequently fixed in commit
> 11d4616bd07f (futex: revert back to the explicit waiter counting code).
> Both the original commit and the fix-up rely on get_futex_key_refs() to
> always imply a barrier.
> 
> However, for private futexes, none of the cases in the switch statement
> of get_futex_key_refs() would be hit and the function completes without
> a memory barrier as required before checking the "waiters" in
> futex_wake() -> hb_waiters_pending(). The consequence is a race with a
> thread waiting on a futex on another CPU, allowing the waker thread to
> read "waiters == 0" while the waiter thread to have read "futex_val ==
> locked" (in kernel).


Verified that this is:

a) how it is documented to work
b) not how it actually works currently

Nice catch indeed.

...

> diff --git a/kernel/futex.c b/kernel/futex.c
> index 815d7af2ffe8..f3a3a071283c 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -343,6 +343,8 @@ static void get_futex_key_refs(union futex_key *key)
>  	case FUT_OFF_MMSHARED:
>  		futex_get_mm(key); /* implies MB (B) */
>  		break;
> +	default:

A comment here indicating this covers the PROCESS_PRIVATE futex case
would be welcome, given the complexity involved.

> +		smp_mb(); /* explicit MB (B) */

Also, the "Basic" futex operation and ordering guarantees documentation
currently reads:

 * Where (A) orders the waiters increment and the futex value read through
 * atomic operations (see hb_waiters_inc) and where (B) orders the write
 * to futex and the waiters read -- this is done by the barriers in
 * get_futex_key_refs(), through either ihold or atomic_inc, depending
on the
 * futex type.

Which is not incomplete (lacking the explicit smp_mb()) added by this
patch. Perhaps the MB implementation of get_futex_key_refs() need not be
explicitly enumerated here?

-- 
Darren Hart
Intel Open Source Technology Center
