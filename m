Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3CMHF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 03:05:56 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39590 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab3CMHFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 03:05:46 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 3/4] zcache: introduce zero-filled pages stat count
Date: Wed, 13 Mar 2013 15:05:20 +0800
Message-Id: <1363158321-20790-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363158321-20790-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1363158321-20790-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031307-1396-0000-0000-000002AA32D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce zero-filled page statistics to monitor the number of
zero-filled pages.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index ed5ef26..dd52975 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -191,6 +191,7 @@ static ssize_t zcache_eph_nonactive_puts_ignored;
 static ssize_t zcache_pers_nonactive_puts_ignored;
 static ssize_t zcache_writtenback_pages;
 static ssize_t zcache_outstanding_writeback_pages;
+static ssize_t zcache_pages_zero;
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
@@ -252,6 +253,7 @@ static int zcache_debugfs_init(void)
 	zdfs("outstanding_writeback_pages", S_IRUGO, root,
 				&zcache_outstanding_writeback_pages);
 	zdfs("writtenback_pages", S_IRUGO, root, &zcache_writtenback_pages);
+	zdfs("pages_zero", S_IRUGO, root, &zcache_pages_zero);
 	return 0;
 }
 #undef	zdebugfs
@@ -321,6 +323,7 @@ void zcache_dump(void)
 	pr_info("zcache: outstanding_writeback_pages=%zd\n",
 				zcache_outstanding_writeback_pages);
 	pr_info("zcache: writtenback_pages=%zd\n", zcache_writtenback_pages);
+	pr_info("zcache: pages_zero=%zd\n", zcache_pages_zero);
 }
 #endif
 
@@ -557,6 +560,7 @@ static void *zcache_pampd_eph_create(char *data, size_t size, bool raw,
 		kunmap_atomic(user_mem);
 		clen = 0;
 		zero_filled = true;
+		zcache_pages_zero++;
 		goto got_pampd;
 	}
 	kunmap_atomic(user_mem);
@@ -639,6 +643,7 @@ static void *zcache_pampd_pers_create(char *data, size_t size, bool raw,
 		kunmap_atomic(user_mem);
 		clen = 0;
 		zero_filled = 1;
+		zcache_pages_zero++;
 		goto got_pampd;
 	}
 	kunmap_atomic(user_mem);
@@ -859,6 +864,7 @@ static int zcache_pampd_get_data_and_free(char *data, size_t *sizep, bool raw,
 		zpages = 1;
 		if (!raw)
 			*sizep = PAGE_SIZE;
+		zcache_pages_zero--;
 		goto zero_fill;
 	}
 
@@ -915,6 +921,7 @@ static void zcache_pampd_free(void *pampd, struct tmem_pool *pool,
 		zero_filled = true;
 		zsize = 0;
 		zpages = 1;
+		zcache_pages_zero--;
 	}
 
 	if (pampd_is_remote(pampd) && !zero_filled) {
-- 
1.7.7.6

