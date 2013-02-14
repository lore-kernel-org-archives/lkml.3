Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab3BNDHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:07:12 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19985 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab3BNDFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:05:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        dan.magenheimer@oracle.com, gregkh@linuxfoundation.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 11/16] zcache/debug: Coalesce all debug under CONFIG_ZCACHE_DEBUG
Date: Wed, 13 Feb 2013 22:05:01 -0500
Message-Id: <1360811106-2679-12-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
References: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and also define this extra attribute in the Kconfig entry.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/Kconfig       | 8 ++++++++
 drivers/staging/zcache/debug.c       | 2 +-
 drivers/staging/zcache/zcache-main.c | 6 +++---
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
index 7358270..2da6cc4 100644
--- a/drivers/staging/zcache/Kconfig
+++ b/drivers/staging/zcache/Kconfig
@@ -10,6 +10,14 @@ config ZCACHE
 	  memory to store clean page cache pages and swap in RAM,
 	  providing a noticeable reduction in disk I/O.
 
+config ZCACHE_DEBUG
+	bool "Enable debug statistics"
+	depends on DEBUG_FS && ZCACHE
+	default n
+	help
+	  This is used to provide an debugfs directory with counters of
+	  how zcache is doing. You probably want to set this to 'N'.
+
 config RAMSTER
 	bool "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
 	depends on CONFIGFS_FS=y && SYSFS=y && !HIGHMEM && ZCACHE=y
diff --git a/drivers/staging/zcache/debug.c b/drivers/staging/zcache/debug.c
index cf19adc..e951c64 100644
--- a/drivers/staging/zcache/debug.c
+++ b/drivers/staging/zcache/debug.c
@@ -1,7 +1,7 @@
 #include <linux/atomic.h>
 #include "debug.h"
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_ZCACHE_DEBUG
 #include <linux/debugfs.h>
 
 #define ATTR(x)  { .name = #x, .val = &zcache_##x, }
diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 4b9ee7f..7c0fda4 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -306,7 +306,7 @@ static void zcache_free_page(struct page *page)
 		max_pageframes = curr_pageframes;
 	if (curr_pageframes < min_pageframes)
 		min_pageframes = curr_pageframes;
-#ifdef ZCACHE_DEBUG
+#ifdef CONFIG_ZCACHE_DEBUG
 	if (curr_pageframes > 2L || curr_pageframes < -2L) {
 		/* pr_info here */
 	}
@@ -1774,7 +1774,7 @@ static int __init zcache_init(void)
 		old_ops = zcache_cleancache_register_ops();
 		pr_info("%s: cleancache enabled using kernel transcendent "
 			"memory and compression buddies\n", namestr);
-#ifdef ZCACHE_DEBUG
+#ifdef CONFIG_ZCACHE_DEBUG
 		pr_info("%s: cleancache: ignorenonactive = %d\n",
 			namestr, !disable_cleancache_ignore_nonactive);
 #endif
@@ -1789,7 +1789,7 @@ static int __init zcache_init(void)
 			frontswap_tmem_exclusive_gets(true);
 		pr_info("%s: frontswap enabled using kernel transcendent "
 			"memory and compression buddies\n", namestr);
-#ifdef ZCACHE_DEBUG
+#ifdef CONFIG_ZCACHE_DEBUG
 		pr_info("%s: frontswap: excl gets = %d active only = %d\n",
 			namestr, frontswap_has_exclusive_gets,
 			!disable_frontswap_ignore_nonactive);
-- 
1.8.0.2

