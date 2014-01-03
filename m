Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbaACUaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:30:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21963 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbaACU36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:29:58 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        david.vrabel@citrix.com
Cc: hpa@zytor.com, Mukesh Rathor <mukesh.rathor@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v13 02/19] xen/pvh/x86: Define what an PVH guest is (v3).
Date: Fri,  3 Jan 2014 14:38:19 -0500
Message-Id: <1388777916-1328-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
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

Also we use the PV cpuid, albeit we can use the HVM (native) cpuid.
However, we do have a fair bit of filtering in the xen_cpuid and
we can piggyback on that until the hypervisor/toolstack filters
the appropiate cpuids. Once that is done we can swap over to
use the native one.

We setup a Kconfig entry that is disabled by default and
cannot be enabled.

Note that on ARM the concept of PVH is non-existent. As Ian
put it: "an ARM guest is neither PV nor HVM nor PVHVM.
It's a bit like PVH but is different also (it's further towards
the H end of the spectrum than even PVH).". As such these
options (PVHVM, PVH) are never enabled nor seen on ARM
compilations.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/Kconfig |  5 +++++
 include/xen/xen.h    | 14 ++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 1a3c765..e7d0590 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -51,3 +51,8 @@ config XEN_DEBUG_FS
 	  Enable statistics output and various tuning options in debugfs.
 	  Enabling this option may incur a significant performance overhead.
 
+config XEN_PVH
+	bool "Support for running as a PVH guest"
+	depends on X86_64 && XEN && BROKEN
+	select XEN_PVHVM
+	def_bool n
diff --git a/include/xen/xen.h b/include/xen/xen.h
index a74d436..0c0e3ef 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -29,4 +29,18 @@ extern enum xen_domain_type xen_domain_type;
 #define xen_initial_domain()	(0)
 #endif	/* CONFIG_XEN_DOM0 */
 
+#ifdef CONFIG_XEN_PVH
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

