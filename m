Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaF3DNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 23:13:18 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39698 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaF3DNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 23:13:16 -0400
Message-ID: <53B0D5C4.8000909@hitachi.com>
Date: Mon, 30 Jun 2014 12:13:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: Re: [RFA][PATCH 00/27] ftrace: Remove ftrace_start/stop() and friends
References: <20140626165221.736847419@goodmis.org>
In-Reply-To: <20140626165221.736847419@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/27 1:52), Steven Rostedt wrote:
> * Request for Acks *
> 
>>From the time I created the use of function_trace_stop, I hated it.
> There was two reasons to create this, one was to try to lower the
> function tracing overhead when debugfs file tracing_enable was set to zero
> (note, tracing_enable no longer exists), the other was a way to stop
> function tracing when going down into suspend and resume.
> 
> Some function was causing suspend and resume to reboot the kernel. In
> debugging this I found that an empty callback from mcount would work.
> That is, instead of running the tracing code, I would just have the
> function trace callback be a nop:
> 
>  void function_trace_call(unsigned long ip, unsigned long parent_ip)
>  {
>  }
> 
> This worked. That means the code in mcount wasn't an issue. I started
> bisecting the contents of the function_trace_call and found that this
> would cause the system to reboot!
> 
>  void function_trace_call(unsigned long ip, unsigned long parent_ip)
>  {
> 	smp_processor_id();
>  }
> 
> That is, just calling smp_processor_id() was enough to trigger a triple
> fault on resume of the system.
> 
> Today, this big hammer approach of disabling the function tracer is starting
> to show its issues. It can't help out in debugging suspend and resume,
> and there's other function trace callbacks that should still work.
> 
> I also have learned ways to bisect functions that cause bugs in function
> tracing. I finally got some time to do so with a box that would reboot
> on suspend and resume. This led me down to a single function:
> 
>  restore_processor_state()
> 
> This made perfect sense, as this function is called from assembly on a
> CPU startup. One of the jobs of this function was to set up the GS register.
> That register is also the register that is used by smp_processor_id()
> to find what CPU the task is running on. With it not set up it will offset
> into some random location and fault. As the fault handlers can also be
> traced, those will fault too and finally the system will reset due to a
> triple fault.

Uh, from the same reason, I must list it in the kprobe blacklist too...

BTW, as far as I can review, x86 and generic parts of the series seems
OK to me. :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


