Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbaGNQXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:23:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36633 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbaGNQXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:23:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen: Introduce 'xen_nopv' to disable PV extensions for HVM guests.
Date: Mon, 14 Jul 2014 12:23:25 -0400
Message-Id: <1405355005-7473-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default when CONFIG_XEN and CONFIG_XEN_PVHVM kernels are
run, they will enable the PV extensions (drivers, interrupts, timers,
etc) - which is the best option for the majority of use cases.

However, in some cases (kexec not fully working, benchmarking)
we want to disable Xen PV extensions. As such introduce the
'xen_nopv' parameter that will do it.

This parameter is intended only for HVM guests as the Xen PV
guests MUST boot with PV extensions. However, even if you use
'xen_nopv' on Xen PV guests it will be ignored.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
[v2: s/off/xen_nopv/ per Boris Ostrovsky recommendation.]
[v3: Add Reviewed-by]
[v4: Clarify that this is only for HVM guests]
---
 Documentation/kernel-parameters.txt |  4 ++++
 arch/x86/xen/enlighten.c            | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c1b9aa8..403f927 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3691,6 +3691,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Disables the ticketlock slowpath using Xen PV
 			optimizations.
 
+	xen_nopv	[X86]
+			Disables the PV optimizations forcing the HVM guest to
+			run as generic HVM guest with no PV drivers.
+
 	xirc2ps_cs=	[NET,PCMCIA]
 			Format:
 			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index ffb101e..eb82239 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1826,8 +1826,19 @@ static void __init xen_hvm_guest_init(void)
 	xen_hvm_init_mmu_ops();
 }
 
+static bool xen_nopv = false;
+static __init int xen_parse_nopv(char *arg)
+{
+       xen_nopv = true;
+       return 0;
+}
+early_param("xen_nopv", xen_parse_nopv);
+
 static uint32_t __init xen_hvm_platform(void)
 {
+	if (xen_nopv)
+		return 0;
+
 	if (xen_pv_domain())
 		return 0;
 
@@ -1836,6 +1847,8 @@ static uint32_t __init xen_hvm_platform(void)
 
 bool xen_hvm_need_lapic(void)
 {
+	if (xen_nopv)
+		return false;
 	if (xen_pv_domain())
 		return false;
 	if (!xen_hvm_domain())
-- 
1.9.3

