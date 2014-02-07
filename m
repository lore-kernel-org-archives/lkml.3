Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaBGSRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:17:48 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:54625 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbaBGSRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:17:46 -0500
Date: Fri, 7 Feb 2014 10:17:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
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
Message-ID: <20140207181737.GS4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1390933151-1797-1-git-send-email-Waiman.Long@hp.com>
 <1390933151-1797-2-git-send-email-Waiman.Long@hp.com>
 <20140131150832.GG4941@twins.programming.kicks-ass.net>
 <52EBF871.5020603@hp.com>
 <20140203114054.GH8874@twins.programming.kicks-ass.net>
 <52F2FD2A.1020704@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F2FD2A.1020704@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020718-0928-0000-0000-000006574A1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 10:10:34PM -0500, Waiman Long wrote:
> On 02/03/2014 06:40 AM, Peter Zijlstra wrote:
> >On Fri, Jan 31, 2014 at 02:24:33PM -0500, Waiman Long wrote:
> >>Light contention is the only case where the qspinlock may not perform as
> >>good as the ticket spinlock. I know this is the most common case. However, I
> >>would argue that the slowdown, if any, will not be really noticeable. This
> >>is what I will try to find out.
> >Please also explain why things are slower/faster. Thomas tried to get
> >you to do so a few months back, but you kept deflecting.
> 
> It is not easy to have a test case to test light contention. I am
> trying to create custom test case to get that data.

Here are some ways of doing that:

1.	Provide (say) a thousand locks for each thread, so that you
	have all of these locks in one big array of locks.  Have each
	thread loop, where each pass through the loop acquires
	and releases a randomly selected lock.	Then measure the
	acquisition/release throughput.

2.	As #1 above, but vary the number of locks per thread in order to
	vary the level of contention in a controlled manner.  Note that
	the cache-miss probability is (N-1)/N, where where N is the
	number of threads, at least assuming each thread gets its own CPU.

3.	Provide each thread with its own lock and have each thread
	loop, where each pass through the loop acquires and releases
	the thread's lock.  This eliminates both contention and
	cache misses.

4.	As #1 above, but randomly acquire some other thread's lock with
	controlled probability to introduce controlled levels of both
	contention and cache misses.

5.	As #4 above, but provide each thread with multiple locks
	randomly selected to allow cache miss rate to be increased
	independently of contention.

All approaches require extremely efficient random-number generators,
for example, independent per-thread generators.

							Thanx, Paul

