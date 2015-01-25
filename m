Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbbAYSlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:41:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858AbbAYSKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Max Gurtovoy <maxg@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.18 068/183] IB/iser: Fix possible SQ overflow
Date: Sun, 25 Jan 2015 10:06:30 -0800
Message-Id: <20150125180813.134156726@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Gurtovoy <maxg@mellanox.com>

commit 6ec9d4d2310e8fc54fc638e4454271d1fcaefa95 upstream.

Fix a regression was introduced in commit 6df5a128f0fd ("IB/iser:
Suppress scsi command send completions").

The sig_count was wrongly set to be static variable, thus it is
possible that we won't reach to (sig_count % ISER_SIGNAL_BATCH) == 0
condition (due to races) and the send queue will be overflowed.

Instead keep sig_count per connection. We don't need it to be atomic
as we are safe under the iscsi session frwd_lock taken by libiscsi on
the queuecommand path.

Fixes: 6df5a128f0fd ("IB/iser: Suppress scsi command send completions")
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    2 ++
 drivers/infiniband/ulp/iser/iser_initiator.c |    6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -432,6 +432,7 @@ struct fast_reg_descriptor {
  * @cma_id:              rdma_cm connection maneger handle
  * @qp:                  Connection Queue-pair
  * @post_recv_buf_count: post receive counter
+ * @sig_count:           send work request signal count
  * @rx_wr:               receive work request for batch posts
  * @device:              reference to iser device
  * @comp:                iser completion context
@@ -452,6 +453,7 @@ struct ib_conn {
 	struct rdma_cm_id           *cma_id;
 	struct ib_qp	            *qp;
 	int                          post_recv_buf_count;
+	u8                           sig_count;
 	struct ib_recv_wr	     rx_wr[ISER_MIN_POSTED_RX];
 	struct iser_device          *device;
 	struct iser_comp	    *comp;
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -369,7 +369,7 @@ static int iser_post_rx_bufs(struct iscs
 	return 0;
 }
 
-static inline bool iser_signal_comp(int sig_count)
+static inline bool iser_signal_comp(u8 sig_count)
 {
 	return ((sig_count % ISER_SIGNAL_CMD_COUNT) == 0);
 }
@@ -388,7 +388,7 @@ int iser_send_command(struct iscsi_conn
 	struct iscsi_scsi_req *hdr = (struct iscsi_scsi_req *)task->hdr;
 	struct scsi_cmnd *sc  =  task->sc;
 	struct iser_tx_desc *tx_desc = &iser_task->desc;
-	static unsigned sig_count;
+	u8 sig_count = ++iser_conn->ib_conn.sig_count;
 
 	edtl = ntohl(hdr->data_length);
 
@@ -435,7 +435,7 @@ int iser_send_command(struct iscsi_conn
 	iser_task->status = ISER_TASK_STATUS_STARTED;
 
 	err = iser_post_send(&iser_conn->ib_conn, tx_desc,
-			     iser_signal_comp(++sig_count));
+			     iser_signal_comp(sig_count));
 	if (!err)
 		return 0;
 


