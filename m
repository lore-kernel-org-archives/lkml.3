Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3I1N4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 09:56:18 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62414 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3I1Nzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 09:55:32 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: richard.genoud@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 6/7] UBI: Fix memory leak in ubi_attach_fastmap() error path
Date: Sat, 28 Sep 2013 15:55:15 +0200
Message-Id: <1380376516-30144-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380376516-30144-1-git-send-email-richard@nod.at>
References: <1380376516-30144-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On error we have to free all three temporary lists.

Reported-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 05067f5..4cfc8da 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -841,6 +841,19 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 fail_bad:
 	ret = UBI_BAD_FASTMAP;
 fail:
+	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &used, u.list) {
+		kmem_cache_free(ai->aeb_slab_cache, tmp_aeb);
+		list_del(&tmp_aeb->u.list);
+	}
+	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &eba_orphans, u.list) {
+		kmem_cache_free(ai->aeb_slab_cache, tmp_aeb);
+		list_del(&tmp_aeb->u.list);
+	}
+	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list) {
+		kmem_cache_free(ai->aeb_slab_cache, tmp_aeb);
+		list_del(&tmp_aeb->u.list);
+	}
+
 	return ret;
 }
 
-- 
1.8.3.1

