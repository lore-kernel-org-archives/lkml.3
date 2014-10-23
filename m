Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaJWPgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:36:32 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:32806 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaJWPga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:36:30 -0400
From: Minfei Huang <mnfhuang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] mm: Avoid overlap the fixmap area on i386
Date: Thu, 23 Oct 2014 23:36:17 +0800
Message-Id: <6B680A9E-6CE9-4C96-934B-CB01DCB58278@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Minfei Huang <mnfhuang@gmail.com>

It is a problem when configuring high memory off where the vmalloc
reserve area could end up overlapping the early_ioremap fixmap
area on i386.

The ordering of the VMALLOC_RESERVE space is:
FIXADDR_TOP
                       fixed_addresses
FIXADDR_START
                       early_ioremap fixed addresses
FIXADDR_BOOT_START
                       Persistent kmap area
PKMAP_BASE
VMALLOC_END
                       Vmalloc area
VMALLOC_START
high_memory

The available address we can use is lower than FIXADDR_BOOT_START. So
We will set the kmap boundary below the FIXADDR_BOOT_START, if configure
the high memory.

If we configure the high memory, the vmalloc reserve area should end
up to PKMAP_BASE, otherwise should end up to FIXADDR_BOOT_START.

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
---
arch/x86/include/asm/pgtable_32_types.h | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pgtable_32_types.h b/arch/x86/include/asm/pgtable_32_types.h
index ed5903b..2ac5fc8 100644
--- a/arch/x86/include/asm/pgtable_32_types.h
+++ b/arch/x86/include/asm/pgtable_32_types.h
@@ -43,7 +43,7 @@ extern bool __vmalloc_start_set; /* set once high_memory is set */
#ifdef CONFIG_HIGHMEM
# define VMALLOC_END	(PKMAP_BASE - 2 * PAGE_SIZE)
#else
-# define VMALLOC_END	(FIXADDR_START - 2 * PAGE_SIZE)
+# define VMALLOC_END	(FIXADDR_BOOT_START - 2 * PAGE_SIZE)
#endif

#define MODULES_VADDR	VMALLOC_START
-- 
1.8.3.1