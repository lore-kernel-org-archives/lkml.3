Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaFKJBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:01:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbaFKJBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:01:10 -0400
Date: Wed, 11 Jun 2014 11:01:06 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
Message-ID: <20140611090106.GK7772@pathway.suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
 <alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz>
 <20140529000909.GC6507@localhost.localdomain>
 <alpine.LNX.2.00.1405290959270.17241@pobox.suse.cz>
 <20140610164641.GD1951@localhost.localdomain>
 <CA+55aFzseOqF-EpKMvwKpfhBJZQSLqKpJ3shzVee9s0+mvyCuA@mail.gmail.com>
 <alpine.LNX.2.00.1406101917410.1321@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1406101917410.1321@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-06-10 19:32:51, Jiri Kosina wrote:
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
> 
> It's OTOH rather useful in a few scenarios -- particularly it's the only 
> way to dump stacktraces from remote CPUs in order to obtain traces that 
> actually make sense (in situations like RCU stall); using workqueue-based 
> dumping is useless there.
> 
> > Make a trivial "printk_nmi()" wrapper that tries to do a trylock on
> > logbuf_lock, and *maybe* the existing sequence of
> > 
> >         if (console_trylock_for_printk())
> >                 console_unlock();
> > 
> > then works for actually triggering the printout. But the wrapper
> > should be 15 lines of code for "if possible, try to print things", and
> > *not* a thousand lines of changes.

I am afraid that basically this is done in my patch set. It does
trylock and uses the main buffer when possible. I am just not able to
squeeze it into 15 lines :-(

One problem is that we do not want to loose the messages,
e.g. stacktraces. We need to store them somewhere and merge them into
the main ring buffer later.

> Well, we are carrying much simpler fix for this whole braindamage in our 
> enterprise kernel that is from pre-7ff9554bb578 era, and it was rather 
> simple fix in principle (the diffstat is much larger than it had to be due 
> to code movements):
> 
> 	http://kernel.suse.com/cgit/kernel/commit/?h=SLE11-SP3&id=8d62ae68ff61d77ae3c4899f05dbd9c9742b14c9
> 
> But after the scary 7ff9554bb578 and its successors, things got a lot more 
> complicated.

Yes, another big problem is the above mentioned commit. The reading from the
temporary storage has to be in the normal context and thus lockless.
It is much more complicated when we work with whole messages and all
the added flags.

Also note that we want to save the last messages when the temporary storage
is full. This is why I used a ring buffer and was not able to use a
more simple producer and consumer algorithm.


Best Regards,
Petr
