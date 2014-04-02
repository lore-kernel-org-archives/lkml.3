Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988AbaDBTOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:14:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846AbaDBTOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:14:38 -0400
Date: Wed, 2 Apr 2014 21:14:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] uprobes/x86: Conditionalize the usage of
	handle_riprel_insn()
Message-ID: <20140402191440.GA8114@redhat.com>
References: <20140331194402.GA9287@redhat.com> <533A2FE3.3050101@hitachi.com> <20140401143346.GA18503@redhat.com> <20140401163934.GA26272@redhat.com> <1396461465.4659.31.camel@oc7886638347.ibm.com.usor.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396461465.4659.31.camel@oc7886638347.ibm.com.usor.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Jim Keniston wrote:
>
> On Tue, 2014-04-01 at 18:39 +0200, Oleg Nesterov wrote:
>
> > So let me explain the problem, and how (I think) it should be solved.
> > Unfortunately, I do not even know the terminology, so firstly I have
> > to explain you the things I recently learned when I investigated the
> > bug report ;)
> >
> [problem description and proposed solution snipped]
>
> Thanks for your work on this.  I think your analysis is correct.

Great, thanks!

> As you
> say, emulating calls is tricky because of the possibility that the call
> will incur a page fault when it grows the stack.  Your best solution
> might be to emulate jumps,

Yes,

> but rewrite call instructions using a scratch
> register, similar to how we handle rip-relative instructions.

Yes, this is what I meant when I said that we can avoid ->emulate in
this case, mangle insn, and complicate post_xol(). But so far I do not
think this would be better.

OK. Let me actually finish amd send the fixes, then we can discuss this
again and see if another approach makes more sense.

Sorry, I was distracted again, so I need more time. Will try to send tomorrow.

> > Once again, if this can work we need more changes to handle jmp's/etc. But
> > lets discuss this later. I am thinking in horror about conditional jmp ;)
> > In fact this should be simple, just I do not know (yet) to parse such an
> > insn, and I simply do not know if lib/insn.c can help me to figure out which
> > flag in regs->flags ->emulate() should check.
>
> Emulating jumps (including conditional jumps) shouldn't be all that much
> code.  In case you haven't already found it, the "AMD64 Architecture
> Programmer's Manual, Volume 3" provides the sort of info you need.

Thanks. I'll try to read it, but most probably I'll come here with the
stupid questions anyway.

> One thing about emulating jumps is that if the task has block stepping
> enabled, then a trap is expected on every successful branch.

Yes, but probably we can do this later. Note that uprobes doesn't play
nice with TIF_BLOCKSTEP anyway, see the comment in arch_uprobe_post_xol:

	/*
	 * arch_uprobe_pre_xol() doesn't save the state of TIF_BLOCKSTEP
	 * so we can get an extra SIGTRAP if we do not clear TF. We need
	 * to examine the opcode to make it right.
	 */

So I think that at least the initial version can safely ignore this problem.

Oleg.

