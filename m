Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934366AbaEKTuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:50:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084AbaEKTW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:22:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vassili Karpov <av1474@comtv.ru>, Sergey Dyasly <dserrg@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        hujianyang <hujianyang@huawei.com>
Subject: [PATCH 3.10 07/48] ARM: 7840/1: LPAE: dont reject mapping /dev/mem above 4GB
Date: Sun, 11 May 2014 21:19:41 +0200
Message-Id: <20140511191949.129664388@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191948.079900414@linuxfoundation.org>
References: <20140511191948.079900414@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Dyasly <dserrg@gmail.com>

commit 3159f372354e8e1f5dee714663d705dd2c7e0759 upstream.

With LPAE enabled, physical address space is larger than 4GB. Allow mapping any
part of it via /dev/mem by using PHYS_MASK to determine valid range.

PHYS_MASK covers 40 bits with LPAE enabled and 32 bits otherwise.

Reported-by: Vassili Karpov <av1474@comtv.ru>
Signed-off-by: Sergey Dyasly <dserrg@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: hujianyang <hujianyang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/mmap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -204,13 +204,11 @@ int valid_phys_addr_range(phys_addr_t ad
 }
 
 /*
- * We don't use supersection mappings for mmap() on /dev/mem, which
- * means that we can't map the memory area above the 4G barrier into
- * userspace.
+ * Do not allow /dev/mem mappings beyond the supported physical range.
  */
 int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
 {
-	return !(pfn + (size >> PAGE_SHIFT) > 0x00100000);
+	return (pfn + (size >> PAGE_SHIFT)) <= (1 + (PHYS_MASK >> PAGE_SHIFT));
 }
 
 #ifdef CONFIG_STRICT_DEVMEM


