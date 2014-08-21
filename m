Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaHUCRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 22:17:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44519 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaHUCQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 22:16:59 -0400
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: [V0 PATCH 1/2] AMD-PVH: set EFER.NX and EFER.SCE for the boot vcpu
Date: Wed, 20 Aug 2014 19:16:39 -0700
Message-Id: <1408587400-18663-2-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408587400-18663-1-git-send-email-mukesh.rathor@oracle.com>
References: <1408587400-18663-1-git-send-email-mukesh.rathor@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On AMD, NX feature must be enabled in the efer for NX to be honored in
the pte entries, otherwise protection fault. We also set SC for
system calls to be enabled.

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

