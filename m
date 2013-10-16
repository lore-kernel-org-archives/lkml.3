Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477Ab3JPN2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:28:22 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41368 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934267Ab3JPN2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:28:19 -0400
Date: Wed, 16 Oct 2013 15:28:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Message-ID: <20131016132813.GB14938@localhost.localdomain>
References: <20131015163906.342d8ffa@gandalf.local.home>
 <20131016114036.GB12773@localhost.localdomain>
 <20131016084518.44eaf61a@gandalf.local.home>
 <20131016130856.GE12773@localhost.localdomain>
 <20131016091437.146cb9d4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016091437.146cb9d4@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 09:14:37AM -0400, Steven Rostedt wrote:
> On Wed, 16 Oct 2013 15:08:57 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> 
> > Faults can call rcu_user_exit() / rcu_user_enter(). This is not supposed to happen
> > between rcu_nmi_enter() and rcu_nmi_exit(). rdtp->dynticks would be incremented in the
> > wrong way.
> > 
> > Ah but we have an in_interrupt() check in context_tracking_user_enter() that protects
> > us against that.
> 
> I will say that we should probably warn if it's any fault other than a
> vmalloc fault. A vmalloc fault should only happen in kernel space, and
> should not be happening from user code.

The NMI can interrupt userspace. When the fault happens, it sees that context tracking
state is set to userspace (NMIs and interrupts in general don't exit that state, hence
the in_interrupt() check that returns when user_exit/enter is called) so it calls user_enter().
But anyway we should be protected against that.

> 
> > 
> > > 
> > > > 
> > > > So I hope we can think about something else for the long term.
> > > 
> > > I still don't understand what's wrong with it. As long as the faulting
> > > code does not grab any locks there shouldn't be anything wrong with
> > > faulting in NMI. For vmalloc, it is just updating page tables.
> > 
> > NMI code is written with the idea that it can't be interrupted. May be that
> > paranoia (again), you know. And I can't point you any problem in practice.
> > I just think that allowing such a thing is asking for troubles.
> 
> The WARN_ON() that I removed is from vmalloc fault. I don't see an
> issue with NMIs faulting via vmalloc. For any other page fault, sure, I
> would be concerned about it. But what's wrong with an NMI running
> module code?

I won't argue further as none of us is going to change his opinion on this :)
