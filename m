Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbaKURBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:01:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:49176 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932099AbaKURBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:01:53 -0500
X-Greylist: delayed 52114 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Nov 2014 12:01:53 EST
Date: Fri, 21 Nov 2014 12:01:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141121170151.GC30603@home.goodmis.org>
References: <alpine.DEB.2.11.1411200002330.3909@nanos>
 <20141119235033.GE11386@lerouge>
 <20141120122339.GA14877@htj.dyndns.org>
 <alpine.DEB.2.11.1411202204030.3950@nanos>
 <20141120221122.GA25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411202315230.3950@nanos>
 <20141120230514.GB25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411210109460.6439@nanos>
 <20141121141332.GA8808@lerouge>
 <20141121162506.GA15461@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141121162506.GA15461@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 11:25:06AM -0500, Tejun Heo wrote:
> 
> * Static percpu areas wouldn't trigger fault lazily.  Note that this
>   is not necessarily because the first percpu chunk which contains the
>   static area is embedded inside the kernel linear mapping.  Depending
>   on the memory layout and boot param, percpu allocator may choose to
>   map the first chunk in vmalloc space too; however, this still works
>   out fine because at that point there are no other page tables and
>   the PUD entries covering the first chunk is faulted in before other
>   pages tables are copied from the kernel one.

That sounds correct.

> 
> * NMI used to be a problem because vmalloc fault handler couldn't
>   safely nest inside NMI handler but this has been fixed since and it
>   should work fine from NMI handlers now.

Right. Of course "should work fine" does not excatly mean "will work fine".


> 
> * Function tracers are problematic because they may end up nesting
>   inside themselves through triggering a vmalloc fault while accessing
>   dynamic percpu memory area.  This may lead to recursive locking and
>   other surprises.

The function tracer infrastructure now has a recursive check that happens
rather early in the call. Unless the registered OPS specifically states
it handles recursions (FTRACE_OPS_FL_RECUSION_SAFE), ftrace will add the
necessary recursion checks. If a registered OPS lies about being recusion
safe, well we can't stop suicide.

Looking at kernel/trace/trace_functions.c: function_trace_call() which is
registered with RECURSION_SAFE, I see that the recursion check is done
before the per_cpu_ptr() call to the dynamically allocated per_cpu data.

It looks OK, but...

Oh! but if we trace the page fault handler, and we fault here too
we just nuked the cr2 register. Not good.

-- Steve


> 
> Are there other cases where the lazy vmalloc faults can break things?
