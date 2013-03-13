Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab3CMHGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 03:06:34 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:52538 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3CMHGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 03:06:32 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH] zram: fix zram_bvec_read duplicate dump failure message and stat accumulation
Date: Wed, 13 Mar 2013 15:06:16 +0800
Message-Id: <1363158376-20954-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031307-5816-0000-0000-0000070F4967
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When zram decompress fails, the code unnecessarily dumps failure messages and
does stat accumulation in function zram_decompress_page(), this work is already 
done in function zram_decompress_page, the patch skips the redundant work.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zram/zram_drv.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 5918fd7..e34e3fe 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -207,11 +207,8 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 
 	ret = zram_decompress_page(zram, uncmem, index);
 	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret != LZO_E_OK)) {
-		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
-		zram_stat64_inc(zram, &zram->stats.failed_reads);
+	if (unlikely(ret != LZO_E_OK))
 		goto out_cleanup;
-	}
 
 	if (is_partial_io(bvec))
 		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
-- 
1.7.11.7

