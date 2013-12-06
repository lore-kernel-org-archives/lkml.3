Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab3LFNB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:01:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046Ab3LFNBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:01:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bart Van Assche <bvanassche@acm.org>,
        Roland Dreier <roland@purestorage.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 106/272] IB/srp: Report receive errors correctly
Date: Fri,  6 Dec 2013 12:56:35 +0000
Message-Id: <1386334761-25517-107-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit cd4e38542a5c2cab94e5410fb17c1cc004a60792 upstream.

The IB spec does not guarantee that the opcode is available in error
completions.  Hence do not rely on it.  See also commit 948d1e889e5b
("IB/srp: Introduce srp_handle_qp_err()").

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f93baf8..df7a19c 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1302,14 +1302,13 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 			     PFX "Recv failed with error code %d\n", res);
 }
 
-static void srp_handle_qp_err(enum ib_wc_status wc_status,
-			      enum ib_wc_opcode wc_opcode,
+static void srp_handle_qp_err(enum ib_wc_status wc_status, bool send_err,
 			      struct srp_target_port *target)
 {
 	if (target->connected && !target->qp_in_error) {
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "failed %s status %d\n",
-			     wc_opcode & IB_WC_RECV ? "receive" : "send",
+			     send_err ? "send" : "receive",
 			     wc_status);
 	}
 	target->qp_in_error = true;
@@ -1325,7 +1324,7 @@ static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 		if (likely(wc.status == IB_WC_SUCCESS)) {
 			srp_handle_recv(target, &wc);
 		} else {
-			srp_handle_qp_err(wc.status, wc.opcode, target);
+			srp_handle_qp_err(wc.status, false, target);
 		}
 	}
 }
@@ -1341,7 +1340,7 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 			iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
 			list_add(&iu->list, &target->free_tx);
 		} else {
-			srp_handle_qp_err(wc.status, wc.opcode, target);
+			srp_handle_qp_err(wc.status, true, target);
 		}
 	}
 }
-- 
1.8.3.2

