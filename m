Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966093AbaFRLDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:03:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965376AbaFRLDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:03:08 -0400
Date: Wed, 18 Jun 2014 13:03:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
In-Reply-To: <CA+55aFzseOqF-EpKMvwKpfhBJZQSLqKpJ3shzVee9s0+mvyCuA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1406181245230.2303@pobox.suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz> <alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz> <20140529000909.GC6507@localhost.localdomain> <alpine.LNX.2.00.1405290959270.17241@pobox.suse.cz> <20140610164641.GD1951@localhost.localdomain>
 <CA+55aFzseOqF-EpKMvwKpfhBJZQSLqKpJ3shzVee9s0+mvyCuA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Linus Torvalds wrote:

> > Lets be crazy and Cc Linus on that.
> 
> Quite frankly, I hate seeing something like this:
> 
>  kernel/printk/printk.c              | 1218 +++++++++++++++++++++++++----------
> 
> for something that is stupid and broken. Printing from NMI context
> isn't really supposed to work, and we all *know* it's not supposed to
> work.
> 
> I'd much rather disallow it, and if there is one or two places that
> really want to print a warning and know that they are in NMI context,
> have a special workaround just for them, with something that does
> *not* try to make printk in general work any better.
> 
> Dammit, NMI context is special. I absolutely refuse to buy into the
> broken concept that we should make more stuff work in NMI context.
> Hell no, we should *not* try to make more crap work in NMI. NMI people
> should be careful.
> 
> Make a trivial "printk_nmi()" wrapper that tries to do a trylock on
> logbuf_lock, and *maybe* the existing sequence of
> 
>         if (console_trylock_for_printk())
>                 console_unlock();
> 
> then works for actually triggering the printout. But the wrapper
> should be 15 lines of code for "if possible, try to print things", and
> *not* a thousand lines of changes.

Alright, so this went silent again without any real progress. Is everyone 
hoping this gets sorted out on kernel summit, or ... ?

Let me sum up the current situation:

- both RCU stall detector and 'echo l > sysrq-trigger' can (and we've 
  seen it happening for real) cause a complete, undebuggable, silent hang 
  of machine (deadlock in NMI context)

- before 7ff9554bb578 and friends, this was trivial to fix more or less 
  exactly the way Linus is proposing above. We've been carrying the 
  fix in our kernels for a while already [1]. With printk() having got  
  overly complicated recently, the "in principle trivial" fix turns out  
  into crazy mess due to handling of all the indexes, sequence numbers, 
  etc.

- printk() from NMI is actually useful in rare cases (such as inter-CPU 
  stack dumping)

- using lockless buffers that trace_printk() is using has its own 
  problems, as described by Petr elsewhere in this thread


I find it rather outrageous that fixing *real bugs* (leading to hangs) 
becomes impossible due to printk() being too complex. It's very 
unfortunate that the same level of pushback didn't happen when new 
features (that actually *made* it so complicated) have been pushed; that 
would be much more valuable an appropriate.

I believe Jan Kara is in the same situation with his softlockup fixes for 
printk. Those are real problems, as they are bringing machines down, and 
after two years, still not fixed, because "printk() code is scary enough 
as-is"

[1] http://kernel.suse.com/cgit/kernel/commit/?h=SLE11-SP3&id=8d62ae68ff61d77ae3c4899f05dbd9c9742b14c9

-- 
Jiri Kosina
SUSE Labs
