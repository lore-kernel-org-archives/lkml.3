Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab3ERDBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:01:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab3ERDAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:33 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=HMavcrwZPg4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=7kyRtF_LnOIA:10 a=JDjsHSkAAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=Hf6muOzgCGQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021651.943440696@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Marc Eshel <eshel@us.ibm.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 063/136 ] LOCKD: Ensure that nlmclnt_block resets block->b_status after a
 server reboot
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0063-LOCKD-Ensure-that-nlmclnt_block-resets-block-b_statu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

[ Upstream commit 1dfd89af8697a299e7982ae740d4695ecd917eef ]

After a server reboot, the reclaimer thread will recover all the existing
locks. For locks that are blocked, however, it will change the value
of block->b_status to nlm_lck_denied_grace_period in order to signal that
they need to wake up and resend the original blocking lock request.

Due to a bug, however, the block->b_status never gets reset after the
blocked locks have been woken up, and so the process goes into an
infinite loop of resends until the blocked lock is satisfied.

Reported-by: Marc Eshel <eshel@us.ibm.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/lockd/clntlock.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/lockd/clntlock.c b/fs/lockd/clntlock.c
index ca0a080..193f04c 100644
--- a/fs/lockd/clntlock.c
+++ b/fs/lockd/clntlock.c
@@ -144,6 +144,9 @@ int nlmclnt_block(struct nlm_wait *block, struct nlm_rqst *req, long timeout)
 			timeout);
 	if (ret < 0)
 		return -ERESTARTSYS;
+	/* Reset the lock status after a server reboot so we resend */
+	if (block->b_status == nlm_lck_denied_grace_period)
+		block->b_status = nlm_lck_blocked;
 	req->a_res.status = block->b_status;
 	return 0;
 }
-- 
1.7.10.4


