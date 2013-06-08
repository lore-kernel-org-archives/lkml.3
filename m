Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab3FHEjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 00:39:10 -0400
Received: from [205.204.113.248] ([205.204.113.248]:56921 "HELO
	us-alimail-mta2.hst.scl.en.alidc.net." rhost-flags-FAIL-FAIL-FAIL-FAIL)
	by vger.kernel.org with SMTP id S1750804Ab3FHEjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 00:39:08 -0400
Message-ID: <51B2B55A.1070607@taobao.com>
Date: Sat, 08 Jun 2013 12:38:50 +0800
From: sanbai <sanbai@taobao.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, Zhu Yanhai <gaoyang.zyh@taobao.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <taoma.tm@gmail.com>
Subject: Re: [RFC v1] add new io-scheduler to use cgroup on high-speed device
References: <1370398171-25173-1-git-send-email-sanbai@taobao.com> <20130605133059.GA16339@redhat.com> <51B14F02.9090409@taobao.com> <20130607195351.GD14015@redhat.com> <51B2A9EE.50908@taobao.com>
In-Reply-To: <51B2A9EE.50908@taobao.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-06-08- 11:50, sanbai wrote:
> On 2013年06月08日 03:53, Vivek Goyal wrote:
>> On Fri, Jun 07, 2013 at 11:09:54AM +0800, sanbai wrote:
>>> On 2013年06月05日 21:30, Vivek Goyal wrote:
>>>> On Wed, Jun 05, 2013 at 10:09:31AM +0800, Robin Dong wrote:
>>>>> We want to use blkio.cgroup on high-speed device (like fusionio) 
>>>>> for our mysql clusters.
>>>>> After testing different io-scheduler, we found that  cfq is too 
>>>>> slow and deadline can't run on cgroup.
>>>> So why not enhance deadline to be able to be used with cgroups 
>>>> instead of
>>>> coming up with a new scheduler?
>>> I think if we add cgroups support into deadline, it will not be
>>> suitable to call "deadline" anymore...so a new ioscheduler and a new
>>> name may not confuse users.
>> Nobody got confused when we added cgroup support to CFQ. Not that
>> I am saying go add support to deadline. I am just saying that need
>> for cgroup support does not sound like it justfies need of a new
>> IO scheduler.
>>
>> [..]
>>>> Can you give more details. Do you idle? Idling kills performance. 
>>>> If not,
>>>> then without idling how do you achieve performance differentiation.
>>> We don't idle, when comes to .elevator_dispatch_fn，we just compute
>>> quota for every group:
>>>
>>> quota = nr_requests - rq_in_driver;
>>> group_quota = quota * group_weight / total_weight;
>>>
>>> and dispatch 'group_quota' requests for the coordinate group.
>>> Therefore high-weight group
>>> will dispatch more requests than low-weight group.
>> Ok, this works only if all the groups are full all the time otherwise
>> groups will lose their fair share. This simplifies the things a lot.
>> That is fairness is provided only if group is always backlogged. In
>> practice, this happens only if a group is doing IO at very high rate
>> (like your fio scripts). Have you tried running any real life workload
>> in these cgroups (apache, databases etc) and see how good is service
>> differentiation.
>>
>> Anyway, sounds like this can be done at generic block layer like
>> blk-throtl and it can sit on top so that it can work with all schedulers
>> and can also work with bio based block drivers.
> That's a new idea, I will give a try later.
>>
>> [..]
>>> I do the test again for cfq (slice_idle=0, quatum=128) and tpps
>>>
>>> cfq (slice_idle=0, quatum=128)
>>> groupname iops avg-rt(ms) max-rt(ms)
>>> test1 16148 15 188
>>> test2 12756 20 117
>>> test3 9778 26 268
>>> test4 6198 41 209
>>>
>>> tpps
>>> groupname iops avg-rt(ms) max-rt(ms)
>>> test1 17292 14 65
>>> test2 15221 16 80
>>> test3 12080 21 66
>>> test4 7995 32 90
>>>
>>> Looks cfq with is much better than before.
>> Yep, I am sure there are more simple opportunites for optimization
>> where it can help. Can you try couple more things.
>>
>> - Drive even deeper queue depth. Set quantum=512.
>>
>> - set group_idle=0.
> I changed the iodepth to 512 in fio script and the new result is:
>
> cfq (group_idle=0, quantum=512)
> groupname    iops        avg-rt(ms)   max-rt(ms)
> test1               15259    33                305
> test2               11858    42                345
> test3               8885      57                335
> test4               5738      89                355
>
> cfq (group_idle=0, quantum=512, slice_sync=10)
> groupname    iops        avg-rt(ms)   max-rt(ms)
> test1               16507    31                177
> test2               12896    39                366
> test3               9301      55                188
> test4               6023      84                545
>
> tpps
> groupname    iops        avg-rt(ms)   max-rt(ms)
> test1               16316    31                99
> test2               15066    33                106
> test3               12182    42                101
> test4               8350      61                180
>
> looks cfq works much better now.

But after I changed to 'randrw', the condition is a little different:

cfq (group_idle=0, quantum=512, slice_sync=10,slice_async=10)
groupname    iops(r/w)        avg-rt(ms)   max-rt(ms)
test1               8717/8726    26/31           553/576
test2               6944/6943    34/39           507/514
test3               4974/4961    49/53           725/658
test4               3117/3109    79/84           1107/1094

tpps
groupname    iops(r/w)        avg-rt(ms)    max-rt(ms)
test1               9130/9147    25/30            85/98
test2               7644/7652    30/36            103/118
test3               5727/5733    41/47           132/146
test4               3889/3891    62/68           193/214
>>
>>    Ideally this should effectively emulate what you are doing. That 
>> is try
>>    to provide fairness without idling on group.
>>
>>    In practice I could not keep group queue full and before group 
>> exhausted
>>    its slice, it got empty and got deleted from service tree and lost 
>> its
>>    fair share. So if group_idle=0 leads to no service differentiation,
>>    try slice_sync=10 and see what happens.
>>
>> Thanks
>> Vivek
>
>


-- 

Robin Dong

email：sanbai@taobao.com

