Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbaHES20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:28:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbaHESOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.14 05/39] ARM: 8115/1: LPAE: reduce damage caused by idmap to virtual memory layout
Date: Tue,  5 Aug 2014 11:13:42 -0700
Message-Id: <20140805181336.189298830@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181336.030349158@linuxfoundation.org>
References: <20140805181336.030349158@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/idmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -25,6 +25,13 @@ static void idmap_add_pmd(pud_t *pud, un
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


