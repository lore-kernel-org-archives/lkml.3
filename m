Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaJTGlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:41:37 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:40119 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaJTGle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:41:34 -0400
Date: Mon, 20 Oct 2014 08:41:28 +0200
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
Message-ID: <20141020064128.GA4268@osiris>
References: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com>
 <543F5C84.7090005@hitachi.com>
 <20141017081921.GA18203@osiris>
 <54446D49.1030208@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54446D49.1030208@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102006-0025-0000-0000-000001F4A445
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Mon, Oct 20, 2014 at 11:02:49AM +0900, Masami Hiramatsu wrote:
> (2014/10/17 17:19), Heiko Carstens wrote:
> > On Thu, Oct 16, 2014 at 02:49:56PM +0900, Masami Hiramatsu wrote:
> >> Hi Heiko,
> >>
> >> (2014/10/16 0:46), Heiko Carstens wrote:
> >>> Hi all,
> >>>
> >>> we would like to implement an architecture specific variant of "kprobes
> >>> on ftrace" without using the current HAVE_KPROBES_ON_FTRACE infrastructure
> >>> which is currently only used by x86.
> > 
> > [...]
> > 
> >> I'm not sure about s390 nor have the machine, so it is very helpful if you
> >> give us a command line level test and show us the result with this patch :)
> >> Fortunately, we already have ftracetest under tools/tesitng/selftest/ftrace/.
> >> You can add the testcase for checking co-existence of kprobes and ftrace on
> >> an entry of a function.
> > 
> > So how about something like below?
> 
> Yes! :) And could you add the results before and after to patch 2/2,
> so that we can see what it changes on s390 ?

The output of the testcase is identical before and after patch 2/2. Maybe I
didn't explain my intention good enough.
Just to explain how mcount/ftrace works on s390 today: if we pass the "-pg"
flag to the compiler a 24 byte(!) block will be added in front of every
function. We patch that block to match the ftrace needs. So an ftrace "nop"
looks like this (simplified):

 0: load return address "24" into register
 6: jump to 24
12: nop
18: nop
24: <function code>

If the function gets enabled for ftrace we will patch the instruction at
offset 6:

 0: load return address "24" into register
 6: jump to ftrace_caller
12: nop
18: nop
24: <function code>

So in fact kprobes and ftrace do work nicely together, since we only patch
the second instruction, while kprobes will put a breakpoint on the first
instruction.

However, what I want to achieve with patch 2/2 is that the code will look
like this:

ftrace disabled:

 0: jump to 24
 6: nop
12: nop
18: nop
24: <function code>

ftrace enabled:

 0: branch to ftrace_caller and save return address into register
 6: nop
12: nop
18: nop
24: <function code>

So, with patch 2/2 the ftrace location of a function now matches the first
instruction of a function and the check within kprobes.c which prevents
putting a kprobe on an ftrace location triggers.

So kprobes and ftrace work with and without patch 2/2, all I want to achieve
is that the overhead of the mcount block gets reduced to a single instruction.
Ultimately we want also a compiler change which only emits a single
instruction, which we can patch; probably similar to "-pg -mfentry" on x86.

