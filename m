Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542AbaGOI5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:57:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:10921 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279AbaGOI5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:57:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,664,1400050800"; 
   d="scan'208";a="573308148"
Message-ID: <53C4ECDA.6010501@linux.intel.com>
Date: Tue, 15 Jul 2014 16:56:58 +0800
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Chen LinX <linx.z.chen@intel.com>
CC: paulus@samba.org, mingo@redhat.com, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Yanmin Zhang <yanmin.zhang@intel.com>
Subject: Re: [PATCH] perf: Don't enable the perf_event without in PERF_ATTACH_CONTEXT
 status
References: <1404358598-19186-1-git-send-email-linx.z.chen@intel.com> <20140714132756.GY19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140714132756.GY19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/7/14 21:27, Peter Zijlstra wrote:
> On Thu, Jul 03, 2014 at 11:36:38AM +0800, Chen LinX wrote:
>> From: "Chen LinX" <linx.z.chen@intel.com>
>>
>> when do cpu hotplug test and run below perf test together, pmu may access freed perf_event
>>
>> while true;
>> do
>> perf record -a -g -f sleep 10
>> rm perf.*
>> done
>>
>> the scenario is that when cpu offline firstly, the 'perf_cpu_notify' will disable event on the
>> pmu and remove it from the context list. after cpu online, the perf app may enable the event
> But it does not, right?

Thanks for your kind comments.
It does, actually.
The major reason is application calls many syscall to start perf.
1) perf_event_open => perf_install_in_context;
2) perf_ioctl => perf_event_enable.

After step 1), the cpu might be hot unplugged, and the event is removed from
the cpu context.
Then, the cpu is hog plugged back. The app runs at step 2) to enable the
event on that cpu.
Then, the cpu is hot unplugged again. As the event is not linked to
the cpu's context, perf_cpu_notify can't disable the events. Mostly, the
event is linked in cpuc->event_list[XXX]. At that time, applcation
might free the event.

When the cpu is plugged back, it might use the freed event and cause kernel
panic.

>
>> that without linked in context list again. when cpu offine the second time, the 'perf_cpu_notify'
>> can't disable event on the pmu as the event doesn't link to context list. the perf app may free
>> this event later(the free procedure try to disable event on the pmu but as the cpu is offline,
>> the 'cpu_function_call(event->cpu, __perf_remove_from_context, event)' is failed)
> Failed how, below is __perf_install_in_context.
>
>> . then after
>> cpu online again, pmu will access freed perf_event and hit panic.
>>
>> so adding PERF_ATTACH_CONTEXT flag check before enable event to avoid this scenario.
> In fact it does not. If you look at perf_event_enable() there's a code
> path that doesn't call __perf_event_enable().

Here we hit it with a per-cpu event instead of task event.

>
>> [  157.670138 ]  [<ffffffff8216321f>] __perf_install_in_context+0xff/0x170
> And yet, __perf_install_in_context isn't mentioned at all in the above.
>
>> Change-Id: I7265d83159b9180e9be3a370ba50e067385547bd
>> Signed-off-by: Yanmin Zhang <yanmin.zhang@intel.com>
>> Signed-off-by: Chen LinX <linx.z.chen@intel.com>
> Wrong SoB-chain, Yanmin didn't author this patch did he, seeing how From
> is you. And Yanmin didn't actually send me this patch either.

Lin works with me in the same team. He is smart, but new in kernel upstream

community. I debugged with him and he caught the root cause ahead of me.

The patch is good. Lin is running more testing with the latest kernel
3.16.0-rc5 now.

Thanks,

Yanmin



