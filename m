Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965566AbaFSV4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:56:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965421AbaFSV4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:56:41 -0400
Date: Thu, 19 Jun 2014 23:56:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 0/3] x86/nmi: Print all cpu stacks from NMI safely
In-Reply-To: <20140619213329.478113470@goodmis.org>
Message-ID: <alpine.LNX.2.00.1406192349400.15014@pobox.suse.cz>
References: <20140619213329.478113470@goodmis.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Steven Rostedt wrote:

> This is my proposal to print the NMI stack traces from an RCU stall safely.
> Here's the gist of it.
> 
> Patch 1: move the trace_seq out of the tracing code. It's useful for other
>  purposes too. Like writing from an NMI context.
> 
> Patch 2: Add a per_cpu "printk_func" that printk calls. By default it calls
>  vprintk_def() which does what it has always done. This allows us to
>  override what printk() calls normally on a per cpu basis.
> 
> Patch 3: Have the NMI handler that dumps the stack trace just change the
>  printk_func to call a NMI safe printk function that writes to a per cpu
>  trace_seq. When all NMI handlers chimed in, the original caller prints
>  out the trace_seqs for each CPU from a printk safe context.
> 
> This is much less intrusive than the other versions out there.

I agree this is less intrusive than having printk() use two versions of 
the buffers and perform merging, OTOH, it doesn't really seem to be 
fully clean and systematic solution either.

I had a different idea earlier today, and Petr seems to have implemented 
it already; I guess he'll be sending it out as RFC tomorrow for 
comparision.

The idea basically is to *switch* what arch_trigger_all_cpu_backtrace() 
and arch_trigger_all_cpu_backtrace_handler() are doing; i.e. use the NMI 
as a way to stop all the CPUs (one by one), and let the CPU that is 
sending the NMIs around to actually walk and dump the stacks of the CPUs 
receiving the NMI IPI.

It's the most trivial aproach I've been able to come up with, and should 
be usable for everybody (RCU stall detector and sysrq). The only tricky 
part is: if we want pt_regs to be part of the dump as well, how to pass 
those cleanly between the 'stopped' CPU and the CPU that is doing the 
printing. Other than that, it's just moving a few lines of code around, I 
believe.

What do you think?

-- 
Jiri Kosina
SUSE Labs
