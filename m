Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaJPK5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:57:17 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:54767 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaJPK5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:57:15 -0400
Date: Thu, 16 Oct 2014 12:57:09 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] s390 vs. kprobes on ftrace
Message-ID: <20141016105709.GA11072@osiris>
References: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com>
 <543F5C84.7090005@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543F5C84.7090005@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101610-0025-0000-0000-000001E9A390
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

thank you for your comments!

On Thu, Oct 16, 2014 at 02:49:56PM +0900, Masami Hiramatsu wrote:
> (2014/10/16 0:46), Heiko Carstens wrote:
> > we would like to implement an architecture specific variant of "kprobes
> > on ftrace" without using the current HAVE_KPROBES_ON_FTRACE infrastructure
> > which is currently only used by x86.
> > 
> > The rationale for these two patches is:
> > - we want to patch the first instruction of the mcount code block to
> >   reduce the overhead of the function tracer
> > - we'd like to keep the ftrace_caller function as simple as possible and
> >   not require it to generate a 100% valid pt_regs structure as required
> >   by the combination of DYNAMIC_FTRACE_WITH_REGS and HAVE_KPROBES_ON_FTRACE.
> >   This allows us to not generate the psw mask field in the pt_regs
> >   structure on each function tracer enabled function, which otherwise would
> >   be very expensive. Besides that program check generated pt_regs contents
> >   are "more" accurate than program generated ones and don't require any
> >   maintenance.
> >   And also we can keep the ftrace and kprobes backends quite separated.
> 
> I'm not sure about s390 nor have the machine, so it is very helpful if you
> give us a command line level test and show us the result with this patch :)
> Fortunately, we already have ftracetest under tools/tesitng/selftest/ftrace/.
> You can add the testcase for checking co-existence of kprobes and ftrace on
> an entry of a function.

Ok, my personal test case was just a kernel module, that added/removed a kprobe
while also enabling/disabling function tracing and verifying that both the
kprobes handler got called correctly and correct entries were added to the
function trace buffer.
Everything worked as expected, however I think I can come up with a test case
that will fit into the ftrace selftests.
I just need to get familiar with the kprobe dynamic event interface (again) ;)

> And also, since ftrace is now supporting assembly trampoline code for each
> handler, performance overhead can be reduced if we save registers only when
> the kprobes enabled on the function. I'm not sure it can implement on s390,
> but your requirement looks similar. What would you think about that?

Yes, Vojtech Pavlik did send patches which implemented that. But that resulted
in a lot of asm code duplication which I didn't feel comfortable with.
Right now the s390 variant of ftrace_regs_caller() is an alias to
ftrace_caller() which means we only have one piece of code which handles both
variants.
I'm still thinking of a different solution which handles the creation of the
pt_regs contents 100% correct with an own trampoline for ftrace_regs_caller(),
but that's a different story.

However, this is more or less independently to the question of what you think
about allowing an architecture to handle kprobes on ftrace completely in the
architecture backend.

>From a pure technical point of view both versions can be implemented and would
also work on s390:
- either handling kprobes on ftrace completely by the architecture
- or implement a "full" version of DYNAMIC_FTRACE_WITH_REGS and then also
  implement a similar HAVE_KPROBES_ON_FTRACE backend like x86 already has

Personally I'd prefer handling kprobes on ftrace completely by the
architecture backend, because both Martin and I think this simply looks
better, and keeps things more separated.
Given that this preference only requires removal of a sanity check in
kprobes.c ("don't put a kprobe on an ftrace location") I'd say this shouldn't
be a problem, no?

Thanks,
Heiko

