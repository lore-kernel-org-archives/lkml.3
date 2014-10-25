Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaJYSj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:39:26 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaJYSjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:39:25 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] UBI: vtbl: Use ubi_eba_atomic_leb_change()
Date: Sat, 25 Oct 2014 19:43:41 +0200
Message-Id: <1414259021-5691-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is more a cosmetic change than a fix.
By using ubi_eba_atomic_leb_change()
we can guarantee that the first VTBL record is always
correct and we don't really need the second one anymore.
But we have to keep the second one to not break anything.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/vtbl.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index 07cac5f..0d26051 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -96,12 +96,8 @@ int ubi_change_vtbl_record(struct ubi_device *ubi, int idx,
 
 	memcpy(&ubi->vtbl[idx], vtbl_rec, sizeof(struct ubi_vtbl_record));
 	for (i = 0; i < UBI_LAYOUT_VOLUME_EBS; i++) {
-		err = ubi_eba_unmap_leb(ubi, layout_vol, i);
-		if (err)
-			return err;
-
-		err = ubi_eba_write_leb(ubi, layout_vol, i, ubi->vtbl, 0,
-					ubi->vtbl_size);
+		err = ubi_eba_atomic_leb_change(ubi, layout_vol, i, ubi->vtbl,
+						ubi->vtbl_size);
 		if (err)
 			return err;
 	}
@@ -148,12 +144,8 @@ int ubi_vtbl_rename_volumes(struct ubi_device *ubi,
 
 	layout_vol = ubi->volumes[vol_id2idx(ubi, UBI_LAYOUT_VOLUME_ID)];
 	for (i = 0; i < UBI_LAYOUT_VOLUME_EBS; i++) {
-		err = ubi_eba_unmap_leb(ubi, layout_vol, i);
-		if (err)
-			return err;
-
-		err = ubi_eba_write_leb(ubi, layout_vol, i, ubi->vtbl, 0,
-					ubi->vtbl_size);
+		err = ubi_eba_atomic_leb_change(ubi, layout_vol, i, ubi->vtbl,
+						ubi->vtbl_size);
 		if (err)
 			return err;
 	}
-- 
1.8.4.5

