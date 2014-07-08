Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbaGHTvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:51:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:34551 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339AbaGHTu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:50:57 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v2] xen: Introduce 'xen_nopv' to disable PV extensions for HVM guests.
Date: Tue,  8 Jul 2014 16:52:25 -0400
Message-Id: <1404852745-25187-1-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

By default when CONFIG_XEN and CONFIG_XEN_PVHVM kernels are
run, they will enable the PV extensions (drivers, interrupts, timers,
etc) - which is perfect.

However, in some cases (kexec not fully wokring, benchmarking)
we want to disable Xen PV extensions. As such introduce the
'xen_nopv' parameter that will do it.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
[v2: s/off/xen_nopv/ per Boris Ostrovsky recommendation.]
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/xen/enlighten.c            |   13 +++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c1b9aa8..5dcfa6e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3691,6 +3691,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Disables the ticketlock slowpath using Xen PV
 			optimizations.
 
+	xen_nopv	[X86,XEN]
+			Disables the PV optimizations forcing the guest to run
+			as generic HVM guest with no PV drivers.
+
 	xirc2ps_cs=	[NET,PCMCIA]
 			Format:
 			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e220197..7aa59ef 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1930,10 +1930,21 @@ static void __init xen_hvm_guest_init(void)
 #endif
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
 	uint32_t eax, ebx, ecx, edx, base;
 
+	if (xen_nopv)
+		return 0;
+
 	if (xen_pv_domain())
 		return 0;
 
@@ -1953,6 +1964,8 @@ static uint32_t __init xen_hvm_platform(void)
 
 bool xen_hvm_need_lapic(void)
 {
+	if (xen_nopv)
+		return false;
 	if (xen_pv_domain())
 		return false;
 	if (!xen_hvm_domain())
-- 
1.7.7.6

