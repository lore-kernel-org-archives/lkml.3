Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaGHIna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:43:30 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57804 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaGHIn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:43:27 -0400
Message-ID: <53BBAEBF.4010107@huawei.com>
Date: Tue, 8 Jul 2014 16:41:35 +0800
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Li Zefan <lizefan@huawei.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <xiaofeng.yan2012@gmail.com>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH] sched/rt: overrun could happen in start_hrtick_dl
References: <1404475341-22536-1-git-send-email-xiaofeng.yan@huawei.com> <20140707084150.GC19379@twins.programming.kicks-ass.net> <53BB4510.5090704@huawei.com> <53BB5A13.1070305@huawei.com> <53BB5C96.2040203@huawei.com> <20140708074943.GK19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140708074943.GK19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.133]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/8 15:49, Peter Zijlstra wrote:
> On Tue, Jul 08, 2014 at 10:51:02AM +0800, xiaofeng.yan wrote:
>> On 2014/7/8 10:40, Li Zefan wrote:
>>> On 2014/7/8 9:10, xiaofeng.yan wrote:
>>>> On 2014/7/7 16:41, Peter Zijlstra wrote:
>>>>> On Fri, Jul 04, 2014 at 12:02:21PM +0000, xiaofeng.yan wrote:
>>>>>> It could be wrong for the precision of runtime and deadline
>>>>>> when the precision is within microsecond level. For example:
>>>>>> Task runtime deadline period
>>>>>>    P1   200us   500us   500us
>>>>>>
>>>>>> This case need enbale HRTICK feature by the next command
>>>>>> PC#echo "HRTICK" > /sys/kernel/debug/sched_features
>>>>>> PC#./schedtool -E -t 200000:500000 -e ./test&
>>>>>> PC#trace-cmd record -e sched_switch
>>>>> Are you actually using HRTICK ?
>>>> yes, If HRTICK is close , then all of runtime and deadline will be wrong.
>>> I think what peter meant is, do you use HRTICK in products or
>>> just use it for testing/experiment?
>>>
>> Thanks for your timely comments. In fact, We use HRTICK feature in product.
>> We need microsecond level
>> precision.
> Ah, thanks. Be advised that currently HRTICK is rather expensive. The
> cost is twofold: 1) doing all the kernel side hrtimer things and 2)
> programming clock hardware.
>
> Of course, if that's what you need, you're willing to pay the price.
>
> I'll see if I can put making it less expensive slightly higher on the
> (endless) todo list.

another fold: 3) Frequent migration  :)
In fact, frequent migration lead to higher overload.  In our product  we 
design new migration solution.
The simple description is as follow:
1 Set affinity in user space program at the beginning
2 Migrate happen per 100ms
3 Free task (runtime < dl_runtime)is migrated to free cpu (rt task 
bandwidth < 65%) .
4 Busy task will run more time in a CPU by dynamic quota.
So the condition of migration depends on whether task is busy or idle or 
not instead of deadline at some point.
This could not meet EDF requirement but meet our product :)







