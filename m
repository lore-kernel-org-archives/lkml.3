Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660Ab3GPRfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:35:04 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:49920 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933612Ab3GPRfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:35:00 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [RFC PATCH 04/10] alpha: Allow HZ to be configured
Date: Tue, 16 Jul 2013 10:34:12 -0700
Message-Id: <1373996058-13399-5-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373996058-13399-1-git-send-email-rth@twiddle.net>
References: <1373996058-13399-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the 1024Hz default, we spend 50% of QEMU emulation
processing timer interrupts.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/Kconfig        | 36 ++++++++++++++++++++++++++++++++++--
 arch/alpha/kernel/setup.c | 10 ++++++++--
 arch/alpha/kernel/time.c  | 24 +++++++++++++++++-------
 3 files changed, 59 insertions(+), 11 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 2053f215..5991a99 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -628,9 +628,41 @@ config VERBOSE_MCHECK_ON
 
 	  Take the default (1) unless you want more control or more info.
 
+choice
+	prompt "Timer interrupt frequency (HZ)?"
+	default HZ_128 if ALPHA_QEMU
+	default HZ_1200 if ALPHA_RAWHIDE
+	default HZ_1024
+	---help---
+	  The frequency at which timer interrupts occur.  A high frequency
+	  minimizes latency, whereas a low frequency minimizes overhead of
+	  process accounting.  The later effect is especially significant
+	  when being run under QEMU.
+
+	  Note that some Alpha hardware cannot change the interrupt frequency
+	  of the timer.  If unsure, say 1024 (or 1200 for Rawhide).
+
+	config HZ_32
+		bool "32 Hz"
+	config HZ_64
+		bool "64 Hz"
+	config HZ_128
+		bool "128 Hz"
+	config HZ_256
+		bool "256 Hz"
+	config HZ_1024
+		bool "1024 Hz"
+	config HZ_1200
+		bool "1200 Hz"
+endchoice
+
 config HZ
-	int
-	default 1200 if ALPHA_RAWHIDE
+	int 
+	default 32 if HZ_32
+	default 64 if HZ_64
+	default 128 if HZ_128
+	default 256 if HZ_256
+	default 1200 if HZ_1200
 	default 1024
 
 source "drivers/pci/Kconfig"
diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index c38d6a1..b20af76 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -1218,6 +1218,7 @@ show_cpuinfo(struct seq_file *f, void *slot)
 	char *systype_name;
 	char *sysvariation_name;
 	int nr_processors;
+	unsigned long timer_freq;
 
 	cpu_index = (unsigned) (cpu->type - 1);
 	cpu_name = "Unknown";
@@ -1229,6 +1230,12 @@ show_cpuinfo(struct seq_file *f, void *slot)
 
 	nr_processors = get_nr_processors(cpu, hwrpb->nr_processors);
 
+#if CONFIG_HZ == 1024 || CONFIG_HZ == 1200
+	timer_freq = (100UL * hwrpb->intr_freq) / 4096;
+#else
+	timer_freq = 100UL * CONFIG_HZ;
+#endif
+
 	seq_printf(f, "cpu\t\t\t: Alpha\n"
 		      "cpu model\t\t: %s\n"
 		      "cpu variation\t\t: %ld\n"
@@ -1254,8 +1261,7 @@ show_cpuinfo(struct seq_file *f, void *slot)
 		       (char*)hwrpb->ssn,
 		       est_cycle_freq ? : hwrpb->cycle_freq,
 		       est_cycle_freq ? "est." : "",
-		       hwrpb->intr_freq / 4096,
-		       (100 * hwrpb->intr_freq / 4096) % 100,
+		       timer_freq / 100, timer_freq % 100,
 		       hwrpb->pagesize,
 		       hwrpb->pa_bits,
 		       hwrpb->max_asn,
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index e336694..7938bf9 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -203,16 +203,26 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 void __init
 common_init_rtc(void)
 {
-	unsigned char x;
+	unsigned char x, sel = 0;
 
 	/* Reset periodic interrupt frequency.  */
-	x = CMOS_READ(RTC_FREQ_SELECT) & 0x3f;
-        /* Test includes known working values on various platforms
-           where 0x26 is wrong; we refuse to change those. */
-	if (x != 0x26 && x != 0x25 && x != 0x19 && x != 0x06) {
-		printk("Setting RTC_FREQ to 1024 Hz (%x)\n", x);
-		CMOS_WRITE(0x26, RTC_FREQ_SELECT);
+#if CONFIG_HZ == 1024 || CONFIG_HZ == 1200
+ 	x = CMOS_READ(RTC_FREQ_SELECT) & 0x3f;
+	/* Test includes known working values on various platforms
+	   where 0x26 is wrong; we refuse to change those. */
+ 	if (x != 0x26 && x != 0x25 && x != 0x19 && x != 0x06) {
+		sel = RTC_REF_CLCK_32KHZ + 6;
 	}
+#elif CONFIG_HZ == 256 || CONFIG_HZ == 128 || CONFIG_HZ == 64 || CONFIG_HZ == 32
+	sel = RTC_REF_CLCK_32KHZ + __builtin_ffs(32768 / CONFIG_HZ);
+#else
+# error "Unknown HZ from arch/alpha/Kconfig"
+#endif
+	if (sel) {
+		printk(KERN_INFO "Setting RTC_FREQ to %d Hz (%x)\n",
+		       CONFIG_HZ, sel);
+		CMOS_WRITE(sel, RTC_FREQ_SELECT);
+ 	}
 
 	/* Turn on periodic interrupts.  */
 	x = CMOS_READ(RTC_CONTROL);
-- 
1.8.1.4

