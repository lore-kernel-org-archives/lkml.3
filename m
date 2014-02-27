Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaB0WcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:32:23 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:54689 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751150AbaB0WcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:32:22 -0500
Date: Thu, 27 Feb 2014 17:31:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140227173150.4e5ed747@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu>
	<20140224172536.GD9987@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu>
	<530B841F.5050803@zytor.com>
	<alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu>
	<530B90A5.3090302@zytor.com>
	<20140224141329.1cd3bb52@gandalf.local.home>
	<20140224193043.GP6835@laptop.programming.kicks-ass.net>
	<530C12CA.6070308@zytor.com>
	<alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu>
	<dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com>
	<20140225094352.73e0e28c@gandalf.local.home>
	<alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 17:06:36 -0500 (EST)
Vince Weaver <vincent.weaver@maine.edu> wrote:

> 
> I spent some more time on this.
> I managed to get a trace that exhibited the bug practically right 
> away, but still unable to generate a reproducible trace :(  
> 
> So instead I'm adding WARN's and trace_printks to see what I can find out.
> 
> Here's a summary of what I think is happneing.  Please let me know if I'm 
> wildly wrong in analyzing this.
> 
> 
> 
> Userspace accesses the perf 
> ring-buffer-user-page of an event for the first time (in this trace
> it's a SW_CPU_CLOCK event).
> 
> This triggers a page_fault to bring in the page.
> 
> This triggers a TRACEPOINT event (task/task_newtask) which
> has PERF_SAMPLE_IP|PERF_SAMPLE_TID|PERF_SAMPLE_TIME|PERF_SAMPLE_CALLCHAIN|PERF_SAMPLE_ID|PERF_SAMPLE_CPU|PERF_SAMPLE_PERIOD|PERF_SAMPLE_STREAM_ID|PERF_SAMPLE_WEIGHT|PERF_SAMPLE_DATA_SRC|PERF_SAMPLE_TRANSACTION;
> and exclude_callchain_kernel=1, triggering a perf_callchain().
> 
> Here is a dump of the stack right after we enter perf_callchain()
> 
> vince@core2:~$ [  202.320444] ------------[ cut here ]------------
> [  202.324001] WARNING: CPU: 1 PID: 2873 at kernel/events/callchain.c:168 perf_callchain+0x67/0x211()
> hermal_sys ehci_pci ehci_hcd sg sd_mod usbcore usb_common
> [  202.324001] CPU: 1 PID: 2873 Comm: perf_fuzzer Not tainted 3.14.0-rc3+ #24
> [  202.324001] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
> [  202.324001]  00000000000000a8 ffff880119ec1b48 ffffffff81531dc1 00000000000000a8
> [  202.324001]  0000000000000000 ffff880119ec1b88 ffffffff81040ce4 ffff880119ec1b88
> [  202.324001]  ffffffff810d416f ffff880119ec1e38 ffff8800cba67800 0000000000000000
> [  202.324001] Call Trace:
> [  202.324001]  [<ffffffff81531dc1>] dump_stack+0x49/0x60
> [  202.324001]  [<ffffffff81040ce4>] warn_slowpath_common+0x81/0x9b
> [  202.324001]  [<ffffffff810d416f>] ? perf_callchain+0x67/0x211
> [  202.324001]  [<ffffffff81040d18>] warn_slowpath_null+0x1a/0x1c
> [  202.324001]  [<ffffffff810d416f>] perf_callchain+0x67/0x211
> [  202.324001]  [<ffffffff8106b0ab>] ? local_clock+0x1b/0x24
> [  202.324001]  [<ffffffff810d0872>] perf_prepare_sample+0x7b/0x304
> [  202.324001]  [<ffffffff810d1079>] __perf_event_overflow+0x156/0x1c1
> [  202.324001]  [<ffffffff810f4613>] ? free_pgtables+0xa7/0xc9
> [  202.324001]  [<ffffffff810d125e>] perf_swevent_overflow+0x41/0x5b
> [  202.324001]  [<ffffffff810d12ea>] perf_swevent_event+0x72/0x74
> [  202.324001]  [<ffffffff810d1478>] perf_tp_event+0xea/0x1ef
> [  202.324001]  [<ffffffff8103515a>] ? perf_trace_x86_exceptions+0x4c/0xba
> [  202.324001]  [<ffffffff810351b6>] perf_trace_x86_exceptions+0xa8/0xba
> [  202.324001]  [<ffffffff8103515a>] ? perf_trace_x86_exceptions+0x4c/0xba
> [  202.324001]  [<ffffffff81538439>] trace_do_page_fault+0x48/0x99
> [  202.324001]  [<ffffffff815354b2>] trace_page_fault+0x22/0x30
> [  202.324001] ---[ end trace 31ccd31b4e82cb42 ]---
> 
> This triggers a kernel pagefault because the BP register is not valid and
> copy_from_user_nmi() tries to copy the user stack area from there.
> 
> This *should* be OK?  And it maybe looks like it works, but then
> 
> 	copy_user_handle_tail()
> 
> causes another page fault again at the invaid BP register.
> 
> But then the code continues to
> 	perf_output_begin()
> 
> 
> 237.265689: page_fault_kernel:    address=0x17a0 ip=copy_user_handle_tail error_code=0x0
> 237.265689: function:                __do_page_fault
> 237.265689: function:                   bad_area_nosemaphore
> 237.265690: function:                      __bad_area_nosemaphore
> 237.265690: function:                         no_context
> 237.265690: function:                            fixup_exception
> 237.265690: function:                               search_exception_tables
> 237.265690: function:                                  search_extable
> 237.265691: function:             perf_output_begin

You can also allow perf to be traced. Remove the CFLAGS_REMOVE_core.o
line from kernel/events/Makefile.

> 237.265692: bprint:               perf_output_begin: VMW: event type 2 config 2a st: 2c3e7
> 
> how are we back in __do_page_fault again here?

Well, the perf ring buffer is vmalloced, right? That can cause a page
fault too.

> 
> 237.265692: function:             __do_page_fault

Try adding a trace_printk() to see all the page faults?

> 237.265692: function:                down_read_trylock
> 237.265692: function:                _cond_resched
> 237.265693: function:                find_vma
> 237.265693: function:                bad_area
> 237.265693: function:                   up_read
> 237.265693: function:                   __bad_area_nosemaphore
> 237.265694: function:                      is_prefetch
> 237.265694: function:                         convert_ip_to_linear
> 237.265695: function:                      unhandled_signal
> 237.265695: function:                      __printk_ratelimit
> 237.265695: function:             _raw_spin_trylock
> 237.265695: function:             _raw_spin_unlock_irqrestore
> 237.265696: function:                      printk
> 237.265696: function:                         vprintk_emit
> 
> [  202.877004] perf_fuzzer[2873]: segfault at 17a0 ip 00000000004017fd sp 00000000ffd19d10 error 6 in perf_fuzzer[400000+d1000]
> 

Yeah, something is getting mesed up.

-- Steve
