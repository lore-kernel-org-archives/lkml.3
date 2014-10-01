Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaJAHrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:47:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47678 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaJAHro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:47:44 -0400
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 4/5] powerpc/powernv: Discover and enable winkle
Date: Wed,  1 Oct 2014 13:16:56 +0530
Message-Id: <1412149617-3178-5-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412149617-3178-1-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1412149617-3178-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100107-6688-0000-0000-000005377266
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discover winkle from device tree. If supported make OPAL calls
necessary to save HIDs, HMEER, HSPRG0 and LPCR.
Also make OPAL call when the HID0 value is modified during
split/unsplit of cores.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/opal.h          |  1 +
 arch/powerpc/platforms/powernv/powernv.h |  1 +
 arch/powerpc/platforms/powernv/setup.c   | 75 ++++++++++++++++++++++++++++++++
 arch/powerpc/platforms/powernv/subcore.c | 15 +++++++
 4 files changed, 92 insertions(+)

diff --git a/arch/powerpc/include/asm/opal.h b/arch/powerpc/include/asm/opal.h
index d376020..a77957f 100644
--- a/arch/powerpc/include/asm/opal.h
+++ b/arch/powerpc/include/asm/opal.h
@@ -778,6 +778,7 @@ extern struct device_node *opal_node;
 #define IDLE_INST_NAP	0x00010000 /* nap instruction can be used */
 #define IDLE_INST_SLEEP	0x00020000 /* sleep instruction can be used */
 #define IDLE_INST_SLEEP_ER1	0x00080000 /* Use sleep with work around*/
+#define IDLE_INST_WINKLE	0x00040000 /* winkle instruction can be used */
 
 /* API functions */
 int64_t opal_invalid_call(void);
diff --git a/arch/powerpc/platforms/powernv/powernv.h b/arch/powerpc/platforms/powernv/powernv.h
index 31ece13..76b37f8 100644
--- a/arch/powerpc/platforms/powernv/powernv.h
+++ b/arch/powerpc/platforms/powernv/powernv.h
@@ -27,6 +27,7 @@ static inline int pnv_pci_dma_set_mask(struct pci_dev *pdev, u64 dma_mask)
 
 #define IDLE_USE_NAP		(1UL << 0)
 #define IDLE_USE_SLEEP		(1UL << 1)
+#define IDLE_USE_WINKLE                (1UL << 3)
 
 extern unsigned int pnv_get_supported_cpuidle_states(void);
 
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index f45b52d..13c5e49 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -273,6 +273,65 @@ unsigned int pnv_get_supported_cpuidle_states(void)
 	return supported_cpuidle_states;
 }
 
+int pnv_save_sprs_for_winkle(void)
+{
+	int cpu;
+	int rc;
+
+	/*
+	* hid0, hid1, hid4, hid5, hmeer and lpcr values are symmetric accross
+	* all cpus at boot. Get these reg values of current cpu and use the
+	* same accross all cpus.
+	*/
+	uint64_t lpcr_val = mfspr(SPRN_LPCR);
+	uint64_t hid0_val = mfspr(SPRN_HID0);
+	uint64_t hid1_val = mfspr(SPRN_HID1);
+	uint64_t hid4_val = mfspr(SPRN_HID4);
+	uint64_t hid5_val = mfspr(SPRN_HID5);
+	uint64_t hmeer_val = mfspr(SPRN_HMEER);
+
+	for_each_possible_cpu(cpu) {
+		uint64_t pir = get_hard_smp_processor_id(cpu);
+		uint64_t local_paca_ptr = (uint64_t)&paca[cpu];
+
+		rc = opal_slw_set_reg(pir, SPRN_HSPRG0, local_paca_ptr);
+		if (rc != 0)
+			return rc;
+
+		rc = opal_slw_set_reg(pir, SPRN_LPCR, lpcr_val);
+		if (rc != 0)
+			return rc;
+
+		/* HIDs are per core registers */
+		if (cpu_thread_in_core(cpu) == 0) {
+
+			rc = opal_slw_set_reg(pir, SPRN_HMEER, hmeer_val);
+			if (rc != 0)
+				return rc;
+
+			rc = opal_slw_set_reg(pir, SPRN_HID0, hid0_val);
+			if (rc != 0)
+				return rc;
+
+			rc = opal_slw_set_reg(pir, SPRN_HID1, hid1_val);
+			if (rc != 0)
+				return rc;
+
+			rc = opal_slw_set_reg(pir, SPRN_HID4, hid4_val);
+			if (rc != 0)
+				return rc;
+
+			rc = opal_slw_set_reg(pir, SPRN_HID5, hid5_val);
+			if (rc != 0)
+				return rc;
+
+		}
+
+	}
+
+	return 0;
+
+}
 static int __init pnv_probe_idle_states(void)
 {
 	struct device_node *power_mgt;
@@ -318,6 +377,22 @@ static int __init pnv_probe_idle_states(void)
 			supported_cpuidle_states |= IDLE_USE_SLEEP;
 			need_fastsleep_workaround = 1;
 		}
+
+		if (flags & IDLE_INST_WINKLE) {
+			/*
+			 * If winkle is supported, save HSPRG0, HIDs and LPCR
+			 * contents via OPAL. Enable winkle only if this
+			 * succeeds.
+			 */
+			int opal_ret_val = pnv_save_sprs_for_winkle();
+
+			if (!opal_ret_val)
+				supported_cpuidle_states |= IDLE_USE_WINKLE;
+			else
+				pr_warn("opal: opal_slw_set_reg failed with rc=%d, disabling winkle\n",
+						opal_ret_val);
+		}
+
 	}
 
 	return 0;
diff --git a/arch/powerpc/platforms/powernv/subcore.c b/arch/powerpc/platforms/powernv/subcore.c
index 894ecb3..47c70666e 100644
--- a/arch/powerpc/platforms/powernv/subcore.c
+++ b/arch/powerpc/platforms/powernv/subcore.c
@@ -24,6 +24,7 @@
 #include <asm/smp.h>
 
 #include "subcore.h"
+#include "powernv.h"
 
 
 /*
@@ -159,6 +160,18 @@ static void wait_for_sync_step(int step)
 	mb();
 }
 
+static void update_hid_in_slw(u64 hid0)
+{
+	u64 idle_states = pnv_get_supported_cpuidle_states();
+
+	if (idle_states & IDLE_USE_WINKLE) {
+		/* OPAL call to patch slw with the new HID0 value */
+		u64 cpu_pir = hard_smp_processor_id();
+
+		opal_slw_set_reg(cpu_pir, SPRN_HID0, hid0);
+	}
+}
+
 static void unsplit_core(void)
 {
 	u64 hid0, mask;
@@ -178,6 +191,7 @@ static void unsplit_core(void)
 	hid0 = mfspr(SPRN_HID0);
 	hid0 &= ~HID0_POWER8_DYNLPARDIS;
 	mtspr(SPRN_HID0, hid0);
+	update_hid_in_slw(hid0);
 
 	while (mfspr(SPRN_HID0) & mask)
 		cpu_relax();
@@ -214,6 +228,7 @@ static void split_core(int new_mode)
 	hid0  = mfspr(SPRN_HID0);
 	hid0 |= HID0_POWER8_DYNLPARDIS | split_parms[i].value;
 	mtspr(SPRN_HID0, hid0);
+	update_hid_in_slw(hid0);
 
 	/* Wait for it to happen */
 	while (!(mfspr(SPRN_HID0) & split_parms[i].mask))
-- 
1.9.3

