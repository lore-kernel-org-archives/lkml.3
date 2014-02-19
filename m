Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbaBSIwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:52:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49698 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaBSIwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:52:45 -0500
Date: Wed, 19 Feb 2014 09:52:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v4 1/3] qspinlock: Introducing a 4-byte queue spinlock
 implementation
Message-ID: <20140219085225.GH27965@twins.programming.kicks-ass.net>
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
 <1392669684-4807-2-git-send-email-Waiman.Long@hp.com>
 <20140218073951.GZ27965@twins.programming.kicks-ass.net>
 <5303B6F3.9090001@hp.com>
 <20140218213400.GS14089@laptop.programming.kicks-ass.net>
 <5303FFC5.5040004@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5303FFC5.5040004@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 07:50:13PM -0500, Waiman Long wrote:
> On 02/18/2014 04:34 PM, Peter Zijlstra wrote:
> >On Tue, Feb 18, 2014 at 02:39:31PM -0500, Waiman Long wrote:
> >>The #ifdef is harder to take away here. The point is that doing a 32-bit
> >>exchange may accidentally steal the lock with the additional code to handle
> >>that. Doing a 16-bit exchange, on the other hand, will never steal the lock
> >>and so don't need the extra handling code. I could construct a function with
> >>different return values to handle the different cases if you think it will
> >>make the code easier to read.
> >Does it really pay to use xchg() with all those fixup cases? Why not
> >have a single cmpxchg() loop that does just the exact atomic op you
> >want?
> 
> The main reason for using xchg instead of cmpxchg is its performance impact
> when the lock is heavily contended. Under those circumstances, a task may
> need to do several tries of read+atomic-RMV before getting it right. This
> may cause a lot of cacheline contention. With xchg, we need at most 2 atomic
> ops. Using cmpxchg() does simplify the code a bit at the expense of
> performance with heavy contention.

Have you actually measured this?
