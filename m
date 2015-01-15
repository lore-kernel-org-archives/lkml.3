Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbbAONOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:14:34 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:17997 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbbAONOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:14:30 -0500
From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Leonid Rosenboim <lrosenboim@caviumnetworks.com>,
        Peter Swain <peter.swain@cavium.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Ralf Baechle <ralf@linux-mips.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH v3 15/15] MIPS: OCTEON: irq: add CIB and other fixes
Date: Thu, 15 Jan 2015 16:11:19 +0300
Message-ID: <1421327487-28679-16-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
References: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [80.240.102.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

- Use of_irq_init() to initialize interrupt controllers
- Get rid of some unlikely()
- Add CIB to support SATA and other interrupts
- Add support for CIU SUM2 interrupt sources

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Leonid Rosenboim <lrosenboim@caviumnetworks.com>
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
Signed-off-by: Peter Swain <peter.swain@cavium.com>
---
 .../devicetree/bindings/mips/cavium/cib.txt        |   43 +
 arch/mips/cavium-octeon/octeon-irq.c               | 1049 +++++++++++++++-----
 2 files changed, 823 insertions(+), 269 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/cib.txt

diff --git a/Documentation/devicetree/bindings/mips/cavium/cib.txt b/Documentation/devicetree/bindings/mips/cavium/cib.txt
new file mode 100644
index 0000000..f39a1aa
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/cavium/cib.txt
@@ -0,0 +1,43 @@
+* Cavium Interrupt Bus widget
+
+Properties:
+- compatible: "cavium,octeon-7130-cib"
+
+  Compatibility with cn70XX SoCs.
+
+- interrupt-controller:  This is an interrupt controller.
+
+- reg: Two elements consisting of the addresses of the RAW and EN
+  registers of the CIB block
+
+- cavium,max-bits: The index (zero based) of the highest numbered bit
+  in the CIB block.
+
+- interrupt-parent:  Always the CIU on the SoC.
+
+- interrupts: The CIU line to which the CIB block is connected.
+
+- #interrupt-cells: Must be <2>.  The first cell is the bit within the
+   CIB.  The second cell specifies the triggering semantics of the
+   line.
+
+Example:
+
+	interrupt-controller@107000000e000 {
+		compatible = "cavium,octeon-7130-cib";
+		reg = <0x10700 0x0000e000 0x0 0x8>, /* RAW */
+		      <0x10700 0x0000e100 0x0 0x8>; /* EN */
+		cavium,max-bits = <23>;
+
+		interrupt-controller;
+		interrupt-parent = <&ciu>;
+		interrupts = <1 24>;
+		/* Interrupts are specified by two parts:
+		 * 1) Bit number in the CIB* registers
+		 * 2) Triggering (1 - edge rising
+		 *		  2 - edge falling
+		 *		  4 - level active high
+		 *		  8 - level active low)
+		 */
+		#interrupt-cells = <2>;
+	};
diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index 1b25998..10f7625 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -3,12 +3,14 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (C) 2004-2012 Cavium, Inc.
+ * Copyright (C) 2004-2014 Cavium, Inc.
  */
 
+#include <linux/of_address.h>
 #include <linux/interrupt.h>
 #include <linux/irqdomain.h>
 #include <linux/bitops.h>
+#include <linux/of_irq.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
@@ -22,16 +24,25 @@ static DEFINE_PER_CPU(unsigned long, octeon_irq_ciu0_en_mirror);
 static DEFINE_PER_CPU(unsigned long, octeon_irq_ciu1_en_mirror);
 static DEFINE_PER_CPU(raw_spinlock_t, octeon_irq_ciu_spinlock);
 
+struct octeon_irq_ciu_domain_data {
+	int num_sum;  /* number of sum registers (2 or 3). */
+};
+
 static __read_mostly u8 octeon_irq_ciu_to_irq[8][64];
 
-union octeon_ciu_chip_data {
-	void *p;
-	unsigned long l;
-	struct {
-		unsigned long line:6;
-		unsigned long bit:6;
-		unsigned long gpio_line:6;
-	} s;
+struct octeon_ciu_chip_data {
+	union {
+		struct {		/* only used for ciu3 */
+			u64 ciu3_addr;
+			unsigned int intsn;
+		};
+		struct {		/* only used for ciu/ciu2 */
+			u8 line;
+			u8 bit;
+			u8 gpio_line;
+		};
+	};
+	int current_cpu;	/* Next CPU expected to take this irq */
 };
 
 struct octeon_core_chip_data {
@@ -45,27 +56,40 @@ struct octeon_core_chip_data {
 
 static struct octeon_core_chip_data octeon_irq_core_chip_data[MIPS_CORE_IRQ_LINES];
 
-static void octeon_irq_set_ciu_mapping(int irq, int line, int bit, int gpio_line,
-				       struct irq_chip *chip,
-				       irq_flow_handler_t handler)
+static int octeon_irq_set_ciu_mapping(int irq, int line, int bit, int gpio_line,
+				      struct irq_chip *chip,
+				      irq_flow_handler_t handler)
 {
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
+
+	cd = kzalloc(sizeof(*cd), GFP_KERNEL);
+	if (!cd)
+		return -ENOMEM;
 
 	irq_set_chip_and_handler(irq, chip, handler);
 
-	cd.l = 0;
-	cd.s.line = line;
-	cd.s.bit = bit;
-	cd.s.gpio_line = gpio_line;
+	cd->line = line;
+	cd->bit = bit;
+	cd->gpio_line = gpio_line;
 
-	irq_set_chip_data(irq, cd.p);
+	irq_set_chip_data(irq, cd);
 	octeon_irq_ciu_to_irq[line][bit] = irq;
+	return 0;
+}
+
+static void octeon_irq_free_cd(struct irq_domain *d, unsigned int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	struct octeon_ciu_chip_data *cd = irq_data_get_irq_chip_data(data);
+
+	irq_set_chip_data(irq, NULL);
+	kfree(cd);
 }
 
-static void octeon_irq_force_ciu_mapping(struct irq_domain *domain,
-					 int irq, int line, int bit)
+static int octeon_irq_force_ciu_mapping(struct irq_domain *domain,
+					int irq, int line, int bit)
 {
-	irq_domain_associate(domain, irq, line << 6 | bit);
+	return irq_domain_associate(domain, irq, line << 6 | bit);
 }
 
 static int octeon_coreid_for_cpu(int cpu)
@@ -202,9 +226,10 @@ static int next_cpu_for_irq(struct irq_data *data)
 #ifdef CONFIG_SMP
 	int cpu;
 	int weight = cpumask_weight(data->affinity);
+	struct octeon_ciu_chip_data *cd = irq_data_get_irq_chip_data(data);
 
 	if (weight > 1) {
-		cpu = smp_processor_id();
+		cpu = cd->current_cpu;
 		for (;;) {
 			cpu = cpumask_next(cpu, data->affinity);
 			if (cpu >= nr_cpu_ids) {
@@ -219,6 +244,7 @@ static int next_cpu_for_irq(struct irq_data *data)
 	} else {
 		cpu = smp_processor_id();
 	}
+	cd->current_cpu = cpu;
 	return cpu;
 #else
 	return smp_processor_id();
@@ -231,15 +257,15 @@ static void octeon_irq_ciu_enable(struct irq_data *data)
 	int coreid = octeon_coreid_for_cpu(cpu);
 	unsigned long *pen;
 	unsigned long flags;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 	raw_spinlock_t *lock = &per_cpu(octeon_irq_ciu_spinlock, cpu);
 
-	cd.p = irq_data_get_irq_chip_data(data);
+	cd = irq_data_get_irq_chip_data(data);
 
 	raw_spin_lock_irqsave(lock, flags);
-	if (cd.s.line == 0) {
+	if (cd->line == 0) {
 		pen = &per_cpu(octeon_irq_ciu0_en_mirror, cpu);
-		__set_bit(cd.s.bit, pen);
+		__set_bit(cd->bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
 		 * enabling the irq.
@@ -248,7 +274,7 @@ static void octeon_irq_ciu_enable(struct irq_data *data)
 		cvmx_write_csr(CVMX_CIU_INTX_EN0(coreid * 2), *pen);
 	} else {
 		pen = &per_cpu(octeon_irq_ciu1_en_mirror, cpu);
-		__set_bit(cd.s.bit, pen);
+		__set_bit(cd->bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
 		 * enabling the irq.
@@ -263,15 +289,15 @@ static void octeon_irq_ciu_enable_local(struct irq_data *data)
 {
 	unsigned long *pen;
 	unsigned long flags;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 	raw_spinlock_t *lock = this_cpu_ptr(&octeon_irq_ciu_spinlock);
 
-	cd.p = irq_data_get_irq_chip_data(data);
+	cd = irq_data_get_irq_chip_data(data);
 
 	raw_spin_lock_irqsave(lock, flags);
-	if (cd.s.line == 0) {
+	if (cd->line == 0) {
 		pen = this_cpu_ptr(&octeon_irq_ciu0_en_mirror);
-		__set_bit(cd.s.bit, pen);
+		__set_bit(cd->bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
 		 * enabling the irq.
@@ -280,7 +306,7 @@ static void octeon_irq_ciu_enable_local(struct irq_data *data)
 		cvmx_write_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2), *pen);
 	} else {
 		pen = this_cpu_ptr(&octeon_irq_ciu1_en_mirror);
-		__set_bit(cd.s.bit, pen);
+		__set_bit(cd->bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
 		 * enabling the irq.
@@ -295,15 +321,15 @@ static void octeon_irq_ciu_disable_local(struct irq_data *data)
 {
 	unsigned long *pen;
 	unsigned long flags;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 	raw_spinlock_t *lock = this_cpu_ptr(&octeon_irq_ciu_spinlock);
 
-	cd.p = irq_data_get_irq_chip_data(data);
+	cd = irq_data_get_irq_chip_data(data);
 
 	raw_spin_lock_irqsave(lock, flags);
-	if (cd.s.line == 0) {
+	if (cd->line == 0) {
 		pen = this_cpu_ptr(&octeon_irq_ciu0_en_mirror);
-		__clear_bit(cd.s.bit, pen);
+		__clear_bit(cd->bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
 		 * enabling the irq.
@@ -312,7 +338,7 @@ static void octeon_irq_ciu_disable_local(struct irq_data *data)
 		cvmx_write_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2), *pen);
 	} else {
 		pen = this_cpu_ptr(&octeon_irq_ciu1_en_mirror);
-		__clear_bit(cd.s.bit, pen);
+		__clear_bit(cd->bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
 		 * enabling the irq.
@@ -328,27 +354,27 @@ static void octeon_irq_ciu_disable_all(struct irq_data *data)
 	unsigned long flags;
 	unsigned long *pen;
 	int cpu;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 	raw_spinlock_t *lock;
 
-	cd.p = irq_data_get_irq_chip_data(data);
+	cd = irq_data_get_irq_chip_data(data);
 
 	for_each_online_cpu(cpu) {
 		int coreid = octeon_coreid_for_cpu(cpu);
 		lock = &per_cpu(octeon_irq_ciu_spinlock, cpu);
-		if (cd.s.line == 0)
+		if (cd->line == 0)
 			pen = &per_cpu(octeon_irq_ciu0_en_mirror, cpu);
 		else
 			pen = &per_cpu(octeon_irq_ciu1_en_mirror, cpu);
 
 		raw_spin_lock_irqsave(lock, flags);
-		__clear_bit(cd.s.bit, pen);
+		__clear_bit(cd->bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
 		 * enabling the irq.
 		 */
 		wmb();
-		if (cd.s.line == 0)
+		if (cd->line == 0)
 			cvmx_write_csr(CVMX_CIU_INTX_EN0(coreid * 2), *pen);
 		else
 			cvmx_write_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1), *pen);
@@ -361,27 +387,27 @@ static void octeon_irq_ciu_enable_all(struct irq_data *data)
 	unsigned long flags;
 	unsigned long *pen;
 	int cpu;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 	raw_spinlock_t *lock;
 
-	cd.p = irq_data_get_irq_chip_data(data);
+	cd = irq_data_get_irq_chip_data(data);
 
 	for_each_online_cpu(cpu) {
 		int coreid = octeon_coreid_for_cpu(cpu);
 		lock = &per_cpu(octeon_irq_ciu_spinlock, cpu);
-		if (cd.s.line == 0)
+		if (cd->line == 0)
 			pen = &per_cpu(octeon_irq_ciu0_en_mirror, cpu);
 		else
 			pen = &per_cpu(octeon_irq_ciu1_en_mirror, cpu);
 
 		raw_spin_lock_irqsave(lock, flags);
-		__set_bit(cd.s.bit, pen);
+		__set_bit(cd->bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
 		 * enabling the irq.
 		 */
 		wmb();
-		if (cd.s.line == 0)
+		if (cd->line == 0)
 			cvmx_write_csr(CVMX_CIU_INTX_EN0(coreid * 2), *pen);
 		else
 			cvmx_write_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1), *pen);
@@ -397,45 +423,106 @@ static void octeon_irq_ciu_enable_v2(struct irq_data *data)
 {
 	u64 mask;
 	int cpu = next_cpu_for_irq(data);
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << (cd.s.bit);
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
 
 	/*
 	 * Called under the desc lock, so these should never get out
 	 * of sync.
 	 */
-	if (cd.s.line == 0) {
+	if (cd->line == 0) {
 		int index = octeon_coreid_for_cpu(cpu) * 2;
-		set_bit(cd.s.bit, &per_cpu(octeon_irq_ciu0_en_mirror, cpu));
+		set_bit(cd->bit, &per_cpu(octeon_irq_ciu0_en_mirror, cpu));
 		cvmx_write_csr(CVMX_CIU_INTX_EN0_W1S(index), mask);
 	} else {
 		int index = octeon_coreid_for_cpu(cpu) * 2 + 1;
-		set_bit(cd.s.bit, &per_cpu(octeon_irq_ciu1_en_mirror, cpu));
+		set_bit(cd->bit, &per_cpu(octeon_irq_ciu1_en_mirror, cpu));
 		cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(index), mask);
 	}
 }
 
 /*
+ * Enable the irq in the sum2 registers.
+ */
+static void octeon_irq_ciu_enable_sum2(struct irq_data *data)
+{
+	u64 mask;
+	int cpu = next_cpu_for_irq(data);
+	int index = octeon_coreid_for_cpu(cpu);
+	struct octeon_ciu_chip_data *cd;
+
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
+
+	cvmx_write_csr(CVMX_CIU_EN2_PPX_IP4_W1S(index), mask);
+}
+
+/*
+ * Disable the irq in the sum2 registers.
+ */
+static void octeon_irq_ciu_disable_local_sum2(struct irq_data *data)
+{
+	u64 mask;
+	int cpu = next_cpu_for_irq(data);
+	int index = octeon_coreid_for_cpu(cpu);
+	struct octeon_ciu_chip_data *cd;
+
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
+
+	cvmx_write_csr(CVMX_CIU_EN2_PPX_IP4_W1C(index), mask);
+}
+
+static void octeon_irq_ciu_ack_sum2(struct irq_data *data)
+{
+	u64 mask;
+	int cpu = next_cpu_for_irq(data);
+	int index = octeon_coreid_for_cpu(cpu);
+	struct octeon_ciu_chip_data *cd;
+
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
+
+	cvmx_write_csr(CVMX_CIU_SUM2_PPX_IP4(index), mask);
+}
+
+static void octeon_irq_ciu_disable_all_sum2(struct irq_data *data)
+{
+	int cpu;
+	struct octeon_ciu_chip_data *cd;
+	u64 mask;
+
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
+
+	for_each_online_cpu(cpu) {
+		int coreid = octeon_coreid_for_cpu(cpu);
+
+		cvmx_write_csr(CVMX_CIU_EN2_PPX_IP4_W1C(coreid), mask);
+	}
+}
+
+/*
  * Enable the irq on the current CPU for chips that
  * have the EN*_W1{S,C} registers.
  */
 static void octeon_irq_ciu_enable_local_v2(struct irq_data *data)
 {
 	u64 mask;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << (cd.s.bit);
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
 
-	if (cd.s.line == 0) {
+	if (cd->line == 0) {
 		int index = cvmx_get_core_num() * 2;
-		set_bit(cd.s.bit, this_cpu_ptr(&octeon_irq_ciu0_en_mirror));
+		set_bit(cd->bit, this_cpu_ptr(&octeon_irq_ciu0_en_mirror));
 		cvmx_write_csr(CVMX_CIU_INTX_EN0_W1S(index), mask);
 	} else {
 		int index = cvmx_get_core_num() * 2 + 1;
-		set_bit(cd.s.bit, this_cpu_ptr(&octeon_irq_ciu1_en_mirror));
+		set_bit(cd->bit, this_cpu_ptr(&octeon_irq_ciu1_en_mirror));
 		cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(index), mask);
 	}
 }
@@ -443,18 +530,18 @@ static void octeon_irq_ciu_enable_local_v2(struct irq_data *data)
 static void octeon_irq_ciu_disable_local_v2(struct irq_data *data)
 {
 	u64 mask;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << (cd.s.bit);
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
 
-	if (cd.s.line == 0) {
+	if (cd->line == 0) {
 		int index = cvmx_get_core_num() * 2;
-		clear_bit(cd.s.bit, this_cpu_ptr(&octeon_irq_ciu0_en_mirror));
+		clear_bit(cd->bit, this_cpu_ptr(&octeon_irq_ciu0_en_mirror));
 		cvmx_write_csr(CVMX_CIU_INTX_EN0_W1C(index), mask);
 	} else {
 		int index = cvmx_get_core_num() * 2 + 1;
-		clear_bit(cd.s.bit, this_cpu_ptr(&octeon_irq_ciu1_en_mirror));
+		clear_bit(cd->bit, this_cpu_ptr(&octeon_irq_ciu1_en_mirror));
 		cvmx_write_csr(CVMX_CIU_INTX_EN1_W1C(index), mask);
 	}
 }
@@ -465,12 +552,12 @@ static void octeon_irq_ciu_disable_local_v2(struct irq_data *data)
 static void octeon_irq_ciu_ack(struct irq_data *data)
 {
 	u64 mask;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << (cd.s.bit);
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
 
-	if (cd.s.line == 0) {
+	if (cd->line == 0) {
 		int index = cvmx_get_core_num() * 2;
 		cvmx_write_csr(CVMX_CIU_INTX_SUM0(index), mask);
 	} else {
@@ -486,21 +573,23 @@ static void octeon_irq_ciu_disable_all_v2(struct irq_data *data)
 {
 	int cpu;
 	u64 mask;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << (cd.s.bit);
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
 
-	if (cd.s.line == 0) {
+	if (cd->line == 0) {
 		for_each_online_cpu(cpu) {
 			int index = octeon_coreid_for_cpu(cpu) * 2;
-			clear_bit(cd.s.bit, &per_cpu(octeon_irq_ciu0_en_mirror, cpu));
+			clear_bit(cd->bit,
+				&per_cpu(octeon_irq_ciu0_en_mirror, cpu));
 			cvmx_write_csr(CVMX_CIU_INTX_EN0_W1C(index), mask);
 		}
 	} else {
 		for_each_online_cpu(cpu) {
 			int index = octeon_coreid_for_cpu(cpu) * 2 + 1;
-			clear_bit(cd.s.bit, &per_cpu(octeon_irq_ciu1_en_mirror, cpu));
+			clear_bit(cd->bit,
+				&per_cpu(octeon_irq_ciu1_en_mirror, cpu));
 			cvmx_write_csr(CVMX_CIU_INTX_EN1_W1C(index), mask);
 		}
 	}
@@ -514,21 +603,23 @@ static void octeon_irq_ciu_enable_all_v2(struct irq_data *data)
 {
 	int cpu;
 	u64 mask;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << (cd.s.bit);
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
 
-	if (cd.s.line == 0) {
+	if (cd->line == 0) {
 		for_each_online_cpu(cpu) {
 			int index = octeon_coreid_for_cpu(cpu) * 2;
-			set_bit(cd.s.bit, &per_cpu(octeon_irq_ciu0_en_mirror, cpu));
+			set_bit(cd->bit,
+				&per_cpu(octeon_irq_ciu0_en_mirror, cpu));
 			cvmx_write_csr(CVMX_CIU_INTX_EN0_W1S(index), mask);
 		}
 	} else {
 		for_each_online_cpu(cpu) {
 			int index = octeon_coreid_for_cpu(cpu) * 2 + 1;
-			set_bit(cd.s.bit, &per_cpu(octeon_irq_ciu1_en_mirror, cpu));
+			set_bit(cd->bit,
+				&per_cpu(octeon_irq_ciu1_en_mirror, cpu));
 			cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(index), mask);
 		}
 	}
@@ -537,10 +628,10 @@ static void octeon_irq_ciu_enable_all_v2(struct irq_data *data)
 static void octeon_irq_gpio_setup(struct irq_data *data)
 {
 	union cvmx_gpio_bit_cfgx cfg;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 	u32 t = irqd_get_trigger_type(data);
 
-	cd.p = irq_data_get_irq_chip_data(data);
+	cd = irq_data_get_irq_chip_data(data);
 
 	cfg.u64 = 0;
 	cfg.s.int_en = 1;
@@ -551,7 +642,7 @@ static void octeon_irq_gpio_setup(struct irq_data *data)
 	cfg.s.fil_cnt = 7;
 	cfg.s.fil_sel = 3;
 
-	cvmx_write_csr(CVMX_GPIO_BIT_CFGX(cd.s.gpio_line), cfg.u64);
+	cvmx_write_csr(CVMX_GPIO_BIT_CFGX(cd->gpio_line), cfg.u64);
 }
 
 static void octeon_irq_ciu_enable_gpio_v2(struct irq_data *data)
@@ -576,36 +667,36 @@ static int octeon_irq_ciu_gpio_set_type(struct irq_data *data, unsigned int t)
 
 static void octeon_irq_ciu_disable_gpio_v2(struct irq_data *data)
 {
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	cvmx_write_csr(CVMX_GPIO_BIT_CFGX(cd.s.gpio_line), 0);
+	cd = irq_data_get_irq_chip_data(data);
+	cvmx_write_csr(CVMX_GPIO_BIT_CFGX(cd->gpio_line), 0);
 
 	octeon_irq_ciu_disable_all_v2(data);
 }
 
 static void octeon_irq_ciu_disable_gpio(struct irq_data *data)
 {
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	cvmx_write_csr(CVMX_GPIO_BIT_CFGX(cd.s.gpio_line), 0);
+	cd = irq_data_get_irq_chip_data(data);
+	cvmx_write_csr(CVMX_GPIO_BIT_CFGX(cd->gpio_line), 0);
 
 	octeon_irq_ciu_disable_all(data);
 }
 
 static void octeon_irq_ciu_gpio_ack(struct irq_data *data)
 {
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 	u64 mask;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << (cd.s.gpio_line);
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->gpio_line);
 
 	cvmx_write_csr(CVMX_GPIO_INT_CLR, mask);
 }
 
-static void octeon_irq_handle_gpio(unsigned int irq, struct irq_desc *desc)
+static void octeon_irq_handle_trigger(unsigned int irq, struct irq_desc *desc)
 {
 	if (irq_get_trigger_type(irq) & IRQ_TYPE_EDGE_BOTH)
 		handle_edge_irq(irq, desc);
@@ -644,11 +735,11 @@ static int octeon_irq_ciu_set_affinity(struct irq_data *data,
 	int cpu;
 	bool enable_one = !irqd_irq_disabled(data) && !irqd_irq_masked(data);
 	unsigned long flags;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 	unsigned long *pen;
 	raw_spinlock_t *lock;
 
-	cd.p = irq_data_get_irq_chip_data(data);
+	cd = irq_data_get_irq_chip_data(data);
 
 	/*
 	 * For non-v2 CIU, we will allow only single CPU affinity.
@@ -668,16 +759,16 @@ static int octeon_irq_ciu_set_affinity(struct irq_data *data,
 		lock = &per_cpu(octeon_irq_ciu_spinlock, cpu);
 		raw_spin_lock_irqsave(lock, flags);
 
-		if (cd.s.line == 0)
+		if (cd->line == 0)
 			pen = &per_cpu(octeon_irq_ciu0_en_mirror, cpu);
 		else
 			pen = &per_cpu(octeon_irq_ciu1_en_mirror, cpu);
 
 		if (cpumask_test_cpu(cpu, dest) && enable_one) {
 			enable_one = 0;
-			__set_bit(cd.s.bit, pen);
+			__set_bit(cd->bit, pen);
 		} else {
-			__clear_bit(cd.s.bit, pen);
+			__clear_bit(cd->bit, pen);
 		}
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
@@ -685,7 +776,7 @@ static int octeon_irq_ciu_set_affinity(struct irq_data *data,
 		 */
 		wmb();
 
-		if (cd.s.line == 0)
+		if (cd->line == 0)
 			cvmx_write_csr(CVMX_CIU_INTX_EN0(coreid * 2), *pen);
 		else
 			cvmx_write_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1), *pen);
@@ -706,24 +797,24 @@ static int octeon_irq_ciu_set_affinity_v2(struct irq_data *data,
 	int cpu;
 	bool enable_one = !irqd_irq_disabled(data) && !irqd_irq_masked(data);
 	u64 mask;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
 	if (!enable_one)
 		return 0;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << cd.s.bit;
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << cd->bit;
 
-	if (cd.s.line == 0) {
+	if (cd->line == 0) {
 		for_each_online_cpu(cpu) {
 			unsigned long *pen = &per_cpu(octeon_irq_ciu0_en_mirror, cpu);
 			int index = octeon_coreid_for_cpu(cpu) * 2;
 			if (cpumask_test_cpu(cpu, dest) && enable_one) {
 				enable_one = false;
-				set_bit(cd.s.bit, pen);
+				set_bit(cd->bit, pen);
 				cvmx_write_csr(CVMX_CIU_INTX_EN0_W1S(index), mask);
 			} else {
-				clear_bit(cd.s.bit, pen);
+				clear_bit(cd->bit, pen);
 				cvmx_write_csr(CVMX_CIU_INTX_EN0_W1C(index), mask);
 			}
 		}
@@ -733,16 +824,44 @@ static int octeon_irq_ciu_set_affinity_v2(struct irq_data *data,
 			int index = octeon_coreid_for_cpu(cpu) * 2 + 1;
 			if (cpumask_test_cpu(cpu, dest) && enable_one) {
 				enable_one = false;
-				set_bit(cd.s.bit, pen);
+				set_bit(cd->bit, pen);
 				cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(index), mask);
 			} else {
-				clear_bit(cd.s.bit, pen);
+				clear_bit(cd->bit, pen);
 				cvmx_write_csr(CVMX_CIU_INTX_EN1_W1C(index), mask);
 			}
 		}
 	}
 	return 0;
 }
+
+static int octeon_irq_ciu_set_affinity_sum2(struct irq_data *data,
+					    const struct cpumask *dest,
+					    bool force)
+{
+	int cpu;
+	bool enable_one = !irqd_irq_disabled(data) && !irqd_irq_masked(data);
+	u64 mask;
+	struct octeon_ciu_chip_data *cd;
+
+	if (!enable_one)
+		return 0;
+
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << cd->bit;
+
+	for_each_online_cpu(cpu) {
+		int index = octeon_coreid_for_cpu(cpu);
+
+		if (cpumask_test_cpu(cpu, dest) && enable_one) {
+			enable_one = false;
+			cvmx_write_csr(CVMX_CIU_EN2_PPX_IP4_W1S(index), mask);
+		} else {
+			cvmx_write_csr(CVMX_CIU_EN2_PPX_IP4_W1C(index), mask);
+		}
+	}
+	return 0;
+}
 #endif
 
 /*
@@ -773,6 +892,34 @@ static struct irq_chip octeon_irq_chip_ciu_v2_edge = {
 #endif
 };
 
+/*
+ * Newer octeon chips have support for lockless CIU operation.
+ */
+static struct irq_chip octeon_irq_chip_ciu_sum2 = {
+	.name = "CIU",
+	.irq_enable = octeon_irq_ciu_enable_sum2,
+	.irq_disable = octeon_irq_ciu_disable_all_sum2,
+	.irq_mask = octeon_irq_ciu_disable_local_sum2,
+	.irq_unmask = octeon_irq_ciu_enable_sum2,
+#ifdef CONFIG_SMP
+	.irq_set_affinity = octeon_irq_ciu_set_affinity_sum2,
+	.irq_cpu_offline = octeon_irq_cpu_offline_ciu,
+#endif
+};
+
+static struct irq_chip octeon_irq_chip_ciu_sum2_edge = {
+	.name = "CIU",
+	.irq_enable = octeon_irq_ciu_enable_sum2,
+	.irq_disable = octeon_irq_ciu_disable_all_sum2,
+	.irq_ack = octeon_irq_ciu_ack_sum2,
+	.irq_mask = octeon_irq_ciu_disable_local_sum2,
+	.irq_unmask = octeon_irq_ciu_enable_sum2,
+#ifdef CONFIG_SMP
+	.irq_set_affinity = octeon_irq_ciu_set_affinity_sum2,
+	.irq_cpu_offline = octeon_irq_cpu_offline_ciu,
+#endif
+};
+
 static struct irq_chip octeon_irq_chip_ciu = {
 	.name = "CIU",
 	.irq_enable = octeon_irq_ciu_enable,
@@ -994,11 +1141,12 @@ static int octeon_irq_ciu_xlat(struct irq_domain *d,
 			       unsigned int *out_type)
 {
 	unsigned int ciu, bit;
+	struct octeon_irq_ciu_domain_data *dd = d->host_data;
 
 	ciu = intspec[0];
 	bit = intspec[1];
 
-	if (ciu > 1 || bit > 63)
+	if (ciu >= dd->num_sum || bit > 63)
 		return -EINVAL;
 
 	*out_hwirq = (ciu << 6) | bit;
@@ -1024,8 +1172,10 @@ static bool octeon_irq_virq_in_range(unsigned int virq)
 static int octeon_irq_ciu_map(struct irq_domain *d,
 			      unsigned int virq, irq_hw_number_t hw)
 {
+	int rv;
 	unsigned int line = hw >> 6;
 	unsigned int bit = hw & 63;
+	struct octeon_irq_ciu_domain_data *dd = d->host_data;
 
 	if (!octeon_irq_virq_in_range(virq))
 		return -EINVAL;
@@ -1034,54 +1184,61 @@ static int octeon_irq_ciu_map(struct irq_domain *d,
 	if (line == 0 && bit >= 16 && bit <32)
 		return 0;
 
-	if (line > 1 || octeon_irq_ciu_to_irq[line][bit] != 0)
+	if (line >= dd->num_sum || octeon_irq_ciu_to_irq[line][bit] != 0)
 		return -EINVAL;
 
-	if (octeon_irq_ciu_is_edge(line, bit))
-		octeon_irq_set_ciu_mapping(virq, line, bit, 0,
-					   octeon_irq_ciu_chip_edge,
-					   handle_edge_irq);
-	else
-		octeon_irq_set_ciu_mapping(virq, line, bit, 0,
-					   octeon_irq_ciu_chip,
-					   handle_level_irq);
-
-	return 0;
+	if (line == 2) {
+		if (octeon_irq_ciu_is_edge(line, bit))
+			rv = octeon_irq_set_ciu_mapping(virq, line, bit, 0,
+				&octeon_irq_chip_ciu_sum2_edge,
+				handle_edge_irq);
+		else
+			rv = octeon_irq_set_ciu_mapping(virq, line, bit, 0,
+				&octeon_irq_chip_ciu_sum2,
+				handle_level_irq);
+	} else {
+		if (octeon_irq_ciu_is_edge(line, bit))
+			rv = octeon_irq_set_ciu_mapping(virq, line, bit, 0,
+				octeon_irq_ciu_chip_edge,
+				handle_edge_irq);
+		else
+			rv = octeon_irq_set_ciu_mapping(virq, line, bit, 0,
+				octeon_irq_ciu_chip,
+				handle_level_irq);
+	}
+	return rv;
 }
 
-static int octeon_irq_gpio_map_common(struct irq_domain *d,
-				      unsigned int virq, irq_hw_number_t hw,
-				      int line_limit, struct irq_chip *chip)
+static int octeon_irq_gpio_map(struct irq_domain *d,
+			       unsigned int virq, irq_hw_number_t hw)
 {
 	struct octeon_irq_gpio_domain_data *gpiod = d->host_data;
 	unsigned int line, bit;
+	int r;
 
 	if (!octeon_irq_virq_in_range(virq))
 		return -EINVAL;
 
 	line = (hw + gpiod->base_hwirq) >> 6;
 	bit = (hw + gpiod->base_hwirq) & 63;
-	if (line > line_limit || octeon_irq_ciu_to_irq[line][bit] != 0)
+	if (line > ARRAY_SIZE(octeon_irq_ciu_to_irq) ||
+		octeon_irq_ciu_to_irq[line][bit] != 0)
 		return -EINVAL;
 
-	octeon_irq_set_ciu_mapping(virq, line, bit, hw,
-				   chip, octeon_irq_handle_gpio);
-	return 0;
-}
-
-static int octeon_irq_gpio_map(struct irq_domain *d,
-			       unsigned int virq, irq_hw_number_t hw)
-{
-	return octeon_irq_gpio_map_common(d, virq, hw, 1, octeon_irq_gpio_chip);
+	r = octeon_irq_set_ciu_mapping(virq, line, bit, hw,
+		octeon_irq_gpio_chip, octeon_irq_handle_trigger);
+	return r;
 }
 
 static struct irq_domain_ops octeon_irq_domain_ciu_ops = {
 	.map = octeon_irq_ciu_map,
+	.unmap = octeon_irq_free_cd,
 	.xlate = octeon_irq_ciu_xlat,
 };
 
 static struct irq_domain_ops octeon_irq_domain_gpio_ops = {
 	.map = octeon_irq_gpio_map,
+	.unmap = octeon_irq_free_cd,
 	.xlate = octeon_irq_gpio_xlat,
 };
 
@@ -1120,6 +1277,26 @@ static void octeon_irq_ip3_ciu(void)
 	}
 }
 
+static void octeon_irq_ip4_ciu(void)
+{
+	int coreid = cvmx_get_core_num();
+	u64 ciu_sum = cvmx_read_csr(CVMX_CIU_SUM2_PPX_IP4(coreid));
+	u64 ciu_en = cvmx_read_csr(CVMX_CIU_EN2_PPX_IP4(coreid));
+
+	ciu_sum &= ciu_en;
+	if (likely(ciu_sum)) {
+		int bit = fls64(ciu_sum) - 1;
+		int irq = octeon_irq_ciu_to_irq[2][bit];
+
+		if (likely(irq))
+			do_IRQ(irq);
+		else
+			spurious_interrupt();
+	} else {
+		spurious_interrupt();
+	}
+}
+
 static bool octeon_irq_use_ip4;
 
 static void octeon_irq_local_enable_ip4(void *arg)
@@ -1201,7 +1378,10 @@ static void octeon_irq_setup_secondary_ciu(void)
 
 	/* Enable the CIU lines */
 	set_c0_status(STATUSF_IP3 | STATUSF_IP2);
-	clear_c0_status(STATUSF_IP4);
+	if (octeon_irq_use_ip4)
+		set_c0_status(STATUSF_IP4);
+	else
+		clear_c0_status(STATUSF_IP4);
 }
 
 static void octeon_irq_setup_secondary_ciu2(void)
@@ -1217,22 +1397,36 @@ static void octeon_irq_setup_secondary_ciu2(void)
 		clear_c0_status(STATUSF_IP4);
 }
 
-static void __init octeon_irq_init_ciu(void)
+static int __init octeon_irq_init_ciu(
+	struct device_node *ciu_node, struct device_node *parent)
 {
-	unsigned int i;
+	unsigned int i, r;
 	struct irq_chip *chip;
 	struct irq_chip *chip_edge;
 	struct irq_chip *chip_mbox;
 	struct irq_chip *chip_wd;
-	struct device_node *gpio_node;
-	struct device_node *ciu_node;
 	struct irq_domain *ciu_domain = NULL;
+	struct octeon_irq_ciu_domain_data *dd;
+
+	dd = kzalloc(sizeof(*dd), GFP_KERNEL);
+	if (!dd)
+		return -ENOMEM;
 
 	octeon_irq_init_ciu_percpu();
 	octeon_irq_setup_secondary = octeon_irq_setup_secondary_ciu;
 
 	octeon_irq_ip2 = octeon_irq_ip2_ciu;
 	octeon_irq_ip3 = octeon_irq_ip3_ciu;
+	if ((OCTEON_IS_OCTEON2() || OCTEON_IS_OCTEON3())
+		&& !OCTEON_IS_MODEL(OCTEON_CN63XX)) {
+		octeon_irq_ip4 =  octeon_irq_ip4_ciu;
+		dd->num_sum = 3;
+		octeon_irq_use_ip4 = true;
+	} else {
+		octeon_irq_ip4 = octeon_irq_ip4_mask;
+		dd->num_sum = 2;
+		octeon_irq_use_ip4 = false;
+	}
 	if (OCTEON_IS_MODEL(OCTEON_CN58XX_PASS2_X) ||
 	    OCTEON_IS_MODEL(OCTEON_CN56XX_PASS2_X) ||
 	    OCTEON_IS_MODEL(OCTEON_CN52XX_PASS2_X) ||
@@ -1251,65 +1445,146 @@ static void __init octeon_irq_init_ciu(void)
 	}
 	octeon_irq_ciu_chip = chip;
 	octeon_irq_ciu_chip_edge = chip_edge;
-	octeon_irq_ip4 = octeon_irq_ip4_mask;
 
 	/* Mips internal */
 	octeon_irq_init_core();
 
-	gpio_node = of_find_compatible_node(NULL, NULL, "cavium,octeon-3860-gpio");
-	if (gpio_node) {
-		struct octeon_irq_gpio_domain_data *gpiod;
-
-		gpiod = kzalloc(sizeof(*gpiod), GFP_KERNEL);
-		if (gpiod) {
-			/* gpio domain host_data is the base hwirq number. */
-			gpiod->base_hwirq = 16;
-			irq_domain_add_linear(gpio_node, 16, &octeon_irq_domain_gpio_ops, gpiod);
-			of_node_put(gpio_node);
-		} else
-			pr_warn("Cannot allocate memory for GPIO irq_domain.\n");
-	} else
-		pr_warn("Cannot find device node for cavium,octeon-3860-gpio.\n");
-
-	ciu_node = of_find_compatible_node(NULL, NULL, "cavium,octeon-3860-ciu");
-	if (ciu_node) {
-		ciu_domain = irq_domain_add_tree(ciu_node, &octeon_irq_domain_ciu_ops, NULL);
-		irq_set_default_host(ciu_domain);
-		of_node_put(ciu_node);
-	} else
-		panic("Cannot find device node for cavium,octeon-3860-ciu.");
+	ciu_domain = irq_domain_add_tree(
+		ciu_node, &octeon_irq_domain_ciu_ops, dd);
+	irq_set_default_host(ciu_domain);
 
 	/* CIU_0 */
-	for (i = 0; i < 16; i++)
-		octeon_irq_force_ciu_mapping(ciu_domain, i + OCTEON_IRQ_WORKQ0, 0, i + 0);
+	for (i = 0; i < 16; i++) {
+		r = octeon_irq_force_ciu_mapping(
+			ciu_domain, i + OCTEON_IRQ_WORKQ0, 0, i + 0);
+		if (r)
+			goto err;
+	}
+
+	r = octeon_irq_set_ciu_mapping(
+		OCTEON_IRQ_MBOX0, 0, 32, 0, chip_mbox, handle_percpu_irq);
+	if (r)
+		goto err;
+	r = octeon_irq_set_ciu_mapping(
+		OCTEON_IRQ_MBOX1, 0, 33, 0, chip_mbox, handle_percpu_irq);
+	if (r)
+		goto err;
+
+	for (i = 0; i < 4; i++) {
+		r = octeon_irq_force_ciu_mapping(
+			ciu_domain, i + OCTEON_IRQ_PCI_INT0, 0, i + 36);
+		if (r)
+			goto err;
+	}
+	for (i = 0; i < 4; i++) {
+		r = octeon_irq_force_ciu_mapping(
+			ciu_domain, i + OCTEON_IRQ_PCI_MSI0, 0, i + 40);
+		if (r)
+			goto err;
+	}
 
-	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX0, 0, 32, 0, chip_mbox, handle_percpu_irq);
-	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX1, 0, 33, 0, chip_mbox, handle_percpu_irq);
+	r = octeon_irq_force_ciu_mapping(ciu_domain, OCTEON_IRQ_TWSI, 0, 45);
+	if (r)
+		goto err;
 
-	for (i = 0; i < 4; i++)
-		octeon_irq_force_ciu_mapping(ciu_domain, i + OCTEON_IRQ_PCI_INT0, 0, i + 36);
-	for (i = 0; i < 4; i++)
-		octeon_irq_force_ciu_mapping(ciu_domain, i + OCTEON_IRQ_PCI_MSI0, 0, i + 40);
+	r = octeon_irq_force_ciu_mapping(ciu_domain, OCTEON_IRQ_RML, 0, 46);
+	if (r)
+		goto err;
 
-	octeon_irq_force_ciu_mapping(ciu_domain, OCTEON_IRQ_TWSI, 0, 45);
-	octeon_irq_force_ciu_mapping(ciu_domain, OCTEON_IRQ_RML, 0, 46);
-	for (i = 0; i < 4; i++)
-		octeon_irq_force_ciu_mapping(ciu_domain, i + OCTEON_IRQ_TIMER0, 0, i + 52);
+	for (i = 0; i < 4; i++) {
+		r = octeon_irq_force_ciu_mapping(
+			ciu_domain, i + OCTEON_IRQ_TIMER0, 0, i + 52);
+		if (r)
+			goto err;
+	}
+
+	r = octeon_irq_force_ciu_mapping(ciu_domain, OCTEON_IRQ_USB0, 0, 56);
+	if (r)
+		goto err;
 
-	octeon_irq_force_ciu_mapping(ciu_domain, OCTEON_IRQ_USB0, 0, 56);
-	octeon_irq_force_ciu_mapping(ciu_domain, OCTEON_IRQ_TWSI2, 0, 59);
+	r = octeon_irq_force_ciu_mapping(ciu_domain, OCTEON_IRQ_TWSI2, 0, 59);
+	if (r)
+		goto err;
 
 	/* CIU_1 */
-	for (i = 0; i < 16; i++)
-		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_WDOG0, 1, i + 0, 0, chip_wd, handle_level_irq);
+	for (i = 0; i < 16; i++) {
+		r = octeon_irq_set_ciu_mapping(
+			i + OCTEON_IRQ_WDOG0, 1, i + 0, 0, chip_wd,
+			handle_level_irq);
+		if (r)
+			goto err;
+	}
 
-	octeon_irq_force_ciu_mapping(ciu_domain, OCTEON_IRQ_USB1, 1, 17);
+	r = octeon_irq_force_ciu_mapping(ciu_domain, OCTEON_IRQ_USB1, 1, 17);
+	if (r)
+		goto err;
 
 	/* Enable the CIU lines */
 	set_c0_status(STATUSF_IP3 | STATUSF_IP2);
-	clear_c0_status(STATUSF_IP4);
+	if (octeon_irq_use_ip4)
+		set_c0_status(STATUSF_IP4);
+	else
+		clear_c0_status(STATUSF_IP4);
+
+	return 0;
+err:
+	return r;
 }
 
+static int __init octeon_irq_init_gpio(
+	struct device_node *gpio_node, struct device_node *parent)
+{
+	struct octeon_irq_gpio_domain_data *gpiod;
+	u32 interrupt_cells;
+	unsigned int base_hwirq;
+	int r;
+
+	r = of_property_read_u32(parent, "#interrupt-cells", &interrupt_cells);
+	if (r)
+		return r;
+
+	if (interrupt_cells == 1) {
+		u32 v;
+
+		r = of_property_read_u32_index(gpio_node, "interrupts", 0, &v);
+		if (r) {
+			pr_warn("No \"interrupts\" property.\n");
+			return r;
+		}
+		base_hwirq = v;
+	} else if (interrupt_cells == 2) {
+		u32 v0, v1;
+
+		r = of_property_read_u32_index(gpio_node, "interrupts", 0, &v0);
+		if (r) {
+			pr_warn("No \"interrupts\" property.\n");
+			return r;
+		}
+		r = of_property_read_u32_index(gpio_node, "interrupts", 1, &v1);
+		if (r) {
+			pr_warn("No \"interrupts\" property.\n");
+			return r;
+		}
+		base_hwirq = (v0 << 6) | v1;
+	} else {
+		pr_warn("Bad \"#interrupt-cells\" property: %u\n",
+			interrupt_cells);
+		return -EINVAL;
+	}
+
+	gpiod = kzalloc(sizeof(*gpiod), GFP_KERNEL);
+	if (gpiod) {
+		/* gpio domain host_data is the base hwirq number. */
+		gpiod->base_hwirq = base_hwirq;
+		irq_domain_add_linear(
+			gpio_node, 16, &octeon_irq_domain_gpio_ops, gpiod);
+	} else {
+		pr_warn("Cannot allocate memory for GPIO irq_domain.\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
 /*
  * Watchdog interrupts are special.  They are associated with a single
  * core, so we hardwire the affinity to that core.
@@ -1319,12 +1594,13 @@ static void octeon_irq_ciu2_wd_enable(struct irq_data *data)
 	u64 mask;
 	u64 en_addr;
 	int coreid = data->irq - OCTEON_IRQ_WDOG0;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << (cd.s.bit);
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
 
-	en_addr = CVMX_CIU2_EN_PPX_IP2_WRKQ_W1S(coreid) + (0x1000ull * cd.s.line);
+	en_addr = CVMX_CIU2_EN_PPX_IP2_WRKQ_W1S(coreid) +
+		(0x1000ull * cd->line);
 	cvmx_write_csr(en_addr, mask);
 
 }
@@ -1335,12 +1611,13 @@ static void octeon_irq_ciu2_enable(struct irq_data *data)
 	u64 en_addr;
 	int cpu = next_cpu_for_irq(data);
 	int coreid = octeon_coreid_for_cpu(cpu);
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << (cd.s.bit);
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
 
-	en_addr = CVMX_CIU2_EN_PPX_IP2_WRKQ_W1S(coreid) + (0x1000ull * cd.s.line);
+	en_addr = CVMX_CIU2_EN_PPX_IP2_WRKQ_W1S(coreid) +
+		(0x1000ull * cd->line);
 	cvmx_write_csr(en_addr, mask);
 }
 
@@ -1349,12 +1626,13 @@ static void octeon_irq_ciu2_enable_local(struct irq_data *data)
 	u64 mask;
 	u64 en_addr;
 	int coreid = cvmx_get_core_num();
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << (cd.s.bit);
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
 
-	en_addr = CVMX_CIU2_EN_PPX_IP2_WRKQ_W1S(coreid) + (0x1000ull * cd.s.line);
+	en_addr = CVMX_CIU2_EN_PPX_IP2_WRKQ_W1S(coreid) +
+		(0x1000ull * cd->line);
 	cvmx_write_csr(en_addr, mask);
 
 }
@@ -1364,12 +1642,13 @@ static void octeon_irq_ciu2_disable_local(struct irq_data *data)
 	u64 mask;
 	u64 en_addr;
 	int coreid = cvmx_get_core_num();
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << (cd.s.bit);
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
 
-	en_addr = CVMX_CIU2_EN_PPX_IP2_WRKQ_W1C(coreid) + (0x1000ull * cd.s.line);
+	en_addr = CVMX_CIU2_EN_PPX_IP2_WRKQ_W1C(coreid) +
+		(0x1000ull * cd->line);
 	cvmx_write_csr(en_addr, mask);
 
 }
@@ -1379,12 +1658,12 @@ static void octeon_irq_ciu2_ack(struct irq_data *data)
 	u64 mask;
 	u64 en_addr;
 	int coreid = cvmx_get_core_num();
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << (cd.s.bit);
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
 
-	en_addr = CVMX_CIU2_RAW_PPX_IP2_WRKQ(coreid) + (0x1000ull * cd.s.line);
+	en_addr = CVMX_CIU2_RAW_PPX_IP2_WRKQ(coreid) + (0x1000ull * cd->line);
 	cvmx_write_csr(en_addr, mask);
 
 }
@@ -1393,13 +1672,14 @@ static void octeon_irq_ciu2_disable_all(struct irq_data *data)
 {
 	int cpu;
 	u64 mask;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << (cd.s.bit);
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd->bit);
 
 	for_each_online_cpu(cpu) {
-		u64 en_addr = CVMX_CIU2_EN_PPX_IP2_WRKQ_W1C(octeon_coreid_for_cpu(cpu)) + (0x1000ull * cd.s.line);
+		u64 en_addr = CVMX_CIU2_EN_PPX_IP2_WRKQ_W1C(
+			octeon_coreid_for_cpu(cpu)) + (0x1000ull * cd->line);
 		cvmx_write_csr(en_addr, mask);
 	}
 }
@@ -1412,7 +1692,8 @@ static void octeon_irq_ciu2_mbox_enable_all(struct irq_data *data)
 	mask = 1ull << (data->irq - OCTEON_IRQ_MBOX0);
 
 	for_each_online_cpu(cpu) {
-		u64 en_addr = CVMX_CIU2_EN_PPX_IP3_MBOX_W1S(octeon_coreid_for_cpu(cpu));
+		u64 en_addr = CVMX_CIU2_EN_PPX_IP3_MBOX_W1S(
+			octeon_coreid_for_cpu(cpu));
 		cvmx_write_csr(en_addr, mask);
 	}
 }
@@ -1425,7 +1706,8 @@ static void octeon_irq_ciu2_mbox_disable_all(struct irq_data *data)
 	mask = 1ull << (data->irq - OCTEON_IRQ_MBOX0);
 
 	for_each_online_cpu(cpu) {
-		u64 en_addr = CVMX_CIU2_EN_PPX_IP3_MBOX_W1C(octeon_coreid_for_cpu(cpu));
+		u64 en_addr = CVMX_CIU2_EN_PPX_IP3_MBOX_W1C(
+			octeon_coreid_for_cpu(cpu));
 		cvmx_write_csr(en_addr, mask);
 	}
 }
@@ -1459,21 +1741,25 @@ static int octeon_irq_ciu2_set_affinity(struct irq_data *data,
 	int cpu;
 	bool enable_one = !irqd_irq_disabled(data) && !irqd_irq_masked(data);
 	u64 mask;
-	union octeon_ciu_chip_data cd;
+	struct octeon_ciu_chip_data *cd;
 
 	if (!enable_one)
 		return 0;
 
-	cd.p = irq_data_get_irq_chip_data(data);
-	mask = 1ull << cd.s.bit;
+	cd = irq_data_get_irq_chip_data(data);
+	mask = 1ull << cd->bit;
 
 	for_each_online_cpu(cpu) {
 		u64 en_addr;
 		if (cpumask_test_cpu(cpu, dest) && enable_one) {
 			enable_one = false;
-			en_addr = CVMX_CIU2_EN_PPX_IP2_WRKQ_W1S(octeon_coreid_for_cpu(cpu)) + (0x1000ull * cd.s.line);
+			en_addr = CVMX_CIU2_EN_PPX_IP2_WRKQ_W1S(
+				octeon_coreid_for_cpu(cpu)) +
+				(0x1000ull * cd->line);
 		} else {
-			en_addr = CVMX_CIU2_EN_PPX_IP2_WRKQ_W1C(octeon_coreid_for_cpu(cpu)) + (0x1000ull * cd.s.line);
+			en_addr = CVMX_CIU2_EN_PPX_IP2_WRKQ_W1C(
+				octeon_coreid_for_cpu(cpu)) +
+				(0x1000ull * cd->line);
 		}
 		cvmx_write_csr(en_addr, mask);
 	}
@@ -1490,10 +1776,11 @@ static void octeon_irq_ciu2_enable_gpio(struct irq_data *data)
 
 static void octeon_irq_ciu2_disable_gpio(struct irq_data *data)
 {
-	union octeon_ciu_chip_data cd;
-	cd.p = irq_data_get_irq_chip_data(data);
+	struct octeon_ciu_chip_data *cd;
 
-	cvmx_write_csr(CVMX_GPIO_BIT_CFGX(cd.s.gpio_line), 0);
+	cd = irq_data_get_irq_chip_data(data);
+
+	cvmx_write_csr(CVMX_GPIO_BIT_CFGX(cd->gpio_line), 0);
 
 	octeon_irq_ciu2_disable_all(data);
 }
@@ -1632,22 +1919,13 @@ static int octeon_irq_ciu2_map(struct irq_domain *d,
 
 	return 0;
 }
-static int octeon_irq_ciu2_gpio_map(struct irq_domain *d,
-				    unsigned int virq, irq_hw_number_t hw)
-{
-	return octeon_irq_gpio_map_common(d, virq, hw, 7, &octeon_irq_chip_ciu2_gpio);
-}
 
 static struct irq_domain_ops octeon_irq_domain_ciu2_ops = {
 	.map = octeon_irq_ciu2_map,
+	.unmap = octeon_irq_free_cd,
 	.xlate = octeon_irq_ciu2_xlat,
 };
 
-static struct irq_domain_ops octeon_irq_domain_ciu2_gpio_ops = {
-	.map = octeon_irq_ciu2_gpio_map,
-	.xlate = octeon_irq_gpio_xlat,
-};
-
 static void octeon_irq_ciu2(void)
 {
 	int line;
@@ -1715,16 +1993,16 @@ out:
 	return;
 }
 
-static void __init octeon_irq_init_ciu2(void)
+static int __init octeon_irq_init_ciu2(
+	struct device_node *ciu_node, struct device_node *parent)
 {
-	unsigned int i;
-	struct device_node *gpio_node;
-	struct device_node *ciu_node;
+	unsigned int i, r;
 	struct irq_domain *ciu_domain = NULL;
 
 	octeon_irq_init_ciu2_percpu();
 	octeon_irq_setup_secondary = octeon_irq_setup_secondary_ciu2;
 
+	octeon_irq_gpio_chip = &octeon_irq_chip_ciu2_gpio;
 	octeon_irq_ip2 = octeon_irq_ciu2;
 	octeon_irq_ip3 = octeon_irq_ciu2_mbox;
 	octeon_irq_ip4 = octeon_irq_ip4_mask;
@@ -1732,47 +2010,49 @@ static void __init octeon_irq_init_ciu2(void)
 	/* Mips internal */
 	octeon_irq_init_core();
 
-	gpio_node = of_find_compatible_node(NULL, NULL, "cavium,octeon-3860-gpio");
-	if (gpio_node) {
-		struct octeon_irq_gpio_domain_data *gpiod;
-
-		gpiod = kzalloc(sizeof(*gpiod), GFP_KERNEL);
-		if (gpiod) {
-			/* gpio domain host_data is the base hwirq number. */
-			gpiod->base_hwirq = 7 << 6;
-			irq_domain_add_linear(gpio_node, 16, &octeon_irq_domain_ciu2_gpio_ops, gpiod);
-			of_node_put(gpio_node);
-		} else
-			pr_warn("Cannot allocate memory for GPIO irq_domain.\n");
-	} else
-		pr_warn("Cannot find device node for cavium,octeon-3860-gpio.\n");
-
-	ciu_node = of_find_compatible_node(NULL, NULL, "cavium,octeon-6880-ciu2");
-	if (ciu_node) {
-		ciu_domain = irq_domain_add_tree(ciu_node, &octeon_irq_domain_ciu2_ops, NULL);
-		irq_set_default_host(ciu_domain);
-		of_node_put(ciu_node);
-	} else
-		panic("Cannot find device node for cavium,octeon-6880-ciu2.");
+	ciu_domain = irq_domain_add_tree(
+		ciu_node, &octeon_irq_domain_ciu2_ops, NULL);
+	irq_set_default_host(ciu_domain);
 
 	/* CUI2 */
-	for (i = 0; i < 64; i++)
-		octeon_irq_force_ciu_mapping(ciu_domain, i + OCTEON_IRQ_WORKQ0, 0, i);
+	for (i = 0; i < 64; i++) {
+		r = octeon_irq_force_ciu_mapping(
+			ciu_domain, i + OCTEON_IRQ_WORKQ0, 0, i);
+		if (r)
+			goto err;
+	}
 
-	for (i = 0; i < 32; i++)
-		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_WDOG0, 1, i, 0,
-					   &octeon_irq_chip_ciu2_wd, handle_level_irq);
+	for (i = 0; i < 32; i++) {
+		r = octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_WDOG0, 1, i, 0,
+			&octeon_irq_chip_ciu2_wd, handle_level_irq);
+		if (r)
+			goto err;
+	}
 
-	for (i = 0; i < 4; i++)
-		octeon_irq_force_ciu_mapping(ciu_domain, i + OCTEON_IRQ_TIMER0, 3, i + 8);
+	for (i = 0; i < 4; i++) {
+		r = octeon_irq_force_ciu_mapping(
+			ciu_domain, i + OCTEON_IRQ_TIMER0, 3, i + 8);
+		if (r)
+			goto err;
+	}
 
-	octeon_irq_force_ciu_mapping(ciu_domain, OCTEON_IRQ_USB0, 3, 44);
+	r = octeon_irq_force_ciu_mapping(ciu_domain, OCTEON_IRQ_USB0, 3, 44);
+	if (r)
+		goto err;
 
-	for (i = 0; i < 4; i++)
-		octeon_irq_force_ciu_mapping(ciu_domain, i + OCTEON_IRQ_PCI_INT0, 4, i);
+	for (i = 0; i < 4; i++) {
+		r = octeon_irq_force_ciu_mapping(
+			ciu_domain, i + OCTEON_IRQ_PCI_INT0, 4, i);
+		if (r)
+			goto err;
+	}
 
-	for (i = 0; i < 4; i++)
-		octeon_irq_force_ciu_mapping(ciu_domain, i + OCTEON_IRQ_PCI_MSI0, 4, i + 8);
+	for (i = 0; i < 4; i++) {
+		r = octeon_irq_force_ciu_mapping(
+			ciu_domain, i + OCTEON_IRQ_PCI_MSI0, 4, i + 8);
+		if (r)
+			goto err;
+	}
 
 	irq_set_chip_and_handler(OCTEON_IRQ_MBOX0, &octeon_irq_chip_ciu2_mbox, handle_percpu_irq);
 	irq_set_chip_and_handler(OCTEON_IRQ_MBOX1, &octeon_irq_chip_ciu2_mbox, handle_percpu_irq);
@@ -1782,8 +2062,242 @@ static void __init octeon_irq_init_ciu2(void)
 	/* Enable the CIU lines */
 	set_c0_status(STATUSF_IP3 | STATUSF_IP2);
 	clear_c0_status(STATUSF_IP4);
+	return 0;
+err:
+	return r;
+}
+
+struct octeon_irq_cib_host_data {
+	raw_spinlock_t lock;
+	u64 raw_reg;
+	u64 en_reg;
+	int max_bits;
+};
+
+struct octeon_irq_cib_chip_data {
+	struct octeon_irq_cib_host_data *host_data;
+	int bit;
+};
+
+static void octeon_irq_cib_enable(struct irq_data *data)
+{
+	unsigned long flags;
+	u64 en;
+	struct octeon_irq_cib_chip_data *cd = irq_data_get_irq_chip_data(data);
+	struct octeon_irq_cib_host_data *host_data = cd->host_data;
+
+	raw_spin_lock_irqsave(&host_data->lock, flags);
+	en = cvmx_read_csr(host_data->en_reg);
+	en |= 1ull << cd->bit;
+	cvmx_write_csr(host_data->en_reg, en);
+	raw_spin_unlock_irqrestore(&host_data->lock, flags);
 }
 
+static void octeon_irq_cib_disable(struct irq_data *data)
+{
+	unsigned long flags;
+	u64 en;
+	struct octeon_irq_cib_chip_data *cd = irq_data_get_irq_chip_data(data);
+	struct octeon_irq_cib_host_data *host_data = cd->host_data;
+
+	raw_spin_lock_irqsave(&host_data->lock, flags);
+	en = cvmx_read_csr(host_data->en_reg);
+	en &= ~(1ull << cd->bit);
+	cvmx_write_csr(host_data->en_reg, en);
+	raw_spin_unlock_irqrestore(&host_data->lock, flags);
+}
+
+static int octeon_irq_cib_set_type(struct irq_data *data, unsigned int t)
+{
+	irqd_set_trigger_type(data, t);
+	return IRQ_SET_MASK_OK;
+}
+
+static struct irq_chip octeon_irq_chip_cib = {
+	.name = "CIB",
+	.irq_enable = octeon_irq_cib_enable,
+	.irq_disable = octeon_irq_cib_disable,
+	.irq_mask = octeon_irq_cib_disable,
+	.irq_unmask = octeon_irq_cib_enable,
+	.irq_set_type = octeon_irq_cib_set_type,
+};
+
+static int octeon_irq_cib_xlat(struct irq_domain *d,
+				   struct device_node *node,
+				   const u32 *intspec,
+				   unsigned int intsize,
+				   unsigned long *out_hwirq,
+				   unsigned int *out_type)
+{
+	unsigned int type = 0;
+
+	if (intsize == 2)
+		type = intspec[1];
+
+	switch (type) {
+	case 0: /* unofficial value, but we might as well let it work. */
+	case 4: /* official value for level triggering. */
+		*out_type = IRQ_TYPE_LEVEL_HIGH;
+		break;
+	case 1: /* official value for edge triggering. */
+		*out_type = IRQ_TYPE_EDGE_RISING;
+		break;
+	default: /* Nothing else is acceptable. */
+		return -EINVAL;
+	}
+
+	*out_hwirq = intspec[0];
+
+	return 0;
+}
+
+static int octeon_irq_cib_map(struct irq_domain *d,
+			      unsigned int virq, irq_hw_number_t hw)
+{
+	struct octeon_irq_cib_host_data *host_data = d->host_data;
+	struct octeon_irq_cib_chip_data *cd;
+
+	if (hw >= host_data->max_bits) {
+		pr_err("ERROR: %s mapping %u is to big!\n",
+		       d->of_node->name, (unsigned)hw);
+		return -EINVAL;
+	}
+
+	cd = kzalloc(sizeof(*cd), GFP_KERNEL);
+	cd->host_data = host_data;
+	cd->bit = hw;
+
+	irq_set_chip_and_handler(virq, &octeon_irq_chip_cib,
+				 handle_simple_irq);
+	irq_set_chip_data(virq, cd);
+	return 0;
+}
+
+static struct irq_domain_ops octeon_irq_domain_cib_ops = {
+	.map = octeon_irq_cib_map,
+	.unmap = octeon_irq_free_cd,
+	.xlate = octeon_irq_cib_xlat,
+};
+
+/* Chain to real handler. */
+static irqreturn_t octeon_irq_cib_handler(int my_irq, void *data)
+{
+	u64 en;
+	u64 raw;
+	u64 bits;
+	int i;
+	int irq;
+	struct irq_domain *cib_domain = data;
+	struct octeon_irq_cib_host_data *host_data = cib_domain->host_data;
+
+	en = cvmx_read_csr(host_data->en_reg);
+	raw = cvmx_read_csr(host_data->raw_reg);
+
+	bits = en & raw;
+
+	for (i = 0; i < host_data->max_bits; i++) {
+		if ((bits & 1ull << i) == 0)
+			continue;
+		irq = irq_find_mapping(cib_domain, i);
+		if (!irq) {
+			unsigned long flags;
+
+			pr_err("ERROR: CIB bit %d@%llx IRQ unhandled, disabling\n",
+				i, host_data->raw_reg);
+			raw_spin_lock_irqsave(&host_data->lock, flags);
+			en = cvmx_read_csr(host_data->en_reg);
+			en &= ~(1ull << i);
+			cvmx_write_csr(host_data->en_reg, en);
+			cvmx_write_csr(host_data->raw_reg, 1ull << i);
+			raw_spin_unlock_irqrestore(&host_data->lock, flags);
+		} else {
+			struct irq_desc *desc = irq_to_desc(irq);
+			struct irq_data *irq_data = irq_desc_get_irq_data(desc);
+			/* If edge, acknowledge the bit we will be sending. */
+			if (irqd_get_trigger_type(irq_data) &
+				IRQ_TYPE_EDGE_BOTH)
+				cvmx_write_csr(host_data->raw_reg, 1ull << i);
+			generic_handle_irq_desc(irq, desc);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int __init octeon_irq_init_cib(struct device_node *ciu_node,
+				      struct device_node *parent)
+{
+	const __be32 *addr;
+	u32 val;
+	struct octeon_irq_cib_host_data *host_data;
+	int parent_irq;
+	int r;
+	struct irq_domain *cib_domain;
+
+	parent_irq = irq_of_parse_and_map(ciu_node, 0);
+	if (!parent_irq) {
+		pr_err("ERROR: Couldn't acquire parent_irq for %s\n.",
+			ciu_node->name);
+		return -EINVAL;
+	}
+
+	host_data = kzalloc(sizeof(*host_data), GFP_KERNEL);
+	raw_spin_lock_init(&host_data->lock);
+
+	addr = of_get_address(ciu_node, 0, NULL, NULL);
+	if (!addr) {
+		pr_err("ERROR: Couldn't acquire reg(0) %s\n.", ciu_node->name);
+		return -EINVAL;
+	}
+	host_data->raw_reg = (u64)phys_to_virt(
+		of_translate_address(ciu_node, addr));
+
+	addr = of_get_address(ciu_node, 1, NULL, NULL);
+	if (!addr) {
+		pr_err("ERROR: Couldn't acquire reg(1) %s\n.", ciu_node->name);
+		return -EINVAL;
+	}
+	host_data->en_reg = (u64)phys_to_virt(
+		of_translate_address(ciu_node, addr));
+
+	r = of_property_read_u32(ciu_node, "cavium,max-bits", &val);
+	if (r) {
+		pr_err("ERROR: Couldn't read cavium,max-bits from %s\n.",
+			ciu_node->name);
+		return r;
+	}
+	host_data->max_bits = val;
+
+	cib_domain = irq_domain_add_linear(ciu_node, host_data->max_bits,
+					   &octeon_irq_domain_cib_ops,
+					   host_data);
+	if (!cib_domain) {
+		pr_err("ERROR: Couldn't irq_domain_add_linear()\n.");
+		return -ENOMEM;
+	}
+
+	cvmx_write_csr(host_data->en_reg, 0); /* disable all IRQs */
+	cvmx_write_csr(host_data->raw_reg, ~0); /* ack any outstanding */
+
+	r = request_irq(parent_irq, octeon_irq_cib_handler,
+			IRQF_NO_THREAD, "cib", cib_domain);
+	if (r) {
+		pr_err("request_irq cib failed %d\n", r);
+		return r;
+	}
+	pr_info("CIB interrupt controller probed: %llx %d\n",
+		host_data->raw_reg, host_data->max_bits);
+	return 0;
+}
+
+static struct of_device_id ciu_types[] __initdata = {
+	{.compatible = "cavium,octeon-3860-ciu", .data = octeon_irq_init_ciu},
+	{.compatible = "cavium,octeon-3860-gpio", .data = octeon_irq_init_gpio},
+	{.compatible = "cavium,octeon-6880-ciu2", .data = octeon_irq_init_ciu2},
+	{.compatible = "cavium,octeon-7130-cib", .data = octeon_irq_init_cib},
+	{}
+};
+
 void __init arch_init_irq(void)
 {
 #ifdef CONFIG_SMP
@@ -1791,10 +2305,7 @@ void __init arch_init_irq(void)
 	cpumask_clear(irq_default_affinity);
 	cpumask_set_cpu(smp_processor_id(), irq_default_affinity);
 #endif
-	if (OCTEON_IS_MODEL(OCTEON_CN68XX))
-		octeon_irq_init_ciu2();
-	else
-		octeon_irq_init_ciu();
+	of_irq_init(ciu_types);
 }
 
 asmlinkage void plat_irq_dispatch(void)
@@ -1808,13 +2319,13 @@ asmlinkage void plat_irq_dispatch(void)
 		cop0_cause &= cop0_status;
 		cop0_cause &= ST0_IM;
 
-		if (unlikely(cop0_cause & STATUSF_IP2))
+		if (cop0_cause & STATUSF_IP2)
 			octeon_irq_ip2();
-		else if (unlikely(cop0_cause & STATUSF_IP3))
+		else if (cop0_cause & STATUSF_IP3)
 			octeon_irq_ip3();
-		else if (unlikely(cop0_cause & STATUSF_IP4))
+		else if (cop0_cause & STATUSF_IP4)
 			octeon_irq_ip4();
-		else if (likely(cop0_cause))
+		else if (cop0_cause)
 			do_IRQ(fls(cop0_cause) - 9 + MIPS_CPU_IRQ_BASE);
 		else
 			break;
-- 
2.2.2

