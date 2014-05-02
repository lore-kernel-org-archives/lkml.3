Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaEBPmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:42:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaEBPmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:42:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        Roland Dreier <roland@purestorage.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 059/151] IB/nes: Return an error on ib_copy_from_udata() failure instead of NULL
Date: Fri,  2 May 2014 08:37:27 -0700
Message-Id: <1399045139-4531-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yann Droneaud <ydroneaud@opteya.com>

commit 9d194d1025f463392feafa26ff8c2d8247f71be1 upstream.

In case of error while accessing to userspace memory, function
nes_create_qp() returns NULL instead of an error code wrapped through
ERR_PTR().  But NULL is not expected by ib_uverbs_create_qp(), as it
check for error with IS_ERR().

As page 0 is likely not mapped, it is going to trigger an Oops when
the kernel will try to dereference NULL pointer to access to struct
ib_qp's fields.

In some rare cases, page 0 could be mapped by userspace, which could
turn this bug to a vulnerability that could be exploited: the function
pointers in struct ib_device will be under userspace total control.

This was caught when using spatch (aka. coccinelle)
to rewrite calls to ib_copy_{from,to}_udata().

Link: https://www.gitorious.org/opteya/ib-hw-nes-create-qp-null
Link: https://www.gitorious.org/opteya/coccib/source/75ebf2c1033c64c1d81df13e4ae44ee99c989eba:ib_copy_udata.cocci
Link: http://marc.info/?i=cover.1394485254.git.ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/hw/nes/nes_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 8308e36..eb62461 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1186,7 +1186,7 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 					nes_free_resource(nesadapter, nesadapter->allocated_qps, qp_num);
 					kfree(nesqp->allocated_buffer);
 					nes_debug(NES_DBG_QP, "ib_copy_from_udata() Failed \n");
-					return NULL;
+					return ERR_PTR(-EFAULT);
 				}
 				if (req.user_wqe_buffers) {
 					virt_wqs = 1;
-- 
1.9.1

