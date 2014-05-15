Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaEOHVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:21:48 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:43735 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaEOHVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:21:46 -0400
From: Wang Nan <wangnan0@huawei.com>
To: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Simon Horman <horms@verge.net.au>,
        Mika Westerberg <ext-mika.1.westerberg@nokia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Wang Nan <wangnan0@huawei.com>, Geng Hui <hui.geng@huawei.com>
Subject: [PATCH] crash_dump: arm: crash dump kernel should use strict pfn_valid
Date: Thu, 15 May 2014 15:14:30 +0800
Message-ID: <1400138070-24046-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes crash dump kernel use arch pfn_valid defined in
arch/arm/mm/init.c instead of the one in include/linux/mmzone.h.
The goal of this patch is to remove some limitation when kexec loading
crash kernel while SPARSEMEM is enabled.

Before this patch, if second kernel selects both CRASH_DUMP and
SPARSEMEM, the second kernel will recongnize memorys at the same section
with itself as valid memory, and prevents ioremap (see arm ioremap code,
arm doesn't allow valid memory to be ioremapped again). Which introduces
some limitations on positioning the crash kernel. For example:

  For a platform with SECTION_SIZE_BITS == 28 (256MiB) and
  crashkernel=128M@0x28000000 in kernel cmdline, the second
  kernel is loaded at 0x28000000. Kexec puts elfcorehdr at
  0x2ff00000, and passes 'elfcorehdr=0x2ff00000 mem=130048K' to
  second kernel. When second kernel start, it tries to use
  ioremap to retrive its elfcorehrd. In this case, elfcodehdr is at the
  same section of the second kernel, pfn_valid will recongnize
  the page as valid, so ioremap will refuse to map it.

Even if we put crash kernel at the boundary of two sections (such as
129MB@0x0x28000000 in the above situation), 0x20000000-0x28000000 used
by old kernel is still unable to retrived by crash kernel because they
are at the same section.

This patch makes crash dump kernel use strict (and slow) version of
pfn_valid(), which makes crash kernel recongnize memory correctly.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: Geng Hui <hui.geng@huawei.com>
Cc: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
Cc: Simon Horman <horms@verge.net.au>
---
 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index db3c541..795b1d4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1800,7 +1800,7 @@ config ARCH_SELECT_MEMORY_MODEL
 	def_bool ARCH_SPARSEMEM_ENABLE
 
 config HAVE_ARCH_PFN_VALID
-	def_bool ARCH_HAS_HOLES_MEMORYMODEL || !SPARSEMEM
+	def_bool ARCH_HAS_HOLES_MEMORYMODEL || !SPARSEMEM || CRASH_DUMP
 
 config HIGHMEM
 	bool "High Memory Support"
-- 
1.8.4

