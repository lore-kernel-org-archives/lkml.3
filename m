Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbaBZTHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:07:01 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:45616 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbaBZTG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:06:59 -0500
From: vinayakm.list@gmail.com
To: gregkh@linuxfoundation.org, arve@android.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Vinayak Menon <vinayakm.list@gmail.com>
Subject: [PATCH v3] staging: android: lowmemorykiller: neglect swap cached pages in other_file
Date: Thu, 27 Feb 2014 00:36:22 +0530
Message-Id: <1393441582-3730-1-git-send-email-vinayakm.list@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinayak Menon <vinayakm.list@gmail.com>

With ZRAM enabled it is observed that lowmemory killer
doesn't trigger properly. swap cached pages are
accounted in NR_FILE, and lowmemorykiller considers
this as reclaimable and adds to other_file. But these
pages can't be reclaimed unless lowmemorykiller triggers.
So subtract swap pages from other_file.

Signed-off-by: Vinayak Menon <vinayakm.list@gmail.com>
---
 drivers/staging/android/lowmemorykiller.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 6f094b3..9e931b2 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -88,7 +88,8 @@ static unsigned long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
 	int array_size = ARRAY_SIZE(lowmem_adj);
 	int other_free = global_page_state(NR_FREE_PAGES) - totalreserve_pages;
 	int other_file = global_page_state(NR_FILE_PAGES) -
-						global_page_state(NR_SHMEM);
+						global_page_state(NR_SHMEM) -
+						total_swapcache_pages();
 
 	if (lowmem_adj_size < array_size)
 		array_size = lowmem_adj_size;
-- 
1.7.10.4

