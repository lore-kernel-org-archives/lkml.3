Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241Ab3JPMpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:45:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:31481 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932406Ab3JPMpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:45:19 -0400
Date: Wed, 16 Oct 2013 08:45:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] x86: Remove WARN_ON(in_nmi()) from vmalloc_fault
Message-ID: <20131016084518.44eaf61a@gandalf.local.home>
In-Reply-To: <20131016114036.GB12773@localhost.localdomain>
References: <20131015163906.342d8ffa@gandalf.local.home>
	<20131016114036.GB12773@localhost.localdomain>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013 13:40:37 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Oct 15, 2013 at 04:39:06PM -0400, Steven Rostedt wrote:
> > Since the NMI iretq nesting has been fixed, there's no reason that
> > an NMI handler can not take a page fault for vmalloc'd code. No locks
> > are taken in that code path, and the software now handles nested NMIs
> > when the fault re-enables NMIs on iretq.
> > 
> > Not only that, if the vmalloc_fault() WARN_ON_ONCE() is hit, and that
> > warn on triggers a vmalloc fault for some reason, then we can go into
> > an infinite loop (the WARN_ON_ONCE() does the WARN() before updating
> > the variable to make it happen "once").
> > 
> > Reported-by: "Liu, Chuansheng" <chuansheng.liu@intel.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Thanks! For now we probably indeed want this patch. But I hope it's only
> for the short term.

Why?

> 
> I still think that allowing faults in NMIs is very nasty, as we expect NMIs to never
> be disturbed.

We do faults (well, breakpoints really) in NMI to enable tracing.

> I'm not even sure if that interacts correctly with the rcu_nmi_enter()
> and preempt_count & NMI_MASK things. Not sure how perf is ready for that either (now
> hardware events can be interrupted by fault trace events).

I'm a bit confused. What doesn't interact correctly with
rcu_nmi_enter()?

> 
> So I hope we can think about something else for the long term.

I still don't understand what's wrong with it. As long as the faulting
code does not grab any locks there shouldn't be anything wrong with
faulting in NMI. For vmalloc, it is just updating page tables.

-- Steve
