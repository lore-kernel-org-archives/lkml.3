Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaB1PUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:20:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:51049 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751671AbaB1PUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:20:02 -0500
Date: Fri, 28 Feb 2014 10:20:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140228102000.0e953a46@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>
	<20140224141329.1cd3bb52@gandalf.local.home>
	<20140224193043.GP6835@laptop.programming.kicks-ass.net>
	<530C12CA.6070308@zytor.com>
	<alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu>
	<dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com>
	<20140225094352.73e0e28c@gandalf.local.home>
	<alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
	<20140227173150.4e5ed747@gandalf.local.home>
	<530FC1C6.5040209@zytor.com>
	<alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
	<20140227215726.7018c861@gandalf.local.home>
	<alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
	<20140228092341.12a40f7c@gandalf.local.home>
	<alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 10:07:29 -0500 (EST)
Vince Weaver <vincent.weaver@maine.edu> wrote:

> On Fri, 28 Feb 2014, Steven Rostedt wrote:

> 199.900696: function:                               __module_address
> ...
> 199.900705: function:                      __kernel_text_address
> 199.900809: kernel_stack:         <stack trace>
> => perf_callchain (ffffffff810d35a2)
> => perf_prepare_sample (ffffffff810cfae3)
> => __perf_event_overflow (ffffffff810d02f4)
> => perf_swevent_overflow (ffffffff810d04e3)
> => perf_swevent_event (ffffffff810d0574)
> => perf_tp_event (ffffffff810d070c)
> => perf_trace_x86_exceptions (ffffffff810341b6)
> => trace_do_page_fault (ffffffff81537702)
> => trace_page_fault (ffffffff81534772)

Thank you!!! You just found the bug :-)

The bug was caused by:

commit 25c74b10bacead867478480170083f69cfc0db48
x86, trace: Register exception handler to trace IDT

With this code:

dotraplinkage void __kprobes
trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
{
	enum ctx_state prev_state;

	prev_state = exception_enter();
	trace_page_fault_entries(regs, error_code);
	__do_page_fault(regs, error_code);
	exception_exit(prev_state);
}

The trace_page_fault_entries() which is called before the cr2 is saved
can fault by perf doing a userspace stack trace. But the cr2 is not
restored when calling __do_page_fault() and that gets the wrong cr2.

Below is a patch that should fix this. Please remove all other patches
and try this out.

Thanks,

-- Steve

> 199.900810: function:             perf_output_begin
> 199.900810: function:             __do_page_fault
> 199.900810: function:                __perf_sw_event
> 199.900810: function:                   perf_swevent_get_recursion_context
> 199.900811: function:                down_read_trylock
> 199.900811: function:                _cond_resched
> 199.900811: function:                find_vma
> 199.900811: function:                bad_area
> 199.900812: function:                   up_read
> 199.900812: function:                   __bad_area_nosemaphore
> 199.900812: function:                      is_prefetch
> 199.900812: function:                         convert_ip_to_linear
> 199.900813: function:                      unhandled_signal
> 199.900813: function:                      __printk_ratelimit
> 199.900813: function:             _raw_spin_trylock
> 199.900813: function:             _raw_spin_unlock_irqrestore
> 199.900814: function:                      printk
> 199.900814: function:                         vprintk_emit

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 6dea040..66b636d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1271,9 +1271,15 @@ dotraplinkage void __kprobes
 trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
+	unsigned long cr2;
 
 	prev_state = exception_enter();
+	/* The trace might fault, save the cr2 register */
+	cr2 = read_cr2();
 	trace_page_fault_entries(regs, error_code);
+	/* Put back the original cr2 if needed */
+	if (cr2 != read_cr2())
+		write_cr2(cr2);
 	__do_page_fault(regs, error_code);
 	exception_exit(prev_state);
 }
