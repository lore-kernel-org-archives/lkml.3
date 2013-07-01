Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3GATRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:17:05 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40886 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3GATRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:17:02 -0400
Date: Mon, 1 Jul 2013 12:16:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full v2 2/7] nohz_full: Add rcu_dyntick data for
 scalable detection of all-idle state
Message-ID: <20130701191656.GR3773@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130628200949.GA17458@linux.vnet.ibm.com>
 <1372450222-19420-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1372450222-19420-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130701153150.GB2923@leaf>
 <20130701155220.GL3773@linux.vnet.ibm.com>
 <20130701181601.GA7964@jtriplet-mobl1>
 <20130701182326.GQ3773@linux.vnet.ibm.com>
 <20130701183412.GA18804@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701183412.GA18804@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070119-3620-0000-0000-0000035BF92E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 11:34:13AM -0700, Josh Triplett wrote:
> On Mon, Jul 01, 2013 at 11:23:26AM -0700, Paul E. McKenney wrote:
> > On Mon, Jul 01, 2013 at 11:16:01AM -0700, Josh Triplett wrote:
> > > On Mon, Jul 01, 2013 at 08:52:20AM -0700, Paul E. McKenney wrote:
> > > > On Mon, Jul 01, 2013 at 08:31:50AM -0700, Josh Triplett wrote:
> > > > > On Fri, Jun 28, 2013 at 01:10:17PM -0700, Paul E. McKenney wrote:
> > > > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > > 
> > > > > > This commit adds fields to the rcu_dyntick structure that are used to
> > > > > > detect idle CPUs.  These new fields differ from the existing ones in
> > > > > > that the existing ones consider a CPU executing in user mode to be idle,
> > > > > > where the new ones consider CPUs executing in user mode to be busy.
> > > > > 
> > > > > Can you explain, both in the commit messages and in the comments added
> > > > > by the next commit, *why* this code doesn't consider userspace a
> > > > > quiescent state?
> > > > 
> > > > Good point!  Does the following explain it?
> > > > 
> > > > 	Although one of RCU's quiescent states is usermode execution,
> > > > 	it is not a full-system idle state.  This is because the purpose
> > > > 	of the full-system idle state is not RCU, but rather determining
> > > > 	when accurate timekeeping can safely be disabled.  Whenever
> > > > 	accurate timekeeping is required in a CONFIG_NO_HZ_FULL kernel,
> > > > 	at least one CPU must keep the scheduling-clock tick going.
> > > > 	If even one CPU is executing in user mode, accurate timekeeping
> > > > 	is requires, particularly for architectures where gettimeofday()
> > > > 	and friends do not enter the kernel.  Only when all CPUs are
> > > > 	really and truly idle can accurate timekeeping be disabled,
> > > > 	allowing all CPUs to turn off the scheduling clock interrupt,
> > > > 	thus greatly improving energy efficiency.
> > > > 
> > > > 	This naturally raises the question "Why is this code in RCU rather
> > > > 	than in timekeeping?", and the answer is that RCU has the data
> > > > 	and infrastructure to efficiently make this determination.
> > > 
> > > Good explanation, thanks.
> > > 
> > > This also naturally raises the question "How can we let userspace get
> > > accurate time without forcing a timer tick?".
> > 
> > We don't.  ;-)
> 
> We don't currently, hence my question about how we can. :)

Per-CPU atomic clocks?  Hardware-synchronized time across all CPUs?
Hardware detection of the full-system idle state, allowing the hardware
synchronization to be shut down in that case?  (But of course started with
full synchronization whenever something went non-idle!)  Use a periodic
hrtimer instead of the scheduling-clock tick?  (Aside from the fact that
the scheduling-clock tick is already an hrtimer in some configurations...)

The last might not be as silly as it sounds.  I believe that timekeeping
can tolerate an interrupt rate much slower than HZ, so if the timekeeping
CPU figured out that the only reason for the scheduling-clock tick
was timekeeping, it could run the tick much more slowly.  That said,
I wouldn't blame Frederic for deferring that particular increment of
complexity for a bit.  ;-)

> > Without CONFIG_NO_HZ_FULL, if a CPU is running in user mode, that CPU
> > takes scheduling-clock interrupts.  User-mode code will therefore always
> > see accurate time.  For some definition of "accurate", anyway.
> > 
> > With CONFIG_NO_HZ_FULL and without CONFIG_NO_HZ_FULL_SYSIDLE, a single
> > designated CPU will always be taking scheduling-clock interrupts, which
> > again ensures that user-mode code will always see accurate time.
> > 
> > With both CONFIG_NO_HZ_FULL and CONFIG_NO_HZ_FULL_SYSIDLE, if
> > any CPU other than the timekeeping CPU is nonidle (where "nonidle"
> > includes usermode execution), then the timekeeping CPU will be taking
> > scheduling-clock interrupts, yet again ensuring that user-mode code will
> > always see accurate time.  If all CPUs are idle (in other words, we are
> > in RCU_SYSIDLE_FULL_NOTED state and the timekeeping CPU is also idle),
> > scheduling-clock interrupts will be globally disabled.  Or will be,
> > once I fix the bug noted by Frederic.
> > 
> > I am guessing that you would like this added to the explanation?  ;-)
> 
> Seemed pretty clear already from your previous explanation above, but
> since you've taken the time to write it... :)

If the above sufficed, the additional verbiage might add more confusion
than understanding.  ;-)

							Thanx, Paul

