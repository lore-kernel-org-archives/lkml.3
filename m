Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaBXDAR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:00:17 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:61376 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaBXDAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:00:15 -0500
Date: Sun, 23 Feb 2014 22:02:15 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <alpine.DEB.2.10.1402230859560.18653@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1402232151280.19337@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402211521040.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211732290.11615@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402212342090.17416@vincent-weaver-1.um.maine.edu>
 <53084317.4090304@zytor.com> <alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu> <e0bf16ca-011f-400d-b938-94e4de2fb1a6@email.android.com> <alpine.DEB.2.10.1402230859560.18653@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Feb 2014, Vince Weaver wrote:
> 
> and as far as I can tell nothing touches rbp again until the segfault.
> Nothing in _memset_sse2 does as far as I can tell.

I only know enough about ftrace to be dangerous, but here is what I think 
is the trace of the problem:

     perf_fuzzer-11492 [000] 197077.488363: function:             intel_get_event_constraints
     perf_fuzzer-11492 [000] 197077.488363: function:                intel_pebs_constraints
     perf_fuzzer-11492 [000] 197077.488365: function:             intel_put_event_constraints
     perf_fuzzer-11492 [000] 197077.488365: function:             intel_pmu_enable_all
     perf_fuzzer-11492 [000] 197077.488366: function:                intel_pmu_pebs_enable_all
     perf_fuzzer-11492 [000] 197077.488367: function:                intel_pmu_lbr_enable_all
     perf_fuzzer-11492 [000] 197077.488366: function:                intel_pmu_pebs_enable_all
     perf_fuzzer-11492 [000] 197077.488367: function:                intel_pmu_lbr_enable_all
     perf_fuzzer-11492 [000] 197077.488368: function:             mutex_unlock
     perf_fuzzer-11492 [000] 197077.488368: function:             mutex_lock
     perf_fuzzer-11492 [000] 197077.488369: function:                _cond_resched
     perf_fuzzer-11492 [000] 197077.488370: function:             _raw_spin_lock_irq
     perf_fuzzer-11492 [000] 197077.488370: function:             mutex_unlock
     perf_fuzzer-11492 [000] 197077.488371: function:             mutex_lock
     perf_fuzzer-11492 [000] 197077.488371: function:                _cond_resched
     perf_fuzzer-11492 [000] 197077.488372: function:             _raw_spin_lock_irq
     perf_fuzzer-11492 [000] 197077.488373: function:             mutex_unlock
     perf_fuzzer-11492 [000] 197077.488373: function:             mutex_lock
     perf_fuzzer-11492 [000] 197077.488374: function:                _cond_resched
     perf_fuzzer-11492 [000] 197077.488374: function:             _raw_spin_lock_irq
     perf_fuzzer-11492 [000] 197077.488375: function:             smp_call_function_single
     perf_fuzzer-11492 [000] 197077.488376: function:             _raw_spin_lock
     perf_fuzzer-11492 [000] 197077.488377: function:             mutex_unlock
     perf_fuzzer-11492 [000] 197077.488378: function:             mutex_lock
     perf_fuzzer-11492 [000] 197077.488378: function:                _cond_resched
     perf_fuzzer-11492 [000] 197077.488379: function:             _raw_spin_lock_irq
     perf_fuzzer-11492 [000] 197077.488380: function:             smp_call_function_single
     perf_fuzzer-11492 [000] 197077.488380: function:             _raw_spin_lock
     perf_fuzzer-11492 [000] 197077.488381: function:             mutex_unlock
     perf_fuzzer-11492 [000] 197077.488382: function:             mutex_unlock
     perf_fuzzer-11492 [000] 197077.488383: function:             syscall_trace_leave
     perf_fuzzer-11492 [000] 197077.488383: sys_exit:             NR 1073741981 = 0
     perf_fuzzer-11492 [000] 197077.488387: function:             do_device_not_available
     perf_fuzzer-11492 [000] 197077.488387: function:                math_state_restore
     perf_fuzzer-11492 [000] 197077.488390: function:             trace_do_page_fault
     perf_fuzzer-11492 [000] 197077.488391: page_fault_user:      address=__per_cpu_end ip=__per_cpu_end error_code=0x6
     perf_fuzzer-11492 [000] 197077.488395: function:             perf_callchain
     perf_fuzzer-11492 [000] 197077.488396: function:             copy_from_user_nmi
     perf_fuzzer-11492 [000] 197077.488397: function:             trace_do_page_fault
     perf_fuzzer-11492 [000] 197077.488398: page_fault_kernel:    address=irq_stack_union ip=copy_user_generic_string error_code=0x0
     perf_fuzzer-11492 [000] 197077.488399: function:                __do_page_fault
     perf_fuzzer-11492 [000] 197077.488400: function:                   bad_area_nosemaphore
     perf_fuzzer-11492 [000] 197077.488401: function:                      __bad_area_nosemaphore
     perf_fuzzer-11492 [000] 197077.488401: function:                         no_context
     perf_fuzzer-11492 [000] 197077.488402: function:                            fixup_exception
     perf_fuzzer-11492 [000] 197077.488403: function:                               search_exception_tables
     perf_fuzzer-11492 [000] 197077.488403: function:                                  search_extable
     perf_fuzzer-11492 [000] 197077.488405: function:             copy_user_handle_tail
     perf_fuzzer-11492 [000] 197077.488406: function:             trace_do_page_fault
     perf_fuzzer-11492 [000] 197077.488406: page_fault_kernel:    address=irq_stack_union ip=copy_user_handle_tail error_code=0x0
     perf_fuzzer-11492 [000] 197077.488407: function:                __do_page_fault
     perf_fuzzer-11492 [000] 197077.488408: function:                   bad_area_nosemaphore
     perf_fuzzer-11492 [000] 197077.488409: function:                      __bad_area_nosemaphore
     perf_fuzzer-11492 [000] 197077.488409: function:                         no_context
     perf_fuzzer-11492 [000] 197077.488410: function:                            fixup_exception
     perf_fuzzer-11492 [000] 197077.488410: function:                               search_exception_tables
     perf_fuzzer-11492 [000] 197077.488411: function:                                  search_extable
     perf_fuzzer-11492 [000] 197077.488413: function:             perf_output_begin
     perf_fuzzer-11492 [000] 197077.488414: function:             perf_output_copy
     perf_fuzzer-11492 [000] 197077.488415: function:             perf_output_copy
     perf_fuzzer-11492 [000] 197077.488415: function:             perf_output_copy
     perf_fuzzer-11492 [000] 197077.488416: function:             perf_output_copy
     perf_fuzzer-11492 [000] 197077.488418: function:             perf_output_copy
     perf_fuzzer-11492 [000] 197077.488419: function:             perf_output_copy
     perf_fuzzer-11492 [000] 197077.488419: function:             perf_output_end
     perf_fuzzer-11492 [000] 197077.488420: function:                perf_output_put_handle
     perf_fuzzer-11492 [000] 197077.488421: function:             __do_page_fault
     perf_fuzzer-11492 [000] 197077.488422: function:                down_read_trylock
     perf_fuzzer-11492 [000] 197077.488423: function:                _cond_resched
     perf_fuzzer-11492 [000] 197077.488423: function:                find_vma
     perf_fuzzer-11492 [000] 197077.488424: function:                bad_area
     perf_fuzzer-11492 [000] 197077.488425: function:                   up_read
     perf_fuzzer-11492 [000] 197077.488426: function:                   __bad_area_nosemaphore
     perf_fuzzer-11492 [000] 197077.488426: function:                      is_prefetch
     perf_fuzzer-11492 [000] 197077.488427: function:                         convert_ip_to_linear
     perf_fuzzer-11492 [000] 197077.488428: function:                      unhandled_signal
     perf_fuzzer-11492 [000] 197077.488429: function:                      __printk_ratelimit
     perf_fuzzer-11492 [000] 197077.488430: function:             _raw_spin_trylock
     perf_fuzzer-11492 [000] 197077.488430: function:             _raw_spin_unlock_irqrestore
     perf_fuzzer-11492 [000] 197077.488431: function:                      printk
     perf_fuzzer-11492 [000] 197077.488432: function:                         vprintk_emit
     perf_fuzzer-11492 [000] 197077.488434: function:                            _raw_spin_lock
     perf_fuzzer-11492 [000] 197077.488443: function:                            cont_add
     perf_fuzzer-11492 [000] 197077.488444: function:                            console_trylock
     perf_fuzzer-11492 [000] 197077.488445: function:                               down_trylock
     perf_fuzzer-11492 [000] 197077.488445: function:                                  _raw_spin_lock_irqsave
     perf_fuzzer-11492 [000] 197077.488446: function:                                  _raw_spin_unlock_irqrestore
     perf_fuzzer-11492 [000] 197077.488447: function:                            console_unlock
     perf_fuzzer-11492 [000] 197077.488447: function:                               _raw_spin_lock_irqsave
     perf_fuzzer-11492 [000] 197077.488449: function:                               print_time
     perf_fuzzer-11492 [000] 197077.488452: function:                               T.950
     perf_fuzzer-11492 [000] 197077.488453: console:              [197179.420735] perf_fuzzer[11492]: segfault at 22e0 ip 000000000041efab sp 00000000ffda0938 error 6
