Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaFEAAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:00:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbaFDXXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Slava Shwartsman <valyushash@gmail.com>,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 177/228] Target/iser: Fix iscsit_accept_np and rdma_cm racy flow
Date: Wed,  4 Jun 2014 16:23:26 -0700
Message-Id: <20140604232353.708729023@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit 531b7bf4bd795d9a09eac92504322a472c010bc8 upstream.

RDMA CM and iSCSI target flows are asynchronous and completely
uncorrelated. Relying on the fact that iscsi_accept_np will be called
after CM connection request event and will wait for it is a mistake.

When attempting to login to a few targets this flow is racy and
unpredictable, but for parallel login to dozens of targets will
race and hang every time.

The correct synchronizing mechanism in this case is pending on
a semaphore rather than a wait_for_event. We keep the pending
interruptible for iscsi_np cleanup stage.

(Squash patch to remove dead code into parent - nab)

Reported-by: Slava Shwartsman <valyushash@gmail.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |   25 ++++++-------------------
 drivers/infiniband/ulp/isert/ib_isert.h |    2 +-
 2 files changed, 7 insertions(+), 20 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -28,6 +28,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 #include <target/iscsi/iscsi_transport.h>
+#include <linux/semaphore.h>
 
 #include "isert_proto.h"
 #include "ib_isert.h"
@@ -585,8 +586,8 @@ isert_connect_request(struct rdma_cm_id
 	list_add_tail(&isert_conn->conn_accept_node, &isert_np->np_accept_list);
 	mutex_unlock(&isert_np->np_accept_mutex);
 
-	pr_debug("isert_connect_request() waking up np_accept_wq: %p\n", np);
-	wake_up(&isert_np->np_accept_wq);
+	pr_debug("isert_connect_request() up np_sem np: %p\n", np);
+	up(&isert_np->np_sem);
 	return 0;
 
 out_conn_dev:
@@ -2569,7 +2570,7 @@ isert_setup_np(struct iscsi_np *np,
 		pr_err("Unable to allocate struct isert_np\n");
 		return -ENOMEM;
 	}
-	init_waitqueue_head(&isert_np->np_accept_wq);
+	sema_init(&isert_np->np_sem, 0);
 	mutex_init(&isert_np->np_accept_mutex);
 	INIT_LIST_HEAD(&isert_np->np_accept_list);
 	init_completion(&isert_np->np_login_comp);
@@ -2618,18 +2619,6 @@ out:
 }
 
 static int
-isert_check_accept_queue(struct isert_np *isert_np)
-{
-	int empty;
-
-	mutex_lock(&isert_np->np_accept_mutex);
-	empty = list_empty(&isert_np->np_accept_list);
-	mutex_unlock(&isert_np->np_accept_mutex);
-
-	return empty;
-}
-
-static int
 isert_rdma_accept(struct isert_conn *isert_conn)
 {
 	struct rdma_cm_id *cm_id = isert_conn->conn_cm_id;
@@ -2721,16 +2710,14 @@ isert_accept_np(struct iscsi_np *np, str
 	int max_accept = 0, ret;
 
 accept_wait:
-	ret = wait_event_interruptible(isert_np->np_accept_wq,
-			!isert_check_accept_queue(isert_np) ||
-			np->np_thread_state == ISCSI_NP_THREAD_RESET);
+	ret = down_interruptible(&isert_np->np_sem);
 	if (max_accept > 5)
 		return -ENODEV;
 
 	spin_lock_bh(&np->np_thread_lock);
 	if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
 		spin_unlock_bh(&np->np_thread_lock);
-		pr_err("ISCSI_NP_THREAD_RESET for isert_accept_np\n");
+		pr_debug("ISCSI_NP_THREAD_RESET for isert_accept_np\n");
 		return -ENODEV;
 	}
 	spin_unlock_bh(&np->np_thread_lock);
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -158,7 +158,7 @@ struct isert_device {
 };
 
 struct isert_np {
-	wait_queue_head_t	np_accept_wq;
+	struct semaphore	np_sem;
 	struct rdma_cm_id	*np_cm_id;
 	struct mutex		np_accept_mutex;
 	struct list_head	np_accept_list;


