Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab3A2V0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 16:26:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5028 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab3A2V0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 16:26:13 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=9Wk9NYerj9wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=O1YP5waFyKMA:10 a=UJCsEg5NEIJW8Hv-zhQA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=20M3INtApBeNQU2x:21 a=LdCQDXns3_TeuYxF:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359494770.17639.76.camel@gandalf.local.home>
Subject: Re: [GIT PULL] cputime: Full dynticks task/cputime accounting v7
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Date: Tue, 29 Jan 2013 16:26:10 -0500
In-Reply-To: <1359426979.17639.10.camel@gandalf.local.home>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	 <1359417749.17639.6.camel@gandalf.local.home>
	 <1359426979.17639.10.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 21:36 -0500, Steven Rostedt wrote:

> [root@bxtest ~]# time /work/c/kernelspin  10
> 
> real	0m10.001s
> user	0m1.114s
> sys	0m8.886s
> 
> 
> But after enabling the force context_tracking I get this:
> 
> [root@bxtest ~]# time /work/c/kernelspin  10
> 
> real	0m10.001s
> user	0m3.769s
> sys	0m6.203s
> 
> 
> Consistently. All the other runs always had a 1.X 8.X ratio. This seems
> to give 3.7x 6.2x ratio consistently. Maybe it's more accurate then the
> others. Or something else is broken.
> 
> I'll look deeper into it.

After lots of investigation, I believe I know why this is so. It is
pretty much as accurate as what we have now, except before it would
error on the side of the kernel, where as here we error on the side of
userspace.

I added a trace_printk where the utime and stime is updated, and applied
my (coming to mainline soon) function_graph patch that adds a
"max_depth" to  limit the function graph tracing. Setting the max_depth
to 1 shows you nicely all the places that enter the kernel. Running this
against my kernelspin.c program I get:

kernelsp-2668    7d...  2837.236400: funcgraph_entry:        1.373 us   |  do_page_fault();
kernelsp-2668    7d...  2837.236403: funcgraph_entry:        1.409 us   |  do_page_fault();
kernelsp-2668    7....  2837.236405: funcgraph_entry:        0.441 us   |  syscall_trace_enter();
kernelsp-2668    7....  2837.236406: funcgraph_entry:        0.114 us   |  sys_brk();
kernelsp-2668    7....  2837.236406: funcgraph_entry:        1.155 us   |  syscall_trace_leave();
kernelsp-2668    7d...  2837.236408: funcgraph_entry:        2.579 us   |  do_page_fault();
kernelsp-2668    7d...  2837.236413: funcgraph_entry:        2.720 us   |  do_page_fault();
kernelsp-2668    7d...  2837.236417: funcgraph_entry:        2.314 us   |  do_page_fault();

I then wrote a perl script to parse the timestamps (and it notices the
syscall_trace_enter and leave as entering the kernel) and it creates a
more accurate time that the program was in the kernel. It outputs
something like:

user time: 0.750846
system time: 5.695917
dropped event time: 3.525461
calc utime: 1.878059 ns
calc stime: 4.520833 ns

The first two times are what it came up with from the timestamps. As
there were events dropped, it also was able to calculate the time missed
for that.

As I used trace_printk() to show the updates of utime and stime, the
last two numbers show the calculated times that those functions came up
with. Note, the dropped events would include both the tracing as well as
updates made by this time.

It's not really that far off.

Then you gave me your config where you could not reproduce the issue. I
ran that too, and got:

user time:      0.000009
system time:    9.974731
dropped event time:     0.000000
calc utime: 0.772511 ns
calc stime: 9.201983 ns

It still errored on the side of userspace, but what I found strange was
that:

1) there were no dropped events
2) the utime/stime from the trace timestamps was much different than my
config

Looking at the two outputs of the trace I found:

my config:

kernelsp-2668    7....  2837.239219: funcgraph_entry:        1.369 us   |  sys_brk();
kernelsp-2668    7....  2837.239225: funcgraph_entry:        1.790 us   |  sys_brk();
kernelsp-2668    7....  2837.239229: funcgraph_entry:        0.778 us   |  sys_brk();
kernelsp-2668    7....  2837.239232: funcgraph_entry:        0.896 us   |  sys_brk();

your config:

kernelsp-969     6....   207.618010: funcgraph_entry:      + 11.123 us  |  sys_brk();
kernelsp-969     6....   207.618024: funcgraph_entry:        7.519 us   |  sys_brk();
kernelsp-969     6....   207.618033: funcgraph_entry:        7.616 us   |  sys_brk();
kernelsp-969     6....   207.618043: funcgraph_entry:        7.420 us   |  sys_brk();

Big difference in the time spent in sys_brk()!

I did a full function graph trace and found:

      kernelspin-1015  [006]   533.405921: funcgraph_entry:                   |  sys_brk() {
      kernelspin-1015  [006]   533.405921: funcgraph_entry:                   |    down_write() {
      kernelspin-1015  [006]   533.405921: funcgraph_entry:                   |      __might_sleep() {
      kernelspin-1015  [006]   533.405922: funcgraph_entry:        0.051 us   |        debug_lockdep_rcu_enabled();
          <idle>-0     [003]   533.405922: bprint:               account_system_time : system: 2368
      kernelspin-1015  [006]   533.405922: funcgraph_entry:        0.044 us   |        debug_lockdep_rcu_enabled();
      kernelspin-1015  [006]   533.405923: funcgraph_entry:        0.051 us   |        debug_lockdep_rcu_enabled();
      kernelspin-1015  [006]   533.405923: funcgraph_exit:         1.440 us   |      }
      kernelspin-1015  [006]   533.405923: funcgraph_exit:         2.015 us   |    }
      kernelspin-1015  [006]   533.405924: funcgraph_entry:        0.113 us   |    find_vma();
[...]
      kernelspin-1015  [006]   533.405938: funcgraph_entry:                   |            set_track() {
      kernelspin-1015  [006]   533.405939: funcgraph_entry:                   |              save_stack_trace() {
       trace-cmd-1010  [005]   533.405939: bprint:               account_system_time : system: 3492
      kernelspin-1015  [006]   533.405939: funcgraph_entry:                   |                dump_trace() {
      kernelspin-1015  [006]   533.405939: funcgraph_entry:                   |                  print_context_stack() {
      kernelspin-1015  [006]   533.405939: funcgraph_entry:                   |                    __kernel_text_address() {
      kernelspin-1015  [006]   533.405939: funcgraph_entry:                   |                      is_module_text_address() {
      kernelspin-1015  [006]   533.405940: funcgraph_entry:                   |                        __module_text_address() {
       trace-cmd-1010  [005]   533.405940: bprint:               account_user_time : user: 1014
      kernelspin-1015  [006]   533.405940: funcgraph_entry:        0.041 us   |                          __module_address();
      kernelspin-1015  [006]   533.405940: funcgraph_exit:         0.464 us   |                        }
      kernelspin-1015  [006]   533.405940: funcgraph_exit:         0.849 us   |                      }
      kernelspin-1015  [006]   533.405941: funcgraph_exit:         1.231 us   |                    }
      kernelspin-1015  [006]   533.405941: funcgraph_entry:                   |                    __kernel_text_address() {
      kernelspin-1015  [006]   533.405941: funcgraph_entry:                   |                      is_module_text_address() {
      kernelspin-1015  [006]   533.405941: funcgraph_entry:                   |                        __module_text_address() {
      kernelspin-1015  [006]   533.405941: funcgraph_entry:        0.046 us   |                          __module_address();
      kernelspin-1015  [006]   533.405942: funcgraph_exit:         0.442 us   |                        }
      kernelspin-1015  [006]   533.405942: funcgraph_exit:         0.851 us   |                      }
      kernelspin-1015  [006]   533.405942: funcgraph_exit:         1.254 us   |                    }
      kernelspin-1015  [006]   533.405942: funcgraph_entry:        0.049 us   |                    __kernel_text_address();
      kernelspin-1015  [006]   533.405943: funcgraph_entry:                   |                    save_stack_address() {
      kernelspin-1015  [006]   533.405943: funcgraph_entry:        0.042 us   |                      __save_stack_address();
      kernelspin-1015  [006]   533.405944: funcgraph_exit:         0.447 us   |                    }
          <idle>-0     [005]   533.405944: bprint:               account_system_time : system: 3993
      kernelspin-1015  [006]   533.405944: funcgraph_entry:                   |                    save_stack_address() {
      kernelspin-1015  [006]   533.405944: funcgraph_entry:        0.055 us   |                      __save_stack_address();
      kernelspin-1015  [006]   533.405944: funcgraph_exit:         0.459 us   |                    }

And it goes on and on!

Sure enough, a big difference between my config and yours, was not only
that I had slab and you had slub, but you also had lockdep, slub
debugging and a whole host of things enabled in your config that will
slow the kernel down.

I turned off all that in your config, recompiled, rebooted, and now I
get this:

[root@bxtest ~]# time /work/c/kernelspin  10

real    0m10.001s
user    0m4.336s
sys     0m5.636s

Thus because the sys_brk is so fast, the program literally does millions
of them. As we suffer a little error to the user side every time we do
the calculation:

[user mode]

<enter kernel>     <------------+
                                |--- error
calculate utime    <------------+

[system mode]

calculate stime    <------------+
                                |--- error
<enter user>       <------------+

That is, from the time we enter the kernel to the time we make the
user/system calculation, plus the time we make the user/system
calculation and then leave the kernel, that total time is a slight
error. And this error happens every time we enter or leave the kernel.
There's no way around that.

Because this was an unrealistic program that did sys_brk() millions of
times (and that's all it did), this program exaggerated the error. By
adding the debug options, and slowing down the sys_brk by a multitude,
we also made the % error decrease by a multitude. It even allowed us not
to lose events.

Thus, I think we can blow off this concern as just an expected error of
the dynamic calculation process. And this will only happen when we have
a CPU in no hz mode, which shouldn't be a big deal anyway, as that is
usually done by processes that don't want to go into the kernel in the
first place. Thus keeping the error down.

But this error should be documented somewhere. Maybe in the Kconfig.

You can have my Acked-by back :-)

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


