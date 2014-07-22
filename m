Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaGVPgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:36:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42476 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaGVPgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:36:38 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-0f-53ce85047ccf
Subject: [PATCH 2/2] ARM: LPAE: reduce damage caused by idmap to virtual memory
 layout
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>
Date: Tue, 22 Jul 2014 19:36:35 +0400
Message-id: <20140722153635.25088.14197.stgit@buzz>
In-reply-to: <20140722153623.25088.37742.stgit@buzz>
References: <20140722153623.25088.37742.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xK7osreeCDV5+FLSYv/M4q8WPnb2s
	FpseX2O1uLxrDpvF7cu8Fn2f7rNYvPx4gsWB3WPNvDWMHi3NPWwem5fUe/RtWcXocfzGdiaP
	z5vkAtiiuGxSUnMyy1KL9O0SuDJ6Z55iLjjIXbHseCNzA+NGzi5GTg4JAROJP8c2s0HYYhIX
	7q0Hs4UEljJKXPqk28XIBWQ3Mkl8nPyNvYuRg0NYIELiygJzkBo2ATOJbftuM4LYIgL+Euu3
	nGcGqWcW6GKUuPjlJjtIgkVAVeLXjg1gRbwCxhIPjy5mArE5gRZ3/LjPBLHMWOLQpi9gi0UF
	5CRWXm5hhagXlPgx+R4LyF5mAXWJKVNyQcLMAvISm9e8ZZ7AKDALSdUshKpZSKoWMDKvYhRN
	LU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJ8y87GBcfszrEKMDBqMTDy/DwVLAQa2JZcWXuIUYJ
	DmYlEd6U+nPBQrwpiZVVqUX58UWlOanFhxiZODilGhjnfTRozNcLmr3u42rDV4vcTn1RP17y
	IyCquzTL5Fd827crPm0CXGm+crsrmo7MtD7zfL67Pdfuh+KuWce2zDJyYV/hXS65dG/Kbotj
	9mFdy6e6XjCKNmya0bStQf3IyfRUp9muv6Snb7VymvZB1eLx2p7oGQZrXl3SNlrT8svzG1ud
	w/zItD1KLMUZiYZazEXFiQCrxai2UQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idmap layout combines both phisical and virtual addresses.
Everything works fine if ram physically lays below PAGE_OFFSET.
Otherwise idmap starts punching huge holes in virtual memory layout.
It maps ram by 2MiB sections, but when it allocates new pmd page it
cuts 1GiB at once.

This patch makes a copy of all affected pmds from init_mm.
Only few (usually one) 2MiB sections will be lost.
This is not eliminates problem but makes it 512 times less likely.

Usually idmap is used only for a short period. For examle for booting
secondary cpu __turn_mmu_on (executed in physical addresses) jumps to
virtual address of __secondary_switched which calls secondary_start_kernel
which in turn calls cpu_switch_mm and switches to normal pgd from init_mm.
So everything will be fine if these functions aren't intersect with idmap.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 arch/arm/mm/idmap.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index 8e0e52e..dcd023c 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -25,6 +25,9 @@ static void idmap_add_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 			pr_warning("Failed to allocate identity pmd.\n");
 			return;
 		}
+		if (!pud_none(*pud))
+			memcpy(pmd, pmd_offset(pud, 0),
+			       PTRS_PER_PMD * sizeof(pmd_t));
 		pud_populate(&init_mm, pud, pmd);
 		pmd += pmd_index(addr);
 	} else

