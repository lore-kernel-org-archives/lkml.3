Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbaDBR5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:57:51 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38655 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633AbaDBR5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:57:49 -0400
Subject: Re: [PATCH 3/7] uprobes/x86: Conditionalize the usage of
 handle_riprel_insn()
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20140401163934.GA26272@redhat.com>
References: <20140331194402.GA9287@redhat.com>
	 <533A2FE3.3050101@hitachi.com> <20140401143346.GA18503@redhat.com>
	 <20140401163934.GA26272@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Apr 2014 10:57:45 -0700
Message-ID: <1396461465.4659.31.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040217-7164-0000-0000-000000BF50EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 18:39 +0200, Oleg Nesterov wrote:
> On 04/01, Oleg Nesterov wrote:
> >
> > Good point, I'll send v2.
> 
> Masami, et al, I was going to send v2 plus the next short RFC series
> which fixes the problem today, but it turns out that I have no time.
> Will try to do this tomorrow.
> 
> So let me explain the problem, and how (I think) it should be solved.
> Unfortunately, I do not even know the terminology, so firstly I have
> to explain you the things I recently learned when I investigated the
> bug report ;)
> 
[problem description and proposed solution snipped]

Thanks for your work on this.  I think your analysis is correct.  As you
say, emulating calls is tricky because of the possibility that the call
will incur a page fault when it grows the stack.  Your best solution
might be to emulate jumps, but rewrite call instructions using a scratch
register, similar to how we handle rip-relative instructions.

> 
> Once again, if this can work we need more changes to handle jmp's/etc. But
> lets discuss this later. I am thinking in horror about conditional jmp ;)
> In fact this should be simple, just I do not know (yet) to parse such an
> insn, and I simply do not know if lib/insn.c can help me to figure out which
> flag in regs->flags ->emulate() should check.

Emulating jumps (including conditional jumps) shouldn't be all that much
code.  In case you haven't already found it, the "AMD64 Architecture
Programmer's Manual, Volume 3" provides the sort of info you need.
Looking at the "Jcc" section, I see dozens of names of conditional-jump
instructions; but they're all aliases for the same 16 variations, which
branch based on various combinations of 5 flags in regs->eflags (OF, CF,
ZF, SF, PF).

One thing about emulating jumps is that if the task has block stepping
enabled, then a trap is expected on every successful branch.  I'd have
to poke around a while to figure out how to know whether block stepping
is enabled.  set_task_blockstep() should point the way.

> 
> So this all looks a bit complicated, but I do not see a simpler solution.
> Well, we could avoid ->emulate() altogether, we could just mangle the
> problematic instructions and complicate arch_uprobe_post_xol(), but I do
> not think this would be better. And if nothing else, ->emulate is a) simple
> and b) should likely succeed and make the probing faster.
> 
> But perhaps I missed something?
> 
> Oleg.
> 

Jim Keniston
IBM Linux Technology Center

