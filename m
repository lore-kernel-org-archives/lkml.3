Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab3BAUyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:54:12 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:37402 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622Ab3BAUwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:52:40 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        rcj@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 11/16] zcache/debug: Coalesce all debug under CONFIG_ZCACHE_DEBUG
Date: Fri,  1 Feb 2013 15:52:14 -0500
Message-Id: <1359751939-23584-12-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1359751939-23584-1-git-send-email-konrad.wilk@oracle.com>
References: <1359751939-23584-1-git-send-email-konrad.wilk@oracle.com>
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
index 88e3c59..f2a13ac 100644
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
 	tristate "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
 	depends on CONFIGFS_FS=y && SYSFS=y && !HIGHMEM && ZCACHE
diff --git a/drivers/staging/zcache/debug.c b/drivers/staging/zcache/debug.c
index 34c4023..1485eef 100644
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
index 8830359..99fd59f 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -308,7 +308,7 @@ static void zcache_free_page(struct page *page)
 		max_pageframes = curr_pageframes;
 	if (curr_pageframes < min_pageframes)
 		min_pageframes = curr_pageframes;
-#ifdef ZCACHE_DEBUG
+#ifdef CONFIG_ZCACHE_DEBUG
 	if (curr_pageframes > 2L || curr_pageframes < -2L) {
 		/* pr_info here */
 	}
@@ -1602,7 +1602,7 @@ static int zcache_init(void)
 		old_ops = zcache_cleancache_register_ops();
 		pr_info("%s: cleancache enabled using kernel transcendent "
 			"memory and compression buddies\n", namestr);
-#ifdef ZCACHE_DEBUG
+#ifdef CONFIG_ZCACHE_DEBUG
 		pr_info("%s: cleancache: ignorenonactive = %d\n",
 			namestr, !disable_cleancache_ignore_nonactive);
 #endif
@@ -1617,7 +1617,7 @@ static int zcache_init(void)
 			frontswap_tmem_exclusive_gets(true);
 		pr_info("%s: frontswap enabled using kernel transcendent "
 			"memory and compression buddies\n", namestr);
-#ifdef ZCACHE_DEBUG
+#ifdef CONFIG_ZCACHE_DEBUG
 		pr_info("%s: frontswap: excl gets = %d active only = %d\n",
 			namestr, frontswap_has_exclusive_gets,
 			!disable_frontswap_ignore_nonactive);
-- 
1.7.11.7

