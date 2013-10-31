Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3JaXkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:40:17 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55934 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3JaXkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:40:15 -0400
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1816\))
Subject: Re: An small ftrace enhancement idea
From: Kenneth Lee <nek.in.cn@gmail.com>
In-Reply-To: <20131031165015.757d0efb@gandalf.local.home>
Date: Thu, 31 Oct 2013 16:40:12 -0700
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1B57F15E-49C6-4D62-8A2F-A3D54F783593@gmail.com>
References: <4A791BBD-EBBE-420F-8199-E4BAAF6A3C46@gmail.com> <20131031165015.757d0efb@gandalf.local.home>
To: Steven Rostedt <rostedt@goodmis.org>
X-Mailer: Apple Mail (2.1816)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you, Steve, 

Yes, with a separated instance, I can measure the latency for a stimulation while capture the other schedule events which I am interesting in. This is a better solution. I don’t know this “instance” stuff before. I don’t need to create another axe. I am sorry for my ignorance. 

Thanks and regards.

--Kenneth

在 2013年10月31日，下午1:50，Steven Rostedt <rostedt@goodmis.org> 写道：

> On Wed, 30 Oct 2013 15:39:50 -0700
> Kenneth Lee <nek.in.cn@gmail.com> wrote:
> 
>> Dear Steven,
>> 
>> I want to add a new function to ftrace subsystem. Sometimes, we will face such a problem: system do not response to the input on time one to two times everyday. It is not easy to capture because it rarely happens. So I want to add a function to the kernel. If I have such problem, I insert a kernel module, who add a hook to the position that receive the input and another to the position that response to the input (with a session id if necessary). And I can compare the time between them and if the period is longer then a pre-set threshold, I can give a signal to a user helper application (maybe a script waiting on the file), which then can save the trace event to a file for later inspection.
> 
> I'm a little confused in what you want.
> 
> 
>> 
>> 
>> 
>> The user helper script may look like this:
>> 
>> 
>> 
>> #/bin/sh
>> 
>> 
>> 
>> echo ‘sched:*’ > /sys/kernel/debug/tracing/set_event
>> 
>> modprobe delay_inspector.ko threshold=500
>> 
>> cat /sys/kernel/debug/tracing/waiter #wait for signal
>> 
>> cp /sys/kernel/debug/tracing/trace /var/log/delay_infomation
>> 
>> 
>> 
>> 
>> 
>> It looks like a standalone function. But I don’t have place to put it. Do you think I can implement it in ftrace? And do you think if there are better solution?
>> 
> 
> You want something to wake up if it takes too long before an event
> happens?
> 
> If so, why not just use a select() on the trace_pipe and if it times
> out, then dump the trace. You can even set up a separate instance.
> 
> (this is waiting for a schedule switch to pid 1)
> 
> cd /sys/kernel/debug/tracing
> mkdir instances/mine
> echo 'next_pid == 1' > instances/mine/events/sched/sched_switch/filter
> echo 1 > instances/mine/events/sched/sched_switch/enable
> 
> 
> The in a userspace program, I open "instances/mine/events/trace_pipe"
> and run a select() on that file descriptor with a given timeout. If the
> event does not happen within the expected time frame, the select
> returns zero, and this userspace program can deal with it.
> 
> Is that the functionality you are trying to achieve?
> 
> -- Steve

