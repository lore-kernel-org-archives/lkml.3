Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbaJCV5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:57:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbaJCVzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:55:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Douglas <adouglas@cadence.com>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 3.14 068/238] xtensa: fix address checks in dma_{alloc,free}_coherent
Date: Fri,  3 Oct 2014 14:29:43 -0700
Message-Id: <20141003212915.848741571@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/kernel/pci-dma.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/xtensa/kernel/pci-dma.c
+++ b/arch/xtensa/kernel/pci-dma.c
@@ -49,9 +49,8 @@ dma_alloc_coherent(struct device *dev,si
 
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


