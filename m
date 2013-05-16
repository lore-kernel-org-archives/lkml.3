Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3EQHlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 03:41:08 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40187 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3EQHlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 03:41:06 -0400
Date: Thu, 16 May 2013 13:06:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is
 enabled
Message-ID: <20130516200602.GF4442@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
 <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
 <20130515083729.GC10510@laptop.programming.kicks-ass.net>
 <20130515150652.GP23604@redhat.com>
 <1368631622.6828.69.camel@gandalf.local.home>
 <20130515165915.GE13916@laptop.home>
 <1368637441.6828.70.camel@gandalf.local.home>
 <20130516081027.GD19669@dyad.programming.kicks-ass.net>
 <20130516150706.GY4442@linux.vnet.ibm.com>
 <20130516175602.GL19669@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516175602.GL19669@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051707-5406-0000-0000-000008948165
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 07:56:02PM +0200, Peter Zijlstra wrote:
> On Thu, May 16, 2013 at 08:07:06AM -0700, Paul E. McKenney wrote:
> > On Thu, May 16, 2013 at 10:10:27AM +0200, Peter Zijlstra wrote:
> > > On Wed, May 15, 2013 at 01:04:01PM -0400, Steven Rostedt wrote:
> > > > On Wed, 2013-05-15 at 18:59 +0200, Peter Zijlstra wrote:
> > > > 
> > > > > At which point we could run the watchdog without perf_event_task_tick().
> > > > 
> > > > At which point we can drop the disable LOCKUP_DETECTOR when NO_HZ_FULL
> > > > is enabled ;-)
> > > > 
> > > 
> > > Can we? The thing I'm worried about is RCU (of course!). ISTR we rely on RCU
> > > working in NMI context. AFAIR for RCU to work, we need to come out of out magic
> > > NO_HZ state since that would've put RCU into EQS.
> > > 
> > > Frederic, PaulMck?
> > 
> > Not sure I understand the question, but hopefully the verbiage below helps.
> > 
> > Only RCU read-side critical sections need to work in NMI context,
> > and RCU hooks into nmi_enter() and nmi_exit() to handle this, and this
> > will work in NO_HZ_FULL in the same way that it works for NO_HZ_IDLE.
> > 
> > But if there are no NMIs, RCU doesn't care.  In other words, RCU needs
> > to know about NMIs so that it can deal with any RCU read-side critical
> > sections in the NMI handlers, but RCU doesn't rely on NMIs happening at
> > any particular time or frequency.
> 
> I suppose the fundamental question was: will receiving NMIs negate NO_HZ_FULL's
> functionality? That is, will the getting of NMIs make us drop out of NO_HZ_FULL
> and re-enable all sorts of things?
> 
> Because clearly RCU needs to exit from EQS, which might (or might not) mean
> leaving NO_HZ_FULL.
> 
> I'm not entirely up-to-date on those details.

My belief is that NMIs won't cause NO_HZ_FULL to kick that CPU out of
adaptive-ticks mode, but I must defer to Frederic on that.

Of course, the NMI -will- cause OS jitter on whichever CPU handles it,
which some people would want to avoid.

							Thanx, Paul

