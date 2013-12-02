Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab3LBVGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:06:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab3LBTNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.10 053/173] IB/srp: Report receive errors correctly
Date: Mon,  2 Dec 2013 11:10:36 -0800
Message-Id: <20131202191148.731849591@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit cd4e38542a5c2cab94e5410fb17c1cc004a60792 upstream.

The IB spec does not guarantee that the opcode is available in error
completions.  Hence do not rely on it.  See also commit 948d1e889e5b
("IB/srp: Introduce srp_handle_qp_err()").

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1300,14 +1300,13 @@ static void srp_handle_recv(struct srp_t
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
@@ -1323,7 +1322,7 @@ static void srp_recv_completion(struct i
 		if (likely(wc.status == IB_WC_SUCCESS)) {
 			srp_handle_recv(target, &wc);
 		} else {
-			srp_handle_qp_err(wc.status, wc.opcode, target);
+			srp_handle_qp_err(wc.status, false, target);
 		}
 	}
 }
@@ -1339,7 +1338,7 @@ static void srp_send_completion(struct i
 			iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
 			list_add(&iu->list, &target->free_tx);
 		} else {
-			srp_handle_qp_err(wc.status, wc.opcode, target);
+			srp_handle_qp_err(wc.status, true, target);
 		}
 	}
 }


