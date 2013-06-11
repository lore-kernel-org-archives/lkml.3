Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3FKRor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:44:47 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:53619 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab3FKRoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:44:46 -0400
Date: Tue, 11 Jun 2013 10:43:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Waiman Long <waiman.long@hp.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130611174340.GP5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <51B748DA.2070306@hp.com>
 <1370967632.9844.182.camel@gandalf.local.home>
 <20130611164313.GH5146@linux.vnet.ibm.com>
 <1370970833.9844.200.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370970833.9844.200.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061117-7606-0000-0000-00000C602748
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 01:13:53PM -0400, Steven Rostedt wrote:
> On Tue, 2013-06-11 at 09:43 -0700, Paul E. McKenney wrote:
> 
> > > > I am a bit concern about the size of the head queue table itself. RHEL6, 
> > > > for example, had defined CONFIG_NR_CPUS to be 4096 which mean a table 
> > > > size of 256. Maybe it is better to dynamically allocate the table at 
> > > > init time depending on the actual number of CPUs in the system.
> > > 
> > > Yeah, it can be allocated dynamically at boot.
> > 
> > But let's first demonstrate the need.  Keep in mind that an early-boot
> > deadlock would exercise this code.
> 
> I think an early-boot deadlock has more problems than this :-)
> 
> Now if we allocate this before other CPUs are enabled, there's no need
> to worry about accessing it before they are used. They can only be used
> on contention, and there would be no contention when we are only running
> on one CPU.
> 
> >   Yes, it is just a check for NULL,
> > but on the other hand I didn't get the impression that you thought that
> > this code was too simple.  ;-)
> 
> I wouldn't change the code that uses it. It should never be hit, and if
> it is triggered by an early boot deadlock, then I think this would
> actually be a plus. An early boot deadlock would cause the system to
> hang with no feedback whats so ever, causing the developer hours of
> crying for mommy and pulling out their hair because the system just
> stops doing anything except to show the developer a blinking cursor that
> blinks "haha, haha, haha".
> 
> But if an early boot deadlock were to cause this code to be triggered
> and do a NULL pointer dereference, then the system crashes. It would
> most likely produce a backtrace that will give a lot more information to
> the developer to see what is happening here. Sure, it may confuse them
> at first, but then they can say: "why is this code triggering before we
> have other CPUS? Oh, I have a deadlock here" and go fix the code in a
> matter of minutes instead of hours.
> 
> Note, I don't even see this triggering with an early boot deadlock. The
> only way that can happen is if the task tries to take a spinlock it
> already owns, or an interrupt goes off and grabs a spinlock that the
> task currently has but didn't disable interrupts. The ticket counter
> would be just 2, which is far below the threshold that triggers the
> queuing.

Fair point.  I suppose that the hapless kernel hacker could set
the threshold really low for that case.

But we are talking about only 8192 bytes of memory here.  Is that really
enough to worry about on current systems?

							Thanx, Paul

