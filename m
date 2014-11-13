Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427AbaKMWbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:31:10 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33175 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934154AbaKMWbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:31:08 -0500
Date: Fri, 14 Nov 2014 07:31:27 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Mahendran Ganesh <opensource.ganesh@gmail.com>
Cc: minchan@kernel.org, ngupta@vflare.org, ddstreet@ieee.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 1/3] mm/zsmalloc: avoid unregister a NOT-registered
 zsmalloc zpool driver
Message-ID: <20141113223127.GA951@swordfish>
References: <1415885857-5283-1-git-send-email-opensource.ganesh@gmail.com>
 <20141113152247.GB1408@swordfish>
 <20141113153017.GC1408@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113153017.GC1408@swordfish>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/14/14 00:30), Sergey Senozhatsky wrote:
> Factor out zsmalloc cpu notifier unregistration code and call
> it from both zs_exit() and zs_init() error path.

I should had have a good sleep before posting this.
shame on me!

v3

Signed-ogg-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 mm/zsmalloc.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index b3b57ef..cd4efa1 100644
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
@@ -898,6 +894,14 @@ static void zs_exit(void)
 	cpu_notifier_register_done();
 }
 
+static void zs_exit(void)
+{
+#ifdef CONFIG_ZPOOL
+	zpool_unregister_driver(&zs_zpool_driver);
+#endif
+	zs_unregister_cpu_notifier();
+}
+
 static int zs_init(void)
 {
 	int cpu, ret;
@@ -921,7 +925,7 @@ static int zs_init(void)
 
 	return 0;
 fail:
-	zs_exit();
+	zs_unregister_cpu_notifier();
 	return notifier_to_errno(ret);
 }
 
