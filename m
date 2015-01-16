Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbbAPQfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:35:48 -0500
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:43620 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756545AbbAPQfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:35:46 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::,RULES_HIT:41:334:355:368:369:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2734:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:5007:6119:6261:7875:7903:8660:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13148:13230:14096:14097:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cub24_147d92c0e3c07
X-Filterd-Recvd-Size: 4248
Date: Fri, 16 Jan 2015 11:35:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH 1/2 v3] ftrace: don't allow IPMODIFY without proper
 compiler support
Message-ID: <20150116113539.78c093ad@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1501151045580.4162@pobox.suse.cz>
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz>
	<20141223094607.GA16445@infradead.org>
	<20141223151056.GA4789@treble.redhat.com>
	<20141226155613.36dd95b9@canb.auug.org.au>
	<20150107144317.61ab2080877a4d8227990551@linux-foundation.org>
	<alpine.LNX.2.00.1501072346400.15299@pobox.suse.cz>
	<20150107153006.60ed354e3458f402e6819b9e@linux-foundation.org>
	<alpine.LNX.2.00.1501080037030.15299@pobox.suse.cz>
	<20150107155701.4839545f63701412003edd88@linux-foundation.org>
	<alpine.LNX.2.00.1501080104190.15299@pobox.suse.cz>
	<54B3C1DD.6090400@hitachi.com>
	<alpine.LNX.2.00.1501132345080.4162@pobox.suse.cz>
	<20150113211223.18908f21@grimm.local.home>
	<alpine.LNX.2.00.1501140945520.4162@pobox.suse.cz>
	<alpine.LNX.2.00.1501151045580.4162@pobox.suse.cz>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 10:50:07 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> Using IPMODIFY needs to be allowed only with compilers which are 
> guaranteed to generate function prologues compatible with function 
> redirection through changing instruction pointer in saved regs.

That's actually not true.

Sorry, I started thinking about this more, and I disagree with this
change.

> 
> For example changing regs->ip on x86_64 in cases when gcc is using mcount 
> (and not fentry) is not allowed, because at the time mcount call is 
> issued, the original function's prologue has already been executed, which 
> leads to all kinds of inconsistent havoc.

No, it only causes havoc if whoever modifies the ip doesn't know it's
not at the start of the function.

Hence, it's only the user of ftrace that wants to replace functions
that needs to worry about this.

In fact, there's nothing wrong if kprobes to use ftrace to change ip
even if fentry isn't supported. That's because if fentry isn't
supported, kprobes will notice that there's no ftrace call at the start
of a function and will use a breakpoint instead. If a kprobe user still
wants to change the ip after the stack frame was set up, they still can
do that, they just need to find where the mcount call is. kprobe does
its work based on the kernel address to probe, not where ftrace places
its hooks.

Now you could argue that there's no reason to change ip if ftrace isn't
using fentry, but there's nothing to prevent a user from doing so.

It also bothers me that you just prevented all users of kprobes from
taking advantage of hooking to a ftrace caller if fentry isn't
supported. All kprobes really needs is the REGS version supported. 99%
of all kprobes do not modify ip.

I have to say NAK on this change.

Instead, make live kernel patching fail to load if fentry isn't
supported. IOW, instead of ftrace_ipmodify_supported, have a
live_kernel_patching_supported that could be based on fentry being used
or not.

-- Steve


> 
> There is currently no way to express dependency on gcc features in 
> Kconfig, (CC_USING_FENTRY is defined only during build, so it's not 
> possible for Kconfig symbol to depend on it) so this needs to be checked 
> in runtime.
> 
> Mark x86_64 with fentry supported for now. Other archs can be added
> gradually.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
