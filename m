Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3GAL1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 07:27:33 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:39007 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3GAL1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 07:27:32 -0400
Message-ID: <51D16777.5000703@huawei.com>
Date: Mon, 1 Jul 2013 19:26:47 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        Zhang Hang <bob.zhanghang@huawei.com>,
        Li Bin <huawei.libin@huawei.com>
Subject: Re: [PATCH] sched: fix cpu utilization account error
References: <51D12570.9070100@huawei.com> <1372664187.7678.45.camel@marge.simpson.net>
In-Reply-To: <1372664187.7678.45.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/1 15:36, Mike Galbraith wrote:
> On Mon, 2013-07-01 at 14:45 +0800, Xie XiuQi wrote: 
>> We setting clock_skip_update = 1 based on the assumption that the
>> next call to update_rq_clock() will come nearly immediately
>> after being set. However, it is not always true especially on
>> non-preempt mode. In this case we may miss some clock update, which
>> would cause an error curr->sum_exec_runtime account.
>>
>> The test result show that test_kthread's exec_runtime has been
>> added to watchdog.
>>
>>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+   P COMMAND
>>    28 root      RT   0     0    0    0 S  100  0.0   0:05.39  5 watchdog/5
>>     7 root      RT   0     0    0    0 S   95  0.0   0:05.83  0 watchdog/0
>>    12 root      RT   0     0    0    0 S   94  0.0   0:05.79  1 watchdog/1
>>    16 root      RT   0     0    0    0 S   92  0.0   0:05.74  2 watchdog/2
>>    20 root      RT   0     0    0    0 S   91  0.0   0:05.71  3 watchdog/3
>>    24 root      RT   0     0    0    0 S   82  0.0   0:05.42  4 watchdog/4
>>    32 root      RT   0     0    0    0 S   79  0.0   0:05.35  6 watchdog/6
>>  5200 root      20   0     0    0    0 R   21  0.0   0:08.88  6 test_kthread/6
>>  5194 root      20   0     0    0    0 R   20  0.0   0:08.41  0 test_kthread/0
>>  5195 root      20   0     0    0    0 R   20  0.0   0:08.44  1 test_kthread/1
>>  5196 root      20   0     0    0    0 R   20  0.0   0:08.49  2 test_kthread/2
>>  5197 root      20   0     0    0    0 R   20  0.0   0:08.53  3 test_kthread/3
>>  5198 root      20   0     0    0    0 R   19  0.0   0:08.81  4 test_kthread/4
>>  5199 root      20   0     0    0    0 R    2  0.0   0:08.66  5 test_kthread/5
>>
>> "test_kthread/i" is a kernel thread which has a infinity loop and it calls
>> schedule() every 1s. It's main process as below:
> 
> It'd be a shame to lose the cycle savings (we could use more) due to
> such horrible behavior.  Where are you seeing this in real life?
> 

Thank you for your comments, Mike.

This issue was reported by a driver related pcie in which a kthread send
huge amounts of data. In non-preempt mode, it would take a cpu for a long
time. But, in preempt mode, I haven't found this issue yet.

Here is the kthread main logic. Although it's not a good idea, but it does
exist:
while (!kthread_should_stop()) {
	/* call schedule every 1 sec */
	if (HZ <= jiffies - last) {
		last = jiffies;
		schedule();
	}

	/* get data and sent it */
	get_msg();
	send_msg();

	if (kthread_should_stop())
		break;
}

> That said, accounting funnies induced by skipped update are possible,
> which could trump the cycle savings I suppose, so maybe savings (sniff)
> should just go away?

Indeed, removing the skip_clock_update could resolve the issue, but I found
there is no this issue in preempt mode. However, if remove skip_clock_update
we'll get more precise time account.

So, what's your opinion, Mike.



