Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaLQNB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:01:58 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:41339 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaLQNB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:01:57 -0500
From: Marc Dionne <marc.c.dionne@gmail.com>
X-Google-Original-From: Marc Dionne <marc.dionne@your-file-system.com>
To: snitzer@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: agk@redhat.com, Marc Dionne <marc.dionne@your-file-system.com>
Subject: [PATCH] dm thin: Initialize refcount and completion earlier
Date: Wed, 17 Dec 2014 07:59:59 -0500
Message-Id: <1418821199-6890-1-git-send-email-marc.dionne@your-file-system.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 80e96c5484be (dm thin: do not allow thin device activation
while pool is suspended) delayed the initialization of the completion
and setting the initial refcount to 1 until after the new thin is
added to the pool's active thins list and the pool lock is released.
This opens a race with a worker thread that walks the list and calls
thin_get/put, noticing that the refcount goes to 0 and calling
complete, freezing up the system and giving the oops below:

 kernel: BUG: unable to handle kernel NULL pointer dereference at           (null)
 kernel: IP: [<ffffffff810d360b>] __wake_up_common+0x2b/0x90

 kernel: Call Trace:
 kernel: [<ffffffff810d3683>] __wake_up_locked+0x13/0x20
 kernel: [<ffffffff810d3dc7>] complete+0x37/0x50
 kernel: [<ffffffffa0595c50>] thin_put+0x20/0x30 [dm_thin_pool]
 kernel: [<ffffffffa059aab7>] do_worker+0x667/0x870 [dm_thin_pool]
 kernel: [<ffffffff816a8a4c>] ? __schedule+0x3ac/0x9a0
 kernel: [<ffffffff810b1aef>] process_one_work+0x14f/0x400
 kernel: [<ffffffff810b206b>] worker_thread+0x6b/0x490
 kernel: [<ffffffff810b2000>] ? rescuer_thread+0x260/0x260
 kernel: [<ffffffff810b6a7b>] kthread+0xdb/0x100
 kernel: [<ffffffff810b69a0>] ? kthread_create_on_node+0x170/0x170
 kernel: [<ffffffff816ad7ec>] ret_from_fork+0x7c/0xb0
 kernel: [<ffffffff810b69a0>] ? kthread_create_on_node+0x170/0x170

Set the initial refcount and initialize the completion
before dropping the pool lock.

Signed-off-by: Marc Dionne <marc.dionne@your-file-system.com>
---
 drivers/md/dm-thin.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 8735543..4133223 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3814,6 +3814,8 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		r = -EINVAL;
 		goto bad;
 	}
+	atomic_set(&tc->refcount, 1);
+	init_completion(&tc->can_destroy);
 	list_add_tail_rcu(&tc->list, &tc->pool->active_thins);
 	spin_unlock_irqrestore(&tc->pool->lock, flags);
 	/*
@@ -3826,9 +3828,6 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	dm_put(pool_md);
 
-	atomic_set(&tc->refcount, 1);
-	init_completion(&tc->can_destroy);
-
 	return 0;
 
 bad:
-- 
2.1.0

