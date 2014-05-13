Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbaEMJiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:38:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60920 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760116AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>,
        Roland Dreier <roland@purestorage.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 067/182] IB/nes: Return an error on ib_copy_from_udata() failure instead of NULL
Date: Tue, 13 May 2014 11:26:59 +0200
Message-Id: <c4d906191b3d75957182cb01984bdb3e825d8ee5.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yann Droneaud <ydroneaud@opteya.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/hw/nes/nes_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 5b53ca5a2284..09999cdec3b1 100644
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
1.9.3

