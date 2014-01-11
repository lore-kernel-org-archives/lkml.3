Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaAKHoc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 02:44:32 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:61916 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaAKHoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 02:44:30 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-e5-52d0f65c9d35
From: Cai Liu <cai.liu@samsung.com>
To: sjenning@linux.vnet.ibm.com, akpm@linux-foundation.org, bob.liu@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, liucai.lfn@gmail.com
Subject: [PATCH] mm/zswap: Check all pool pages instead of one pool pages
Date: Sat, 11 Jan 2014 15:43:07 +0800
Message-id: <000101cf0ea0$f4e7c560$deb75020$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac8OoEXSkddrVD1JQEiG1jw4jDS9aA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jAd2YbxeCDF5elrSYs34Nm0XXqaks
	Fpd3zWGzuLfmP6vFpj3HWC0O7VvF7sDmsXPWXXaPTZ8msXucmPGbxePBoc0sHh+f3mLx+LxJ
	LoAtissmJTUnsyy1SN8ugSvj47GnrAWruSvunnvI3MC4hLOLkZNDQsBEYtah22wQtpjEhXvr
	wWwhgUWMEnMOOXQxcgHZPxgl+tb9ZAVJsAkoSzx4MJ0RxBYR8JOY1NbP1MXIwcEs4CVxfZ4K
	iCks4Cnx96IKSAWLgKpE/9dp7CBhXgFLiYdddSBhXgFBiR+T77GA2MwCWhLrdx5ngrDlJTav
	ecsMcY2CxI6zr6EW6Ul8bbrFBlEjLrHxyC2WCYwCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTIzjsn0ntYFzZYHGIUYCDUYmHN1DkQpAQa2JZcWXuIUYJDmYl
	EV7WT0Ah3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFINjEUr
	l2dcYxGYd+jkNqXynycuTny/5uLlAJaLj99nMt2r7hEXSHgpNJPf6JY549N9Exnll2gkPc9m
	Zr69IVrzvcrqxliruKzNBywC/23+VXRX/8L+2dtW820KuOjja7d2cU6k0PbJ8tdPHah/Yd0w
	LSqjc92B5cL8xz69/yvjY+tp3yptuFLsp6ISS3FGoqEWc1FxIgCibIHJdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zswap can support multiple swapfiles. So we need to check
all zbud pool pages in zswap.

Signed-off-by: Cai Liu <cai.liu@samsung.com>
---
 mm/zswap.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index d93afa6..2438344 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -291,7 +291,6 @@ static void zswap_free_entry(struct zswap_tree *tree,
 	zbud_free(tree->pool, entry->handle);
 	zswap_entry_cache_free(entry);
 	atomic_dec(&zswap_stored_pages);
-	zswap_pool_pages = zbud_get_pool_size(tree->pool);
 }
 
 /* caller must hold the tree lock */
@@ -405,10 +404,24 @@ cleanup:
 /*********************************
 * helpers
 **********************************/
+static u64 get_zswap_pool_pages(void)
+{
+	int i;
+	u64 pool_pages = 0;
+
+	for (i = 0; i < MAX_SWAPFILES; i++) {
+		if (zswap_trees[i])
+			pool_pages += zbud_get_pool_size(zswap_trees[i]->pool);
+	}
+	zswap_pool_pages = pool_pages;
+
+	return pool_pages;
+}
+
 static bool zswap_is_full(void)
 {
 	return (totalram_pages * zswap_max_pool_percent / 100 <
-		zswap_pool_pages);
+		get_zswap_pool_pages());
 }
 
 /*********************************
@@ -716,7 +729,6 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 
 	/* update stats */
 	atomic_inc(&zswap_stored_pages);
-	zswap_pool_pages = zbud_get_pool_size(tree->pool);
 
 	return 0;
 
-- 
1.7.10.4

