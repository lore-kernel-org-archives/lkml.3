Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbaIZKAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:00:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082AbaIZJqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:40 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sebastian Parschauer <sebastian.riemer@profitbricks.com>,
        Roland Dreier <roland@purestorage.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 116/142] IB/srp: Fix deadlock between host removal and multipathd
Date: Fri, 26 Sep 2014 11:45:27 +0200
Message-Id: <2b84b406a9083b1f8f67d195c2e93111f9887b99.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit bcc05910359183b431da92713e98eed478edf83a upstream.

If scsi_remove_host() is invoked after a SCSI device has been blocked,
if the fast_io_fail_tmo or dev_loss_tmo work gets scheduled on the
workqueue executing srp_remove_work() and if an I/O request is
scheduled after the SCSI device had been blocked by e.g. multipathd
then the following deadlock can occur:

    kworker/6:1     D ffff880831f3c460     0   195      2 0x00000000
    Call Trace:
     [<ffffffff814aafd9>] schedule+0x29/0x70
     [<ffffffff814aa0ef>] schedule_timeout+0x10f/0x2a0
     [<ffffffff8105af6f>] msleep+0x2f/0x40
     [<ffffffff8123b0ae>] __blk_drain_queue+0x4e/0x180
     [<ffffffff8123d2d5>] blk_cleanup_queue+0x225/0x230
     [<ffffffffa0010732>] __scsi_remove_device+0x62/0xe0 [scsi_mod]
     [<ffffffffa000ed2f>] scsi_forget_host+0x6f/0x80 [scsi_mod]
     [<ffffffffa0002eba>] scsi_remove_host+0x7a/0x130 [scsi_mod]
     [<ffffffffa07cf5c5>] srp_remove_work+0x95/0x180 [ib_srp]
     [<ffffffff8106d7aa>] process_one_work+0x1ea/0x6c0
     [<ffffffff8106dd9b>] worker_thread+0x11b/0x3a0
     [<ffffffff810758bd>] kthread+0xed/0x110
     [<ffffffff814b972c>] ret_from_fork+0x7c/0xb0
    multipathd      D ffff880096acc460     0  5340      1 0x00000000
    Call Trace:
     [<ffffffff814aafd9>] schedule+0x29/0x70
     [<ffffffff814aa0ef>] schedule_timeout+0x10f/0x2a0
     [<ffffffff814ab79b>] io_schedule_timeout+0x9b/0xf0
     [<ffffffff814abe1c>] wait_for_completion_io_timeout+0xdc/0x110
     [<ffffffff81244b9b>] blk_execute_rq+0x9b/0x100
     [<ffffffff8124f665>] sg_io+0x1a5/0x450
     [<ffffffff8124fd21>] scsi_cmd_ioctl+0x2a1/0x430
     [<ffffffff8124fef2>] scsi_cmd_blk_ioctl+0x42/0x50
     [<ffffffffa00ec97e>] sd_ioctl+0xbe/0x140 [sd_mod]
     [<ffffffff8124bd04>] blkdev_ioctl+0x234/0x840
     [<ffffffff811cb491>] block_ioctl+0x41/0x50
     [<ffffffff811a0df0>] do_vfs_ioctl+0x300/0x520
     [<ffffffff811a1051>] SyS_ioctl+0x41/0x80
     [<ffffffff814b9962>] tracesys+0xd0/0xd5

Fix this by scheduling removal work on another workqueue than the
transport layer timers.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Reviewed-by: David Dillow <dave@thedillows.org>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 38 +++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 024fa025a7ab..15984e1c0b61 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -93,6 +93,7 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
 
 static struct scsi_transport_template *ib_srp_transport_template;
+static struct workqueue_struct *srp_remove_wq;
 
 static struct ib_client srp_client = {
 	.name   = "srp",
@@ -458,7 +459,7 @@ static bool srp_queue_remove_work(struct srp_target_port *target)
 	spin_unlock_irq(&target->lock);
 
 	if (changed)
-		queue_work(system_long_wq, &target->remove_work);
+		queue_work(srp_remove_wq, &target->remove_work);
 
 	return changed;
 }
@@ -2602,9 +2603,10 @@ static void srp_remove_one(struct ib_device *device)
 		spin_unlock(&host->target_lock);
 
 		/*
-		 * Wait for target port removal tasks.
+		 * Wait for tl_err and target port removal tasks.
 		 */
 		flush_workqueue(system_long_wq);
+		flush_workqueue(srp_remove_wq);
 
 		kfree(host);
 	}
@@ -2649,16 +2651,22 @@ static int __init srp_init_module(void)
 		indirect_sg_entries = cmd_sg_entries;
 	}
 
+	srp_remove_wq = create_workqueue("srp_remove");
+	if (IS_ERR(srp_remove_wq)) {
+		ret = PTR_ERR(srp_remove_wq);
+		goto out;
+	}
+
+	ret = -ENOMEM;
 	ib_srp_transport_template =
 		srp_attach_transport(&ib_srp_transport_functions);
 	if (!ib_srp_transport_template)
-		return -ENOMEM;
+		goto destroy_wq;
 
 	ret = class_register(&srp_class);
 	if (ret) {
 		pr_err("couldn't register class infiniband_srp\n");
-		srp_release_transport(ib_srp_transport_template);
-		return ret;
+		goto release_tr;
 	}
 
 	ib_sa_register_client(&srp_sa_client);
@@ -2666,13 +2674,22 @@ static int __init srp_init_module(void)
 	ret = ib_register_client(&srp_client);
 	if (ret) {
 		pr_err("couldn't register IB client\n");
-		srp_release_transport(ib_srp_transport_template);
-		ib_sa_unregister_client(&srp_sa_client);
-		class_unregister(&srp_class);
-		return ret;
+		goto unreg_sa;
 	}
 
-	return 0;
+out:
+	return ret;
+
+unreg_sa:
+	ib_sa_unregister_client(&srp_sa_client);
+	class_unregister(&srp_class);
+
+release_tr:
+	srp_release_transport(ib_srp_transport_template);
+
+destroy_wq:
+	destroy_workqueue(srp_remove_wq);
+	goto out;
 }
 
 static void __exit srp_cleanup_module(void)
@@ -2681,6 +2698,7 @@ static void __exit srp_cleanup_module(void)
 	ib_sa_unregister_client(&srp_sa_client);
 	class_unregister(&srp_class);
 	srp_release_transport(ib_srp_transport_template);
+	destroy_workqueue(srp_remove_wq);
 }
 
 module_init(srp_init_module);
-- 
2.1.0

