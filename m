Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaJACS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 22:18:56 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35465 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaJACSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 22:18:54 -0400
Message-ID: <542B6488.9090902@hitachi.com>
Date: Wed, 01 Oct 2014 11:18:48 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [hw_breakpoint] WARNING: at kernel/trace/trace_kprobe.c:1393
 kprobe_trace_self_tests_init()
References: <20140930074305.GA8090@wfg-t540p.sh.intel.com> <20140930175844.GA20922@redhat.com>
In-Reply-To: <20140930175844.GA20922@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/01 2:58), Oleg Nesterov wrote:
> Hi Fengguang,
> 
> On 09/30, Fengguang Wu wrote:
>>
>> Hi Oleg,
>>
>> 0day kernel testing robot got the below dmesg and the first bad commit is
>>
>> commit 8b4d801b2b123b6c09742f861fe44a8527b84d47
>> Author:     Oleg Nesterov <oleg@redhat.com>
>> AuthorDate: Thu Jun 20 17:50:06 2013 +0200
>> Commit:     Ingo Molnar <mingo@kernel.org>
>> CommitDate: Thu Jun 20 17:57:00 2013 +0200
>>
>>     hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
>>
>>     trinity fuzzer triggered WARN_ONCE("Can't find any breakpoint
>>     slot") in arch_install_hw_breakpoint() but the problem is not
>>     arch-specific.
>>
>>     The problem is, task_bp_pinned(cpu) checks "cpu == iter->cpu"
>>     but this doesn't account the "all cpus" events with iter->cpu <
>>     0.
>>
>>     This means that, say, register_user_hw_breakpoint(tsk) can
>>     happily create the arbitrary number > HBP_NUM of breakpoints
>>     which can not be activated. toggle_bp_task_slot() is equally
>>     wrong by the same reason and nr_task_bp_pinned[] can have
>>     negative entries.
>>
>>     Simple test:
>>
>>     	# perl -e 'sleep 1 while 1' &
>>     	# perf record -e mem:0x10,mem:0x10,mem:0x10,mem:0x10,mem:0x10 -p `pidof perl`
>>
>>     Before this patch this triggers the same problem/WARN_ON(),
>>     after the patch it correctly fails with -ENOSPC.
>>
>>     Reported-by: Vince Weaver <vincent.weaver@maine.edu>
>>     Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>>     Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
>>     Cc: <stable@vger.kernel.org>
>>     Link: http://lkml.kernel.org/r/20130620155006.GA6324@redhat.com
>>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
>>
>> +-----------------------------------------------------------------------+------------+------------+------------------+
>> |                                                                       | 003002e04e | 8b4d801b2b | v3.17-rc7_093000 |
>> +-----------------------------------------------------------------------+------------+------------+------------------+
>> | boot_successes                                                        | 60         | 0          | 0                |
>> | boot_failures                                                         | 0          | 20         | 11               |
>> | WARNING:at_kernel/trace/trace_kprobe.c:kprobe_trace_self_tests_init() | 0          | 20         | 11               |
>> | backtrace:kprobe_trace_self_tests_init                                | 0          | 20         | 11               |
>> | backtrace:warn_slowpath_null                                          | 0          | 20         | 11               |
>> | backtrace:kernel_init_freeable                                        | 0          | 20         | 11               |
>> +-----------------------------------------------------------------------+------------+------------+------------------+
>>
>> [    4.188679] Testing kprobe tracing:
>> [    4.189810] Could not insert probe at kprobe_trace_selftest_target+0: -22
> 
> __register_trace_kprobe() fails.
> 
> No, I am very sure this can't be caused by the commit above. If nothing else,
> task_bp_pinned() changed by this commit is not even called in this case.

Uh, right. I'm trying to reproduce this to analyze...

Anyway, I'd like to remove the whole of kprobe_trace selftest from the
kernel binary. Instead of that, we already have ftracetest scripts.
We can run the test after the kernel booted.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


