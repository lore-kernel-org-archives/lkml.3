Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab3CNKJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:09:19 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33426 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab3CNKJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:09:09 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 3/4] introduce zero-filled page stat count
Date: Thu, 14 Mar 2013 18:08:16 +0800
Message-Id: <1363255697-19674-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363255697-19674-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1363255697-19674-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031410-0260-0000-0000-000002AABE0B
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
index db200b4..2091a4d 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -196,6 +196,7 @@ static ssize_t zcache_eph_nonactive_puts_ignored;
 static ssize_t zcache_pers_nonactive_puts_ignored;
 static ssize_t zcache_writtenback_pages;
 static ssize_t zcache_outstanding_writeback_pages;
+static ssize_t zcache_pages_zero;
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
@@ -257,6 +258,7 @@ static int zcache_debugfs_init(void)
 	zdfs("outstanding_writeback_pages", S_IRUGO, root,
 				&zcache_outstanding_writeback_pages);
 	zdfs("writtenback_pages", S_IRUGO, root, &zcache_writtenback_pages);
+	zdfs("pages_zero", S_IRUGO, root, &zcache_pages_zero);
 	return 0;
 }
 #undef	zdebugfs
@@ -326,6 +328,7 @@ void zcache_dump(void)
 	pr_info("zcache: outstanding_writeback_pages=%zd\n",
 				zcache_outstanding_writeback_pages);
 	pr_info("zcache: writtenback_pages=%zd\n", zcache_writtenback_pages);
+	pr_info("zcache: pages_zero=%zd\n", zcache_pages_zero);
 }
 #endif
 
@@ -562,6 +565,7 @@ static void *zcache_pampd_eph_create(char *data, size_t size, bool raw,
 		kunmap_atomic(user_mem);
 		clen = 0;
 		zero_filled = true;
+		zcache_pages_zero++;
 		goto got_pampd;
 	}
 	kunmap_atomic(user_mem);
@@ -645,6 +649,7 @@ static void *zcache_pampd_pers_create(char *data, size_t size, bool raw,
 		kunmap_atomic(user_mem);
 		clen = 0;
 		zero_filled = true;
+		zcache_pages_zero++;
 		goto got_pampd;
 	}
 	kunmap_atomic(user_mem);
@@ -866,6 +871,7 @@ static int zcache_pampd_get_data_and_free(char *data, size_t *sizep, bool raw,
 		zpages = 0;
 		if (!raw)
 			*sizep = PAGE_SIZE;
+		zcache_pages_zero--;
 		goto zero_fill;
 	}
 
@@ -922,6 +928,7 @@ static void zcache_pampd_free(void *pampd, struct tmem_pool *pool,
 		zero_filled = true;
 		zsize = 0;
 		zpages = 0;
+		zcache_pages_zero--;
 	}
 
 	if (pampd_is_remote(pampd) && !zero_filled) {
-- 
1.7.7.6

