Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaFJRc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:32:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaFJRc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:32:56 -0400
Date: Tue, 10 Jun 2014 19:32:51 +0200 (CEST)
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
Message-ID: <alpine.LNX.2.00.1406101917410.1321@pobox.suse.cz>
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

It's OTOH rather useful in a few scenarios -- particularly it's the only 
way to dump stacktraces from remote CPUs in order to obtain traces that 
actually make sense (in situations like RCU stall); using workqueue-based 
dumping is useless there.

> I'd much rather disallow it, and if there is one or two places that
> really want to print a warning and know that they are in NMI context,
> have a special workaround just for them, with something that does
> *not* try to make printk in general work any better.

Well, that'd mean that at least our stack dumping mechanism would need to 
know both ways of printing; but yes, it'll still probably be less than 880 
lines added.

> Dammit, NMI context is special. I absolutely refuse to buy into the
> broken concept that we should make more stuff work in NMI context.
> Hell no, we should *not* try to make more crap work in NMI. NMI people
> should be careful.

In parallel, I'd for the sake of argument propose to just drop the whole 
_CONT printing (and all the things that followed on top) as that made 
printk() a complete hell to maintain for a disputable gain IMO.

> Make a trivial "printk_nmi()" wrapper that tries to do a trylock on
> logbuf_lock, and *maybe* the existing sequence of
> 
>         if (console_trylock_for_printk())
>                 console_unlock();
> 
> then works for actually triggering the printout. But the wrapper
> should be 15 lines of code for "if possible, try to print things", and
> *not* a thousand lines of changes.

Well, we are carrying much simpler fix for this whole braindamage in our 
enterprise kernel that is from pre-7ff9554bb578 era, and it was rather 
simple fix in principle (the diffstat is much larger than it had to be due 
to code movements):

	http://kernel.suse.com/cgit/kernel/commit/?h=SLE11-SP3&id=8d62ae68ff61d77ae3c4899f05dbd9c9742b14c9

But after the scary 7ff9554bb578 and its successors, things got a lot more 
complicated.

-- 
Jiri Kosina
SUSE Labs
