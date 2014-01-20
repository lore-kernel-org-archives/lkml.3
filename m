Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaATAwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 19:52:25 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:49382 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaATAwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 19:52:21 -0500
Date: Sun, 19 Jan 2014 16:52:15 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Matt Turner <mattst88@gmail.com>,
        Waiman Long <waiman.long@hp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Daniel J Blueman <daniel@numascale.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140120005215.GH10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFydYLQeBq=4AQQp_4dAnq09ocLmde1LFaXiNAJ=wJzfFA@mail.gmail.com>
 <20140116103659.GO7572@laptop.programming.kicks-ass.net>
 <20140118100105.GV10038@linux.vnet.ibm.com>
 <20140118113406.GY30183@twins.programming.kicks-ass.net>
 <20140118122548.GX10038@linux.vnet.ibm.com>
 <20140118124136.GZ30183@twins.programming.kicks-ass.net>
 <20140118212227.GA10038@linux.vnet.ibm.com>
 <CA+55aFww9F7DA2V611OjkDyf8nfBVFZkLCu1M243mcj7DKqekA@mail.gmail.com>
 <20140119080405.GB10038@linux.vnet.ibm.com>
 <CA+55aFwPpEOqkhi8C=ck+6WFQJHOW3LsNg-0DxjMm9m1HW1AYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwPpEOqkhi8C=ck+6WFQJHOW3LsNg-0DxjMm9m1HW1AYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012000-1344-0000-0000-0000051081C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 11:56:02AM -0800, Linus Torvalds wrote:
> On Sun, Jan 19, 2014 at 12:04 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > OK, another approach would be to never add "select ARCH_USE_QUEUE_RWLOCK"
> > on Alpha, at least if the queued rwlocks really do want to atomically
> > manipulate bytes.  After all, the Alpha systems that I know about don't
> > have enough CPUs to make queued rwlocks necessary anyway.
> >
> > Much simpler solution!
> >
> > Is this what you were getting at, or am I missing your point?
> 
> You're missing something.
> 
> Just make the "writer" field be an "int" on little-endian archiectures
> (like alpha).
> 
> There is no reason for that field to be a "char" to begin with, as far
> as I can tell, since the padding of the structure means that it
> doesn't save any space. But even if that wasn't true, we could make an
> arch-specific type for "minimum type for locking".

On 64-bit systems (which includes Alpha), agreed, the field can be a
32-bit portion of a 64-bit structure that is then manipulated atomically.
Many 32-bit systems need the reader and writer counts to fix in 32 bits
in order to allow things like queue_read_trylock() to correctly account
for both readers and writers.

If there was a 32-bit system running Linux that did not support byte
accesses, there would be a problem, but I don't know of any such system.

> So my *point* was that it should be easy enough to just make sure that
> any data structures used for locking have types that are appropriate
> for that locking.

So something like the following for the qrwlock definition, with
appropriate C-preprocessor wrappers for the atomic-add accesses?

							Thanx, Paul

------------------------------------------------------------------------

typedef struct qrwlock {
	union qrwcnts {
#ifdef CONFIG_64B
		struct (
			int writer;
			int reader;
		};
		atomic_long_t rwa;
		u64	 rwc;
#else
		struct {
#ifdef __LITTLE_ENDIAN
			u8  writer;	/* Writer state		*/
#else
			u16 r16;	/* Reader count - msb	*/
			u8  r8;		/* Reader count - lsb	*/
			u8  writer;	/* Writer state		*/
#endif
		};
		atomic_t    rwa;	/* Reader/writer atomic	*/
		u32	    rwc;	/* Reader/writer counts */
	} cnts;
#endif
	struct mcs_spinlock *waitq;	/* Tail of waiting queue */
} arch_rwlock_t;

