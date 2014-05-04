Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbaEDQoN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:44:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbaEDPlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yann Droneaud <ydroneaud@opteya.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.14 082/158] IB/nes: Return an error on ib_copy_from_udata() failure instead of NULL
Date: Sun,  4 May 2014 11:39:51 -0400
Message-Id: <20140504154041.036423626@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/nes/nes_verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1186,7 +1186,7 @@ static struct ib_qp *nes_create_qp(struc
 					nes_free_resource(nesadapter, nesadapter->allocated_qps, qp_num);
 					kfree(nesqp->allocated_buffer);
 					nes_debug(NES_DBG_QP, "ib_copy_from_udata() Failed \n");
-					return NULL;
+					return ERR_PTR(-EFAULT);
 				}
 				if (req.user_wqe_buffers) {
 					virt_wqs = 1;


