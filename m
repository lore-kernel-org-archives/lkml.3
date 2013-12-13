Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3LMCLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:11:10 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:61340 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab3LMCKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:10:47 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        george.dunlap@eu.citrix.com, ian.jackson@eu.citrix.com,
        mukesh.rathor@oracle.com, tim@xen.org, jbeulich@suse.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH V10 09/14] xen: implement updated XENMEM_add_to_physmap_range ABI
Date: Thu, 12 Dec 2013 21:10:16 -0500
Message-Id: <1386900621-27528-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@citrix.com>

Allows for more fine grained error reporting. Only used by PVH and
ARM both of which are marked EXPERIMENTAL precisely because the ABI
is not yet stable

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 1d1fbdb..a31449f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2541,14 +2541,16 @@ static int pvh_add_to_xen_p2m(unsigned long lpfn, unsigned long fgmfn,
 	};
 	xen_ulong_t idx = fgmfn;
 	xen_pfn_t gpfn = lpfn;
+	int err = 0;
 
 	set_xen_guest_handle(xatp.idxs, &idx);
 	set_xen_guest_handle(xatp.gpfns, &gpfn);
+	set_xen_guest_handle(xatp.errs, &err);
 
 	rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
-	if (rc)
-		pr_warn("d0: Failed to map pfn (0x%lx) to mfn (0x%lx) rc:%d\n",
-			lpfn, fgmfn, rc);
+	if (rc || err)
+		pr_warn("d0: Failed to map pfn (0x%lx) to mfn (0x%lx) rc:%d:%d\n",
+			lpfn, fgmfn, rc, err);
 	return rc;
 }
 
-- 
1.7.7.6

