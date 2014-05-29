Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbaE2IJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:09:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330AbaE2IJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:09:52 -0400
Date: Thu, 29 May 2014 10:09:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Petr Mladek <pmladek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
In-Reply-To: <20140529000909.GC6507@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.1405290959270.17241@pobox.suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz> <alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz> <20140529000909.GC6507@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014, Frederic Weisbecker wrote:

> > I am rather surprised that this patchset hasn't received a single review 
> > comment for 3 weeks.
> > 
> > Let me point out that the issues Petr is talking about in the cover letter 
> > are real -- we've actually seen the lockups triggered by RCU stall 
> > detector trying to dump stacks on all CPUs, and hard-locking machine up 
> > while doing so.
> > 
> > So this really needs to be solved.
> 
> The lack of review may be partly due to a not very appealing changestat 
> on an old codebase that is already unpopular:
> 
>  Documentation/kernel-parameters.txt |   19 +-
>  kernel/printk/printk.c              | 1218 +++++++++++++++++++++++++----------
>  2 files changed, 878 insertions(+), 359 deletions(-)
> 
> 
> Your patches look clean and pretty nice actually. They must be seriously 
> considered if we want to keep the current locked ring buffer design and 
> extend it to multiple per context buffers. But I wonder if it's worth to 
> continue that way with the printk ancient design.
> 
> If it takes more than 1000 line changes (including 500 added) to make it 
> finally work correctly with NMIs by working around its fundamental 
> flaws, shouldn't we rather redesign it to use a lockless ring buffer 
> like ftrace or perf ones?

Yeah, printk() has grown over years to a stinking pile of you-know-what, 
no argument to that.

I also agree that performing a massive rewrite, which will make it use a 
lockless buffer, and therefore ultimately solve all its problems 
(scheduler deadlocks, NMI deadlocks, xtime_lock deadlocks) at once, is 
necessary in the long run.

On the other hand, I am completely sure that the diffstat for such rewrite 
is going to be much more scary :)

This is not adding fancy features to printk(), where we really should be 
saying no; horrible commits like 7ff9554bb5 is exactly something that 
should be pushed against *heavily*. But bugfixes for hard machine lockups 
are a completely different story to me (until we have a whole new printk() 
buffer handling implementation).

-- 
Jiri Kosina
SUSE Labs
