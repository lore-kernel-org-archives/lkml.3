Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaAAEhG (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 23:37:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18504 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaAAEhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 23:37:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v12 02/18] xen/pvh/x86: Define what an PVH guest is (v2).
Date: Tue, 31 Dec 2013 23:35:29 -0500
Message-Id: <1388550945-25499-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

Which is a PV guest with auto page translation enabled
and with vector callback. It is a cross between PVHVM and PV.

The Xen side defines PVH as (from docs/misc/pvh-readme.txt,
with modifications):

"* the guest uses auto translate:
 - p2m is managed by Xen
 - pagetables are owned by the guest
 - mmu_update hypercall not available
* it uses event callback and not vlapic emulation,
* IDT is native, so set_trap_table hcall is also N/A for a PVH guest.

For a full list of hcalls supported for PVH, see pvh_hypercall64_table
in arch/x86/hvm/hvm.c in xen.  From the ABI prespective, it's mostly a
PV guest with auto translate, although it does use hvm_op for setting
callback vector."

We don't have yet a Kconfig entry setup as we do not
have all the parts ready for it - so we piggyback
on the PVHVM config option. This scaffolding will
be removed later.

Note that on ARM the concept of PVH is non-existent. As Ian
put it: "an ARM guest is neither PV nor HVM nor PVHVM.
It's a bit like PVH but is different also (it's further towards
the H end of the spectrum than even PVH).". As such these
options (PVHVM, PVH) are never enabled nor seen on ARM
compilations.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/xen/xen.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/xen/xen.h b/include/xen/xen.h
index a74d436..c4ab644 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -29,4 +29,20 @@ extern enum xen_domain_type xen_domain_type;
 #define xen_initial_domain()	(0)
 #endif	/* CONFIG_XEN_DOM0 */
 
+#ifdef CONFIG_XEN_PVHVM
+/* Temporarily under XEN_PVHVM, but will be under CONFIG_XEN_PVH */
+
+/* This functionality exists only for x86. The XEN_PVHVM support exists
+ * only in x86 world - hence on ARM it will be always disabled.
+ * N.B. ARM guests are neither PV nor HVM nor PVHVM.
+ * It's a bit like PVH but is different also (it's further towards the H
+ * end of the spectrum than even PVH).
+ */
+#include <xen/features.h>
+#define xen_pvh_domain() (xen_pv_domain() && \
+			  xen_feature(XENFEAT_auto_translated_physmap) && \
+			  xen_have_vector_callback)
+#else
+#define xen_pvh_domain()	(0)
+#endif
 #endif	/* _XEN_XEN_H */
-- 
1.8.3.1

