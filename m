Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaK3Lgm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 06:36:42 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14389 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaK3Lft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 06:35:49 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/6] UBI: Fastmap: Notify user in case of an ubi_update_fastmap() failure
Date: Sun, 30 Nov 2014 12:35:37 +0100
Message-Id: <1417347340-6872-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417347340-6872-1-git-send-email-richard@nod.at>
References: <1417347340-6872-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ubi_update_fastmap() fails notify the user.
This is not a hard error as ubi_update_fastmap() makes sure that upon failure
the current on-flash fastmap will no be used upon next UBI attach.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 523d8a4..7821342 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -657,7 +657,11 @@ again:
 	 * refill the WL pool synchronous. */
 	if (pool->used == pool->size || wl_pool->used == wl_pool->size) {
 		spin_unlock(&ubi->wl_lock);
-		ubi_update_fastmap(ubi);
+		ret = ubi_update_fastmap(ubi);
+		if (ret) {
+			ubi_msg(ubi, "Unable to write a new fastmap: %i", ret);
+			return -ENOSPC;
+		}
 		spin_lock(&ubi->wl_lock);
 	}
 
-- 
1.8.4.5

