Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaI3Vi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:38:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32886 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbaI3Viw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Douglas <adouglas@cadence.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 040/103] xtensa: fix address checks in dma_{alloc,free}_coherent
Date: Tue, 30 Sep 2014 14:30:45 -0700
Message-Id: <1412112708-27356-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Douglas <adouglas@cadence.com>

commit 1ca49463c44c970b1ab1d71b0f268bfdf8427a7e upstream.

Virtual address is translated to the XCHAL_KSEG_CACHED region in the
dma_free_coherent, but is checked to be in the 0...XCHAL_KSEG_SIZE
range.

Change check for end of the range from 'addr >= X' to 'addr > X - 1' to
handle the case of X == 0.

Replace 'if (C) BUG();' construct with 'BUG_ON(C);'.

Signed-off-by: Alan Douglas <adouglas@cadence.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/xtensa/kernel/pci-dma.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/kernel/pci-dma.c b/arch/xtensa/kernel/pci-dma.c
index 2d9cc6d..e8b76b8 100644
--- a/arch/xtensa/kernel/pci-dma.c
+++ b/arch/xtensa/kernel/pci-dma.c
@@ -49,9 +49,8 @@ dma_alloc_coherent(struct device *dev,size_t size,dma_addr_t *handle,gfp_t flag)
 
 	/* We currently don't support coherent memory outside KSEG */
 
-	if (ret < XCHAL_KSEG_CACHED_VADDR
-	    || ret >= XCHAL_KSEG_CACHED_VADDR + XCHAL_KSEG_SIZE)
-		BUG();
+	BUG_ON(ret < XCHAL_KSEG_CACHED_VADDR ||
+	       ret > XCHAL_KSEG_CACHED_VADDR + XCHAL_KSEG_SIZE - 1);
 
 
 	if (ret != 0) {
@@ -68,10 +67,11 @@ EXPORT_SYMBOL(dma_alloc_coherent);
 void dma_free_coherent(struct device *hwdev, size_t size,
 			 void *vaddr, dma_addr_t dma_handle)
 {
-	long addr=(long)vaddr+XCHAL_KSEG_CACHED_VADDR-XCHAL_KSEG_BYPASS_VADDR;
+	unsigned long addr = (unsigned long)vaddr +
+		XCHAL_KSEG_CACHED_VADDR - XCHAL_KSEG_BYPASS_VADDR;
 
-	if (addr < 0 || addr >= XCHAL_KSEG_SIZE)
-		BUG();
+	BUG_ON(addr < XCHAL_KSEG_CACHED_VADDR ||
+	       addr > XCHAL_KSEG_CACHED_VADDR + XCHAL_KSEG_SIZE - 1);
 
 	free_pages(addr, get_order(size));
 }
-- 
1.9.1

