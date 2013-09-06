Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3IFPKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:10:19 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:42250 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab3IFPKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:10:17 -0400
From: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "axboe@kernel.dk" <axboe@kernel.dk>, "tj@kernel.org" <tj@kernel.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "majianpeng@gmail.com" <majianpeng@gmail.com>
Subject: Re: [PATCH v2 1/2] elevator: Fix a race in elevator switching and
 md device initialization
Thread-Topic: [PATCH v2 1/2] elevator: Fix a race in elevator switching and
 md device initialization
Thread-Index: AQHOpdLdNzajY7OslkaUETgfqPSrrZm42DEA
Date: Fri, 6 Sep 2013 15:01:08 +0000
Message-ID: <CE4F663E.7903%Tomoki.Sekiyama@hds.com>
In-Reply-To: <20130830224707.21812.63516.stgit@hds.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF96FFBDE0CAD04397CADBF5E412C3CA@hds.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-09-06_06:2013-09-06,2013-09-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1309060087
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping: any comments for this series?


On 8/30/13 18:47 , "Tomoki Sekiyama" <tomoki.sekiyama@hds.com> wrote:

>The soft lockup below happens at the boot time of the system using dm
>multipath and the udev rules to switch scheduler.
>
>[  356.127001] BUG: soft lockup - CPU#3 stuck for 22s! [sh:483]
>[  356.127001] RIP: 0010:[<ffffffff81072a7d>]  [<ffffffff81072a7d>]
>lock_timer_base.isra.35+0x1d/0x50
>...
>[  356.127001] Call Trace:
>[  356.127001]  [<ffffffff81073810>] try_to_del_timer_sync+0x20/0x70
>[  356.127001]  [<ffffffff8118b08a>] ?
>kmem_cache_alloc_node_trace+0x20a/0x230
>[  356.127001]  [<ffffffff810738b2>] del_timer_sync+0x52/0x60
>[  356.127001]  [<ffffffff812ece22>] cfq_exit_queue+0x32/0xf0
>[  356.127001]  [<ffffffff812c98df>] elevator_exit+0x2f/0x50
>[  356.127001]  [<ffffffff812c9f21>] elevator_change+0xf1/0x1c0
>[  356.127001]  [<ffffffff812caa50>] elv_iosched_store+0x20/0x50
>[  356.127001]  [<ffffffff812d1d09>] queue_attr_store+0x59/0xb0
>[  356.127001]  [<ffffffff812143f6>] sysfs_write_file+0xc6/0x140
>[  356.127001]  [<ffffffff811a326d>] vfs_write+0xbd/0x1e0
>[  356.127001]  [<ffffffff811a3ca9>] SyS_write+0x49/0xa0
>[  356.127001]  [<ffffffff8164e899>] system_call_fastpath+0x16/0x1b
>
>This is caused by a race between md device initialization by multipathd
>and
>shell script to switch the scheduler using sysfs.
>
> - multipathd:
>   SyS_ioctl -> do_vfs_ioctl -> dm_ctl_ioctl -> ctl_ioctl -> table_load
>   -> dm_setup_md_queue -> blk_init_allocated_queue -> elevator_init
>    q->elevator = elevator_alloc(q, e); // not yet initialized
>
> - sh -c 'echo deadline > /sys/$DEVPATH/queue/scheduler':
>   elevator_switch (in the call trace above)
>    struct elevator_queue *old = q->elevator;
>    q->elevator = elevator_alloc(q, new_e);
>    elevator_exit(old);                 // lockup! (*)
>
> - multipathd: (cont.)
>    err = e->ops.elevator_init_fn(q);   // init fails; q->elevator is
>modified
>
>(*) When del_timer_sync() is called, lock_timer_base() will loop
>infinitely
>while timer->base == NULL. In this case, as timer will never initialized,
>it results in lockup.
>
>This patch introduces acquisition of q->sysfs_lock around elevator_init()
>into blk_init_allocated_queue(), to provide mutual exclusion between
>initialization of the q->scheduler and switching of the scheduler.
>
>This should fix this bugzilla:
>https://bugzilla.redhat.com/show_bug.cgi?id=902012
>
>Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
>---
> block/blk-core.c |   10 +++++++++-
> block/elevator.c |    6 ++++++
> 2 files changed, 15 insertions(+), 1 deletion(-)
>
>diff --git a/block/blk-core.c b/block/blk-core.c
>index 93a18d1..2f6275f 100644
>--- a/block/blk-core.c
>+++ b/block/blk-core.c
>@@ -739,9 +739,17 @@ blk_init_allocated_queue(struct request_queue *q,
>request_fn_proc *rfn,
> 
> 	q->sg_reserved_size = INT_MAX;
> 
>+	/* Protect q->elevator from elevator_change */
>+	mutex_lock(&q->sysfs_lock);
>+
> 	/* init elevator */
>-	if (elevator_init(q, NULL))
>+	if (elevator_init(q, NULL)) {
>+		mutex_unlock(&q->sysfs_lock);
> 		return NULL;
>+	}
>+
>+	mutex_unlock(&q->sysfs_lock);
>+
> 	return q;
> }
> EXPORT_SYMBOL(blk_init_allocated_queue);
>diff --git a/block/elevator.c b/block/elevator.c
>index 668394d..02d4390 100644
>--- a/block/elevator.c
>+++ b/block/elevator.c
>@@ -186,6 +186,12 @@ int elevator_init(struct request_queue *q, char
>*name)
> 	struct elevator_type *e = NULL;
> 	int err;
> 
>+	/*
>+	 * q->sysfs_lock must be held to provide mutual exclusion between
>+	 * elevator_switch() and here.
>+	 */
>+	lockdep_assert_held(&q->sysfs_lock);
>+
> 	if (unlikely(q->elevator))
> 		return 0;
> 
>

