Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaKUVuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:50:46 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36250 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaKUVup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:50:45 -0500
Date: Fri, 21 Nov 2014 22:50:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141121215040.GC9198@lerouge>
References: <alpine.DEB.2.11.1411202204030.3950@nanos>
 <20141120221122.GA25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411202315230.3950@nanos>
 <20141120230514.GB25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411210109460.6439@nanos>
 <20141121141332.GA8808@lerouge>
 <20141121162506.GA15461@htj.dyndns.org>
 <20141121170151.GC30603@home.goodmis.org>
 <20141121213204.GA9198@lerouge>
 <CALCETrV9dNVS=OgDW3eO=ztNCQ6UAzYZvzwDBqd-BqmVpg7EHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV9dNVS=OgDW3eO=ztNCQ6UAzYZvzwDBqd-BqmVpg7EHA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 01:34:08PM -0800, Andy Lutomirski wrote:
> On Fri, Nov 21, 2014 at 1:32 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Fri, Nov 21, 2014 at 12:01:51PM -0500, Steven Rostedt wrote:
> >> On Fri, Nov 21, 2014 at 11:25:06AM -0500, Tejun Heo wrote:
> >> >
> >> > * Static percpu areas wouldn't trigger fault lazily.  Note that this
> >> >   is not necessarily because the first percpu chunk which contains the
> >> >   static area is embedded inside the kernel linear mapping.  Depending
> >> >   on the memory layout and boot param, percpu allocator may choose to
> >> >   map the first chunk in vmalloc space too; however, this still works
> >> >   out fine because at that point there are no other page tables and
> >> >   the PUD entries covering the first chunk is faulted in before other
> >> >   pages tables are copied from the kernel one.
> >>
> >> That sounds correct.
> >>
> >> >
> >> > * NMI used to be a problem because vmalloc fault handler couldn't
> >> >   safely nest inside NMI handler but this has been fixed since and it
> >> >   should work fine from NMI handlers now.
> >>
> >> Right. Of course "should work fine" does not excatly mean "will work fine".
> >>
> >>
> >> >
> >> > * Function tracers are problematic because they may end up nesting
> >> >   inside themselves through triggering a vmalloc fault while accessing
> >> >   dynamic percpu memory area.  This may lead to recursive locking and
> >> >   other surprises.
> >>
> >> The function tracer infrastructure now has a recursive check that happens
> >> rather early in the call. Unless the registered OPS specifically states
> >> it handles recursions (FTRACE_OPS_FL_RECUSION_SAFE), ftrace will add the
> >> necessary recursion checks. If a registered OPS lies about being recusion
> >> safe, well we can't stop suicide.
> >
> > Same if the recursion state is based on per cpu memory.
> >
> >>
> >> Looking at kernel/trace/trace_functions.c: function_trace_call() which is
> >> registered with RECURSION_SAFE, I see that the recursion check is done
> >> before the per_cpu_ptr() call to the dynamically allocated per_cpu data.
> >>
> >> It looks OK, but...
> >>
> >> Oh! but if we trace the page fault handler, and we fault here too
> >> we just nuked the cr2 register. Not good.
> >
> > If we fault in the page fault handler, we double fault and apparently
> > recovering from that isn't quite expected anyway.
> 
> Not quite.  We only double fault if we fault while pushing the
> hardware part of the state onto the stack.  That happens even before
> the entry asm gets run.
> 
> Otherwise if we have a page fault inside do_page_fault, it's just a
> nested page fault.

Oh ok!

But we still have the cr2 issue that Steve talked about.

> 
> --Andy
> 
> 
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC
