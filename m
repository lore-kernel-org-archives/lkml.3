Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaGHOE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:04:59 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbaGHOE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:04:57 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] UBI: init_volumes: Ignore volumes with no LEBs
Date: Tue,  8 Jul 2014 16:04:44 +0200
Message-Id: <1404828284-32643-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UBI assumes that ubi_attach_info will only contain ubi_ainf_volume
structures for volumes with at least one LEB.
In scanning mode this is true because UBI can nicely create a ubi_ainf_volume
on demand while creating the EBA table.

For fastmap this is not true, the fastmap on-flash structure has a list of
all volumes, the ubi_ainf_volume structures are created from this list.
So it can happen that an empty volume ends up in init_volumes().

We can easely deal with that by looking into ->leb_count too.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/vtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index d77b1c1..07cac5f 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -591,7 +591,7 @@ static int init_volumes(struct ubi_device *ubi,
 
 		/* Static volumes only */
 		av = ubi_find_av(ai, i);
-		if (!av) {
+		if (!av || !av->leb_count) {
 			/*
 			 * No eraseblocks belonging to this volume found. We
 			 * don't actually know whether this static volume is
-- 
2.0.1

