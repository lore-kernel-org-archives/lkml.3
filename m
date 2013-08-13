Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3HMEti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 00:49:38 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:50703 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab3HMEte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 00:49:34 -0400
From: Nilanjan Roychowdhury <nilanjan.roychowdhury@gmail.com>
To: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-kernel@vger.kernel.org,
        Nilanjan Roychowdhury <nilanjan.roychowdhury@gmail.com>
Subject: [PATCH 1/1] Resubmit mtd: mtdoops: fix for a potential memory leak in mtdoops_notify_remove
Date: Mon, 12 Aug 2013 21:48:35 -0700
Message-Id: <1376369315-5170-1-git-send-email-nilanjan.roychowdhury@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we are allocating cxt->oops_page_used using vmalloc in mtdoops_notify_add for
every mtd_info addition but not freeing it in mtdoops_notify_remove. Also care is
taken so that we do not free the same pointer again in module remove.

Signed-off-by: Nilanjan Roychowdhury <nilanjan.roychowdhury@gmail.com>
---
 drivers/mtd/mtdoops.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
index 97bb8f6..4b8b621 100644
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -386,6 +386,8 @@ static void mtdoops_notify_remove(struct mtd_info *mtd)
 	cxt->mtd = NULL;
 	flush_work(&cxt->work_erase);
 	flush_work(&cxt->work_write);
+	vfree(cxt->oops_page_used);
+	cxt->oops_page_used = NULL;
 }
 
 
@@ -439,7 +441,8 @@ static void __exit mtdoops_exit(void)
 
 	unregister_mtd_user(&mtdoops_notifier);
 	vfree(cxt->oops_buf);
-	vfree(cxt->oops_page_used);
+	if (cxt->oops_page_used)
+		vfree(cxt->oops_page_used);
 }
 
 
-- 
1.7.9.5

