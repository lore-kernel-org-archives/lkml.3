Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbaELK3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 06:29:18 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32742 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaELK3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 06:29:17 -0400
X-IronPort-AV: E=Sophos;i="4.97,1034,1389744000"; 
   d="scan'208";a="129293683"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH] x86: skip check for spurious faults for non-present faults
Date: Mon, 12 May 2014 11:29:10 +0100
Message-ID: <1399890550-26475-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a fault on a kernel address is due to a non-present page, then it
cannot be the result of stale TLB entry from a protection change (RO
to RW or NX to X).  Thus the pagetable walk in spurious_fault() can be
skipped.

This avoids spurious_fault() oopsing in some cases if the pagetables
it attempts to walk are not accessible.  This obscures the location of
the original fault.

This also fixes a crash with Xen PV guests when they access entries in
the M2P corresponding to device MMIO regions.  The M2P is mapped
(read-only) by Xen into the kernel address space of the guest and this
mapping may contains holes for non-RAM regions.  Read faults will
result in calls to spurious_fault(), but because the page tables for
the M2P mappings are not accessible by the guest the pagetable walk
would fault.

This was not normally a problem as MMIO mappings would not normally
result in a M2P lookup because of the use of the _PAGE_IOMAP bit the
PTE.  However, removing the _PAGE_IOMAP bit requires M2P lookups for
MMIO mappings as well.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
x86 maintainers, this is a prerequisite for removing Xen's usage of
_PAGE_IOMAP so I think this is best merged via the Xen tree.

See the full series at https://lkml.org/lkml/2014/4/15/390
---
 arch/x86/mm/fault.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8e57229..c39e249 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -936,8 +936,10 @@ spurious_fault(unsigned long error_code, unsigned long address)
 	pte_t *pte;
 	int ret;
 
-	/* Reserved-bit violation or user access to kernel space? */
-	if (error_code & (PF_USER | PF_RSVD))
+	/* Only check for spurious faults on supervisor write or
+	   instruction faults. */
+	if (error_code != (PF_WRITE | PF_PROT)
+	    && error_code != (PF_INSTR | PF_PROT))
 		return 0;
 
 	pgd = init_mm.pgd + pgd_index(address);
-- 
1.7.10.4

