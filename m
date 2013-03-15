Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3COCfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 22:35:23 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:39979 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3COCfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 22:35:20 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 4/5] introduce zero-filled page stat count
Date: Fri, 15 Mar 2013 10:34:19 +0800
Message-Id: <1363314860-22731-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363314860-22731-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1363314860-22731-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031502-6102-0000-0000-0000032863A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce zero-filled page statistics to monitor the number of
zero-filled pages.

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index ef8c960..bc7ccbb 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -197,6 +197,7 @@ static ssize_t zcache_eph_nonactive_puts_ignored;
 static ssize_t zcache_pers_nonactive_puts_ignored;
 static ssize_t zcache_writtenback_pages;
 static ssize_t zcache_outstanding_writeback_pages;
+static ssize_t zcache_zero_filled_pages;
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
@@ -258,6 +259,7 @@ static int zcache_debugfs_init(void)
 	zdfs("outstanding_writeback_pages", S_IRUGO, root,
 				&zcache_outstanding_writeback_pages);
 	zdfs("writtenback_pages", S_IRUGO, root, &zcache_writtenback_pages);
+	zdfs("zero_filled_pages", S_IRUGO, root, &zcache_zero_filled_pages);
 	return 0;
 }
 #undef	zdebugfs
@@ -327,6 +329,7 @@ void zcache_dump(void)
 	pr_info("zcache: outstanding_writeback_pages=%zd\n",
 				zcache_outstanding_writeback_pages);
 	pr_info("zcache: writtenback_pages=%zd\n", zcache_writtenback_pages);
+	pr_info("zcache: zero_filled_pages=%zd\n", zcache_zero_filled_pages);
 }
 #endif
 
@@ -563,6 +566,7 @@ static void *zcache_pampd_eph_create(char *data, size_t size, bool raw,
 		kunmap_atomic(user_mem);
 		clen = 0;
 		zero_filled = true;
+		zcache_zero_filled_pages++;
 		goto got_pampd;
 	}
 	kunmap_atomic(user_mem);
@@ -646,6 +650,7 @@ static void *zcache_pampd_pers_create(char *data, size_t size, bool raw,
 		kunmap_atomic(user_mem);
 		clen = 0;
 		zero_filled = true;
+		zcache_zero_filled_pages++;
 		goto got_pampd;
 	}
 	kunmap_atomic(user_mem);
@@ -867,6 +872,7 @@ static int zcache_pampd_get_data_and_free(char *data, size_t *sizep, bool raw,
 		zpages = 1;
 		if (!raw)
 			*sizep = PAGE_SIZE;
+		zcache_zero_filled_pages--;
 		goto zero_fill;
 	}
 
@@ -923,6 +929,7 @@ static void zcache_pampd_free(void *pampd, struct tmem_pool *pool,
 		zero_filled = true;
 		zsize = 0;
 		zpages = 1;
+		zcache_zero_filled_pages--;
 	}
 
 	if (pampd_is_remote(pampd) && !zero_filled) {
-- 
1.7.7.6

