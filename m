Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352Ab3CSJ0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:26:18 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33962 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842Ab3CSJ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:26:14 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 3/8] staging: zcache: handle zcache_[eph|pers]_zpages for zero-filled page
Date: Tue, 19 Mar 2013 17:25:45 +0800
Message-Id: <1363685150-18303-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363685150-18303-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1363685150-18303-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031909-5564-0000-0000-00000720E53F
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
index 050a99f..892e97e 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -647,6 +647,8 @@ static int zcache_pampd_get_data_and_free(char *data, size_t *sizep, bool raw,
 	if (pampd == (void *)ZERO_FILLED) {
 		handle_zero_filled_page(data);
 		zero_filled = true;
+		zsize = 0;
+		zpages = 1;
 		if (!raw)
 			*sizep = PAGE_SIZE;
 		goto zero_fill;
@@ -695,8 +697,11 @@ static void zcache_pampd_free(void *pampd, struct tmem_pool *pool,
 
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

