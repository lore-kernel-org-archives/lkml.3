Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaFJQtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:49:43 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50219 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaFJQtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:49:42 -0400
Date: Tue, 10 Jun 2014 18:49:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
Message-ID: <20140610164936.GE1951@localhost.localdomain>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
 <alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz>
 <20140529000909.GC6507@localhost.localdomain>
 <20140530081328.GA2419@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530081328.GA2419@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 10:13:28AM +0200, Jan Kara wrote:
> On Thu 29-05-14 02:09:11, Frederic Weisbecker wrote:
> > On Thu, May 29, 2014 at 12:02:30AM +0200, Jiri Kosina wrote:
> > > On Fri, 9 May 2014, Petr Mladek wrote:
> > > 
> > > > printk() cannot be used safely in NMI context because it uses internal locks
> > > > and thus could cause a deadlock. Unfortunately there are circumstances when
> > > > calling printk from NMI is very useful. For example, all WARN.*(in_nmi())
> > > > would be much more helpful if they didn't lockup the machine.
> > > > 
> > > > Another example would be arch_trigger_all_cpu_backtrace for x86 which uses NMI
> > > > to dump traces on all CPU (either triggered by sysrq+l or from RCU stall
> > > > detector).
> > > 
> > > I am rather surprised that this patchset hasn't received a single review 
> > > comment for 3 weeks.
> > > 
> > > Let me point out that the issues Petr is talking about in the cover letter 
> > > are real -- we've actually seen the lockups triggered by RCU stall 
> > > detector trying to dump stacks on all CPUs, and hard-locking machine up 
> > > while doing so.
> > > 
> > > So this really needs to be solved.
> > 
> > The lack of review may be partly due to a not very appealing changestat on an
> > old codebase that is already unpopular:
> > 
> >  Documentation/kernel-parameters.txt |   19 +-
> >  kernel/printk/printk.c              | 1218 +++++++++++++++++++++++++----------
> >  2 files changed, 878 insertions(+), 359 deletions(-)
> > 
> > 
> > Your patches look clean and pretty nice actually. They must be seriously
> > considered if we want to keep the current locked ring buffer design and
> > extend it to multiple per context buffers. But I wonder if it's worth to
> > continue that way with the printk ancient design.
> > 
> > If it takes more than 1000 line changes (including 500 added) to make it
> > finally work correctly with NMIs by working around its fundamental flaws,
> > shouldn't we rather redesign it to use a lockless ring buffer like ftrace
> > or perf ones?
>   I agree that lockless ringbuffer would be a more elegant solution but a
> much more intrusive one and complex as well. Petr's patch set basically
> leaves ordinary printk path intact to avoid concerns about regressions
> there.
> 
> Given how difficult / time consuming is it to push any complex changes to
> printk I'd push for fixing printk from NMI in this inelegant but relatively
> non-contentious way and work on converting printk to lockless
> implementation long term. But before spending huge amount of time on that
> I'd like to get some wider concensus that this is really the way we want to
> go - at least AKPM and Steven - something for discussion in the KS topic I'd
> proposed I think [1].

Agreed, lets wait for others opinion. Andrew, Steve?
