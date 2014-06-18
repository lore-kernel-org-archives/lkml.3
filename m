Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbaFROgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:36:22 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48014 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaFROgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:36:20 -0400
Date: Wed, 18 Jun 2014 07:36:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>, Kay Sievers <kay@vrfy.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
Message-ID: <20140618143612.GC4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
 <alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz>
 <20140529000909.GC6507@localhost.localdomain>
 <alpine.LNX.2.00.1405290959270.17241@pobox.suse.cz>
 <20140610164641.GD1951@localhost.localdomain>
 <CA+55aFzseOqF-EpKMvwKpfhBJZQSLqKpJ3shzVee9s0+mvyCuA@mail.gmail.com>
 <alpine.LNX.2.00.1406181245230.2303@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1406181245230.2303@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061814-7164-0000-0000-00000285EA70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 01:03:05PM +0200, Jiri Kosina wrote:
> On Tue, 10 Jun 2014, Linus Torvalds wrote:
> 
> > > Lets be crazy and Cc Linus on that.
> > 
> > Quite frankly, I hate seeing something like this:
> > 
> >  kernel/printk/printk.c              | 1218 +++++++++++++++++++++++++----------
> > 
> > for something that is stupid and broken. Printing from NMI context
> > isn't really supposed to work, and we all *know* it's not supposed to
> > work.
> > 
> > I'd much rather disallow it, and if there is one or two places that
> > really want to print a warning and know that they are in NMI context,
> > have a special workaround just for them, with something that does
> > *not* try to make printk in general work any better.
> > 
> > Dammit, NMI context is special. I absolutely refuse to buy into the
> > broken concept that we should make more stuff work in NMI context.
> > Hell no, we should *not* try to make more crap work in NMI. NMI people
> > should be careful.
> > 
> > Make a trivial "printk_nmi()" wrapper that tries to do a trylock on
> > logbuf_lock, and *maybe* the existing sequence of
> > 
> >         if (console_trylock_for_printk())
> >                 console_unlock();
> > 
> > then works for actually triggering the printout. But the wrapper
> > should be 15 lines of code for "if possible, try to print things", and
> > *not* a thousand lines of changes.
> 
> Alright, so this went silent again without any real progress. Is everyone 
> hoping this gets sorted out on kernel summit, or ... ?
> 
> Let me sum up the current situation:
> 
> - both RCU stall detector and 'echo l > sysrq-trigger' can (and we've 
>   seen it happening for real) cause a complete, undebuggable, silent hang 
>   of machine (deadlock in NMI context)

I could easily add an option to RCU to allow people to tell it not to
use NMIs to dump the stack.  Would that help?

							Thanx, Paul

> - before 7ff9554bb578 and friends, this was trivial to fix more or less 
>   exactly the way Linus is proposing above. We've been carrying the 
>   fix in our kernels for a while already [1]. With printk() having got  
>   overly complicated recently, the "in principle trivial" fix turns out  
>   into crazy mess due to handling of all the indexes, sequence numbers, 
>   etc.
> 
> - printk() from NMI is actually useful in rare cases (such as inter-CPU 
>   stack dumping)
> 
> - using lockless buffers that trace_printk() is using has its own 
>   problems, as described by Petr elsewhere in this thread
> 
> 
> I find it rather outrageous that fixing *real bugs* (leading to hangs) 
> becomes impossible due to printk() being too complex. It's very 
> unfortunate that the same level of pushback didn't happen when new 
> features (that actually *made* it so complicated) have been pushed; that 
> would be much more valuable an appropriate.
> 
> I believe Jan Kara is in the same situation with his softlockup fixes for 
> printk. Those are real problems, as they are bringing machines down, and 
> after two years, still not fixed, because "printk() code is scary enough 
> as-is"
> 
> [1] http://kernel.suse.com/cgit/kernel/commit/?h=SLE11-SP3&id=8d62ae68ff61d77ae3c4899f05dbd9c9742b14c9
> 
> -- 
> Jiri Kosina
> SUSE Labs
> 

