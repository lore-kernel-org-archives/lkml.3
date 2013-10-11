Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab3JKKrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:47:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58806 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab3JKKoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:44:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jack Wang <jinpu.wang@profitbricks.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 091/100] ib_srpt: always set response for task management
Date: Fri, 11 Oct 2013 11:42:01 +0100
Message-Id: <1381488130-30235-92-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 0ff33b0..10f88e6 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1609,7 +1609,7 @@ static int srpt_build_tskmgmt_rsp(struct srpt_rdma_ch *ch,
 	int resp_data_len;
 	int resp_len;
 
-	resp_data_len = (rsp_code == SRP_TSK_MGMT_SUCCESS) ? 0 : 4;
+	resp_data_len = 4;
 	resp_len = sizeof(*srp_rsp) + resp_data_len;
 
 	srp_rsp = ioctx->ioctx.buf;
@@ -1621,11 +1621,9 @@ static int srpt_build_tskmgmt_rsp(struct srpt_rdma_ch *ch,
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
1.8.3.2

