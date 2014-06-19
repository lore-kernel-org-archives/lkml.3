Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965702AbaFSW6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 18:58:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:29178 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965348AbaFSW6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 18:58:14 -0400
Date: Thu, 19 Jun 2014 18:58:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 0/3] x86/nmi: Print all cpu stacks from NMI safely
Message-ID: <20140619185810.4137e14b@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1406192349400.15014@pobox.suse.cz>
References: <20140619213329.478113470@goodmis.org>
	<alpine.LNX.2.00.1406192349400.15014@pobox.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014 23:56:36 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:


> I agree this is less intrusive than having printk() use two versions of 
> the buffers and perform merging, OTOH, it doesn't really seem to be 
> fully clean and systematic solution either.

I'm not sure why you consider it not fully clean. I think it is quite
elegant ;-)

> 
> I had a different idea earlier today, and Petr seems to have implemented 
> it already; I guess he'll be sending it out as RFC tomorrow for 
> comparision.
> 
> The idea basically is to *switch* what arch_trigger_all_cpu_backtrace() 
> and arch_trigger_all_cpu_backtrace_handler() are doing; i.e. use the NMI 
> as a way to stop all the CPUs (one by one), and let the CPU that is 
> sending the NMIs around to actually walk and dump the stacks of the CPUs 
> receiving the NMI IPI.

And this is cleaner? Stopping a CPU via NMI and then what happens if
something else goes wrong and that CPU never starts back up? This
sounds like something that can cause more problems than it was
reporting on.

The code had better handle all the strange cases where an NMI comes in
after the code that sent it timed out waiting for the NMIs to return.
Then you also need to print out the data while the NMIs still spin.

> 
> It's the most trivial aproach I've been able to come up with, and should 
> be usable for everybody (RCU stall detector and sysrq). The only tricky 
> part is: if we want pt_regs to be part of the dump as well, how to pass 
> those cleanly between the 'stopped' CPU and the CPU that is doing the 
> printing. Other than that, it's just moving a few lines of code around, I 
> believe.

Note, I first tried to just save the data and pass it to the calling
functions, but found that rather messy, as there is a lot of stuff
being dumped, and it's different if it is x86_64 vs i386 or if the NMI
happened when in userspace or kernel. That's when I realized it would
be trivial to just switch what printk does and then have the NMI do the
printing to another NMI safe buffer.

It was even more convenient that trace_seq already existed and made it
much easier to implement.

-- Steve

