Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab3ANTeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 14:34:13 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:56640 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab3ANTeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 14:34:11 -0500
Date: Mon, 14 Jan 2013 20:34:09 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-rdma@vger.kernel.org, Hal Rosenstock <hal.rosenstock@gmail.com>,
        Sean Hefty <sean.hefty@intel.com>, Roland Dreier <roland@kernel.org>,
        Steve Wise <swise@chelsio.com>, trivial@kernel.org
Subject: [PATCH] IB: cxgb3: delay freeing mem untill entirely done with it
Message-ID: <alpine.LNX.2.00.1301142031050.31033@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, it's just the pointer value we use, but the coverity checker
complains about a use-after-free bug and it really does seem cleaner
to delay freeing until we are entirely done with the memory. So,
rearrange the code to move the kfree() later untill we are completely
done.
Trivial and harmless, but nice IMHO.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 0bdf09a..145d82a 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -783,8 +783,8 @@ static int iwch_dealloc_mw(struct ib_mw *mw)
 	mmid = (mw->rkey) >> 8;
 	cxio_deallocate_window(&rhp->rdev, mhp->attr.stag);
 	remove_handle(rhp, &rhp->mmidr, mmid);
-	kfree(mhp);
 	PDBG("%s ib_mw %p mmid 0x%x ptr %p\n", __func__, mw, mmid, mhp);
+	kfree(mhp);
 	return 0;
 }
 
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

