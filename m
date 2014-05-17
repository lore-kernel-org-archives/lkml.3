Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964902AbaEQROo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:14:44 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:55782 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964866AbaEQROm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:14:42 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] infiniband: hw: ehca: ehca_mrmw.c:  Fix for possible null pointer dereference
Date: Sat, 17 May 2014 19:15:26 +0200
Message-Id: <1400346926-25235-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/infiniband/hw/ehca/ehca_mrmw.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 3488e8c..1fe4344 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -316,9 +316,8 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 {
 	struct ib_mr *ib_mr;
 	struct ehca_mr *e_mr;
-	struct ehca_shca *shca =
-		container_of(pd->device, struct ehca_shca, ib_device);
-	struct ehca_pd *e_pd = container_of(pd, struct ehca_pd, ib_pd);
+	struct ehca_shca *shca;
+	struct ehca_pd *e_pd;
 	struct ehca_mr_pginfo pginfo;
 	int ret, page_shift;
 	u32 num_kpages;
@@ -330,6 +329,9 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		return ERR_PTR(-EFAULT);
 	}
 
+	shca = container_of(pd->device, struct ehca_shca, ib_device);
+	e_pd = container_of(pd, struct ehca_pd, ib_pd);
+
 	if (((mr_access_flags & IB_ACCESS_REMOTE_WRITE) &&
 	     !(mr_access_flags & IB_ACCESS_LOCAL_WRITE)) ||
 	    ((mr_access_flags & IB_ACCESS_REMOTE_ATOMIC) &&
-- 
1.7.10.4

