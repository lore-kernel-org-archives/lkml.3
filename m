Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbaKUCgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:36:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:19454 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756779AbaKUCgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:36:20 -0500
Date: Thu, 20 Nov 2014 21:33:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141121023310.GB30603@home.goodmis.org>
References: <20141119225615.GA11386@lerouge>
 <alpine.DEB.2.11.1411200002330.3909@nanos>
 <20141119235033.GE11386@lerouge>
 <20141120122339.GA14877@htj.dyndns.org>
 <alpine.DEB.2.11.1411202204030.3950@nanos>
 <20141120221122.GA25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411202315230.3950@nanos>
 <20141120230514.GB25393@htj.dyndns.org>
 <CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
 <20141120233920.GC25393@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120233920.GC25393@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 06:39:20PM -0500, Tejun Heo wrote:
> On Thu, Nov 20, 2014 at 03:08:03PM -0800, Andy Lutomirski wrote:
> > > So, for now, all we need is adding nmi check in percpu accessors,
> > > right?
> > >
> > 
> > What's the issue with nmi?  Page faults are supposed to nest correctly
> > inside nmi, right?
> 
> Thought they couldn't.  Looking at the trace that Frederic linked, it
> looks like straight-out tracing function recursion due to an
> unexpected fault while holding a lock.  I don't think this can be
> annotated from percpu accessor side.  There's nothing special about
> the context.  :(

There use to be issues with page faults in NMI. One was that the iretq
from the page fault handler would re-enable NMIs, and if another NMI triggered
then it would stomp all over the stack of the initial NMI. But my tripple
copy of the NMI stack frame solved that. You can read all about it here:

  http://lwn.net/Articles/484932/

The second bug was that if an NMI triggered right after a page fault, and
it had a page fault, the content of the cr2 register (faulting address)
would be lost for the page fault that was preempted by the NMI.
This too was solved by using (queue irony) using per_cpu variables.

Now I'm hoping that kernel boot time per_cpu variables never take any
faults, otherwise we are all f*cked!

> 
> Does this matter for anybody other than tracers?  Ultimately, the
> solution would be removing the vmalloc area faulting as Thomas
> suggested.

I don't know, but per_cpu variables are rather special and used all
over the place. Most other vmalloc code isn't as used as per_cpu is.

-- Steve

