Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3LQUwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:52:00 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20048 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab3LQUv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:51:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        mukesh.rathor@oracle.com, jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v11 02/12] xen/pvh: Define what an PVH guest is.
Date: Tue, 17 Dec 2013 15:51:33 -0500
Message-Id: <1387313503-31362-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
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

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/xen/xen.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/xen/xen.h b/include/xen/xen.h
index a74d436..1d6a237 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -29,4 +29,13 @@ extern enum xen_domain_type xen_domain_type;
 #define xen_initial_domain()	(0)
 #endif	/* CONFIG_XEN_DOM0 */
 
+#ifdef CONFIG_XEN_PVHVM
+/* Temporarily under XEN_PVHVM, but will be under CONFIG_XEN_PVH */
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

