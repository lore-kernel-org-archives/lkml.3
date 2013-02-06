Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3BFDau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 22:30:50 -0500
Received: from mail.candelatech.com ([208.74.158.172]:55946 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab3BFDat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 22:30:49 -0500
Message-ID: <5111CE60.4080403@candelatech.com>
Date: Tue, 05 Feb 2013 19:30:40 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
References: <5111AD8D.1080005@candelatech.com>  <20130206015430.GA9161@home.goodmis.org> <5111BF51.5010607@candelatech.com> <1360119124.2621.37.camel@gandalf.local.home>
In-Reply-To: <1360119124.2621.37.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 06:52 PM, Steven Rostedt wrote:
> On Tue, 2013-02-05 at 18:26 -0800, Ben Greear wrote:
>> Well, here it is..something is calling rcu_read_lock lots and lots,
>
> Or a bug in the way lockdep handles rcu mappings.
>
>> it seems.  Any way to get a better idea of where those calls are
>> made?
>
> Yeah, with ftrace.
>
>> 96 locks held by swapper/0/0:
>>    #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
>>    #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
> [...]
>>    #92:  (rcu_read_lock){.+.+..}, at: [<ffffffff81476836>] rcu_read_lock+0x0/0x6f
>>    #93:  (&(&wl->cfg_spin_lock)->rlock){..-...}, at: [<ffffffffa07bc4d0>] handle_rcv+0x15d/0x1dd [wanlink]
>>    #94:  (&wl_threads[q].my_wq){..-...}, at: [<ffffffff810abe4d>] __wake_up+0x1d/0x48
>>    #95:  (&p->pi_lock){-.-.-.}, at: [<ffffffff810b09c1>] try_to_wake_up+0x29/0x20b
>
> If you haven't already configured ftrace into your kernel, can you
> please do so. Specifically:
>
> CONFIG_FUNCTION_TRACER=y
> CONFIG_FUNCTION_GRAPH_TRACER=y
> CONFIG_DYNAMIC_FTRACE=y
>
> Then, before triggering this, run the following as root:
>
>   # mount -t debugfs nodev /sys/kernel/debug
>   # cd /sys/kernel/debug/tracing
>   # echo net_rx_action > set_graph_function
>   # echo function_graph > current_tracer
>
> In the kernel, where you added the above dump, before any of the printks
> happen, add this too:
>
> 	trace_printk("BUG\n");
> 	tracing_off();
>
> This will stop the trace at the point of the error. The trace_printk()
> is a nice way to see the trace too.
>
> Then after you trigger the bug, do the following:
>
>    cat /sys/kernel/debug/tracing/trace
>
> and reply with that.

It's huge, so here's a link:

http://www.candelatech.com/~greearb/debug.tgz


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

