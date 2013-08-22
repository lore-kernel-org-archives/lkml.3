Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3HVV5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:57:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab3HVV5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:57:44 -0400
Date: Thu, 22 Aug 2013 23:57:42 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        mhocko@suse.cz, hare@suse.de, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/4 v6] Avoid softlockups in console_unlock()
Message-ID: <20130822215742.GA32040@quack.suse.cz>
References: <1377072512-7986-1-git-send-email-jack@suse.cz>
 <20130821142723.5fd8c0b0062b35ee83a68dcc@linux-foundation.org>
 <20130821225915.GA16653@quack.suse.cz>
 <20130822124913.c6de8fe61e9fd601bd83ff63@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822124913.c6de8fe61e9fd601bd83ff63@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 22-08-13 12:49:13, Andrew Morton wrote:
> On Thu, 22 Aug 2013 00:59:15 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> > On Wed 21-08-13 14:27:23, Andrew Morton wrote:
> > > On Wed, 21 Aug 2013 10:08:28 +0200 Jan Kara <jack@suse.cz> wrote:
> > > 
> > > > These patches avoid softlockups when a CPU gets caught in console_unlock() for
> > > > a long time during heavy printing from other CPU. As is discussed in patch 3/4
> > > > it isn't enough to just silence the watchdog because if CPU spends too long in
> > > > console_unlock() also RCU will complain, other CPUs can be blocked waiting for
> > > > printing CPU to process IPI, and even disk can be offlined because commands
> > > > couldn't be delivered to it for too long.
> > > > 
> > > > This patch series solves the problem by stopping printing in console_unlock()
> > > > after 1000 characters and the printing is postponed to irq work. To avoid
> > > > hogging a single CPU (irq work gets processed on the same CPU where it was
> > > > queued so it doesn't really help to reduce the printing load on that CPU) we
> > > > introduce a new type of lazy irq work - IRQ_WORK_UNBOUND - which can be
> > > > processed by any CPU.
> > > 
> > > I still hate the patchset :(
> > > 
> > > Remind us why we need this?  Whose kernel is spewing so much logging and
> > > why?
> >   We have customers (quite a few of them actually) which have machines with
> > lots of SCSI disks attached (due to multipath etc.) and during boot when
> > these disks are discovered and partitions set up quite some printing
> > happens - multiplied by the number of devices (1000+) it is too much for a
> > serial console to handle quickly enough. So these machines aren't able to
> > boot with serial console enabled.
> 
> It sounds like rather a corner case, not worth mucking up the critical
> core logging code.
> 
> Desperately seeking alternatives...
> 
> I suppose there's some reason why we can't just make those drivers shut
> up?  If the messages are in the log buffer but aren't displayed,
> they're still accessible after boot?
> 
> Or how about passing those messages over to a kernel thread, to be
> printed out at a lower rate?  A linked list and schedule_work() would
> suffice.
  Andrew, you seem really desperate ;-) I don't really like modifying
individual drivers, partitioning code, or SCSI core to be less verbose -
IMHO that's fighting with windmills and it's not like any of those parts is
excessively verbose. Every part prints its bits and it accumulates. I
cannot really imagine this would work long term.

Handing over printing to someone else is exactly what I'm doing - if
there's too big traffic so that one CPU is forced to write a lot of stuff
for other CPUs. The only difference to what you suggest seems to be that
you would like to explicitely mark printks that can be passed to someone
else. We could technically do that but I have trouble how do identify which
printks to mark - I could experimetally find those for some machine but
finding it for all machines is difficult. And then you have cases like
'echo t >/proc/sysrq-trigger' which currently kill the machine with serial
console and lots of processes (I've tried that although no customer
complained about this yet). And marking 'less important' printks wouldn't
bring any code simplification anyway since you would still have to handle
offload for the marked printks.

So as much as I understand the uncertainty of giving up the printing CPU
and relying on a timer tick on some CPU to pick up printing disturbs you, it
seems as the most maintainable solution to me... Or do you have other
concerns?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
