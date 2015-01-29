Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbbA2PMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:12:54 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19032 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbbA2PMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:12:48 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-10-54ca4d5b1408
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/A...)
Subject: [PATCH v10 15/17] kernel: add support for .init_array.* constructors
Date: Thu, 29 Jan 2015 18:11:59 +0300
Message-id: <1422544321-24232-16-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.2
In-reply-to: <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xy7oxvqdCDC7NYrTY9usRm8XvvTNZ
	LeasX8NmceTad3aLv5OOsVtc//aG0eLTyweMFs8fPmS3mPCwjd1iZXczm8X2Z2+ZLFZ2PmC1
	6Nj1lcXi8q45bBb31vxntVh85Dazxbtnk5ktfmx4zOog5PH71yRGj/k7PzJ67Jx1l91jwaZS
	j8V7XjJ5bFrVyeax6dMkdo+ut1eYPE7M+M3i8eTKdCaPj09vsXj0bVnF6PF5k1wAbxSXTUpq
	TmZZapG+XQJXxsq5M9kL1nBVfHryn6WB8QhHFyMnh4SAicTke8dZIWwxiQv31rOB2EICSxkl
	bs5T72LkArL7mCR6+n8wgyTYBPQk/s3aDlYkIqAgsbn3GStIEbNAG6vElVc32bsYOTiEBXwl
	dq0qAKlhEVCV2DvhFxOIzSvgLnHk9mFmkBIJATmJCx/jQcKcQOF/9x4zQexqYpTYeHYe2wRG
	3gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQiLi6w7GpcesDjEKcDAq8fDO2HQyRIg1
	say4MvcQowQHs5II71LLUyFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGGWe3VBiPPdB0vlzRPZO
	iUaPDqemL2/KGMokdh8zmuxfbbel/MTBrkJ1dsMtq05m/A03Vt0clK1+e8dcbvWI9U7b3flu
	lRpe+lURFMYmOMsz7+CEE7Ktuobpx+Z225bYzHohaZUQ27FzU+ax3dnrjzOfdF8d/sb+SvDG
	r0l/n26Xdc4rE/x9UYmlOCPRUIu5qDgRANszICNmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KASan uses constructors for initializing redzones for global
variables. Actually KASan doesn't need priorities for constructors,
so they were removed from GCC 5.0, but GCC 4.9.2 still generates
constructors with priorities.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/asm-generic/vmlinux.lds.h | 1 +
 scripts/module-common.lds         | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bee5d68..ac78910 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -478,6 +478,7 @@
 #define KERNEL_CTORS()	. = ALIGN(8);			   \
 			VMLINUX_SYMBOL(__ctors_start) = .; \
 			*(.ctors)			   \
+			*(SORT(.init_array.*))		   \
 			*(.init_array)			   \
 			VMLINUX_SYMBOL(__ctors_end) = .;
 #else
diff --git a/scripts/module-common.lds b/scripts/module-common.lds
index 0865b3e..01c5849 100644
--- a/scripts/module-common.lds
+++ b/scripts/module-common.lds
@@ -16,4 +16,7 @@ SECTIONS {
 	__kcrctab_unused	: { *(SORT(___kcrctab_unused+*)) }
 	__kcrctab_unused_gpl	: { *(SORT(___kcrctab_unused_gpl+*)) }
 	__kcrctab_gpl_future	: { *(SORT(___kcrctab_gpl_future+*)) }
+
+	. = ALIGN(8);
+	.init_array		: { *(SORT(.init_array.*)) *(.init_array) }
 }
-- 
2.2.2

