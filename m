Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3JaUuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 16:50:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:45235 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751710Ab3JaUuU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 16:50:20 -0400
Date: Thu, 31 Oct 2013 16:50:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Kenneth Lee <nek.in.cn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: An small ftrace enhancement idea
Message-ID: <20131031165015.757d0efb@gandalf.local.home>
In-Reply-To: <4A791BBD-EBBE-420F-8199-E4BAAF6A3C46@gmail.com>
References: <4A791BBD-EBBE-420F-8199-E4BAAF6A3C46@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013 15:39:50 -0700
Kenneth Lee <nek.in.cn@gmail.com> wrote:

> Dear Steven,
> 
> I want to add a new function to ftrace subsystem. Sometimes, we will face such a problem: system do not response to the input on time one to two times everyday. It is not easy to capture because it rarely happens. So I want to add a function to the kernel. If I have such problem, I insert a kernel module, who add a hook to the position that receive the input and another to the position that response to the input (with a session id if necessary). And I can compare the time between them and if the period is longer then a pre-set threshold, I can give a signal to a user helper application (maybe a script waiting on the file), which then can save the trace event to a file for later inspection.

I'm a little confused in what you want.


> 
>  
> 
> The user helper script may look like this:
> 
>  
> 
> #/bin/sh
> 
>  
> 
> echo ‘sched:*’ > /sys/kernel/debug/tracing/set_event
> 
> modprobe delay_inspector.ko threshold=500
> 
> cat /sys/kernel/debug/tracing/waiter #wait for signal
> 
> cp /sys/kernel/debug/tracing/trace /var/log/delay_infomation
> 
>  
> 
>  
> 
> It looks like a standalone function. But I don’t have place to put it. Do you think I can implement it in ftrace? And do you think if there are better solution?
> 

You want something to wake up if it takes too long before an event
happens?

If so, why not just use a select() on the trace_pipe and if it times
out, then dump the trace. You can even set up a separate instance.

 (this is waiting for a schedule switch to pid 1)

cd /sys/kernel/debug/tracing
mkdir instances/mine
echo 'next_pid == 1' > instances/mine/events/sched/sched_switch/filter
echo 1 > instances/mine/events/sched/sched_switch/enable


The in a userspace program, I open "instances/mine/events/trace_pipe"
and run a select() on that file descriptor with a given timeout. If the
event does not happen within the expected time frame, the select
returns zero, and this userspace program can deal with it.

Is that the functionality you are trying to achieve?

-- Steve
