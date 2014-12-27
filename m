Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaL0JDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 04:03:36 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:20435 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaL0JD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 04:03:27 -0500
Message-ID: <549E75C3.80808@huawei.com>
Date: Sat, 27 Dec 2014 17:02:59 +0800
From: Li Bin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Dave Jones" <davej@redhat.com>, <rui.xiang@huawei.com>,
        <wengmeiling.weng@huawei.com>
Subject: Re: sched: spinlock recursion in sched_rr_get_interval
References: <53B98709.3090603@oracle.com> <20140707083016.GA19379@twins.programming.kicks-ass.net> <53BAA6DF.5060409@oracle.com> <20140707200550.GA6758@twins.programming.kicks-ass.net> <549D03F6.9090607@huawei.com> <549D07CD.8000204@oracle.com>
In-Reply-To: <549D07CD.8000204@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.25.181]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/26 15:01, Sasha Levin wrote:
> On 12/26/2014 01:45 AM, Li Bin wrote:
>> On 2014/7/8 4:05, Peter Zijlstra wrote:
>>>> On Mon, Jul 07, 2014 at 09:55:43AM -0400, Sasha Levin wrote:
>>>>>> I've also had this one, which looks similar:
>>>>>>
>>>>>> [10375.005884] BUG: spinlock recursion on CPU#0, modprobe/10965
>>>>>> [10375.006573]  lock: 0xffff8803a0fd7740, .magic: dead4ead, .owner: modprobe/10965, .owner_cpu: 15
>>>>>> [10375.007412] CPU: 0 PID: 10965 Comm: modprobe Tainted: G        W      3.16.0-rc3-next-20140704-sasha-00023-g26c0906-dirty #765
>>>>
>>>> Something's fucked; so we have:
>>>>
>>>> debug_spin_lock_before()
>>>> 	SPIN_BUG_ON(lock->owner == current, "recursion");
>>>>
>> Hello，
>> Does ACCESS_ONCE() can help this issue? I have no evidence that its lack is
>> responsible for the issue, but I think here need it indeed. Is that right?
>>
>> SPIN_BUG_ON(ACCESS_ONCE(lock->owner) == current, "recursion");
> 
> Could you explain a bit more why do you think it's needed?
> 

Oh, just adding ACCESS_ONCE may be not enough, and i think lacking lock protection
for reading lock->owner is a risk. In short, the reason of the issue is more like
the spinlock debug mechanism, rather than a real spinlock recursion.

...
//under no lock protection
if (lock->owner == current) //access lock->owner
|-spin_dump(lock, "recursion");
	|-if (lock->owner && lock->owner != SPINLOCK_OWNER_INIT) //access lock->owner again
    	owner = lock->owner;
...	

Right, or am I missing something?
Thanks,
		Li Bin

> 
> Thanks,
> Sasha
> 
> 


