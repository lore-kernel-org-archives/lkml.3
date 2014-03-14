Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaCNKo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:44:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38279 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaCNKo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:44:26 -0400
Date: Fri, 14 Mar 2014 11:44:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
Message-ID: <20140314104415.GS27965@twins.programming.kicks-ass.net>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
 <20140217143340.GR27965@twins.programming.kicks-ass.net>
 <530529FC.6080704@intel.com>
 <87siqqtlv6.fsf@ashishki-desk.ger.corp.intel.com>
 <20140310172440.GG13302@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310172440.GG13302@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 10:24:40AM -0700, Andi Kleen wrote:
> > > Wouldn't we have to teach a ton of code how to be IRQ safe for this to
> > > work?  Just step one: how do we go modifying page tables safely from an
> > > interrupt?  mm->page_table_lock is a plain non-irq spinlock.
> > 
> > Yes, this does look more than just tricky even if we move the bulk of
> > interrupt code to an irq_work. Peter, are you quite sure this is what we
> > want to do just for exporting trace buffers to userspace?
> 
> The other big problem is scalability. Even if it was somehow possible
> to make this scheme work the IPIs for flushing would kill performance 
> on any multi threaded client.  Given perf is not multi-threaded today, but
> it doesn't seem a good idea to design the interface assuming no client ever
> will be.

Well any mmap()ed interface that wants to swap buffers will have this
same problem.

You can restrict the TLB flushing to the threads that poll() on the
relevant events. This just means other threads will see old/partial
data, but that shouldn't be a problem as they shouldn't be looking in
the first place.
