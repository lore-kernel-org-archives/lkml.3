Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaAPJed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:34:33 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:39506 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaAPJe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:34:29 -0500
Message-ID: <52D7A750.50906@huawei.com>
Date: Thu, 16 Jan 2014 17:33:04 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: <oprofile-list@lists.sf.net>, <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, <wangnan0@huawei.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>, <sdu.liu@huawei.com>
Subject: Re: [PATCH] oprofile: check whether oprofile perf enabled in op_overflow_handler()
References: <52B3F66D.6060707@huawei.com> <20140113084555.GU20315@rric.localhost> <52D4984B.9090600@huawei.com> <20140114150553.GC20315@rric.localhost> <52D5EC44.30101@huawei.com> <20140115102445.GE20315@rric.localhost> <52D73148.4090408@huawei.com>
In-Reply-To: <52D73148.4090408@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,
The testcase which trigger the problem on kernel 2.6.34 is:
opcontrol --init
opcontrol --no-vmlinux
opcontrol --event=CPU_CYCLES:500:0:1:1
opcontrol --start

Run the testcase in the Linux 3.13-rc1 kernel, the last step "opcontrol --start"
will stall, and can't be killed,  and print the following messages:

#opcontrol --start
Using 2.6+ OProfile kernel interface.
Using log file /var/lib/oprofile/samples/oprofiled.log
Daemon started.

[  864.450714] INFO: rcu_sched self-detected stall on CPU { 0}  (t=2100 jiffies g=176 c=175 q=73)

then the watchdog will cause the os reboot, because the environment casing the kernel 2.6.34
warning message has gone. we use pandaboard to buildup the test environment now, but after reboot
the demsg will lost, so I can't get the dmesg messages.

Using the same test case, the problem also exists in the same kernel with the new patch applied:


# opcontrol --start

Using 2.6+ OProfile kernel interface.
Using log file /var/lib/oprofile/samples/oprofiled.log
Daemon started.
[  508.456878] INFO: rcu_sched self-detected stall on CPU { 0}  (t=2100 jiffies g=685 c=684 q=83)
[  571.496856] INFO: rcu_sched self-detected stall on CPU { 0}  (t=8404 jiffies g=685 c=684 q=83)
[  634.526855] INFO: rcu_sched self-detected stall on CPU { 0}  (t=14707 jiffies g=685 c=684 q=83)


During the test, I go through the code again. One thing confused me:
when the event's sample_period is small, even the events was enabled
after it was added to the perf_events list, the cpu won't keep printing
the warning, but the code will go to another branch oprofile_add_sample(),
so an interrupt storm will continue? In this way, it may be best to solve the
problem from userland? Like oprofile tools, the oprofile tool version must be below
v0.9.9, or the problem can't be reproduced. Because the v0.9.9 add the following
patch which increase the minimum cycle period:

ARM: events: increase minimum cycle period to 100k

On ARM, we intentionally leave the minimum event counters low since
the performance profile of the cores can vary dramatically between CPUs
and their implementations.

However, since the default event is CPU_CYCLES, it's best to err on the
side of caution and raise the limit to something more realistic so we
don't lock-up on the unsuspecting user (as opposed to somebody passing
an explicit event period).

This patch raises the CPU_CYCLES minimum event count to 100k on ARM.

Signed-off-by: Will Deacon <will.deacon@arm.com>

Authored by:  Will Deacon 2013-07-29
Committed by:  Maynard Johnson 2013-07-29
Browse code at this revision
Parent(s): [a7e408]
Child(ren): [491aff]
changed events/arm/armv7-common/events

events/arm/armv7-common/events Diff Switch to side-by-side view

--- a/events/arm/armv7-common/events
+++ b/events/arm/armv7-common/events
@@ -33,4 +33,4 @@
 event:0x1C counters:1,2,3,4,5,6 um:zero minimum:500 name:TTBR_WRITE_RETIRED : Write to TTBR architecturally executed, condition code pass
 event:0x1D counters:1,2,3,4,5,6 um:zero minimum:500 name:BUS_CYCLES : Bus cycle

-event:0xFF counters:0 um:zero minimum:500 name:CPU_CYCLES : CPU cycle
+event:0xFF counters:0 um:zero minimum:100000 name:CPU_CYCLES : CPU cycle


This is just my personal opinion. Maybe there is something wrong. What do you think about it?


On 2014/1/16 9:09, Weng Meiling wrote:
> 
> On 2014/1/15 18:24, Robert Richter wrote:
>> On 15.01.14 10:02:44, Weng Meiling wrote:
>>> On 2014/1/14 23:05, Robert Richter wrote:
>>>> @@ -94,6 +98,11 @@ static int op_create_counter(int cpu, int event)
>>>>  
>>>>  	per_cpu(perf_events, cpu)[event] = pevent;
>>>>  
>>>> +	/* sync perf_events with overflow handler: */
>>>> +	smp_wmb();
>>>> +
>>>> +	perf_event_enable(pevent);
>>>> +
>>>
>>> Should this step go before the if check:pevent->state != PERF_EVENT_STATE_ACTIVE ?
>>> Because the attr->disabled is true, So after the perf_event_create_kernel_counter
>>> the pevent->state is not PERF_EVENT_STATE_ACTIVE.
>>
>> Right, the check is a problem. We need to move it after the event was
>> enabled. On error, we need to NULL the event, see below.
>>
>> -Robert
>>
>> ---
>>  drivers/oprofile/oprofile_perf.c | 27 +++++++++++++++++++--------
>>  1 file changed, 19 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
>> index d5b2732..9dfb236 100644
>> --- a/drivers/oprofile/oprofile_perf.c
>> +++ b/drivers/oprofile/oprofile_perf.c
>> @@ -38,6 +38,9 @@ static void op_overflow_handler(struct perf_event *event,
>>  	int id;
>>  	u32 cpu = smp_processor_id();
>>  
>> +	/* sync perf_events with op_create_counter(): */
>> +	smp_rmb();
>> +
>>  	for (id = 0; id < num_counters; ++id)
>>  		if (per_cpu(perf_events, cpu)[id] == event)
>>  			break;
>> @@ -68,6 +71,7 @@ static void op_perf_setup(void)
>>  		attr->config		= counter_config[i].event;
>>  		attr->sample_period	= counter_config[i].count;
>>  		attr->pinned		= 1;
>> +		attr->disabled		= 1;
>>  	}
>>  }
>>  
>> @@ -85,16 +89,23 @@ static int op_create_counter(int cpu, int event)
>>  	if (IS_ERR(pevent))
>>  		return PTR_ERR(pevent);
>>  
>> -	if (pevent->state != PERF_EVENT_STATE_ACTIVE) {
>> -		perf_event_release_kernel(pevent);
>> -		pr_warning("oprofile: failed to enable event %d "
>> -				"on CPU %d\n", event, cpu);
>> -		return -EBUSY;
>> -	}
>> -
>>  	per_cpu(perf_events, cpu)[event] = pevent;
>>  
>> -	return 0;
>> +	/* sync perf_events with overflow handler: */
>> +	smp_wmb();
>> +
>> +	perf_event_enable(pevent);
>> +
>> +	if (pevent->state == PERF_EVENT_STATE_ACTIVE)
>> +		return 0;
>> +
>> +	perf_event_release_kernel(pevent);
>> +	per_cpu(perf_events, cpu)[event] = NULL;
>> +
>> +	pr_warning("oprofile: failed to enable event %d on CPU %d\n",
>> +		event, cpu);
>> +
>> +	return -EBUSY;
>>  }
>>  
>>  static void op_destroy_counter(int cpu, int event)
>>
> 
> OK, I'll test the patch, and send the result as soon as possible.
> 


