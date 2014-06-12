Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaFLX2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:28:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaFLXSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:18:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 04/19] Target/iscsi,iser: Avoid accepting transport connections during stop stage
Date: Thu, 12 Jun 2014 16:21:41 -0700
Message-Id: <20140612232138.846818026@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232138.561318739@linuxfoundation.org>
References: <20140612232138.561318739@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit 14f4b54fe38f3a8f8392a50b951c8aa43b63687a upstream.

When the target is in stop stage, iSER transport initiates RDMA disconnects.
The iSER initiator may wish to establish a new connection over the
still existing network portal. In this case iSER transport should not
accept and resume new RDMA connections. In order to learn that, iscsi_np
is added with enabled flag so the iSER transport can check when deciding
weather to accept and resume a new connection request.

The iscsi_np is enabled after successful transport setup, and disabled
before iscsi_np login threads are cleaned up.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c   |    8 ++++++++
 drivers/target/iscsi/iscsi_target_core.h  |    1 +
 drivers/target/iscsi/iscsi_target_login.c |    1 +
 drivers/target/iscsi/iscsi_target_tpg.c   |    1 +
 4 files changed, 11 insertions(+)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -489,6 +489,14 @@ isert_connect_request(struct rdma_cm_id
 	struct ib_device *ib_dev = cma_id->device;
 	int ret = 0;
 
+	spin_lock_bh(&np->np_thread_lock);
+	if (!np->enabled) {
+		spin_unlock_bh(&np->np_thread_lock);
+		pr_debug("iscsi_np is not enabled, reject connect request\n");
+		return rdma_reject(cma_id, NULL, 0);
+	}
+	spin_unlock_bh(&np->np_thread_lock);
+
 	pr_debug("Entering isert_connect_request cma_id: %p, context: %p\n",
 		 cma_id, cma_id->context);
 
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -773,6 +773,7 @@ struct iscsi_np {
 	int			np_ip_proto;
 	int			np_sock_type;
 	enum np_thread_state_table np_thread_state;
+	bool                    enabled;
 	enum iscsi_timer_flags_table np_login_timer_flags;
 	u32			np_exports;
 	enum np_flags_table	np_flags;
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -981,6 +981,7 @@ int iscsi_target_setup_login_socket(
 	}
 
 	np->np_transport = t;
+	np->enabled = true;
 	return 0;
 }
 
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -184,6 +184,7 @@ static void iscsit_clear_tpg_np_login_th
 		return;
 	}
 
+	tpg_np->tpg_np->enabled = false;
 	iscsit_reset_np_thread(tpg_np->tpg_np, tpg_np, tpg, shutdown);
 }
 


