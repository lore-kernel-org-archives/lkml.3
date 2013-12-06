Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261Ab3LFXaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:30:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48924 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422962Ab3LFXUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:18 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bvanassche@acm.org>,
        Roland Dreier <roland@purestorage.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 085/152] IB/srp: Remove target from list before freeing Scsi_Host structure
Date: Fri,  6 Dec 2013 15:10:09 -0800
Message-Id: <1386371476-2477-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vu Pham <vuhuong@mellanox.com>

commit 65d7dd2f3479ef5aec1d9ddd1481cb7851c11af6 upstream.

Remove an SRP target from the SRP target list before invoking the last
scsi_host_put() call.  This change is necessary because that last put
frees the memory that holds the srp_target_port structure.

This patch prevents the following kernel oops:

    RIP: 0010:[<ffffffff810b00d0>] __lock_acquire+0x500/0x1570
    Call Trace:
     [<ffffffff810b11e4>] lock_acquire+0xa4/0x120
     [<ffffffff81531206>] _spin_lock+0x36/0x70
     [<ffffffffa01b6d8f>] srp_remove_work+0xef/0x180 [ib_srp]
     [<ffffffff8109125c>] worker_thread+0x21c/0x3d0
     [<ffffffff81096e86>] kthread+0x96/0xa0
     [<ffffffff8100c20a>] child_rip+0xa/0x20

Signed-off-by: Vu Pham <vuhuong@mellanox.com>

[ bvanassche - Modified path description and CC'ed stable. ]

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 7ccf328..2223eb6 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -532,6 +532,11 @@ static void srp_remove_target(struct srp_target_port *target)
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
 	srp_free_req_data(target);
+
+	spin_lock(&target->srp_host->target_lock);
+	list_del(&target->list);
+	spin_unlock(&target->srp_host->target_lock);
+
 	scsi_host_put(target->scsi_host);
 }
 
@@ -542,10 +547,6 @@ static void srp_remove_work(struct work_struct *work)
 
 	WARN_ON_ONCE(target->state != SRP_TARGET_REMOVED);
 
-	spin_lock(&target->srp_host->target_lock);
-	list_del(&target->list);
-	spin_unlock(&target->srp_host->target_lock);
-
 	srp_remove_target(target);
 }
 
-- 
1.8.3.2

