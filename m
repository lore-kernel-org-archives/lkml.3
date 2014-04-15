Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaDOOTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:19:44 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58095 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaDOOQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:16:07 -0400
X-IronPort-AV: E=Sophos;i="4.97,864,1389744000"; 
   d="scan'208";a="121257952"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xenproject.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 7/9] x86: skip check for spurious faults for non-present faults
Date: Tue, 15 Apr 2014 15:15:35 +0100
Message-ID: <1397571337-20409-8-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
References: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
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
---
 arch/x86/mm/fault.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

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
1.7.2.5

