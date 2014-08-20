Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaHTMM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:12:27 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58869 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 003/104] ARM: 8115/1: LPAE: reduce damage caused by idmap to virtual memory layout
Date: Wed, 20 Aug 2014 13:42:26 +0200
Message-Id: <8e49be939c5868035f26a77e997cab2e4f6b5d13.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 811a2407a3cf7bbd027fbe92d73416f17485a3d8 upstream.

On LPAE, each level 1 (pgd) page table entry maps 1GiB, and the level 2
(pmd) entries map 2MiB.

When the identity mapping is created on LPAE, the pgd pointers are copied
from the swapper_pg_dir.  If we find that we need to modify the contents
of a pmd, we allocate a new empty pmd table and insert it into the
appropriate 1GB slot, before then filling it with the identity mapping.

However, if the 1GB slot covers the kernel lowmem mappings, we obliterate
those mappings.

When replacing a PMD, first copy the old PMD contents to the new PMD, so
that we preserve the existing mappings, particularly the mappings of the
kernel itself.

[rewrote commit message and added code comment -- rmk]

Fixes: ae2de101739c ("ARM: LPAE: Add identity mapping support for the 3-level page table format")
Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mm/idmap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index 83cb3ac27095..c61d2373408c 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -24,6 +24,13 @@ static void idmap_add_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 			pr_warning("Failed to allocate identity pmd.\n");
 			return;
 		}
+		/*
+		 * Copy the original PMD to ensure that the PMD entries for
+		 * the kernel image are preserved.
+		 */
+		if (!pud_none(*pud))
+			memcpy(pmd, pmd_offset(pud, 0),
+			       PTRS_PER_PMD * sizeof(pmd_t));
 		pud_populate(&init_mm, pud, pmd);
 		pmd += pmd_index(addr);
 	} else
-- 
2.0.4

