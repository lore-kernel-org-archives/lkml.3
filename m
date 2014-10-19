Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaJSBrH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 21:47:07 -0400
Received: from numascale.com ([213.162.240.84]:51226 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbaJSBrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 21:47:01 -0400
From: Daniel J Blueman <daniel@numascale.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Daniel J Blueman <daniel@numascale.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH v2 3/5] Numachip: Add safe is-present function
Date: Sun, 19 Oct 2014 09:45:50 +0800
Message-Id: <1413683152-31302-3-git-send-email-daniel@numascale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413683152-31302-1-git-send-email-daniel@numascale.com>
References: <1413683152-31302-1-git-send-email-daniel@numascale.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add safe function to check if Numachip is detected, to be used elsewhere.

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
---
 arch/x86/include/asm/numachip/numachip.h | 9 +++++++++
 arch/x86/kernel/apic/apic_numachip.c     | 9 +++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/numachip/numachip.h b/arch/x86/include/asm/numachip/numachip.h
index 1c6f7f6..3e1f4f9 100644
--- a/arch/x86/include/asm/numachip/numachip.h
+++ b/arch/x86/include/asm/numachip/numachip.h
@@ -16,4 +16,13 @@
 
 extern int __init pci_numachip_init(void);
 
+#ifdef CONFIG_X86_NUMACHIP
+extern bool is_numachip_system(void);
+#else
+static inline bool is_numachip_system(void)
+{
+	return 0;
+}
+#endif
+
 #endif /* _ASM_X86_NUMACHIP_NUMACHIP_H */
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index bd083c0..c965b69 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -30,7 +30,7 @@
 #include <asm/apic_flat_64.h>
 #include <asm/pgtable.h>
 
-static int numachip_system __read_mostly;
+static bool numachip_system __read_mostly;
 
 static const struct apic apic_numachip __refconst;
 
@@ -173,11 +173,16 @@ static void fixup_cpu_id(struct cpuinfo_x86 *c, int node)
 	}
 }
 
+bool is_numachip_system(void)
+{
+	return numachip_system;
+}
+
 static int __init numachip_system_init(void)
 {
 	unsigned int val;
 
-	if (!numachip_system)
+	if (!is_numachip_system())
 		return 0;
 
 	x86_cpuinit.fixup_cpu_id = fixup_cpu_id;
-- 
1.9.1

