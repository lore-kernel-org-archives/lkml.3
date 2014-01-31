Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbaAaPJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:09:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48327 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811AbaAaPI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:08:58 -0500
Date: Fri, 31 Jan 2014 16:08:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
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
Subject: Re: [PATCH v3 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
Message-ID: <20140131150832.GG4941@twins.programming.kicks-ass.net>
References: <1390933151-1797-1-git-send-email-Waiman.Long@hp.com>
 <1390933151-1797-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390933151-1797-2-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 01:19:10PM -0500, Waiman Long wrote:
> For single-thread performance (no contention), a 256K lock/unlock
> loop was run on a 2.4Ghz Westmere x86-64 CPU.  The following table
> shows the average time (in ns) for a single lock/unlock sequence
> (including the looping and timing overhead):
> 
>   Lock Type			Time (ns)
>   ---------			---------
>   Ticket spinlock		  14.1
>   Queue spinlock (Normal)	   8.8*

What CONFIG_NR_CPUS ?

Because for CONFIG_NR_CPUS < 128 (or 256 if you got !PARAVIRT), the fast
path code should be:

ticket:

  mov $0x100,eax
  lock xadd %ax,(%rbx)
  cmp %al,%ah
  jne ...

although my GCC is being silly and writes:

  mov $0x100,eax
  lock xadd %ax,(%rbx)
  movzbl %ah,%edx
  cmp %al,%dl
  jne ...

Which seems rather like a waste of a perfectly good cycle.

With a bigger NR_CPUS you do indeed need more ops:

  mov $0x10000,%edx
  lock xadd %edx,(%rbx)
  mov %edx,%ecx
  shr $0x10,%ecx
  cmp %dx,%cx
  jne ...


Whereas for the straight cmpxchg() you'd get something relatively simple
like:

  mov %edx,%eax
  lock cmpxchg %ecx,(%rbx)
  cmp %edx,%eax
  jne ...



Anyway, as soon as you get some (light) contention you're going to tank
because you have to pull in extra cachelines, which is sad.


I suppose we could from the ticket code more and optimize the
uncontended path, but that'll make the contended path more expensive
again, although probably not as bad as hitting a new cacheline.
