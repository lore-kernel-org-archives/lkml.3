Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaFJPUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:20:13 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46034 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaFJPUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:20:10 -0400
Date: Tue, 10 Jun 2014 08:20:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
 unprotected when accessed by /proc)
Message-ID: <20140610152006.GA30219@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140603172632.GA27956@redhat.com>
 <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
 <20140603200125.GB1105@redhat.com>
 <20140606203350.GU4581@linux.vnet.ibm.com>
 <20140608130718.GA11129@redhat.com>
 <20140609162613.GE4581@linux.vnet.ibm.com>
 <20140610083726.GY3213@twins.programming.kicks-ass.net>
 <20140610125234.GI4581@linux.vnet.ibm.com>
 <20140610130138.GC3213@twins.programming.kicks-ass.net>
 <20140610143632.GM4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610143632.GM4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061015-6688-0000-0000-00000277FB57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 07:36:32AM -0700, Paul E. McKenney wrote:
> On Tue, Jun 10, 2014 at 03:01:38PM +0200, Peter Zijlstra wrote:
> > On Tue, Jun 10, 2014 at 05:52:35AM -0700, Paul E. McKenney wrote:
> > > On Tue, Jun 10, 2014 at 10:37:26AM +0200, Peter Zijlstra wrote:
> > > > On Mon, Jun 09, 2014 at 09:26:13AM -0700, Paul E. McKenney wrote:
> > > > > That would indeed be a bad thing, as it could potentially lead to
> > > > > use-after-free bugs.  Though one could argue that any code that resulted
> > > > > in use-after-free would be quite aggressive.  But still...
> > > > 
> > > > Let me hijack this thread for yet another issue... So I had an RCU
> > > > related use-after-free the other day, and while Sasha was able to
> > > > trigger it quite easily, I had a multi-day struggle to reproduce.
> > > > 
> > > > Once I figured out what the exact problem was it was also clear to me
> > > > why it was so hard for me to reproduce.
> > > > 
> > > > So normally its easier to trigger races on bigger machines, more cpus,
> > > > more concurrency, more races, all good.
> > > > 
> > > > _However_ with RCU the grace period machinery is slower the bigger the
> > > > machine, so bigger machine, slower grace period, slower RCU free, less
> > > > likely to hit use-after-free.
> > > > 
> > > > So I was thinking, and I know you all will go kick me for this because
> > > > the very last thing we need is what I'm about to propose: more RCU
> > > > flavours :-).
> > > > 
> > > > How about an rcu_read_unlock() reference counted RCU variant that's
> > > > ultra aggressive in doing the callbacks in order to better trigger such
> > > > issues?
> > > 
> > > If you are using synchronize_rcu() for the update side, then I suggest
> > > rcutorture.gp_exp=1 to force use expediting throughout.
> > 
> > No such luck, this was regular kfree() from call_rcu(). And the callback
> > execution was typically delayed long enough to never 'see' the
> > use-after-free.
> 
> Figures.  ;-)
> 
> Well, there is always the approach of booting your big systems with most
> of the CPUs turned off.  Another approach would be to set HZ=10000 or
> some such, assuming the kernel can actually survive that kind of abuse.

And yet another approach is to have a pair of low-priority processes
per CPU that context-switch back and forth to each other if that CPU
has nothing else to do.  This should get rid of most of the increase in
grace-period duration with increasing numbers of CPUs.

							Thanx, Paul

