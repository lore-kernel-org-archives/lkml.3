Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaIMSjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 14:39:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:60268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbaIMSh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 14:37:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,518,1406617200"; 
   d="scan'208";a="590897168"
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Glenn P. Williamson" <glenn.p.williamson@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 5/6] yx86/efi: fixup faults from UEFI firmware
Date: Sat, 13 Sep 2014 11:36:15 -0700
Message-Id: <1410633376-8822-6-git-send-email-ricardo.neri-calderon@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
References: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buggy UEFI firmware implementations may try to access the
EFI_BOOT_SERVICES_* memory regions even after those regions have been
surrendered to the kernel (after calling ExitBootServices() on the
firmware). If such regions are not mapped, a page fault will be
generated. Fix that up.

We are sure that we will not have false positives as those memory regions
are reserved and the kernel cannot use them.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 arch/x86/mm/fault.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a241946..f084912 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -14,6 +14,7 @@
 #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
 #include <linux/prefetch.h>		/* prefetchw			*/
 #include <linux/context_tracking.h>	/* exception_enter(), ...	*/
+#include <linux/efi.h>			/* fixup for buggy UEFI firmware*/
 
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
@@ -702,6 +703,13 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 		return;
 
 	/*
+	 * Try to fixup faults caused by illegal access to BOOT_SERVICES_*
+	 * regions by UEFI firmware.
+	 */
+	if (efi_boot_services_fixup(address))
+		return;
+
+	/*
 	 * Oops. The kernel tried to access some bad page. We'll have to
 	 * terminate things with extreme prejudice:
 	 */
-- 
1.9.1

