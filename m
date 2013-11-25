Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3KYMIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:08:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab3KYMIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:08:12 -0500
Date: Mon, 25 Nov 2013 13:08:10 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 3/4] printk: Defer printing to irq work when we printed
 too much
Message-ID: <20131125120810.GA30165@quack.suse.cz>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
 <1383860919-1883-4-git-send-email-jack@suse.cz>
 <CAFTL4hw6wO+3Y8EpW3_swodfyV9UAaLF-KE6KC+u-5sKjKY7eA@mail.gmail.com>
 <20131107225733.GE2054@quack.suse.cz>
 <20131107232148.GE28130@localhost.localdomain>
 <20131107183717.0fc9eb6e@gandalf.local.home>
 <20131107234647.GG28130@localhost.localdomain>
 <20131108102113.GB6343@quack.suse.cz>
 <20131122152711.c644e5acf02b61668c63b59c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122152711.c644e5acf02b61668c63b59c@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 22-11-13 15:27:11, Andrew Morton wrote:
> On Fri, 8 Nov 2013 11:21:13 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > On Fri 08-11-13 00:46:49, Frederic Weisbecker wrote:
> > > On Thu, Nov 07, 2013 at 06:37:17PM -0500, Steven Rostedt wrote:
> > > > On Fri, 8 Nov 2013 00:21:51 +0100
> > > > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > > 
> > > > > Offloading to a workqueue would be perhaps better, and writing to the serial
> > > > > console could then be done with interrupts enabled, preemptible context, etc...
> > > > 
> > > > Oh God no ;-)  Adding workqueue logic into printk just spells a
> > > > nightmare of much more complexity for a critical kernel infrastructure.
> > > 
> > > But yeah that's scary, that means workqueues itself can't printk that safely.
> > > So, you're right after all.
> >   Yeah, we've been there (that was actually my initial proposal). But
> > Andrew and Steven (rightfully) objected and suggested irq_work should be
> > used instead.
> 
> I still hate the patchset and so does everyone else, including you ;)
> There must be something smarter we can do.  Let's start by restating
> the problem:
> 
> CPU A is in printk, emitting log_buf characters to a slow device. 
> Meanwhile other CPUs come into printk(), see that the system is busy,
> dump their load into log_buf then scram, leaving CPU A to do even more
> work.
> 
> Correct so far?
  Yes, correct.

> If so, what is the role of local_irq_disabled() in this?  Did CPU A
> call printk() with local interrupts disabled, or is printk (or the
> console driver) causing the irqs-off condition?  Where and why is this
> IRQ disablement happening?
  So there are couple of places where we disable interrupts.
a) call_console_drivers() which does the printing to console is always
   called with interrupts disabled. Commonly it is called from
   console_unlock() which takes care of disabling interrupts. I presume
   this is because we want to guard against interrupts doing something
   unexpected with the console while we are printing to it. But I don't
   really understand console drivers to be sure...
b) vprintk_emit() (which is the function usually calling console_unlock())
   also disables interrupts to make updates of log_buf interrupt safe. It
   calls console_unlock() with interrupts disabled which seems to be
   unnecessary as that function takes care of disabling interrupts itself.
   It makes the situation somewhat worse because console_unlock() could
   otherwise enable interrupts from time to time. That being said I've
   tried to fix this shortcoming in previous versions of the patch set but
   it didn't seem to make a difference - maybe
     local_irq_restore(flags);
     spin_lock_irqsafe(&logbuf_lock, flags);
   which is what console_unlock() does, doesn't give APIC enough time to
   deliver blocked interrupts.
c) printk() itself is sometimes called with interrupts disabled. This
   happens a lot for example from sysrq handlers which is sometimes
   unpleasant (sysrq-s simply kills large machines) but not a primary
   concern for me. It doesn't seem to happen too often after an early boot
   is finished (in particular SCSI messages which make machines unbootable
   seem to be generated from kernel thread context). But there are some
   messages like this and if we are unlucky and we get caught in such
   printk, the machine dies. So I believe we have to reliably handle a
   situation when printk() itself gets called with interrupts disabled.
  
> Could we fix this problem by not permitting CPUs B, C and D to DoS CPU
> A?  When CPU B comes into printk() and sees that printk is busy, make
> CPU A hand over to CPU B and let CPU A get out of there?
  We could. In fact I was proposing this in
https://lkml.org/lkml/2013/9/5/329
  It has the advantage that we won't rely on irq work. If we changed
console_trylock() to console_lock() in console_trylock_for_printk() and
made console_unlock() only print the messages in log_buf on function entry,
it would even make things simpler but it would basically undo your change
from ages ago and I'm not sure about consequences. All printk()s could
suddently block much more since printk() would essentially become
completely synchronous.

We could try some more fancy compromise between current "completely async
printk" and ancient "completely synchronous printk" but then it gets more
complex and so far dependence on irq work seemed as a lesser evil to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
