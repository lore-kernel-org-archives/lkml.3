Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162245Ab3LFWZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:25:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161195Ab3LFVxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>,
        Jens Axboe <axboe@kernel.dk>, Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH 3.12 72/83] elevator: Fix a race in elevator switching and md device initialization
Date: Fri,  6 Dec 2013 13:52:02 -0800
Message-Id: <20131206214646.750902268@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoki Sekiyama <tomoki.sekiyama@hds.com>

commit eb1c160b22655fd4ec44be732d6594fd1b1e44f4 upstream.

The soft lockup below happens at the boot time of the system using dm
multipath and the udev rules to switch scheduler.

[  356.127001] BUG: soft lockup - CPU#3 stuck for 22s! [sh:483]
[  356.127001] RIP: 0010:[<ffffffff81072a7d>]  [<ffffffff81072a7d>] lock_timer_base.isra.35+0x1d/0x50
...
[  356.127001] Call Trace:
[  356.127001]  [<ffffffff81073810>] try_to_del_timer_sync+0x20/0x70
[  356.127001]  [<ffffffff8118b08a>] ? kmem_cache_alloc_node_trace+0x20a/0x230
[  356.127001]  [<ffffffff810738b2>] del_timer_sync+0x52/0x60
[  356.127001]  [<ffffffff812ece22>] cfq_exit_queue+0x32/0xf0
[  356.127001]  [<ffffffff812c98df>] elevator_exit+0x2f/0x50
[  356.127001]  [<ffffffff812c9f21>] elevator_change+0xf1/0x1c0
[  356.127001]  [<ffffffff812caa50>] elv_iosched_store+0x20/0x50
[  356.127001]  [<ffffffff812d1d09>] queue_attr_store+0x59/0xb0
[  356.127001]  [<ffffffff812143f6>] sysfs_write_file+0xc6/0x140
[  356.127001]  [<ffffffff811a326d>] vfs_write+0xbd/0x1e0
[  356.127001]  [<ffffffff811a3ca9>] SyS_write+0x49/0xa0
[  356.127001]  [<ffffffff8164e899>] system_call_fastpath+0x16/0x1b

This is caused by a race between md device initialization by multipathd and
shell script to switch the scheduler using sysfs.

 - multipathd:
   SyS_ioctl -> do_vfs_ioctl -> dm_ctl_ioctl -> ctl_ioctl -> table_load
   -> dm_setup_md_queue -> blk_init_allocated_queue -> elevator_init
    q->elevator = elevator_alloc(q, e); // not yet initialized

 - sh -c 'echo deadline > /sys/$DEVPATH/queue/scheduler':
   elevator_switch (in the call trace above)
    struct elevator_queue *old = q->elevator;
    q->elevator = elevator_alloc(q, new_e);
    elevator_exit(old);                 // lockup! (*)

 - multipathd: (cont.)
    err = e->ops.elevator_init_fn(q);   // init fails; q->elevator is modified

(*) When del_timer_sync() is called, lock_timer_base() will loop infinitely
while timer->base == NULL. In this case, as timer will never initialized,
it results in lockup.

This patch introduces acquisition of q->sysfs_lock around elevator_init()
into blk_init_allocated_queue(), to provide mutual exclusion between
initialization of the q->scheduler and switching of the scheduler.

This should fix this bugzilla:
https://bugzilla.redhat.com/show_bug.cgi?id=902012

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-core.c |   10 +++++++++-
 block/elevator.c |    6 ++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -741,9 +741,17 @@ blk_init_allocated_queue(struct request_
 
 	q->sg_reserved_size = INT_MAX;
 
+	/* Protect q->elevator from elevator_change */
+	mutex_lock(&q->sysfs_lock);
+
 	/* init elevator */
-	if (elevator_init(q, NULL))
+	if (elevator_init(q, NULL)) {
+		mutex_unlock(&q->sysfs_lock);
 		return NULL;
+	}
+
+	mutex_unlock(&q->sysfs_lock);
+
 	return q;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -186,6 +186,12 @@ int elevator_init(struct request_queue *
 	struct elevator_type *e = NULL;
 	int err;
 
+	/*
+	 * q->sysfs_lock must be held to provide mutual exclusion between
+	 * elevator_switch() and here.
+	 */
+	lockdep_assert_held(&q->sysfs_lock);
+
 	if (unlikely(q->elevator))
 		return 0;
 


