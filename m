Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180AbaKMNh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:37:56 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42083 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026AbaKMNhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:37:54 -0500
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
To: minchan@kernel.org, ngupta@vflare.org, ddstreet@ieee.org,
        sergey.senozhatsky@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: [PATCH 1/3] mm/zsmalloc: avoid unregister a NOT-registered zsmalloc zpool driver
Date: Thu, 13 Nov 2014 21:37:35 +0800
Message-Id: <1415885857-5283-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now zsmalloc can be registered as a zpool driver into zpool when
CONFIG_ZPOOL is enabled. During the init of zsmalloc, when error happens,
we need to do cleanup. But in current code, it will unregister a not yet
registered zsmalloc zpool driver(*zs_zpool_driver*).

This patch puts the cleanup in zs_init() instead of calling zs_exit()
where it will unregister a not-registered zpool driver.

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
---
 mm/zsmalloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 839a48c..3d2bb36 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -907,10 +907,8 @@ static int zs_init(void)
 	__register_cpu_notifier(&zs_cpu_nb);
 	for_each_online_cpu(cpu) {
 		ret = zs_cpu_notifier(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
-		if (notifier_to_errno(ret)) {
-			cpu_notifier_register_done();
+		if (notifier_to_errno(ret))
 			goto fail;
-		}
 	}
 
 	cpu_notifier_register_done();
@@ -920,8 +918,14 @@ static int zs_init(void)
 #endif
 
 	return 0;
+
 fail:
-	zs_exit();
+	for_each_online_cpu(cpu)
+		zs_cpu_notifier(NULL, CPU_UP_CANCELED, (void *)(long)cpu);
+	__unregister_cpu_notifier(&zs_cpu_nb);
+
+	cpu_notifier_register_done();
+
 	return notifier_to_errno(ret);
 }
 
-- 
1.7.9.5

