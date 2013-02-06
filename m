Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3BFCwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:52:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17182 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3BFCwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:52:06 -0500
X-Authority-Analysis: v=2.0 cv=NqdTgrhJ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_Bp3_fu7e2UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wIfm1DkAj9kA:10 a=8vK88x-t45icI1jUeVMA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360119124.2621.37.camel@gandalf.local.home>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Date: Tue, 05 Feb 2013 21:52:04 -0500
In-Reply-To: <5111BF51.5010607@candelatech.com>
References: <5111AD8D.1080005@candelatech.com>
	 <20130206015430.GA9161@home.goodmis.org> <5111BF51.5010607@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 18:26 -0800, Ben Greear wrote:
> Well, here it is..something is calling rcu_read_lock lots and lots,

Or a bug in the way lockdep handles rcu mappings.

> it seems.  Any way to get a better idea of where those calls are
> made?

Yeah, with ftrace.

> 96 locks held by swapper/0/0:
>   #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
>   #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
[...]
>   #92:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
>   #93:  (&(&wl->cfg_spin_lock)->rlock){..-...}, at: [<ffffffffa07bc4d0>] handle_rcv+0x15d/0x1dd [wanlink]
>   #94:  (&wl_threads[q].my_wq){..-...}, at: [<ffffffff810abe4d>] __wake_up+0x1d/0x48
>   #95:  (&p->pi_lock){-.-.-.}, at: [<ffffffff810b09c1>] try_to_wake_up+0x29/0x20b

If you haven't already configured ftrace into your kernel, can you
please do so. Specifically:

CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y

Then, before triggering this, run the following as root:

 # mount -t debugfs nodev /sys/kernel/debug
 # cd /sys/kernel/debug/tracing
 # echo net_rx_action > set_graph_function
 # echo function_graph > current_tracer

In the kernel, where you added the above dump, before any of the printks
happen, add this too:

	trace_printk("BUG\n");
	tracing_off();

This will stop the trace at the point of the error. The trace_printk()
is a nice way to see the trace too.

Then after you trigger the bug, do the following:

  cat /sys/kernel/debug/tracing/trace

and reply with that.

To turn tracing on again (because the tracing_off() disabled it), you
can do:

  echo 1 > /sys/kernel/debug/tracing/tracing_on

Careful not to do "echo 1> ..." ;-)

-- Steve




