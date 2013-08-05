Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3HEIbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:31:22 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:42598 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab3HEIbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:31:19 -0400
Message-ID: <51FF62CB.3090906@huawei.com>
Date: Mon, 5 Aug 2013 16:31:07 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] cma: adjust goto branch in function cma_create_area()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the function structure, one for the success path, 
the other for the failure path.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 drivers/base/dma-contiguous.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 1bcfaed..aa72f93 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -167,26 +167,28 @@ static __init struct cma *cma_create_area(unsigned long base_pfn,
 
 	cma = kmalloc(sizeof *cma, GFP_KERNEL);
 	if (!cma)
-		return ERR_PTR(-ENOMEM);
+		goto err;
 
 	cma->base_pfn = base_pfn;
 	cma->count = count;
 	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
 
 	if (!cma->bitmap)
-		goto no_mem;
+		goto err;
 
 	ret = cma_activate_area(base_pfn, count);
 	if (ret)
-		goto error;
+		goto err;
 
 	pr_debug("%s: returned %p\n", __func__, (void *)cma);
 	return cma;
 
-error:
-	kfree(cma->bitmap);
-no_mem:
-	kfree(cma);
+err:
+	if (cma) {
+		if (cma->bitmap)
+			kfree(cma->bitmap);
+		kfree(cma);
+	}
 	return ERR_PTR(ret);
 }
 
-- 
1.7.1

