Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab3HSUcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:32:06 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750827Ab3HSUcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:32:05 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] UBI: Fix invalidate_fastmap()
Date: Mon, 19 Aug 2013 22:31:49 +0200
Message-Id: <1376944309-11342-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Onging tests uncovered that invalidate_fastmap() is broken.
It must not call ubi_wl_put_fm_peb() because all PEBs used
by the old fastmap have already been put back.

Signed-off-by: Richard Weinberger <richard@nod.at>
[rw: I did not Cc -stable because fastmap is an experimental feature.]
---
 drivers/mtd/ubi/fastmap.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 1542751..f5aa4b0 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1343,7 +1343,7 @@ out:
 static int invalidate_fastmap(struct ubi_device *ubi,
 			      struct ubi_fastmap_layout *fm)
 {
-	int ret, i;
+	int ret;
 	struct ubi_vid_hdr *vh;
 
 	ret = erase_block(ubi, fm->e[0]->pnum);
@@ -1360,9 +1360,6 @@ static int invalidate_fastmap(struct ubi_device *ubi,
 	vh->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
 	ret = ubi_io_write_vid_hdr(ubi, fm->e[0]->pnum, vh);
 
-	for (i = 0; i < fm->used_blocks; i++)
-		ubi_wl_put_fm_peb(ubi, fm->e[i], i, fm->to_be_tortured[i]);
-
 	return ret;
 }
 
-- 
1.8.1.4

