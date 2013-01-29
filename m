Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab3A2WPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:15:38 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:16085 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573Ab3A2WPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:15:35 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h1155h)
X-WSS-ID: 0MHER5Q-02-DWU-02
X-M-MSG: 
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
CC: <Jacob.Shin@amd.com>, <bp@alien8.de>, <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: [PATCH v2 2/2] x86,AMD: Enable WC+ memory type on family 10 processors
Date: Tue, 29 Jan 2013 17:15:23 -0500
Message-ID: <1359497723-24791-1-git-send-email-boris.ostrovsky@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases BIOS may not enable WC+ memory type on family 10
processors, instead converting what would be WC+ memory to CD type.
On guests using nested pages this could result in performance
degradation. This patch enables WC+.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
---
 arch/x86/include/uapi/asm/msr-index.h |    1 +
 arch/x86/kernel/cpu/amd.c             |   19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index 433a59f..158cde9 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -173,6 +173,7 @@
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD64_DC_CFG		0xc0011022
+#define MSR_AMD64_BU_CFG2		0xc001102a
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index dd4a5b6..a873bcc 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -698,13 +698,11 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 > 0x11)
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
-	/*
-	 * Disable GART TLB Walk Errors on Fam10h. We do this here
-	 * because this is always needed when GART is enabled, even in a
-	 * kernel which has no MCE support built in.
-	 */
 	if (c->x86 == 0x10) {
 		/*
+		 * Disable GART TLB Walk Errors on Fam10h. We do this here
+		 * because this is always needed when GART is enabled, even in a
+		 * kernel which has no MCE support built in.
 		 * BIOS should disable GartTlbWlk Errors themself. If
 		 * it doesn't do it here as suggested by the BKDG.
 		 *
@@ -718,6 +716,17 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 			mask |= (1 << 10);
 			wrmsrl_safe(MSR_AMD64_MCx_MASK(4), mask);
 		}
+
+		/*
+		 * On family 10h BIOS may not have properly enabled WC+ support,
+		 * causing it to be converted to CD memtype. This may result in
+		 * performance degradation for certain nested-paging guests.
+		 * Prevent this conversion by clearing bit 24 in
+		 * MSR_AMD64_BU_CFG2.
+		 */
+		rdmsrl(MSR_AMD64_BU_CFG2, value);
+		value &= ~(1ULL << 24);
+		wrmsrl(MSR_AMD64_BU_CFG2, value);
 	}
 
 	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
-- 
1.7.1


