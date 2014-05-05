Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbaEEMxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:53:37 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41000 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932286AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sergey Dyasly <dserrg@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 14/50] ARM: 7840/1: LPAE: don't reject mapping /dev/mem above 4GB
Date: Mon,  5 May 2014 14:42:56 +0200
Message-Id: <4aeced5ed3e351ffad601615a11305b6e2eb16e1.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergey Dyasly <dserrg@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3159f372354e8e1f5dee714663d705dd2c7e0759 upstream.

With LPAE enabled, physical address space is larger than 4GB. Allow mapping any
part of it via /dev/mem by using PHYS_MASK to determine valid range.

PHYS_MASK covers 40 bits with LPAE enabled and 32 bits otherwise.

Reported-by: Vassili Karpov <av1474@comtv.ru>
Signed-off-by: Sergey Dyasly <dserrg@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mm/mmap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index 304661d21369..5e85ed371364 100644
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
1.9.2

