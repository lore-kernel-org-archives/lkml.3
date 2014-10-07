Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaJGKxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:53:18 -0400
Received: from ozlabs.org ([103.22.144.67]:38176 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbaJGKtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:49:32 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v3 04/16] powerpc/msi: Improve IRQ bitmap allocator
Date: Tue,  7 Oct 2014 21:48:10 +1100
Message-Id: <1412678902-18672-5-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412678902-18672-1-git-send-email-mikey@neuling.org>
References: <1412678902-18672-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Currently msi_bitmap_alloc_hwirqs() will round up any IRQ allocation requests
to the nearest power of 2. eg. ask for 5 IRQs and you'll get 8. This wastes a
lot of IRQs which can be a scarce resource.

For cxl we may require multiple IRQs for every context that is attached to the
accelerator. There may be 1000s of contexts attached, hence we can easily run
out of IRQs, especially if we are needlessly wasting them.

This changes the msi_bitmap_alloc_hwirqs() to allocate only the required number
of IRQs, hence avoiding this wastage. It keeps the natural alignment
requirement though.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 arch/powerpc/sysdev/msi_bitmap.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/sysdev/msi_bitmap.c b/arch/powerpc/sysdev/msi_bitmap.c
index 2ff6302..56c8b13 100644
--- a/arch/powerpc/sysdev/msi_bitmap.c
+++ b/arch/powerpc/sysdev/msi_bitmap.c
@@ -20,32 +20,37 @@ int msi_bitmap_alloc_hwirqs(struct msi_bitmap *bmp, int num)
 	int offset, order = get_count_order(num);
 
 	spin_lock_irqsave(&bmp->lock, flags);
-	/*
-	 * This is fast, but stricter than we need. We might want to add
-	 * a fallback routine which does a linear search with no alignment.
-	 */
-	offset = bitmap_find_free_region(bmp->bitmap, bmp->irq_count, order);
+
+	offset = bitmap_find_next_zero_area(bmp->bitmap, bmp->irq_count, 0,
+					    num, (1 << order) - 1);
+	if (offset > bmp->irq_count)
+		goto err;
+
+	bitmap_set(bmp->bitmap, offset, num);
 	spin_unlock_irqrestore(&bmp->lock, flags);
 
-	pr_debug("msi_bitmap: allocated 0x%x (2^%d) at offset 0x%x\n",
-		 num, order, offset);
+	pr_debug("msi_bitmap: allocated 0x%x at offset 0x%x\n", num, offset);
 
 	return offset;
+err:
+	spin_unlock_irqrestore(&bmp->lock, flags);
+	return -ENOMEM;
 }
+EXPORT_SYMBOL(msi_bitmap_alloc_hwirqs);
 
 void msi_bitmap_free_hwirqs(struct msi_bitmap *bmp, unsigned int offset,
 			    unsigned int num)
 {
 	unsigned long flags;
-	int order = get_count_order(num);
 
-	pr_debug("msi_bitmap: freeing 0x%x (2^%d) at offset 0x%x\n",
-		 num, order, offset);
+	pr_debug("msi_bitmap: freeing 0x%x at offset 0x%x\n",
+		 num, offset);
 
 	spin_lock_irqsave(&bmp->lock, flags);
-	bitmap_release_region(bmp->bitmap, offset, order);
+	bitmap_clear(bmp->bitmap, offset, num);
 	spin_unlock_irqrestore(&bmp->lock, flags);
 }
+EXPORT_SYMBOL(msi_bitmap_free_hwirqs);
 
 void msi_bitmap_reserve_hwirq(struct msi_bitmap *bmp, unsigned int hwirq)
 {
@@ -180,6 +185,12 @@ void __init test_basics(void)
 	msi_bitmap_free_hwirqs(&bmp, size / 2, 1);
 	check(msi_bitmap_alloc_hwirqs(&bmp, 1) == size / 2);
 
+	/* Check we get a naturally aligned offset */
+	check(msi_bitmap_alloc_hwirqs(&bmp, 2) % 2 == 0);
+	check(msi_bitmap_alloc_hwirqs(&bmp, 4) % 4 == 0);
+	check(msi_bitmap_alloc_hwirqs(&bmp, 8) % 8 == 0);
+	check(msi_bitmap_alloc_hwirqs(&bmp, 9) % 16 == 0);
+
 	msi_bitmap_free(&bmp);
 
 	/* Clients may check bitmap == NULL for "not-allocated" */
-- 
1.9.1

