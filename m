Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbaAAEkp (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 23:40:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19639 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaAAEhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 23:37:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v12 10/18] xen/pvh: Update E820 to work with PVH (v2)
Date: Tue, 31 Dec 2013 23:35:37 -0500
Message-Id: <1388550945-25499-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

In xen_add_extra_mem() we can skip updating P2M as it's managed
by Xen. PVH maps the entire IO space, but only RAM pages need
to be repopulated.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 2137c51..dd5f905 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -27,6 +27,7 @@
 #include <xen/interface/memory.h>
 #include <xen/interface/physdev.h>
 #include <xen/features.h>
+#include "mmu.h"
 #include "xen-ops.h"
 #include "vdso.h"
 
@@ -81,6 +82,9 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
 
 	memblock_reserve(start, size);
 
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
+
 	xen_max_p2m_pfn = PFN_DOWN(start + size);
 	for (pfn = PFN_DOWN(start); pfn < xen_max_p2m_pfn; pfn++) {
 		unsigned long mfn = pfn_to_mfn(pfn);
@@ -103,6 +107,7 @@ static unsigned long __init xen_do_chunk(unsigned long start,
 		.domid        = DOMID_SELF
 	};
 	unsigned long len = 0;
+	int xlated_phys = xen_feature(XENFEAT_auto_translated_physmap);
 	unsigned long pfn;
 	int ret;
 
@@ -116,7 +121,7 @@ static unsigned long __init xen_do_chunk(unsigned long start,
 				continue;
 			frame = mfn;
 		} else {
-			if (mfn != INVALID_P2M_ENTRY)
+			if (!xlated_phys && mfn != INVALID_P2M_ENTRY)
 				continue;
 			frame = pfn;
 		}
@@ -154,6 +159,13 @@ static unsigned long __init xen_do_chunk(unsigned long start,
 static unsigned long __init xen_release_chunk(unsigned long start,
 					      unsigned long end)
 {
+	/*
+	 * Xen already ballooned out the E820 non RAM regions for us
+	 * and set them up properly in EPT.
+	 */
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return end - start;
+
 	return xen_do_chunk(start, end, true);
 }
 
@@ -222,7 +234,13 @@ static void __init xen_set_identity_and_release_chunk(
 	 * (except for the ISA region which must be 1:1 mapped) to
 	 * release the refcounts (in Xen) on the original frames.
 	 */
-	for (pfn = start_pfn; pfn <= max_pfn_mapped && pfn < end_pfn; pfn++) {
+
+	/*
+	 * PVH E820 matches the hypervisor's P2M which means we need to
+	 * account for the proper values of *release and *identity.
+	 */
+	for (pfn = start_pfn; !xen_feature(XENFEAT_auto_translated_physmap) &&
+	     pfn <= max_pfn_mapped && pfn < end_pfn; pfn++) {
 		pte_t pte = __pte_ma(0);
 
 		if (pfn < PFN_UP(ISA_END_ADDRESS))
