Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaD1Bbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42881 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Roland Dreier" <roland@purestorage.com>,
        "Yann Droneaud" <ydroneaud@opteya.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.72384035@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 50/94] IB/nes: Return an error on ib_copy_from_udata()
 failure instead of NULL
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/hw/nes/nes_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1183,7 +1183,7 @@ static struct ib_qp *nes_create_qp(struc
 					nes_free_resource(nesadapter, nesadapter->allocated_qps, qp_num);
 					kfree(nesqp->allocated_buffer);
 					nes_debug(NES_DBG_QP, "ib_copy_from_udata() Failed \n");
-					return NULL;
+					return ERR_PTR(-EFAULT);
 				}
 				if (req.user_wqe_buffers) {
 					virt_wqs = 1;

