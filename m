Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaIHRsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:48:31 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60736 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753708AbaIHRr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:47:56 -0400
X-Sasl-enc: xpa0NCpq9htoeReFgdjWPkl3ax3jtih9Bv77zwDF4aBp 1410197888
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 4/8] x86, microcode, intel: add error logging to early update driver
Date: Mon,  8 Sep 2014 14:37:50 -0300
Message-Id: <1410197875-19252-5-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance the logging in the Intel early microcode update driver to
be able to report errors.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 arch/x86/kernel/cpu/microcode/intel_early.c |   94 +++++++++++++++------------
 1 file changed, 54 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index f73fc0a..8ad50d6 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -31,6 +31,12 @@
 #include <asm/tlbflush.h>
 #include <asm/setup.h>
 
+enum {
+	INTEL_EARLYMCU_NONE = 0, /* did nothing */
+	INTEL_EARLYMCU_UPDATEOK, /* microcode updated */
+	INTEL_EARLYMCU_REJECTED, /* cpu rejected it */
+};
+
 static unsigned long mc_saved_in_initrd[MAX_UCODE_COUNT];
 static struct mc_saved_data {
 	unsigned int mc_saved_count;
@@ -576,37 +582,50 @@ scan_microcode(unsigned long start, unsigned long end,
 
 /*
  * Print ucode update info.
+ * for status == INTEL_EARLYMCU_UPDATEOK, data should be the mcu date
+ * for status == INTEL_EARLYMCU_REJECTED, data should be mcu revision
  */
-static void
-print_ucode_info(struct ucode_cpu_info *uci, unsigned int date)
+static void print_ucode_info(const unsigned int status,
+			      const struct ucode_cpu_info *uci,
+			      const unsigned int data)
 {
 	int cpu = smp_processor_id();
-
-	pr_info("CPU%d: entire core updated early to revision 0x%x, date %04x-%02x-%02x\n",
-		cpu,
-		uci->cpu_sig.rev,
-		date & 0xffff,
-		date >> 24,
-		(date >> 16) & 0xff);
+	struct ucode_cpu_info ucil;
+
+	switch (status) {
+	case INTEL_EARLYMCU_NONE:
+		break;
+	case INTEL_EARLYMCU_UPDATEOK:
+		if (!uci) {
+			collect_cpu_info_early(&ucil);
+			uci = &ucil;
+		}
+		pr_info("CPU%d: entire core updated early to revision 0x%x, date %04x-%02x-%02x\n",
+			cpu,
+			uci->cpu_sig.rev,
+			data & 0xffff,
+			data >> 24,
+			(data >> 16) & 0xff);
+		break;
+	case INTEL_EARLYMCU_REJECTED:
+		pr_err("CPU%d: update to revision 0x%x rejected by the processor\n", cpu, data);
+		break;
+	}
 }
 
 #ifdef CONFIG_X86_32
 
-static int delay_ucode_info;
-static int current_mc_date;
+static unsigned int delay_ucode_info;
+static unsigned int delay_ucode_info_data;
 
 /*
  * Print early updated ucode info after printk works. This is delayed info dump.
+ * This is only used for the BSP.
  */
 void show_ucode_info_early(void)
 {
-	struct ucode_cpu_info uci;
-
-	if (delay_ucode_info) {
-		collect_cpu_info_early(&uci);
-		print_ucode_info(&uci, current_mc_date);
-		delay_ucode_info = 0;
-	}
+	print_ucode_info(delay_ucode_info, NULL, delay_ucode_info_data);
+	delay_ucode_info = INTEL_EARLYMCU_NONE;
 }
 
 /*
@@ -614,21 +633,18 @@ void show_ucode_info_early(void)
  * mc_saved_data.mc_saved and delay printing microcode info in
  * show_ucode_info_early() until printk() works.
  */
-static void print_ucode(struct ucode_cpu_info *uci)
+static void print_ucode(const unsigned int status,
+			const struct ucode_cpu_info * const uci,
+			const unsigned int data)
 {
-	struct microcode_intel *mc_intel;
-	int *delay_ucode_info_p;
-	int *current_mc_date_p;
-
-	mc_intel = uci->mc;
-	if (mc_intel == NULL)
-		return;
+	unsigned int *delay_ucode_info_p;
+	unsigned int *delay_ucode_info_data_p;
 
-	delay_ucode_info_p = (int *)__pa_nodebug(&delay_ucode_info);
-	current_mc_date_p = (int *)__pa_nodebug(&current_mc_date);
+	delay_ucode_info_p = (unsigned int *)__pa_nodebug(&delay_ucode_info);
+	delay_ucode_info_data_p = (unsigned int *)__pa_nodebug(&delay_ucode_info_data);
 
-	*delay_ucode_info_p = 1;
-	*current_mc_date_p = mc_intel->hdr.date;
+	*delay_ucode_info_p = status;
+	*delay_ucode_info_data_p = data;
 }
 #else
 
@@ -641,15 +657,11 @@ static inline void flush_tlb_early(void)
 	__native_flush_tlb_global_irq_disabled();
 }
 
-static inline void print_ucode(struct ucode_cpu_info *uci)
+static inline void print_ucode(const unsigned int status,
+			       const struct ucode_cpu_info * const uci,
+			       const unsigned int data)
 {
-	struct microcode_intel *mc_intel;
-
-	mc_intel = uci->mc;
-	if (mc_intel == NULL)
-		return;
-
-	print_ucode_info(uci, mc_intel->hdr.date);
+	print_ucode_info(status, uci, data);
 }
 #endif
 
@@ -674,8 +686,10 @@ static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
 
 	/* get the current revision from MSR 0x8B */
 	native_rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
-	if (val[1] != mc_intel->hdr.rev)
+	if (val[1] != mc_intel->hdr.rev) {
+		print_ucode(INTEL_EARLYMCU_REJECTED, uci, mc_intel->hdr.rev);
 		return -1;
+	}
 
 #ifdef CONFIG_X86_64
 	/* Flush global tlb. This is precaution. */
@@ -683,7 +697,7 @@ static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
 #endif
 	uci->cpu_sig.rev = val[1];
 
-	print_ucode(uci);
+	print_ucode(INTEL_EARLYMCU_UPDATEOK, uci, mc_intel->hdr.date);
 
 	return 0;
 }
-- 
1.7.10.4

