Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaK3LtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 06:49:11 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14388 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaK3Lrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 06:47:55 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/6] UBI: Fastmap: Remove bogus ubi_assert()
Date: Sun, 30 Nov 2014 12:47:43 +0100
Message-Id: <1417348066-7043-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417348066-7043-1-git-send-email-richard@nod.at>
References: <1417348066-7043-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is legal to have PEBs left in the used list.
This can happen if UBI copies a PEB and a powercut happens
between writing a new fastmap and adding this PEB into the EBA table.
In this case the old PEB will be used.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 600c4f9..9858bfb 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -814,7 +814,9 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list)
 		list_move_tail(&tmp_aeb->u.list, &ai->free);
 
-	ubi_assert(list_empty(&used));
+	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &used, u.list)
+		list_move_tail(&tmp_aeb->u.list, &ai->erase);
+
 	ubi_assert(list_empty(&eba_orphans));
 	ubi_assert(list_empty(&free));
 
-- 
1.8.4.5

