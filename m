Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaAJDl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 22:41:26 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35663 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaAJDlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 22:41:07 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jesse Barker <jesse.barker@arm.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH 2/2] ion: Add carveout and chunk heaps to dummy driver
Date: Thu,  9 Jan 2014 19:40:55 -0800
Message-Id: <1389325255-31534-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389325255-31534-1-git-send-email-john.stultz@linaro.org>
References: <1389325255-31534-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to the dummy driver for basic carveout and chunk heaps.

Since we're generating these heaps at module_init, and we want
this driver to be generic enough to be tested on any arch, we
don't have the ability to alloc bootmem, so both of these heaps
are conventionally allocated using alloc_pages(), which limits us
to 4M in size.

Should look into using CMA for heap allocation eventually, but
this provides enough to test the basic functionality of the
heaps.

Cc: Colin Cross <ccross@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Jesse Barker <jesse.barker@arm.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_dummy_driver.c | 67 +++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
index 6749d29..55b2002 100644
--- a/drivers/staging/android/ion/ion_dummy_driver.c
+++ b/drivers/staging/android/ion/ion_dummy_driver.c
@@ -26,6 +26,9 @@
 struct ion_device *idev;
 struct ion_heap **heaps;
 
+void *carveout_ptr;
+void *chunk_ptr;
+
 struct ion_platform_heap dummy_heaps[] = {
 		{
 			.id	= ION_HEAP_TYPE_SYSTEM,
@@ -37,10 +40,24 @@ struct ion_platform_heap dummy_heaps[] = {
 			.type	= ION_HEAP_TYPE_SYSTEM_CONTIG,
 			.name	= "system contig",
 		},
+		{
+			.id	= ION_HEAP_TYPE_CARVEOUT,
+			.type	= ION_HEAP_TYPE_CARVEOUT,
+			.name	= "carveout",
+			.size	= SZ_4M,
+		},
+		{
+			.id	= ION_HEAP_TYPE_CHUNK,
+			.type	= ION_HEAP_TYPE_CHUNK,
+			.name	= "chunk",
+			.size	= SZ_4M,
+			.align	= SZ_16K,
+			.priv	= (void *)(SZ_16K),
+		},
 };
 
 struct ion_platform_data dummy_ion_pdata = {
-	.nr = 2,
+	.nr = 4,
 	.heaps = dummy_heaps,
 };
 
@@ -54,9 +71,36 @@ static int __init ion_dummy_init(void)
 	if (!heaps)
 		return PTR_ERR(heaps);
 
+
+	/* Allocate a dummy carveout heap */
+	carveout_ptr = alloc_pages_exact(
+				dummy_heaps[ION_HEAP_TYPE_CARVEOUT].size,
+				GFP_KERNEL);
+	if (carveout_ptr)
+		dummy_heaps[ION_HEAP_TYPE_CARVEOUT].base =
+						virt_to_phys(carveout_ptr);
+	else
+		pr_err("ion_dummy: Could not allocate carveout\n");
+
+	/* Allocate a dummy chunk heap */
+	chunk_ptr = alloc_pages_exact(
+				dummy_heaps[ION_HEAP_TYPE_CHUNK].size,
+				GFP_KERNEL);
+	if (chunk_ptr)
+		dummy_heaps[ION_HEAP_TYPE_CHUNK].base = virt_to_phys(chunk_ptr);
+	else
+		pr_err("ion_dummy: Could not allocate chunk\n");
+
 	for (i = 0; i < dummy_ion_pdata.nr; i++) {
 		struct ion_platform_heap *heap_data = &dummy_ion_pdata.heaps[i];
 
+		if (heap_data->type == ION_HEAP_TYPE_CARVEOUT &&
+							!heap_data->base)
+			continue;
+
+		if (heap_data->type == ION_HEAP_TYPE_CHUNK && !heap_data->base)
+			continue;
+
 		heaps[i] = ion_heap_create(heap_data);
 		if (IS_ERR_OR_NULL(heaps[i])) {
 			err = PTR_ERR(heaps[i]);
@@ -72,6 +116,16 @@ err:
 	}
 	kfree(heaps);
 
+	if (carveout_ptr) {
+		free_pages_exact(carveout_ptr,
+				dummy_heaps[ION_HEAP_TYPE_CARVEOUT].size);
+		carveout_ptr = NULL;
+	}
+	if (chunk_ptr) {
+		free_pages_exact(chunk_ptr,
+				dummy_heaps[ION_HEAP_TYPE_CHUNK].size);
+		chunk_ptr = NULL;
+	}
 	return err;
 }
 
@@ -85,6 +139,17 @@ static void __exit ion_dummy_exit(void)
 		ion_heap_destroy(heaps[i]);
 	kfree(heaps);
 
+	if (carveout_ptr) {
+		free_pages_exact(carveout_ptr,
+				dummy_heaps[ION_HEAP_TYPE_CARVEOUT].size);
+		carveout_ptr = NULL;
+	}
+	if (chunk_ptr) {
+		free_pages_exact(chunk_ptr,
+				dummy_heaps[ION_HEAP_TYPE_CHUNK].size);
+		chunk_ptr = NULL;
+	}
+
 	return;
 }
 
-- 
1.8.3.2

