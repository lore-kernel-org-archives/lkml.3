Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaBXSe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:34:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39665 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbaBXSe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:34:57 -0500
Message-ID: <530B90A5.3090302@zytor.com>
Date: Mon, 24 Feb 2014 10:34:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vince Weaver <vincent.weaver@maine.edu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
References: <53084317.4090304@zytor.com> <alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu> <e0bf16ca-011f-400d-b938-94e4de2fb1a6@email.android.com> <alpine.DEB.2.10.1402230859560.18653@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402232151280.19337@vincent-weaver-1.um.maine.edu> <530AD71E.50800@zytor.com> <alpine.DEB.2.10.1402241030500.19768@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com> <alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu> <20140224172536.GD9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu> <530B841F.5050803@zytor.com> <alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu>
In-Reply-To: <alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 10:07 AM, Vince Weaver wrote:
>>
>> Anyway I've attached the full tail end of the trace if you want to see 
>> everything that happens.
> 
> and then I note there are *two* kernel page faults.
> 
>      perf_fuzzer-2979  [000]   161.475924: page_fault_kernel:    address=irq_stack_union ip=copy_user_generic_string error_code=0x0
> address=0x1 ip=0xffffffff812a7d9c error_code=0x0
>      perf_fuzzer-2979  [000]   161.475924: function:                __do_page_fault
>      perf_fuzzer-2979  [000]   161.475924: function:                   bad_area_nosemaphore
>      perf_fuzzer-2979  [000]   161.475925: function:                      __bad_area_nosemaphore
>      perf_fuzzer-2979  [000]   161.475925: function:                         no_context
>      perf_fuzzer-2979  [000]   161.475925: function:                            fixup_exception
>      perf_fuzzer-2979  [000]   161.475926: function:                               search_exception_tables
>      perf_fuzzer-2979  [000]   161.475926: function:                                  search_extable
>      perf_fuzzer-2979  [000]   161.475927: function:             copy_user_handle_tail
>      perf_fuzzer-2979  [000]   161.475927: function:             trace_do_page_fault
>      perf_fuzzer-2979  [000]   161.475928: page_fault_kernel:    address=irq_stack_union ip=copy_user_handle_tail error_code=0x0
> address=0x1 ip=0xffffffff812a92bb error_code=0x0
>      perf_fuzzer-2979  [000]   161.475928: function:                __do_page_fault
>      perf_fuzzer-2979  [000]   161.475928: function:                   bad_area_nosemaphore
>      perf_fuzzer-2979  [000]   161.475929: function:                      __bad_area_nosemaphore
>      perf_fuzzer-2979  [000]   161.475929: function:                         no_context
>      perf_fuzzer-2979  [000]   161.475929: function:                            fixup_exception
>      perf_fuzzer-2979  [000]   161.475929: function:                               search_exception_tables
>      perf_fuzzer-2979  [000]   161.475930: function:                                  search_extable
>      perf_fuzzer-2979  [000]   161.475931: function:             perf_output_begin
>      perf_fuzzer-2979  [000]   161.475931: function:             perf_output_copy
> 
> That second one is in copy_user_handle_tail()
> 

Either way, it really seems like we have a case of CR2 leakage out of
the NMI context.

	-hpa

