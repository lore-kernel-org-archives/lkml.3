Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab3H2T2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:28:23 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:37326 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab3H2T2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:28:21 -0400
From: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "majianpeng@gmail.com" <majianpeng@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] elevator: Fix a race in elevator switching and md
 device initialization
Thread-Topic: [PATCH] elevator: Fix a race in elevator switching and md
 device initialization
Thread-Index: AQHOomKEe8NHX1i8QUyRMlMbtDjKDpmsyrUA///MRYA=
Date: Thu, 29 Aug 2013 19:28:02 +0000
Message-ID: <CE451293.7603%Tomoki.Sekiyama@hds.com>
In-Reply-To: <20130829183310.GB6171@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <40261091BC0035418C409AC099F94753@hds.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-29_07:2013-08-29,2013-08-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1308290106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi vivek,

Thanks for your comments.

On 8/29/13 14:33 , "Vivek Goyal" <vgoyal@redhat.com> wrote:

>On Mon, Aug 26, 2013 at 09:45:15AM -0400, Tomoki Sekiyama wrote:
>> The soft lockup below happes at the boot time of the system using dm
>> multipath and automated elevator switching udev rules.
>> 
>> [  356.127001] BUG: soft lockup - CPU#3 stuck for 22s! [sh:483]
>> [  356.127001] RIP: 0010:[<ffffffff81072a7d>]  [<ffffffff81072a7d>]
>>lock_timer_base.isra.35+0x1d/0x50
>> ...
>> [  356.127001] Call Trace:
>> [  356.127001]  [<ffffffff81073810>] try_to_del_timer_sync+0x20/0x70
>> [  356.127001]  [<ffffffff8118b08a>] ?
>>kmem_cache_alloc_node_trace+0x20a/0x230
>> [  356.127001]  [<ffffffff810738b2>] del_timer_sync+0x52/0x60
>> [  356.127001]  [<ffffffff812ece22>] cfq_exit_queue+0x32/0xf0
>> [  356.127001]  [<ffffffff812c98df>] elevator_exit+0x2f/0x50
>> [  356.127001]  [<ffffffff812c9f21>] elevator_change+0xf1/0x1c0
>> [  356.127001]  [<ffffffff812caa50>] elv_iosched_store+0x20/0x50
>> [  356.127001]  [<ffffffff812d1d09>] queue_attr_store+0x59/0xb0
>> [  356.127001]  [<ffffffff812143f6>] sysfs_write_file+0xc6/0x140
>> [  356.127001]  [<ffffffff811a326d>] vfs_write+0xbd/0x1e0
>> [  356.127001]  [<ffffffff811a3ca9>] SyS_write+0x49/0xa0
>> [  356.127001]  [<ffffffff8164e899>] system_call_fastpath+0x16/0x1b
>> 
>
>Tokomi, 
>
>As you noticed, there is a fedora bug open with similar signature. May
>be this patch will fix that issue also.
>
>https://bugzilla.redhat.com/show_bug.cgi?id=902012
>
>
>> This is caused by a race between md device initialization and sysfs knob
>> to switch the scheduler.
>> 
>> * multipathd:
>>  SyS_ioctl -> do_vfs_ioctl -> dm_ctl_ioctl -> ctl_ioctl ->  table_load
>>   -> dm_setup_md_queue -> blk_init_allocated_queue -> elevator_init:
>>
>>     q->elevator = elevator_alloc(q, e); // not yet initialized
>> 
>>
>>* sh -c 'echo deadline > /sys/$DEVPATH/queue/scheduler'
>>  SyS_write -> vfs_write -> sysfs_write_file -> queue_attr_store
>>      ( mutex_lock(&q->sysfs_lock) here. )
>>   -> elv_iosched_store -> elevator_change:
>> 
>>
>>   elevator_exit(old); // try to de-init uninitialized elevator and hang
>>up
>> 
>>
>>This patch adds acquisition of q->sysfs_lock in
>>blk_init_allocated_queue().
>> This also adds the lock into elevator_change() to ensure locking from
>>the
>> other path, as it is exposed function (and queue_attr_store will uses
>> __elevator_change() now, the non-locking version of elevator_change()).
>
>I think introducing __elevator_change() is orthogonal to this problem.
>May be keep that in a separate patch.

OK, I will split it into 2 patches.


>>  block/blk-core.c |    6 +++++-
>>  block/elevator.c |   16 ++++++++++++++--
>>  2 files changed, 19 insertions(+), 3 deletions(-)
>> 
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 93a18d1..2323ec3 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -739,9 +739,13 @@ blk_init_allocated_queue(struct request_queue *q,
>>request_fn_proc *rfn,
>>  
>>  	q->sg_reserved_size = INT_MAX;
>>  
>> +	/* Protect q->elevator from elevator_change */
>> +	mutex_lock(&q->sysfs_lock);
>>  	/* init elevator */
>>  	if (elevator_init(q, NULL))
>> -		return NULL;
>> +		q = NULL;
>> +	mutex_unlock(&q->sysfs_lock);
>> +
>
>So core of the problem is, what's the locking semantics to make sure
>that we are not trying to switch elevator while it is still initializing.
>IOW, should we allow multiple parallel calls of elevator_init_fn() on a
>queue and is it safe?
>
>I would argue that it is easier to read and maintain the code if we
>provide explicit locking around. So I like the idea of introducing
>some locking around elevator_init().
>
>Because we are racing against elevator switch path which takes
>q->sysfs_lock, it makes sense to provide mutual exlusion using
>q->sysfs_lock.
>
>What I don't know is that can we take mutex in queue init path. Generally
>drivers call it and do they expect that they can call this function
>while holding a spin lock.

As elevator_alloc() allocates memory with GFP_KERNEL, elevator_init() might
sleep. So it should be safe to use mutex here.
 
>I am CCing Tejun also to the thread. He also might have some ideas here.
>
>Thanks
>Vivek

Thanks,
Tomoki Sekiyama


