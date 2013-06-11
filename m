Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab3FKKOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 06:14:12 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53809 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3FKKOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 06:14:10 -0400
Date: Tue, 11 Jun 2013 03:14:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        sbw@mit.edu
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130611101401.GC5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <1370911480.9844.160.camel@gandalf.local.home>
 <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
 <51B6D76D.9090207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B6D76D.9090207@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061110-4834-0000-0000-000007F213AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 03:53:17PM +0800, Lai Jiangshan wrote:
> On 06/11/2013 08:51 AM, Linus Torvalds wrote:
> > On Mon, Jun 10, 2013 at 5:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >>
> >> OK, I haven't found a issue here yet, but youss are beiing trickssy! We
> >> don't like trickssy, and we must find precccciouss!!!
> > 
> > .. and I personally have my usual reservations. I absolutely hate
> > papering over scalability issues, and historically whenever people
> > have ever thought that we want complex spinlocks, the problem has
> > always been that the locking sucks.
> > 
> > So reinforced by previous events, I really feel that code that needs
> > this kind of spinlock is broken and needs to be fixed, rather than
> > actually introduce tricky spinlocks.
> > 
> > So in order to merge something like this, I want (a) numbers for real
> > loads and (b) explanations for why the spinlock users cannot be fixed.
> > 
> > Because "we might hit loads" is just not good enough. I would counter
> > with "hiding problems causes more of them".
> > 
> 
> Hi, all
> 
> Off-topic, although I am in this community for several years,
> I am not exactly clear with this problem.
> 
> 1) In general case, which lock is the most competitive in the kernel? what it protects for?
> 2) In which special case, which lock is the most competitive in the kernel? what it protects for?
> 3) In general case, which list is the most hot list?
> 4) In which special case, which list is the most hot list?

Others would know better than I, but mmap_sem has been called out as a
prime offender for some workloads.  There is of course some debate as
to whether the fault lies mmap_sem or with the workloads.  There have
been some efforts to solve this one on LKML, plus some in academia have
worked on this as well:

http://people.csail.mit.edu/nickolai/papers/clements-bonsai.pdf
http://pdos.csail.mit.edu/papers/radixvm:eurosys13.pdf

And IIRC this was the subject of a session at a recent minisummit.

There are a few locks within the RCU implementation that have popped
up from time to time on very large systems, but I have dealt with those
and have plans for each should it become a problem.  The plans probably
won't survive first contact with a real workload, but having thought
things through is very helpful.

							Thanx, Paul

