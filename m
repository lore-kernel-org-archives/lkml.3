Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3CJVEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 17:04:33 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56342 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab3CJVEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 17:04:32 -0400
Date: Sun, 10 Mar 2013 14:04:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        paul.gortmaker@windriver.com, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: irq_work: WARNING: at kernel/irq_work.c:98
 irq_work_needs_cpu+0x8a/0xb0()
Message-ID: <20130310210423.GA3601@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <51397B96.7030008@oracle.com>
 <20130308164435.GI3268@linux.vnet.ibm.com>
 <513A2CF1.9060006@oracle.com>
 <20130308194608.GK3268@linux.vnet.ibm.com>
 <513A4E8F.2020704@oracle.com>
 <20130308222058.GP3268@linux.vnet.ibm.com>
 <513CD568.90409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513CD568.90409@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031021-7182-0000-0000-000005B92078
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 02:48:08PM -0400, Sasha Levin wrote:
> On 03/08/2013 05:20 PM, Paul E. McKenney wrote:
> > Alternatively, given that this is a debug option, how about replacing
> > the schedule_timeout_uninterruptible() with something like the following:
> > 
> > 	{
> > 		unsigned long starttime = jiffies + 2;
> > 
> > 		while (ULONG_CMP_LT(jiffies, starttime))
> > 			cpu_relax();
> > 	}
> > 
> > That way the RCU GP kthread would never go to sleep, and thus would not
> > have to wait for the timer to wake it up.  If this works, then my next
> > thought would be to try to get at the timer state for the wakeup fo
> > schedule_timeout_uninterruptible().
> 
> It did the trick, I still see those IRQ warnings but the RCU lockup
> is gone.

So it looks like RCU's problem was that when it gave up the CPU, it never got
it back.  The earlier warning looks to be due to getting an interrupt on
a CPU that had already marked itself offline.  If this interrupt was the
timer interrupt that was supposed to wake up RCU, that would explain the
RCU hang -- but I thought that timers got migrated during the offline
procedure.  Of course, we are shutting down as well.

Hmmmm...  In case this is inherent, I should condition that debug
statement with "system_state == SYSTEM_RUNNING".

							Thanx, Paul

