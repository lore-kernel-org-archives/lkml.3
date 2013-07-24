Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab3GXRsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:48:24 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42683 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3GXRsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:48:23 -0400
Date: Wed, 24 Jul 2013 19:48:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Pan, Zhenjie" <zhenjie.pan@intel.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NMI: fix NMI period is not correct when cpu frequency
 changes issue.
Message-ID: <20130724174815.GA23431@somewhere>
References: <F98D4B5C3D86834DB612ABF854C98B7FB54822@SHSMSX101.ccr.corp.intel.com>
 <20130415163049.08498e3a8726f0bd6f4d6ebe@linux-foundation.org>
 <1366284729.19383.16.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366284729.19383.16.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 01:32:09PM +0200, Peter Zijlstra wrote:
> On Mon, 2013-04-15 at 16:30 -0700, Andrew Morton wrote:
> > I think this will break the build if CONFIG_PERF_EVENTS=n and
> > CONFIG_LOCKUP_DETECTOR=y.  I was able to create such a config for
> > powerpc.  If I'm reading it correctly, CONFIG_PERF_EVENTS cannot be
> > disabled on x86_64?  If so, what the heck?
> 
> Frederic and Ingo made that happen,.. a long while ago Frederic
> promised to fix that.. I suppose its never been quite important enough
> to get around to :/
> 
> (Frederic; read this as a gentle prod to move his upward on the todo
> list)
> 

Sorry to answer so late on this.

So the breakpoint code used by ptrace is what retains perf events from
ever being conditionally built in x86.

This is because the breakpoints and the perf events subsystem are
interdependent in some nasty ways:

* perf uses the breakpoint subsystem to create perf events on breakpoints
* ptrace use the breakpoint subsystem which then relies on perf to create
breakpoints.

I don't feel very comfortable with this layout. Ideally, the breakpoint
subsystem should be a standalone layer which both perf and ptrace can use
without forcing perf as a midlayer as in what we have currently.

So here's my point of view. And the upside is that we could make x86
build without CONFIG_PERF_EVENTS.

But I discussed that with Ingo and he seemed to prefer that we keep the
current state, because perf is a handy interface for ptrace to use.

And he's arguably right. The interface is there and it's easy to use,
it provides all the task context management that is needed, all the breakpoint
code and callback support. It's not perfect though: this would be even nicer if we
could pass arch information directly to the breakpoint creation instead of
needing to convert it to generic breakpoint interface datas first.
But still: it's quite handy.

Now the tradeoff is indeed this nasty inter-dependency between perf and breakpoints.

I wouldn't mind changing that and make the breakpoint susbsystem independant
from perf. And in my opinion we probably should do that.

But I need to be sure that Ingo agrees with this aproach because that require quite
some work and I really don't want to spend days of work and weeks of patchset iteration
if there are good chances that it gets eventually pushed back.

Is there any user of x86 that really don't care about perf events? May be some
users are burdened with the .text and .data used by perf that increase the
kernel image?

If some users really need that to change, this would certainly cut short the issue. 

Thanks.
