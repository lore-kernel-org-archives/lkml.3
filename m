Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbaJ2MxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:53:04 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14391 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848AbaJ2MqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:14 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 12/35] UBI: Fastmap: Notify user in case of an ubi_update_fastmap() failure
Date: Wed, 29 Oct 2014 13:45:35 +0100
Message-Id: <1414586758-9972-13-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ubi_update_fastmap() fails notify the user.
This is not a hard error as ubi_update_fastmap() makes sure upon failure that
the current on-flash fastmap will no be used upon next UBI attach.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index ac19f75..44ebefd 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -640,7 +640,11 @@ again:
 	if (!pool->size || !wl_pool->size || pool->used >= pool->size ||
 	    wl_pool->used >= wl_pool->size) {
 		spin_unlock(&ubi->wl_lock);
-		ubi_update_fastmap(ubi);
+		ret = ubi_update_fastmap(ubi);
+		if (ret) {
+			ubi_msg("Unable to write a new fastmap: %i", ret);
+			return -ENOSPC;
+		}
 		spin_lock(&ubi->wl_lock);
 	}
 
-- 
1.8.4.5

