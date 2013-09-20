Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3IVVsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:48:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab3IVVrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:47:55 -0400
Date: Fri, 20 Sep 2013 23:55:45 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, hare@suse.de,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/4 v6] Avoid softlockups in console_unlock()
Message-ID: <20130920215545.GA22181@quack.suse.cz>
References: <1377072512-7986-1-git-send-email-jack@suse.cz>
 <20130821142723.5fd8c0b0062b35ee83a68dcc@linux-foundation.org>
 <20130821225915.GA16653@quack.suse.cz>
 <20130822124913.c6de8fe61e9fd601bd83ff63@linux-foundation.org>
 <alpine.LNX.2.00.1308232146250.25124@deuxcents.site>
 <20130823125822.b3f5b946ef1e86c52834d0c3@linux-foundation.org>
 <20130905154612.GD19782@quack.suse.cz>
 <20130919142627.2b67463baea318c7d26fe6af@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919142627.2b67463baea318c7d26fe6af@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 19-09-13 14:26:27, Andrew Morton wrote:
> On Thu, 5 Sep 2013 17:46:12 +0200 Jan Kara <jack@suse.cz> wrote:
> > On Fri 23-08-13 12:58:22, Andrew Morton wrote:
> > > On Fri, 23 Aug 2013 21:48:36 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:
> > > 
> > > > > >   We have customers (quite a few of them actually) which have machines with
> > > > > > lots of SCSI disks attached (due to multipath etc.) and during boot when
> > > > > > these disks are discovered and partitions set up quite some printing
> > > > > > happens - multiplied by the number of devices (1000+) it is too much for a
> > > > > > serial console to handle quickly enough. So these machines aren't able to
> > > > > > boot with serial console enabled.
> > > > > 
> > > > > It sounds like rather a corner case, not worth mucking up the critical
> > > > > core logging code.
> > > > 
> > > > Andrew, I have to admit I don't understand this argument at all.
> > > 
> > > Of course you do.  print should be simple, robust and have minimum
> > > dependency on other kernel parts.
> > > 
> > > I suppose that if you make the proposed
> > > /proc/sys/kernel/max_printk_chars settable from the boot command line
> > > and default to zero, any risks are minimized.
> >   That's easy enough to do so if it makes you happy I'll go for that.
> > During my vacation I was also thinking how I could address some of your
> > concerns. The only idea I found plausible was a scheme where CPU that
> > wants to stop printing would raise some flag but still keep printing
> > releasing and reacquiring the console_sem from time to time. In
> > console_trylock_for_printk() we would block waiting for console_sem
> > if we see the flag raised.
> > 
> > This way we would be guaranteed someone has really taken over printing
> > before we leave console_unlock(). We would still need to use irq_work so
> > that we have someone to take over printing in case printk storm has filled
> > our dmesg buffer and we are now slowly getting it out to the console.
> > 
> > So all in all this would be a bit more complex than my current solution
> > (additional flag and some logic around it). The advantage is that we would
> > rely on irq_work only to achieve reasonable irq latency but it won't be
> > necessary for getting printk out to console. If this addresses your
> > concerns better I could try implementing that. Thoughts?
> > 
> 
> What driver is in use here, anyway? 
> Is it drivers/tty/serial/8250/8250_early.c?
  It is 8250 serial (at least in report I have checked now). However I don't
think it's early console - the lockup reports contain traces e.g. with
serial8250_console_putchar() which is a standard serial console (but I may
be wrong here).
 
> I'm not sure that I fully undertand the problem yet.  You say "These
> patches avoid softlockups when a CPU gets caught in console_unlock()
> for a long time during heavy printing from other CPU".  But *why* is
> the printing CPU holding the lock for so long?  A single printk won't
> take a huge amount of time, so that CPU must be spinning waiting for
> previously-printk'd characters to drain?
  Yes. We want to print a message, we enter concole_unlock() on some CPU
and start sending characters via serial console. While we are doing that,
other CPUs come and add new messages to the kernel buffer. We also have to
send those to serial console which even prolongs the window during which
other CPUs have time to add new messages to the buffer. So the time we can
spend in console_unlock() doing printing is currently unbounded - while
other CPUs keep coming with messages, current holder of console_sem keeps
printing.

> Or something else?
> See, if we can get to the bottom of this then perhaps we can pace the
> printing CPU so that it somehow twiddles thumbs outside console_lock().
  I've actually tried to do this in some of my previous attempts to tackle
the problem. The problem I hit with that approach was that printk() itself
is often called with interrupts disabled. So to be able to reenable
interrupts within reasonable time, we have to return from such printk()
first.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
