Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab3CSJ0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:26:06 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37770 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab3CSJ0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:26:02 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 1/8] staging: zcache: introduce zero-filled pages handler
Date: Tue, 19 Mar 2013 17:25:43 +0800
Message-Id: <1363685150-18303-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363685150-18303-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1363685150-18303-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031909-5140-0000-0000-000002E9638E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce zero-filled pages handler to capture and handle zero pages.

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 328898e..d73dd4b 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -460,6 +460,32 @@ static void zcache_obj_free(struct tmem_obj *obj, struct tmem_pool *pool)
 	kmem_cache_free(zcache_obj_cache, obj);
 }
 
+static bool page_is_zero_filled(void *ptr)
+{
+	unsigned int pos;
+	unsigned long *page;
+
+	page = (unsigned long *)ptr;
+
+	for (pos = 0; pos < PAGE_SIZE / sizeof(*page); pos++) {
+		if (page[pos])
+			return false;
+	}
+
+	return true;
+}
+
+static void handle_zero_filled_page(void *page)
+{
+	void *user_mem;
+
+	user_mem = kmap_atomic(page);
+	memset(user_mem, 0, PAGE_SIZE);
+	kunmap_atomic(user_mem);
+
+	flush_dcache_page(page);
+}
+
 static struct tmem_hostops zcache_hostops = {
 	.obj_alloc = zcache_obj_alloc,
 	.obj_free = zcache_obj_free,
-- 
1.7.7.6

