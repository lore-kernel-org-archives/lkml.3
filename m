Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbbAVOZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:25:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57825 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbbAVOZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:25:40 -0500
Date: Thu, 22 Jan 2015 06:25:16 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-bfb050702990d6a2033d072cb2af583aee5c6fc5@git.kernel.org>
Cc: tglx@linutronix.de, joro@8bytes.org, mingo@kernel.org,
        jiang.liu@linux.intel.com, linux-kernel@vger.kernel.org, bp@alien8.de,
        hpa@zytor.com, tony.luck@intel.com
Reply-To: jiang.liu@linux.intel.com, tglx@linutronix.de, joro@8bytes.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        bp@alien8.de, tony.luck@intel.com
In-Reply-To: <20150115211702.445212133@linutronix.de>
References: <20150115211702.445212133@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Move x2apic code to one place
Git-Commit-ID: bfb050702990d6a2033d072cb2af583aee5c6fc5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bfb050702990d6a2033d072cb2af583aee5c6fc5
Gitweb:     http://git.kernel.org/tip/bfb050702990d6a2033d072cb2af583aee5c6fc5
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:12 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:54 +0100

x86/apic: Move x2apic code to one place

Having several disjunct pieces of code for x2apic support makes
reading the code unnecessarily hard. Move it to one ifdeffed section.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20150115211702.445212133@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 58 ++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a7d3b64..ff2a8b8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -134,9 +134,6 @@ static inline void imcr_apic_to_pic(void)
  */
 static int force_enable_local_apic __initdata;
 
-/* Control whether x2APIC mode is enabled or not */
-static bool nox2apic __initdata;
-
 /*
  * APIC command line parameters
  */
@@ -161,33 +158,6 @@ static __init int setup_apicpmtimer(char *s)
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
@@ -1504,7 +1474,35 @@ void __init bsp_end_local_APIC_setup(void)
 
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
