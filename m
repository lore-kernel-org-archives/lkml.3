Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3FZPCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:02:20 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36949 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3FZPCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:02:18 -0400
Date: Wed, 26 Jun 2013 07:31:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 0/8] Provide infrastructure for full-system
 idle
Message-ID: <20130626143104.GL3828@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130625213721.GA19452@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1306252345210.4013@ionos.tec.linutronix.de>
 <51CA3FBF.6080201@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CA3FBF.6080201@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062614-4834-0000-0000-0000086D695B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 06:11:27PM -0700, Andy Lutomirski wrote:
> On 06/25/2013 02:49 PM, Thomas Gleixner wrote:
> > On Tue, 25 Jun 2013, Paul E. McKenney wrote:
> >> Note that this version pays attention to CPUs that have taken an NMI
> >> from idle.  It is not clear to me that NMI handlers can safely access
> >> the time on a system that is long-term idle.  Unless someone tells me
> >> that it is somehow safe to access time from an NMI from idle, I will
> >> remove NMI support in the next version.
> > 
> > NMI cannot access any time related functions independent of NOHZ, long
> > term idle or whatever you come up with:
> > 
> >        write_seqcount_begin(&timekeeper_seq);
> > 
> > ---> NMI
> > 	...
> > 	do {
> > 	   seq = read_seqcount_begin(&timekeeper_seq);
> > 	} while (read_seqcount_retry(&timekeeper_seq, seq));
> > 
> > Guess how well that works ....
> > 
> > Thanks,
> > 
> > 	tglx
> > 
> 
> Is this something worth fixing?  One of the things on my infinitely long
> todo list is to replace that seqcount with a wait-free data structure,
> in which case this would be okay.  I don't care about NMIs, but this
> would mean that clock_gettime would never stall just because the
> timekeeping code was running somewhere -- at worse you'd get a couple
> extra cache misses.
> 
> The data structure is described here:
> 
> http://link.springer.com/chapter/10.1007%2F978-3-540-92221-6_40
> 
> (Sorry, this was my first paper and is therefore not so well written.
> Also, it costs $30, although I think I'm allowed to email copies out and
> probably even host them on a website somewhere.)
> 
> The main downside would be a possible loss of monotonicity, like this:
> 
> Thread a: read the timekeeping data
> Thread b: update the timekeeping data
> Thread c: start and finish reading the time (using new data)
> Thread a: read new raw clock value but compute using old timekeeping data
> 
> This would be fixable.
> 
> The data structure is essentially an array of copies of the protected
> data, which can be called bin 0, 1, 2, ..., N.  The data is versioned,
> just like with seqcount.  Bin i contains the most recent copy of the
> data that had a version number that's a multiple of 2^i, but any bin can
> also be marked as invalid if it's being written.

If I remember correctly, something like this was proposed some years
back, but was rejected because it was not possible to set a bound on
how long a given thread would be using a given array element, which
could result in all elements being both in use and out of date.

It is possible to avoid this, but the only way I can see to do so
re-introduces retries.

> To write: update all bins that need updating (that is 1 + num trailing
> zeros in the new version number), starting at the highest number.
> 
> To read starting at bin i: try to read bin i (just like with a
> seqcount).  If that fails, then recursively read starting at bin i+1.
> As a double-check, re-try bin i.  If the retry fails but the recursive
> read succeeded, return the value from the recursive read.
> 
> The only way this can fail is if you race with ~2^N writes.  You can try
> to read in a loop to avoid this problem.
> 
> Unlike a seqcount, you need to race with more than 1 write, which
> eliminates this deadlock -- writers have to make continuous progress for
> readers to get stuck.  But it's extremely unlikely that a reader ever
> has to loop.

Unless I am missing something, you still have to have readers loop, but
reduce the probability of them having to do so.  Assuming that you were
willing to reuse old entries, you could avoid the deadlock that Thomas
pointed out, but at the cost of reusing an arbitrarily old entry in the
case where the NMI happened at the end of a long full-system idle period.
Which might not be such a good thing!

Therefore, I still intend to remove the NMI detection.

							Thanx, Paul

