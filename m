Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819Ab3DJK2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:28:35 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:38546 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab3DJK2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:28:34 -0400
Date: Wed, 10 Apr 2013 12:28:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH RFC 1/3] mutex: Make more scalable by doing less atomic
 operations
Message-ID: <20130410102829.GA28505@gmail.com>
References: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com>
 <1365087258-7169-2-git-send-email-Waiman.Long@hp.com>
 <20130408124223.GA10093@gmail.com>
 <51630168.40403@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51630168.40403@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <Waiman.Long@hp.com> wrote:

> > Furthermore, since you are seeing this effect so profoundly, have you 
> > considered using another approach, such as queueing all the poll-waiters in 
> > some fashion?
> >
> > That would optimize your workload additionally: removing the 'stampede' of 
> > trylock attempts when an unlock happens - only a single wait-poller would get 
> > the lock.
>
> The mutex code in the slowpath has already put the waiters into a sleep queue 
> and wait up only one at a time.

Yes - but I'm talking about spin/poll-waiters.

> [...] However, there are 2 additional source of mutex lockers besides those in 
> the sleep queue:
>
> 1. New tasks trying to acquire the mutex and currently in the fast path.
> 2. Mutex spinners (CONFIG_MUTEX_SPIN_ON_OWNER on) who are spinning
> on the owner field and ready to acquire the mutex once the owner
> field change.
> 
> The 2nd and 3rd patches are my attempts to limit the second types of mutex 
> lockers.

Even the 1st patch seems to do that, it limits the impact of spin-loopers, right?

I'm fine with patch #1 [your numbers are proof enough that it helps while the low 
client count effect seems to be in the noise] - the questions that seem open to me 
are:

 - Could the approach in patch #1 be further improved by an additional patch that 
   adds queueing to the _spinners_ in some fashion - like ticket spin locks try to
   do in essence? Not queue the blocked waiters (they are already queued), but the
   active spinners. This would have additional benefits, especially with a high
   CPU count and a high NUMA factor, by removing the stampede effect as owners get 
   switched.

 - Why does patch #2 have an effect? (it shouldn't at first glance) It has a 
   non-trivial cost, it increases the size of 'struct mutex' by 8 bytes, which 
   structure is embedded in numerous kernel data structures. When doing 
   comparisons I'd suggest comparing it not to just vanilla, but to a patch that
   only extends the struct mutex data structure (and changes no code) - this
   allows the isolation of cache layout change effects.

 - Patch #3 is rather ugly - and my hope would be that if spinners are queued in
   some fashion it becomes unnecessary.

Thanks,

	Ingo
