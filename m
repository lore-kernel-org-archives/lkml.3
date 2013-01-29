Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3A2VdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 16:33:07 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:33302
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972Ab3A2VdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 16:33:00 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz32i87h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h1155h)
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0MHEP6R-01-8VK-02
X-M-MSG: 
From: Boris Ostrovsky <ostr@amd64.org>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
CC: <Jacob.Shin@amd.com>, <bp@alien8.de>, <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: [PATCH 2/2] x86,AMD: Enable WC+ memory type on family 10 processors
Date: Tue, 29 Jan 2013 16:32:49 -0500
Message-ID: <1359495169-23278-1-git-send-email-ostr@amd64.org>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

In some cases BIOS may not enable WC+ memory type on family 10
processors, instead converting what would be WC+ memory to CD type.
On guests using nested pages this could result in performance
degradation. This patch enables WC+.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
---
 arch/x86/include/uapi/asm/msr-index.h |    1 +
 arch/x86/kernel/cpu/amd.c             |   21 ++++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

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
index dd4a5b6..721ef32 100644
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
@@ -718,6 +716,19 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
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
+		if (c->x86 == 0x10) {
+			rdmsrl(MSR_AMD64_BU_CFG2, value);
+			value &= ~(1ULL << 24);
+			wrmsrl(MSR_AMD64_BU_CFG2, value);
+		}
 	}
 
 	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
-- 
1.7.1


