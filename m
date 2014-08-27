Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936112AbaH0Wdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 18:33:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31877 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936087AbaH0Wdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 18:33:50 -0400
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: [V1 PATCH 1/2] PVH: set EFER.NX and EFER.SCE for boot vcpu
Date: Wed, 27 Aug 2014 15:33:34 -0700
Message-Id: <1409178815-2026-2-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1409178815-2026-1-git-send-email-mukesh.rathor@oracle.com>
References: <1409178815-2026-1-git-send-email-mukesh.rathor@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses three things for a pvh boot vcpu:

  - NX bug on intel: It was recenlty discovered that NX is not being
    honored in PVH on intel since EFER.NX is not being set. The pte.NX
    bits are ignored if EFER.NX is not set on intel.

  - PVH boot hang on newer xen:  Following c/s on xen

        c/s 7645640:  x86/PVH: don't set EFER_SCE for pvh guest

    removes setting of EFER.SCE for PVH guests. As such, existing intel pvh
    guest will no longer boot on xen after that c/s.

  - Both above changes will be applicable to AMD also when xen support of
    AMD pvh is added.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
---
 arch/x86/xen/enlighten.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c0cb11f..4af512d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1499,6 +1499,17 @@ void __ref xen_pvh_secondary_vcpu_init(int cpu)
 	xen_pvh_set_cr_flags(cpu);
 }
 
+/* This is done in secondary_startup_64 for hvm guests. */
+static void __init xen_configure_efer(void)
+{
+	u64 efer;
+
+	rdmsrl(MSR_EFER, efer);
+	efer |= EFER_SCE;
+	efer |= (cpuid_edx(0x80000001) & (1 << 20)) ? EFER_NX : 0;
+	wrmsrl(MSR_EFER, efer);
+}
+
 static void __init xen_pvh_early_guest_init(void)
 {
 	if (!xen_feature(XENFEAT_auto_translated_physmap))
@@ -1508,6 +1519,7 @@ static void __init xen_pvh_early_guest_init(void)
 		return;
 
 	xen_have_vector_callback = 1;
+	xen_configure_efer();
 	xen_pvh_set_cr_flags(0);
 
 #ifdef CONFIG_X86_32
-- 
1.8.3.1

