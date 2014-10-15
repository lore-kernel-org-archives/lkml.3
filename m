Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaJOMx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:53:27 -0400
Received: from numascale.com ([213.162.240.84]:53941 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbaJOMxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:53:24 -0400
From: Daniel J Blueman <daniel@numascale.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Daniel J Blueman <daniel@numascale.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH 1/3] Numachip: fixes
Date: Wed, 15 Oct 2014 20:53:06 +0800
Message-Id: <1413377588-6985-1-git-send-email-daniel@numascale.com>
X-Mailer: git-send-email 1.9.1
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

Fix APIC declaration to be consistent with definition; this addresses
a compilation failure with the development branch of GCC, see:
https://bugzilla.kernel.org/show_bug.cgi?id=78251

Fix 16-bit APIC ID truncation and redundant APIC ICR idle polling
for IPI to self (AMD64 APICs are documented in the system developer
manuals to queue APIC writes).

Finally, add safe function to check if Numachip is detected, to be
used elsewhere.

Candidate for stable.

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
Reviewed-by: Steffen Persvold <sp@numascale.com>
---
 arch/x86/include/asm/numachip/numachip.h |  9 +++++++++
 arch/x86/kernel/apic/apic_numachip.c     | 12 ++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

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
index ae91539..4156470 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -30,9 +30,13 @@
 #include <asm/apic_flat_64.h>
 #include <asm/pgtable.h>
 
-static int numachip_system __read_mostly;
+static bool numachip_system __read_mostly;
+static const struct apic apic_numachip __refconst;
 
-static const struct apic apic_numachip __read_mostly;
+bool is_numachip_system(void)
+{
+	return numachip_system;
+}
 
 static unsigned int get_apic_id(unsigned long x)
 {
@@ -40,7 +44,7 @@ static unsigned int get_apic_id(unsigned long x)
 	unsigned int id;
 
 	rdmsrl(MSR_FAM10H_NODE_ID, value);
-	id = ((x >> 24) & 0xffU) | ((value << 2) & 0x3f00U);
+	id = ((x >> 24) & 0xffU) | ((value << 2) & 0xff00U);
 
 	return id;
 }
@@ -145,7 +149,7 @@ static void numachip_send_IPI_all(int vector)
 
 static void numachip_send_IPI_self(int vector)
 {
-	__default_send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
+	apic_write(APIC_SELF_IPI, vector);
 }
 
 static int __init numachip_probe(void)
-- 
1.9.1

