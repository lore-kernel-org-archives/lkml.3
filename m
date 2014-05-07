Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbaEGNWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:22:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45596 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933272AbaEGNO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sergey Dyasly <dserrg@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        hujianyang <hujianyang@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 50/70] ARM: 7840/1: LPAE: don't reject mapping /dev/mem above 4GB
Date: Wed,  7 May 2014 14:12:53 +0100
Message-Id: <1399468393-10140-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mm/mmap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index 304661d..5e85ed3 100644
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -202,13 +202,11 @@ int valid_phys_addr_range(phys_addr_t addr, size_t size)
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
-- 
1.9.1

