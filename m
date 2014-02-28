Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaB1Ujk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:39:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47181 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbaB1Ujj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:39:39 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <530B90A5.3090302@zytor.com> <20140224141329.1cd3bb52@gandalf.local.home> <20140224193043.GP6835@laptop.programming.kicks-ass.net> <530C12CA.6070308@zytor.com> <alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu> <dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com> <20140225094352.73e0e28c@gandalf.local.home> <alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu> <20140227173150.4e5ed747@gandalf.local.home> <530FC1C6.5040209@zytor.com> <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu> <20140227215726.7018c861@gandalf.local.home> <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu> <20140228092341.12a40f7c@gandalf.local.home> <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: perf_fuzzer compiled for x32 causes reboot
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 28 Feb 2014 12:38:52 -0800
To: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Message-ID: <40f095f7-605f-4885-951f-31da7d2d637a@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we need to figure out if the reboot problem and the segfault problem are actually the same... I have a nasty feeling they might be different problems.

On February 28, 2014 7:07:29 AM PST, Vince Weaver <vincent.weaver@maine.edu> wrote:
>On Fri, 28 Feb 2014, Steven Rostedt wrote:
>
>> Interesting. Are you doing a perf function trace?
>> 
>> And just in case, can you add this patch and make sure the copy is
>> called by NMI.
>
>199.900682: function:             trace_do_page_fault
>199.900683: page_fault_user:      address=__per_cpu_end
>ip=__per_cpu_end error_code=0x6
>199.900683: function:             perf_swevent_get_recursion_context
>199.900684: function:             perf_tp_event
>199.900684: function:                perf_swevent_event
>199.900684: function:                   perf_swevent_overflow
>199.900684: function:                      __perf_event_overflow
>199.900685: function:                         perf_prepare_sample
>199.900685: function:                           
>__perf_event_header__init_id
>199.900685: function:                               task_tgid_nr_ns
>199.900685: function:                               perf_event_tid
>199.900686: function:                                  __task_pid_nr_ns
>199.900686: function:                            perf_callchain
>199.900687: function:             copy_from_user_nmi
>199.900687: function:             trace_do_page_fault
>199.900687: page_fault_kernel:    address=irq_stack_union
>ip=copy_user_generic_string error_code=0x0
>199.900688: function:                __do_page_fault
>199.900688: function:                   bad_area_nosemaphore
>199.900688: function:                      __bad_area_nosemaphore
>199.900689: function:                         no_context
>199.900689: function:                            fixup_exception
>199.900689: function:                              
>search_exception_tables
>199.900689: function:                                  search_extable
>199.900691: function:             copy_user_handle_tail
>199.900691: function:             trace_do_page_fault
>199.900691: page_fault_kernel:    address=irq_stack_union
>ip=copy_user_handle_tail error_code=0x0
>199.900691: function:                __do_page_fault
>199.900692: function:                   bad_area_nosemaphore
>199.900692: function:                      __bad_area_nosemaphore
>199.900692: function:                         no_context
>199.900692: function:                            fixup_exception
>199.900692: function:                              
>search_exception_tables
>199.900692: function:                                  search_extable
>199.900693: function:             save_stack_trace
>199.900693: function:                dump_trace
>199.900694: function:                   print_context_stack
>199.900694: function:                      __kernel_text_address
>199.900694: function:                         is_module_text_address
>199.900695: function:                            __module_text_address
>199.900695: function:                               __module_address
>199.900695: function:                      __kernel_text_address
>199.900695: function:                         is_module_text_address
>199.900696: function:                            __module_text_address
>199.900696: function:                               __module_address
>...
>199.900705: function:                      __kernel_text_address
>199.900809: kernel_stack:         <stack trace>
>=> perf_callchain (ffffffff810d35a2)
>=> perf_prepare_sample (ffffffff810cfae3)
>=> __perf_event_overflow (ffffffff810d02f4)
>=> perf_swevent_overflow (ffffffff810d04e3)
>=> perf_swevent_event (ffffffff810d0574)
>=> perf_tp_event (ffffffff810d070c)
>=> perf_trace_x86_exceptions (ffffffff810341b6)
>=> trace_do_page_fault (ffffffff81537702)
>=> trace_page_fault (ffffffff81534772)
>199.900810: function:             perf_output_begin
>199.900810: function:             __do_page_fault
>199.900810: function:                __perf_sw_event
>199.900810: function:                  
>perf_swevent_get_recursion_context
>199.900811: function:                down_read_trylock
>199.900811: function:                _cond_resched
>199.900811: function:                find_vma
>199.900811: function:                bad_area
>199.900812: function:                   up_read
>199.900812: function:                   __bad_area_nosemaphore
>199.900812: function:                      is_prefetch
>199.900812: function:                         convert_ip_to_linear
>199.900813: function:                      unhandled_signal
>199.900813: function:                      __printk_ratelimit
>199.900813: function:             _raw_spin_trylock
>199.900813: function:             _raw_spin_unlock_irqrestore
>199.900814: function:                      printk
>199.900814: function:                         vprintk_emit

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
