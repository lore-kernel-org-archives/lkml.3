Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3I0Pha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:37:30 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34368 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3I0Ph2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:37:28 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] UBI: fastmap: fix a mem leak on error path
Date: Fri, 27 Sep 2013 17:37:15 +0200
Message-Id: <1380296235-24194-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the scan_pool() function fails, the "free" list is not freed.
This leads to destroy_ai(ai) complaining with:
"kmem_cache_destroy ubi_ainf_peb_slab: Slab cache still has objects"

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/mtd/ubi/fastmap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 05067f5..22eb527 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -841,6 +841,10 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 fail_bad:
 	ret = UBI_BAD_FASTMAP;
 fail:
+	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list) {
+		kmem_cache_free(ai->aeb_slab_cache, tmp_aeb);
+		list_del(&tmp_aeb->u.list);
+	}
 	return ret;
 }
 
-- 
1.7.10.4

