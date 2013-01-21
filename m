Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3AUFVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 00:21:42 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44169 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3AUFVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 00:21:38 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-a2-50fcd05e7829
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, jmarchan@redhat.com,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v3 4/4] zram: Fix deadlock bug in partial write
Date: Mon, 21 Jan 2013 14:21:31 +0900
Message-Id: <1358745691-4556-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358745691-4556-1-git-send-email-minchan@kernel.org>
References: <1358745691-4556-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now zram allocates new page with GFP_KERNEL in zram I/O path
if IO is partial. Unfortunately, It may cuase deadlock with
reclaim path so this patch solves the problem.

Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
We could use GFP_IO instead of GFP_ATOMIC in zram_bvec_read with
some modification related to buffer allocation in case of partial IO.
But it needs more churn and prevent merge this patch into stable
if we should send this to stable so I'd like to keep it as simple
as possbile. GFP_IO usage could be separate patch after we merge it.
Thanks.

 drivers/staging/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 1f6938a..e00397f 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -192,7 +192,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 	user_mem = kmap_atomic(page);
 	if (is_partial_io(bvec))
 		/* Use  a temporary buffer to decompress the page */
-		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		uncmem = kmalloc(PAGE_SIZE, GFP_ATOMIC);
 	else
 		uncmem = user_mem;
 
@@ -240,7 +240,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		 * This is a partial IO. We need to read the full page
 		 * before to write the changes.
 		 */
-		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
 		if (!uncmem) {
 			pr_info("Error allocating temp memory!\n");
 			ret = -ENOMEM;
-- 
1.7.9.5

