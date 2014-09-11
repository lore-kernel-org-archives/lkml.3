Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaIKImH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:42:07 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:32639 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaIKIhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:37:34 -0400
From: Paul Burton <paul.burton@imgtec.com>
To: <linux-mips@linux-mips.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Paul Burton <paul.burton@imgtec.com>
Subject: [PATCH 05/10] MIPS: detect presence of the FRE & UFR bits
Date: Thu, 11 Sep 2014 08:30:18 +0100
Message-ID: <1410420623-11691-6-git-send-email-paul.burton@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
References: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.159.78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect the presence of the Config5 FRE & UFE bits, as indicated by the
FREP bit in FPIR. Record this as a CPU option bit, and provide a
cpu_has_fre macro to ease checking of that option bit.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
---
 arch/mips/include/asm/cpu-features.h | 4 ++++
 arch/mips/include/asm/cpu.h          | 1 +
 arch/mips/kernel/cpu-probe.c         | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index e079598..b9420d8 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -334,4 +334,8 @@
 # define cpu_has_msa		0
 #endif
 
+#ifndef cpu_has_fre
+# define cpu_has_fre		(cpu_data[0].options & MIPS_CPU_FRE)
+#endif
+
 #endif /* __ASM_CPU_FEATURES_H */
diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index dfdc77e..11025bf 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -368,6 +368,7 @@ enum cpu_type_enum {
 #define MIPS_CPU_HTW		0x100000000ull /* CPU support Hardware Page Table Walker */
 #define MIPS_CPU_RIXIEX		0x200000000ull /* CPU has unique exception codes for {Read, Execute}-Inhibit exceptions */
 #define MIPS_CPU_MAAR		0x400000000ull /* MAAR(I) registers are present */
+#define MIPS_CPU_FRE		0x800000000ull /* FRE & UFE bits implemented */
 
 /*
  * CPU ASE encodings
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index e34b10b..db929a0 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1233,6 +1233,8 @@ void cpu_probe(void)
 				    MIPS_CPU_ISA_M64R1 | MIPS_CPU_ISA_M64R2)) {
 			if (c->fpu_id & MIPS_FPIR_3D)
 				c->ases |= MIPS_ASE_MIPS3D;
+			if (c->fpu_id & MIPS_FPIR_FREP)
+				c->options |= MIPS_CPU_FRE;
 		}
 	}
 
-- 
2.0.4

