Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab3JKThh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:37:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243Ab3JKThY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:37:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jack Wang <jinpu.wang@profitbricks.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 37/48] ib_srpt: always set response for task management
Date: Fri, 11 Oct 2013 12:36:44 -0700
Message-Id: <20131011193641.267784628@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193637.253208688@linuxfoundation.org>
References: <20131011193637.253208688@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1610,7 +1610,7 @@ static int srpt_build_tskmgmt_rsp(struct
 	int resp_data_len;
 	int resp_len;
 
-	resp_data_len = (rsp_code == SRP_TSK_MGMT_SUCCESS) ? 0 : 4;
+	resp_data_len = 4;
 	resp_len = sizeof(*srp_rsp) + resp_data_len;
 
 	srp_rsp = ioctx->ioctx.buf;
@@ -1622,11 +1622,9 @@ static int srpt_build_tskmgmt_rsp(struct
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


