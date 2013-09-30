Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3I3N03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:26:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14026 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab3I3N0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:26:23 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-b9-52497bfe0226
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 01/14] skd: fix unregister_blkdev() placement
Date: Mon, 30 Sep 2013 15:25:42 +0200
Message-id: <1380547556-17719-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xgO6/as8gg7vfJS16e06yW6y+289m
	sXHGelaLs7+uslicbXrDbnF51xw2BzaPy2dLPd7vu8rm0bdlFaPHnXMfmDw+b5ILYI3isklJ
	zcksSy3St0vgyth8YCpbwS72ikeHFrM3MG5m62Lk5JAQMJF43ruGFcIWk7hwbz1YXEhgEaPE
	suNBXYxcQHYXk0T32i2MIAk2ASuJie2rwGwRAWGJ/R2tLCBFzAJNjBIbl8wB6xYWsJXomNEL
	ZrMIqEp0/7zCBGLzCnhInNkxkxFim7zE0/t9YDWcAp4S/28fZYTY7CHx7dBlpgmMvAsYGVYx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBIfSM+kdjKsaLA4xCnAwKvHwWiz1CBJiTSwrrsw9
	xCjBwawkwite5hkkxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJ
	g1OqgXHFQ2crwwKBQ8IefOcu3Om/Xi53fMt2MTul68YvlyU4q9cbXAn5U2j4Tqa/w94rueO/
	0Mp3j7nl8iTVf0rq3zv943bMFPOMi3PnVAlJLn+j3yxQu/kJq8qSSM1FTDxXZm9Z91lovuev
	FuW5ruf1W4yPctpUnM49vaLdQDyqTOfE49PendJ52UosxRmJhlrMRcWJAKuHxzYhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

register_blkdev() is called before pci_register_driver() in skd_init()
so unregister_blkdev() should be called after pci_unregister_driver()
in skd_exit(). Fix it.

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 3110f68..a98d1bc 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -5778,9 +5778,10 @@ static void __exit skd_exit(void)
 {
 	pr_info(PFX " v%s-b%s unloading\n", DRV_VERSION, DRV_BUILD_ID);
 
-	unregister_blkdev(skd_major, DRV_NAME);
 	pci_unregister_driver(&skd_driver);
 
+	unregister_blkdev(skd_major, DRV_NAME);
+
 	kmem_cache_destroy(skd_flush_slab);
 }
 
-- 
1.8.2.3

