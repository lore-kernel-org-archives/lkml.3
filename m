Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965506AbaKNM44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 07:56:56 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:57185 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965171AbaKNM4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 07:56:55 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mahendran Ganesh <opensource.ganesh@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-mm@kvack.or,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] zsmalloc: fix zs_init cpu notifier error handling
Date: Fri, 14 Nov 2014 21:57:06 +0900
Message-Id: <1415969826-6416-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.218.ge7f43d6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mahendran Ganesh reported that zpool-enabled zsmalloc should not
call zpool_unregister_driver() from zs_init() if cpu notifier
registration has failed, because error handling is performed
before we register the driver via zpool_register_driver() call.

Factor out cpu notifier registration and unregistration code and
fix zs_init() error handling.

link: http://lkml.iu.edu//hypermail/linux/kernel/1411.1/04156.html
Reported-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 mm/zsmalloc.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index b3b57ef..b8c2d41 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -881,14 +881,10 @@ static struct notifier_block zs_cpu_nb = {
 	.notifier_call = zs_cpu_notifier
 };
 
-static void zs_exit(void)
+static void zs_unregister_cpu_notifier(void)
 {
 	int cpu;
 
-#ifdef CONFIG_ZPOOL
-	zpool_unregister_driver(&zs_zpool_driver);
-#endif
-
 	cpu_notifier_register_begin();
 
 	for_each_online_cpu(cpu)
@@ -898,7 +894,7 @@ static void zs_exit(void)
 	cpu_notifier_register_done();
 }
 
-static int zs_init(void)
+static int zs_register_cpu_notifier(void)
 {
 	int cpu, ret;
 
@@ -907,22 +903,35 @@ static int zs_init(void)
 	__register_cpu_notifier(&zs_cpu_nb);
 	for_each_online_cpu(cpu) {
 		ret = zs_cpu_notifier(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
-		if (notifier_to_errno(ret)) {
-			cpu_notifier_register_done();
-			goto fail;
-		}
+		if (notifier_to_errno(ret))
+			break;
 	}
 
 	cpu_notifier_register_done();
+	return notifier_to_errno(ret);
+}
+
+static void zs_exit(void)
+{
+#ifdef CONFIG_ZPOOL
+	zpool_unregister_driver(&zs_zpool_driver);
+#endif
+	zs_unregister_cpu_notifier();
+}
+
+static int zs_init(void)
+{
+	int ret = zs_register_cpu_notifier();
+
+	if (ret) {
+		zs_unregister_cpu_notifier();
+		return ret;
+	}
 
 #ifdef CONFIG_ZPOOL
 	zpool_register_driver(&zs_zpool_driver);
 #endif
-
 	return 0;
-fail:
-	zs_exit();
-	return notifier_to_errno(ret);
 }
 
 static unsigned int get_maxobj_per_zspage(int size, int pages_per_zspage)
-- 
2.2.0.rc0.218.ge7f43d6

