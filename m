Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab3JJP4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:56:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52987 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498Ab3JJPtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jack Wang <jinpu.wang@profitbricks.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 102/104] ib_srpt: always set response for task management
Date: Thu, 10 Oct 2013 08:42:30 -0700
Message-Id: <1381419752-29733-103-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Wang <jinpu.wang@profitbricks.com>

commit c807f64340932e19f0d2ac9b30c8381e1f60663a upstream.

The SRP specification requires:

  "Response data shall be provided in any SRP_RSP response that is sent in
   response to an SRP_TSK_MGMT request (see 6.7). The information in the
   RSP_CODE field (see table 24) shall indicate the completion status of
   the task management function."

So fix this to avoid the SRP initiator interprets task management functions
that succeeded as failed.

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 047ebe4..fb8abcb 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1588,7 +1588,7 @@ static int srpt_build_tskmgmt_rsp(struct srpt_rdma_ch *ch,
 	int resp_data_len;
 	int resp_len;
 
-	resp_data_len = (rsp_code == SRP_TSK_MGMT_SUCCESS) ? 0 : 4;
+	resp_data_len = 4;
 	resp_len = sizeof(*srp_rsp) + resp_data_len;
 
 	srp_rsp = ioctx->ioctx.buf;
@@ -1600,11 +1600,9 @@ static int srpt_build_tskmgmt_rsp(struct srpt_rdma_ch *ch,
 				    + atomic_xchg(&ch->req_lim_delta, 0));
 	srp_rsp->tag = tag;
 
-	if (rsp_code != SRP_TSK_MGMT_SUCCESS) {
-		srp_rsp->flags |= SRP_RSP_FLAG_RSPVALID;
-		srp_rsp->resp_data_len = cpu_to_be32(resp_data_len);
-		srp_rsp->data[3] = rsp_code;
-	}
+	srp_rsp->flags |= SRP_RSP_FLAG_RSPVALID;
+	srp_rsp->resp_data_len = cpu_to_be32(resp_data_len);
+	srp_rsp->data[3] = rsp_code;
 
 	return resp_len;
 }
-- 
1.8.1.2

