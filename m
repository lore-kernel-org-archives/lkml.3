Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaK3MEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:04:53 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14390 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaK3MEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:04:48 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/6] UBI: Fastmap: Prepare for variable sized fastmaps
Date: Sun, 30 Nov 2014 13:04:29 +0100
Message-Id: <1417349070-8894-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417349070-8894-1-git-send-email-richard@nod.at>
References: <1417349070-8894-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code assumes that each fastmap has the same amount of PEBs.
So far this is true but will change soon.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 2cf2506..762e25c 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1385,7 +1385,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 			ret = -ENOSPC;
 			goto err;
-		} else if (!tmp_e && old_fm) {
+		} else if (!tmp_e && old_fm && old_fm->e[i]) {
 			ret = erase_block(ubi, old_fm->e[i]->pnum);
 			if (ret < 0) {
 				int j;
@@ -1401,12 +1401,20 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 		} else {
 			new_fm->e[i] = tmp_e;
 
-			if (old_fm)
+			if (old_fm && old_fm->e[i])
 				ubi_wl_put_fm_peb(ubi, old_fm->e[i], i,
 						  old_fm->to_be_tortured[i]);
 		}
 	}
 
+	/* Old fastmap is larger than the new one */
+	if (old_fm && new_fm->used_blocks < old_fm->used_blocks) {
+		for (i = new_fm->used_blocks; i < old_fm->used_blocks; i++) {
+			ubi_wl_put_fm_peb(ubi, old_fm->e[i], i,
+					  old_fm->to_be_tortured[i]);
+		}
+	}
+
 	spin_lock(&ubi->wl_lock);
 	tmp_e = ubi_wl_get_fm_peb(ubi, 1);
 	spin_unlock(&ubi->wl_lock);
-- 
1.8.4.5

