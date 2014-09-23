Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaIWCgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:36:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:37848 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaIWCgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:36:51 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Douglas <adouglas@cadence.com>,
        Max Filippov <jcmvbkbc@gmail.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 15/45] xtensa: fix address checks in dma_{alloc,free}_coherent
Date: Tue, 23 Sep 2014 10:31:17 +0800
Message-Id: <1411439507-30391-15-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Douglas <adouglas@cadence.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 1ca49463c44c970b1ab1d71b0f268bfdf8427a7e upstream.

Virtual address is translated to the XCHAL_KSEG_CACHED region in the
dma_free_coherent, but is checked to be in the 0...XCHAL_KSEG_SIZE
range.

Change check for end of the range from 'addr >= X' to 'addr > X - 1' to
handle the case of X == 0.

Replace 'if (C) BUG();' construct with 'BUG_ON(C);'.

Signed-off-by: Alan Douglas <adouglas@cadence.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/xtensa/kernel/pci-dma.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/kernel/pci-dma.c b/arch/xtensa/kernel/pci-dma.c
index 2783fda..c055c91 100644
--- a/arch/xtensa/kernel/pci-dma.c
+++ b/arch/xtensa/kernel/pci-dma.c
@@ -48,9 +48,8 @@ dma_alloc_coherent(struct device *dev,size_t size,dma_addr_t *handle,gfp_t flag)
 
 	/* We currently don't support coherent memory outside KSEG */
 
-	if (ret < XCHAL_KSEG_CACHED_VADDR
-	    || ret >= XCHAL_KSEG_CACHED_VADDR + XCHAL_KSEG_SIZE)
-		BUG();
+	BUG_ON(ret < XCHAL_KSEG_CACHED_VADDR ||
+	       ret > XCHAL_KSEG_CACHED_VADDR + XCHAL_KSEG_SIZE - 1);
 
 
 	if (ret != 0) {
@@ -66,10 +65,11 @@ dma_alloc_coherent(struct device *dev,size_t size,dma_addr_t *handle,gfp_t flag)
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
1.7.9.5

