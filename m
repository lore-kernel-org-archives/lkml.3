Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3LTTaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:30:18 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:28001 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3LTTaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:30:15 -0500
Message-ID: <1387567810.2704.19.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 20 Dec 2013 11:30:10 -0800
In-Reply-To: <CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	 <1387478746-5436-5-git-send-email-davidlohr@hp.com>
	 <CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 15:14 -0800, Linus Torvalds wrote:
> 
> So I still think this can be done without that new counter field, or
> any new atomics.
> 
> hb_waiters_pending() could be something like
> 
>     spin_contended(hb->lock) || !list_empty(&hb->chain)
> 
> which considering where you increment the new count should be
> equivalent to your "!!hb->waiters". The smp_mb_after_atomic_inc()" on
> the spinlock side would become smp_mb_after_spin_lock() instead.

So we'd need the barrier right after the ticket increment (ie: the xadd
TICKET_LOCK_INC in x86), and cannot rely on the barrier after the lock
is taken as we could miss waiters that are just spinning trying to take
it. Is this implicitly guaranteed across all archs?

Thanks,
Davidlohr

