Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab3JKTmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:42:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822Ab3JKTmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jack Wang <jinpu.wang@profitbricks.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 105/135] ib_srpt: always set response for task management
Date: Fri, 11 Oct 2013 12:39:46 -0700
Message-Id: <20131011193956.678776463@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1588,7 +1588,7 @@ static int srpt_build_tskmgmt_rsp(struct
 	int resp_data_len;
 	int resp_len;
 
-	resp_data_len = (rsp_code == SRP_TSK_MGMT_SUCCESS) ? 0 : 4;
+	resp_data_len = 4;
 	resp_len = sizeof(*srp_rsp) + resp_data_len;
 
 	srp_rsp = ioctx->ioctx.buf;
@@ -1600,11 +1600,9 @@ static int srpt_build_tskmgmt_rsp(struct
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


