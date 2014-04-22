Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbaDVUWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:22:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36425 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaDVUWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:22:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        Roland Dreier <roland@purestorage.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 112/133] IB/ehca: Returns an error on ib_copy_to_udata() failure
Date: Tue, 22 Apr 2014 13:14:10 -0700
Message-Id: <1398197671-12786-113-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yann Droneaud <ydroneaud@opteya.com>

commit 5bdb0f02add5994b0bc17494f4726925ca5d6ba1 upstream.

In case of error when writing to userspace, function ehca_create_cq()
does not set an error code before following its error path.

This patch sets the error code to -EFAULT when ib_copy_to_udata()
fails.

This was caught when using spatch (aka. coccinelle)
to rewrite call to ib_copy_{from,to}_udata().

Link: https://www.gitorious.org/opteya/coccib/source/75ebf2c1033c64c1d81df13e4ae44ee99c989eba:ib_copy_udata.cocci
Link: http://marc.info/?i=cover.1394485254.git.ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/hw/ehca/ehca_cq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 8f52901..32c4bf8 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -296,6 +296,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 			(my_cq->galpas.user.fw_handle & (PAGE_SIZE - 1));
 		if (ib_copy_to_udata(udata, &resp, sizeof(resp))) {
 			ehca_err(device, "Copy to udata failed.");
+			cq = ERR_PTR(-EFAULT);
 			goto create_cq_exit4;
 		}
 	}
-- 
1.9.1

