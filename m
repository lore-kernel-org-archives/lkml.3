Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015Ab3DBCqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:46:45 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:42086 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760000Ab3DBCqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:46:39 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v5 3/8] staging: zcache: handle zcache_[eph|pers]_zpages for zero-filled page
Date: Tue,  2 Apr 2013 10:46:15 +0800
Message-Id: <1364870780-16296-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1364870780-16296-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1364870780-16296-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040202-5490-0000-0000-000003359866
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increment/decrement zcache_[eph|pers]_zpages for zero-filled pages,
the main point of the counters for zpages and pageframes is to be 
able to calculate density == zpages/pageframes. A zero-filled page 
becomes a zpage that "compresses" to zero bytes and, as a result, 
requires zero pageframes for storage. So the zpages counter should 
be increased but the pageframes counter should not.

[Dan Magenheimer <dan.magenheimer@oracle.com>: patch description]
Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 961fbf1..14dcf8a 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -648,6 +648,8 @@ static int zcache_pampd_get_data_and_free(char *data, size_t *sizep, bool raw,
 	if (pampd == (void *)ZERO_FILLED) {
 		handle_zero_filled_page(data);
 		zero_filled = true;
+		zsize = 0;
+		zpages = 1;
 		if (!raw)
 			*sizep = PAGE_SIZE;
 		goto zero_fill;
@@ -696,8 +698,11 @@ static void zcache_pampd_free(void *pampd, struct tmem_pool *pool,
 
 	BUG_ON(preemptible());
 
-	if (pampd == (void *)ZERO_FILLED)
+	if (pampd == (void *)ZERO_FILLED) {
 		zero_filled = true;
+		zsize = 0;
+		zpages = 1;
+	}
 
 	if (pampd_is_remote(pampd) && !zero_filled) {
 		BUG_ON(!ramster_enabled);
-- 
1.7.7.6

