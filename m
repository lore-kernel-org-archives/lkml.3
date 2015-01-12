Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbbALRaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:30:15 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60228 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbbALRaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:30:10 -0500
Date: Mon, 12 Jan 2015 17:30:05 +0000
From: Will Deacon <will.deacon@arm.com>
To: Pratyush Anand <panand@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        William Cohen <wcohen@redhat.com>,
        Steve Capper <steve.capper@linaro.org>,
        David Long <dave.long@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: Query: ARM64: Behavior of el1_dbg exception while executing
 el0_dbg
Message-ID: <20150112173005.GK13360@arm.com>
References: <54AE830E.1090000@redhat.com>
 <20150108162312.GO11583@arm.com>
 <54AEBE45.9080203@redhat.com>
 <20150109154635.GG11258@arm.com>
 <54B00C39.1070809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B00C39.1070809@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 05:13:29PM +0000, Pratyush Anand wrote:
> 
> 
> On Friday 09 January 2015 09:16 PM, Will Deacon wrote:
> > On Thu, Jan 08, 2015 at 05:28:37PM +0000, Pratyush Anand wrote:
> >> On Thursday 08 January 2015 09:53 PM, Will Deacon wrote:
> >>> On Thu, Jan 08, 2015 at 01:15:58PM +0000, Pratyush Anand wrote:
> >>>> I am trying to test following scenario, which seems valid to me. But I
> >>>> am very new to ARM64 as well as to debugging tools, so seeking expert's
> >>>> comment here.
> >>>>
> >>>> -- I have inserted a kprobe to the function uprobe_breakpoint_handler
> >>>> which is called from elo_dbg
> >>>> (el0_dbg->do_debug_exception->brk_handler->call_break_hook->uprobe_breakpoint_handler)
> >>>>
> >>>> -- kprobe is enabled.
> >>>>
> >>>> -- an uprobe is inserted into a test application and enabled.
> >>>>
> >>>> So, when uprobe is enabled and test code execution reaches to probe
> >>>> instruction, it executes uprobe breakpoint instruction and el0_dbg
> >>>> exception is raised.
> >>>>
> >>>> When control reaches to start of uprobe_breakpoint_handler and it
> >>>> executes first instruction (which has been replaced with a kprobe
> >>>> breakpoint instruction), el1_dbg exception is raised.
> >>>
> >>> Hmm, debug exceptions should be masked at this point so I don't see why
> >>> you're taking the second debug exception.
> >>>
> >>
> >> So, you mean to say that when an exception which has been taken from
> >> lower exception level (EL0) is being executed, then we keep masked also
> >> the exception from current exception level (EL1)...
> >
> > Yeah, if you look at entry.S then you'll see that neither el0_dbg or el1_dbg
> > re-enable debug exceptions (masked automatically by the CPU after taking the
> > exception) until *after* the handling has completed. This is to prevent
> > recursive debug exceptions, which I don't see how we can reasonable handle.
> 
> May be I am missing something, but my observation on silicon is 
> different. Please have a look at git log of HEAD of following branch, 
> which says that el1_dbg exception has been raised while el0_dbg was 
> executing. Do not know what I am missing..
> 
> https://github.com/pratyushanand/linux/tree/ml_arm64_uprobe_devel_debug_kprobe_insertion_at_uprobe_breakpoint_handler

That page just says "Failed to load latest commit information." for me.

Regardless, I think you need to debug further and found out if PSTATE.D is
getting cleared and, if so, who is responsible for that. Somebody could be
enabling IRQs, for example, which will then unmask debug exceptions in
el1_irq.

Will
