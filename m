Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbbAOV2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:28:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:58255 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbbAOVW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:28 -0500
Message-Id: <20150115211702.445212133@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 03/23] x86/apic: Move x2apic code to one place
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=x86-apic-move-x2apic-code-to-one-place.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having several disjunct pieces of code for x2apic support makes
reading the code unnecessarily hard. Move it to one ifdeffed section.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c |   58 +++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -134,9 +134,6 @@ static inline void imcr_apic_to_pic(void
  */
 static int force_enable_local_apic __initdata;
 
-/* Control whether x2APIC mode is enabled or not */
-static bool nox2apic __initdata;
-
 /*
  * APIC command line parameters
  */
@@ -161,33 +158,6 @@ static __init int setup_apicpmtimer(char
 __setup("apicpmtimer", setup_apicpmtimer);
 #endif
 
-#ifdef CONFIG_X86_X2APIC
-int x2apic_mode;
-/* x2apic enabled before OS handover */
-int x2apic_preenabled;
-static int x2apic_disabled;
-static int __init setup_nox2apic(char *str)
-{
-	if (x2apic_enabled()) {
-		int apicid = native_apic_msr_read(APIC_ID);
-
-		if (apicid >= 255) {
-			pr_warning("Apicid: %08x, cannot enforce nox2apic\n",
-				   apicid);
-			return 0;
-		}
-
-		pr_warning("x2apic already enabled. will disable it\n");
-	} else
-		setup_clear_cpu_cap(X86_FEATURE_X2APIC);
-
-	nox2apic = true;
-
-	return 0;
-}
-early_param("nox2apic", setup_nox2apic);
-#endif
-
 unsigned long mp_lapic_addr;
 int disable_apic;
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
@@ -1504,7 +1474,35 @@ void __init bsp_end_local_APIC_setup(voi
 
 }
 
+/* Control whether x2APIC mode is enabled or not */
+static bool nox2apic __initdata;
+
 #ifdef CONFIG_X86_X2APIC
+int x2apic_mode;
+/* x2apic enabled before OS handover */
+int x2apic_preenabled;
+static int x2apic_disabled;
+static int __init setup_nox2apic(char *str)
+{
+	if (x2apic_enabled()) {
+		int apicid = native_apic_msr_read(APIC_ID);
+
+		if (apicid >= 255) {
+			pr_warning("Apicid: %08x, cannot enforce nox2apic\n",
+				   apicid);
+			return 0;
+		}
+
+		pr_warning("x2apic already enabled. will disable it\n");
+	} else
+		setup_clear_cpu_cap(X86_FEATURE_X2APIC);
+
+	nox2apic = true;
+
+	return 0;
+}
+early_param("nox2apic", setup_nox2apic);
+
 /*
  * Need to disable xapic and x2apic at the same time and then enable xapic mode
  */


