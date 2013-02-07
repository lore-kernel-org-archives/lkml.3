Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab3BGQsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:48:22 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40920 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758830Ab3BGQsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:48:20 -0500
Date: Thu, 7 Feb 2013 08:30:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
Message-ID: <20130207163004.GS2632@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
 <1360205415.2621.60.camel@gandalf.local.home>
 <20130207111025.GD8945@gmail.com>
 <1360253520.2621.66.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360253520.2621.66.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020716-5806-0000-0000-00001F4FB4D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 11:12:00AM -0500, Steven Rostedt wrote:
> On Thu, 2013-02-07 at 12:10 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > I'll reply to this as I come up with comments.
> > > 
> > > First thing is, don't call it NO_HZ_FULL. A better name would 
> > > be NO_HZ_CPU. I would like to reserve NO_HZ_FULL when we 
> > > totally remove jiffies :-)
> > 
> > I don't think we want yet another config option named in a 
> > weird way.
> > 
> > What we want instead is to just split NO_HZ up into its 
> > conceptual parts:
> > 
> >    CONFIG_NO_HZ_IDLE
> >    CONFIG_NO_HZ_USER_SPACE
> >    CONFIG_NO_HZ_KERNEL_SPACE
> > 
> > Where the current status quo is NO_HZ_IDLE=y, and Frederic is 
> > about to introduce NO_HZ_USER_SPACE=y. When jiffies get removed 
> > we get NO_HZ_KERNEL_SPACE=y.
> 
> Saying NO_HZ_USER_SPACE is a bit of a misnomer. As we don't just stop
> the tick for user space, but it may remained stopped when entering the
> kernel. The rule is that when there's just a single task on a CPU, the
> tick can stop (no scheduling work needed). But if the task triggers
> something that may require a tick (like printk) then the tick will start
> again. But just going into the kernel does not designate a tick restart.
> 
> Maybe a better name would be NO_HZ_SINGLE_TASK ?
> 
> > 
> > The 'CONFIG_NO_HZ' meta-option, which we should leave for easy 
> > configurability and for compatibility, should get us the 
> > currently recommended default, which for the time being might 
> > be:
> > 
> >    CONFIG_NO_HZ_IDLE=y
> >    # CONFIG_NO_HZ_USER_SPACE is disabled
> > 
> > Btw., you could add CONFIG_NO_HZ_KERNEL_SPACE right away, just 
> > keep it false all the time. That would document our future plans 
> > pretty well.
> 
> Maybe the removal of jiffies would be NO_HZ_COMPLETE?

I suspect that removal of jiffies from the kernel will take a few stages,
with RCU being one of the laggards for awhile.  Making RCU's state
machine depend wholly on process-based execution will take some care
and experimentation, especially for extreme and corner-case workloads.
For example, having RCU OOM the system just because a specific CPU was
unable to run some RCU kthread for an extended time is something to
be avoided.  ;-)

							Thanx, Paul

