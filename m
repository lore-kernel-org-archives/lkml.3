Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaGHPyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:54:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50404 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHPyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:54:06 -0400
Message-ID: <53BC141B.3020405@codeaurora.org>
Date: Tue, 08 Jul 2014 11:54:03 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH] RFC: perf: Make overflow signals inheritable
References: <1403727129-20665-1-git-send-email-cov@codeaurora.org> <20140707091308.GH6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140707091308.GH6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for the review.

On 07/07/2014 05:13 AM, Peter Zijlstra wrote:
> On Wed, Jun 25, 2014 at 04:12:09PM -0400, Christopher Covington wrote:
>> In order to get a signal from the perf events framework (use an
>> "event_limit"), one must not not only call perf_event_open() with the
>> appropriate sample_period, watermark, and wakeup_watermark values,
>> but also set the FASYNC flag on the resulting file descriptor with
>> fcntl(). 
> 
> Tell me more; why are you wanting this?

I'm slicing and dicing program execution to approximate long program runs on
slow systems. For single-threaded applications, the SimPoint lossy instruction
stream compression algorithm seems to be the most popular approach but I've
yet to come across a similarly successful approach for
multi-threaded/multi-process programs. I'm hoping that improving the
multi-threaded/multi-process support of the perf events framework will enable
experimentation in that area.

One use case is "fast forwarding": run a program for X million instructions
(or maybe some other event) on a fast system. Take a checkpoint, either with
Checkpoint and Restore in Userspace (CRIU) or something like QEMU's
snapshotting capability. At this point you could either fast forward further
or kill the program.

The other use case is statistic collection for a window of execution: run a
program, restored from a checkpoint in my case, for Y million instructions.
Collect more statistics than just the instruction count. I'm using something
along the lines of `perf stat -e event:u -p pid`. When the given number of
instructions have elapsed you can collect statistics for an adjacent window of
execution or kill the program. This might be done on the slow system or a
third system for reference.

>> If the inherit attribute is also set, one would expect child
>> tasks to cause signals like their parents. They don't, though,
>> because their FASYNC setting isn't set (and can't be by the user
>> since only the parent has a file descriptor). To fix this, allow the
>> parent's FASYNC value to be passed along to child events when the
>> inherit attribute is set. Overflow counts are still per process and
>> per CPU.
> 
> There's more issues though; the comment you deleted isn't explicit about
> this (it maybe should have been).
> 
> This would mean the inherited children would get signals; they might not
> be expecting them.

The possibility for programs to receive unexpected signals from the perf
events framework exists without my patch. Consider when an event is opened and
set up to send a signal, initially in the disabled state but with
enable-on-exec set, and then an unsuspecting program is run with exec().
Elaborating on that scenario a parent process can fork and set up the signal
to be sent to the child, which runs the unsuspecting program with exec(). I
thought this behavior was intentional and have used both of these scenarios.
I've been using ptrace to intercept the signal and replace the SIGIO with a
SIGSTOP. Should I write a separate patch to generate the SIGSTOP directly?
There may be some overlap with another patch I recently sent out to generate a
SIGSTOP in the tracing framework [1].

1. https://lwn.net/Articles/603805/

> When they do get a signal, they should be calling IOC_REFRESH to re-arm
> the signal, but that explicitly doesn't work for inherited events.

>From the man page:

  There are two ways to generate signals.

       The first is to set a wakeup_events or wakeup_watermark value that
       will generate a signal if a certain number of samples or bytes have
       been written to the mmap ring buffer.  In this case, a signal of type
       POLL_IN is sent.

       The other way is by use of the PERF_EVENT_IOC_REFRESH ioctl.  This
       ioctl adds to a counter that decrements each time the event
       overflows.  When nonzero, a POLL_IN signal is sent on overflow, but
       once the value reaches 0, a signal is sent of type POLL_HUP and the
       underlying event is disabled.

As I meant to convey in the commit text, I'm using the first approach of
setting wakeup_watermark (to 1).

> Which leads me to believe you didn't actually test this.

This patch has received testing, although with a limited combination of
attributes. I will include the test case in the next revision.

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
