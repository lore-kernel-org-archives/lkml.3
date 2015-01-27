Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbbA0GE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 01:04:29 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:7342 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753071AbbA0GEZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 01:04:25 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>,
        "'tranmanphong@gmail.com'" <tranmanphong@gmail.com>,
        "'fabio.estevam@freescale.com'" <fabio.estevam@freescale.com>,
        "'prime.zeng@huawei.com'" <prime.zeng@huawei.com>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: "Gao, Neil" <Neil.Gao@sonymobile.com>
Date: Tue, 27 Jan 2015 14:04:21 +0800
Subject: [RFC] ion:change ion_cma_allocate return error value
Thread-Topic: [RFC] ion:change ion_cma_allocate return error value
Thread-Index: AdA59xeNaPys83UbSBCxEwQ2fVLbaQ==
Message-ID: <35FD53F367049845BC99AC72306C23D1044A02027DF9@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch change the error return value from -1 to -ENOMEM,
so that userspace can get the correct errno, otherwise,
-1 will be -EPERM, userspace will print permission deny for allocation
failure.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 drivers/staging/android/ion/ion_cma_heap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/ion/ion_cma_heap.c b/drivers/staging/android/ion/ion_cma_heap.c
index f4211f1..55bcaec2 100644
--- a/drivers/staging/android/ion/ion_cma_heap.c
+++ b/drivers/staging/android/ion/ion_cma_heap.c
@@ -24,8 +24,6 @@
 #include "ion.h"
 #include "ion_priv.h"
 
-#define ION_CMA_ALLOCATE_FAILED -1
-
 struct ion_cma_heap {
 	struct ion_heap heap;
 	struct device *dev;
@@ -59,7 +57,7 @@ static int ion_cma_allocate(struct ion_heap *heap, struct ion_buffer *buffer,
 
 	info = kzalloc(sizeof(struct ion_cma_buffer_info), GFP_KERNEL);
 	if (!info)
-		return ION_CMA_ALLOCATE_FAILED;
+		return -ENOMEM;
 
 	info->cpu_addr = dma_alloc_coherent(dev, len, &(info->handle),
 						GFP_HIGHUSER | __GFP_ZERO);
@@ -87,7 +85,7 @@ free_mem:
 	dma_free_coherent(dev, len, info->cpu_addr, info->handle);
 err:
 	kfree(info);
-	return ION_CMA_ALLOCATE_FAILED;
+	return -ENOMEM;
 }
 
 static void ion_cma_free(struct ion_buffer *buffer)
-- 
2.2.2
