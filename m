Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab3KXDqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 22:46:34 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:57259 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab3KXDqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 22:46:32 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1311231206380.30673@ionos.tec.linutronix.de>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
	<1385168197-8612-5-git-send-email-davidlohr@hp.com>
	<CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>
	<1385176773.5402.14.camel@buesod1.americas.hpqcorp.net>
	<alpine.DEB.2.02.1311231206380.30673@ionos.tec.linutronix.de>
Date: Sat, 23 Nov 2013 19:46:31 -0800
X-Google-Sender-Auth: 8ZsYCH_m-2f-154OVDMfU_uhD_c
Message-ID: <CA+55aFwzRqPHKp67EhJ9hsX4v5=p3uQxvnaVZko2ZXDf6CQAPQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>, "Norton, Scott J" <scott.norton@hp.com>,
        tom.vaden@hp.com, "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>, Jason Low <jason.low2@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 5:16 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Now the question is why we queue the waiter _AFTER_ reading the user
> space value. The comment in the code is pretty non sensical:
>
>    * On the other hand, we insert q and release the hash-bucket only
>    * after testing *uaddr.  This guarantees that futex_wait() will NOT
>    * absorb a wakeup if *uaddr does not match the desired values
>    * while the syscall executes.
>
> There is no reason why we cannot queue _BEFORE_ reading the user space
> value. We just have to dequeue in all the error handling cases, but
> for the fast path it does not matter at all.
>
> CPU 0                                   CPU 1
>
>     val = *futex;
>     futex_wait(futex, val);
>
>     spin_lock(&hb->lock);
>
>     plist_add(hb, self);
>     smp_wmb();
>
>     uval = *futex;
>                                         *futex = newval;
>                                         futex_wake();
>
>                                         smp_rmb();
>                                         if (plist_empty(hb))
>                                            return;
> ...

This would seem to be a nicer approach indeed, without needing the
extra atomics.

Davidlohr, mind trying Thomas' approach?

             Linus
