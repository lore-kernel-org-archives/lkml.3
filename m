Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3FGDKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 23:10:15 -0400
Received: from [205.204.113.249] ([205.204.113.249]:45009 "HELO
	us-alimail-mta2.hst.scl.en.alidc.net." rhost-flags-FAIL-FAIL-FAIL-FAIL)
	by vger.kernel.org with SMTP id S1751367Ab3FGDKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 23:10:13 -0400
Message-ID: <51B14F02.9090409@taobao.com>
Date: Fri, 07 Jun 2013 11:09:54 +0800
From: sanbai <sanbai@taobao.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, Zhu Yanhai <gaoyang.zyh@taobao.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <taoma.tm@gmail.com>
Subject: Re: [RFC v1] add new io-scheduler to use cgroup on high-speed device
References: <1370398171-25173-1-git-send-email-sanbai@taobao.com> <20130605133059.GA16339@redhat.com>
In-Reply-To: <20130605133059.GA16339@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年06月05日 21:30, Vivek Goyal wrote:
> On Wed, Jun 05, 2013 at 10:09:31AM +0800, Robin Dong wrote:
>> We want to use blkio.cgroup on high-speed device (like fusionio) for our mysql clusters.
>> After testing different io-scheduler, we found that  cfq is too slow and deadline can't run on cgroup.
> So why not enhance deadline to be able to be used with cgroups instead of
> coming up with a new scheduler?
I think if we add cgroups support into deadline, it will not be suitable 
to call "deadline" anymore...so a new ioscheduler and a new name may not 
confuse users.
>
>> So we developed a new io-scheduler: tpps (Tiny Parallel Proportion Scheduler).It dispatch requests
>> only by using their individual weight and total weight (proportion) therefore it's simply and efficient.
> Can you give more details. Do you idle? Idling kills performance. If not,
> then without idling how do you achieve performance differentiation.
We don't idle, when comes to .elevator_dispatch_fn，we just compute 
quota for every group:

quota = nr_requests - rq_in_driver;
group_quota = quota * group_weight / total_weight;

and dispatch 'group_quota' requests for the coordinate group. Therefore 
high-weight group
will dispatch more requests than low-weight group.
>
>> Test case: fusionio card, 4 cgroups, iodepth-512
>>
>> groupname  weight
>> test1      1000
>> test2      800
>> test3      600
>> test4      400
>>
> What's the workload used for this?
>
>> Use tpps, the result is:
>>
>> groupname  iops    avg-rt(ms)   max-rt(ms)
>> test1      30220   16           54
>> test2      28261   18           56
>> test3      26333   19           69
>> test4      20152   25           87
>>
>> Use cfq, the result is:
>>
>> groupname  iops    avg-rt(ms)   max-rt(ms)
>> test1      16478   30           242
>> test2      13015   39           347
>> test3       9300   54           371
>> test4       5806   87           393
> How do results look like with cfq if this is run with slice_idle=0 and
> quatum=128 or higher.
>
> cfqq idles on 3 things. queue (cfqq), service tree and cfq group.
> slice_idle will disable idling on cfqq but not no service tree. If
> we provide a knob for that, then idling on service tree can be disabled
> too and then we will be left with group idling only and then it should
> be much better.
I do the test again for cfq (slice_idle=0, quatum=128) and tpps

cfq (slice_idle=0, quatum=128)
groupname iops avg-rt(ms) max-rt(ms)
test1 16148 15 188
test2 12756 20 117
test3 9778 26 268
test4 6198 41 209

tpps
groupname iops avg-rt(ms) max-rt(ms)
test1 17292 14 65
test2 15221 16 80
test3 12080 21 66
test4 7995 32 90

Looks cfq with is much better than before.

My fio script is :
[global]
direct=1
ioengine=libaio
#ioengine=psync
runtime=30
bs=4k
rw=randread
iodepth=256

filename=/dev/fioa
numjobs=2
#group_reporting

[read1]
cgroup=test1
cgroup_weight=1000

[read2]
cgroup=test2
cgroup_weight=800

[read3]
cgroup=test3
cgroup_weight=600

[read4]
cgroup=test4
cgroup_weight=400


>
> Thanks
> Vivek


-- 

Robin Dong
董昊（花名：三百）
阿里巴巴 集团 核心系统部 内核组
分机：72370
手机：13520865473
email：sanbai@taobao.com

