Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3LMW1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:32 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41140 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3LMW1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:25 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 049/115] gpu: ion: Modify reserve function for carveouts with no start address
Date: Fri, 13 Dec 2013 14:24:23 -0800
Message-Id: <1386973529-4884-50-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

This patch allows you to specify a heap that requires carveout memory
but that doesn't specify a start address.  Memblock_alloc will be called
to find a location for these heaps.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index e0eb2de..3167c1d 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1343,16 +1343,35 @@ void ion_device_destroy(struct ion_device *dev)
 
 void __init ion_reserve(struct ion_platform_data *data)
 {
-	int i, ret;
+	int i;
 
 	for (i = 0; i < data->nr; i++) {
 		if (data->heaps[i].size == 0)
 			continue;
-		ret = memblock_reserve(data->heaps[i].base,
-				       data->heaps[i].size);
-		if (ret)
-			pr_err("memblock reserve of %x@%lx failed\n",
-			       data->heaps[i].size,
-			       data->heaps[i].base);
+
+		if (data->heaps[i].base == 0) {
+			phys_addr_t paddr;
+			paddr = memblock_alloc_base(data->heaps[i].size,
+						    data->heaps[i].align,
+						    MEMBLOCK_ALLOC_ANYWHERE);
+			if (!paddr) {
+				pr_err("%s: error allocating memblock for "
+				       "heap %d\n",
+					__func__, i);
+				continue;
+			}
+			data->heaps[i].base = paddr;
+		} else {
+			int ret = memblock_reserve(data->heaps[i].base,
+					       data->heaps[i].size);
+			if (ret)
+				pr_err("memblock reserve of %x@%lx failed\n",
+				       data->heaps[i].size,
+				       data->heaps[i].base);
+		}
+		pr_info("%s: %s reserved base %lx size %d\n", __func__,
+			data->heaps[i].name,
+			data->heaps[i].base,
+			data->heaps[i].size);
 	}
 }
-- 
1.8.3.2

