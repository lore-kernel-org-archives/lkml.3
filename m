Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaCaMWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:22:37 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:45017 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaCaMWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:22:35 -0400
Date: Mon, 31 Mar 2014 14:22:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic changes for v3.15
Message-ID: <20140331122231.GA8722@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-apic-for-linus

   # HEAD: ea7bdc65bca8cf837a63e0ff7b75daed83222511 x86/apic: Plug racy xAPIC access of CPU hotplug code

An xAPIC CPU hotplug race fix, plus cleanups and minor fixes.

 Thanks,

	Ingo

------------------>
David Rientjes (4):
      x86/apic: Only use default_wait_for_init_deassert()
      x86/apic: Switch wait_for_init_deassert() to a bool flag
      x86/apic: Remove unused function prototypes
      x86/apic: Always define nox2apic and define it as initdata

Jan Kiszka (1):
      x86/apic: Plug racy xAPIC access of CPU hotplug code


 arch/x86/include/asm/apic.h           | 14 +-------------
 arch/x86/kernel/apic/apic.c           | 13 ++++++++++---
 arch/x86/kernel/apic/apic_flat_64.c   |  4 ++--
 arch/x86/kernel/apic/apic_noop.c      |  3 +--
 arch/x86/kernel/apic/apic_numachip.c  |  2 +-
 arch/x86/kernel/apic/bigsmp_32.c      |  3 +--
 arch/x86/kernel/apic/es7000_32.c      | 12 ++----------
 arch/x86/kernel/apic/numaq_32.c       |  3 +--
 arch/x86/kernel/apic/probe_32.c       |  3 +--
 arch/x86/kernel/apic/summit_32.c      |  3 +--
 arch/x86/kernel/apic/x2apic_cluster.c |  2 +-
 arch/x86/kernel/apic/x2apic_phys.c    |  2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    |  2 +-
 arch/x86/kernel/smpboot.c             | 16 ++++++++++++----
 14 files changed, 36 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1d2091a..19b0eba 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -93,9 +93,6 @@ static inline int is_vsmp_box(void)
 	return 0;
 }
 #endif
-extern void xapic_wait_icr_idle(void);
-extern u32 safe_xapic_wait_icr_idle(void);
-extern void xapic_icr_write(u32, u32);
 extern int setup_profiling_timer(unsigned int);
 
 static inline void native_apic_mem_write(u32 reg, u32 v)
@@ -184,7 +181,6 @@ extern int x2apic_phys;
 extern int x2apic_preenabled;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
-extern void x2apic_icr_write(u32 low, u32 id);
 static inline int x2apic_enabled(void)
 {
 	u64 msr;
@@ -221,7 +217,6 @@ static inline void x2apic_force_phys(void)
 {
 }
 
-#define	nox2apic	0
 #define	x2apic_preenabled 0
 #define	x2apic_supported()	0
 #endif
@@ -351,7 +346,7 @@ struct apic {
 	int trampoline_phys_low;
 	int trampoline_phys_high;
 
-	void (*wait_for_init_deassert)(atomic_t *deassert);
+	bool wait_for_init_deassert;
 	void (*smp_callin_clear_local_apic)(void);
 	void (*inquire_remote_apic)(int apicid);
 
@@ -517,13 +512,6 @@ extern int default_cpu_present_to_apicid(int mps_cpu);
 extern int default_check_phys_apicid_present(int phys_apicid);
 #endif
 
-static inline void default_wait_for_init_deassert(atomic_t *deassert)
-{
-	while (!atomic_read(deassert))
-		cpu_relax();
-	return;
-}
-
 extern void generic_bigsmp_probe(void);
 
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7f26c9a..53e2053 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -133,6 +133,10 @@ static inline void imcr_apic_to_pic(void)
  * +1=force-enable
  */
 static int force_enable_local_apic __initdata;
+
+/* Control whether x2APIC mode is enabled or not */
+static bool nox2apic __initdata;
+
 /*
  * APIC command line parameters
  */
@@ -162,8 +166,7 @@ int x2apic_mode;
 /* x2apic enabled before OS handover */
 int x2apic_preenabled;
 static int x2apic_disabled;
-static int nox2apic;
-static __init int setup_nox2apic(char *str)
+static int __init setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
 		int apicid = native_apic_msr_read(APIC_ID);
@@ -178,7 +181,7 @@ static __init int setup_nox2apic(char *str)
 	} else
 		setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 
-	nox2apic = 1;
+	nox2apic = true;
 
 	return 0;
 }
@@ -283,8 +286,12 @@ u32 native_safe_apic_wait_icr_idle(void)
 
 void native_apic_icr_write(u32 low, u32 id)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
 	apic_write(APIC_ICR, low);
+	local_irq_restore(flags);
 }
 
 u64 native_apic_icr_read(void)
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 2c621a6..7c1b294 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -198,7 +198,7 @@ static struct apic apic_flat =  {
 
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-	.wait_for_init_deassert		= NULL,
+	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
@@ -314,7 +314,7 @@ static struct apic apic_physflat =  {
 
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-	.wait_for_init_deassert		= NULL,
+	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 191ce75..8c7c982 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -172,8 +172,7 @@ struct apic apic_noop = {
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 
-	.wait_for_init_deassert		= NULL,
-
+	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 3e67f9e..a5b45df 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -248,7 +248,7 @@ static const struct apic apic_numachip __refconst = {
 	.wakeup_secondary_cpu		= numachip_wakeup_secondary,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-	.wait_for_init_deassert		= NULL,
+	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL, /* REMRD not supported */
 
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index d50e364..e4840aa 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -199,8 +199,7 @@ static struct apic apic_bigsmp = {
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 
-	.wait_for_init_deassert		= default_wait_for_init_deassert,
-
+	.wait_for_init_deassert		= true,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index c552247..6f8f8b3 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -394,12 +394,6 @@ static void es7000_enable_apic_mode(void)
 		WARN(1, "Command failed, status = %x\n", mip_status);
 }
 
-static void es7000_wait_for_init_deassert(atomic_t *deassert)
-{
-	while (!atomic_read(deassert))
-		cpu_relax();
-}
-
 static unsigned int es7000_get_apic_id(unsigned long x)
 {
 	return (x >> 24) & 0xFF;
@@ -658,8 +652,7 @@ static struct apic __refdata apic_es7000_cluster = {
 	.trampoline_phys_low		= 0x467,
 	.trampoline_phys_high		= 0x469,
 
-	.wait_for_init_deassert		= NULL,
-
+	.wait_for_init_deassert		= false,
 	/* Nothing to do for most platforms, since cleared by the INIT cycle: */
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
@@ -722,8 +715,7 @@ static struct apic __refdata apic_es7000 = {
 	.trampoline_phys_low		= 0x467,
 	.trampoline_phys_high		= 0x469,
 
-	.wait_for_init_deassert		= es7000_wait_for_init_deassert,
-
+	.wait_for_init_deassert		= true,
 	/* Nothing to do for most platforms, since cleared by the INIT cycle: */
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 1e42e8f..030ea1c 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -505,8 +505,7 @@ static struct apic __refdata apic_numaq = {
 	.trampoline_phys_high		= NUMAQ_TRAMPOLINE_PHYS_HIGH,
 
 	/* We don't do anything here because we use NMI's to boot instead */
-	.wait_for_init_deassert		= NULL,
-
+	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= numaq_smp_callin_clear_local_apic,
 	.inquire_remote_apic		= NULL,
 
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index eb35ef9..cceb352 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -119,8 +119,7 @@ static struct apic apic_default = {
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 
-	.wait_for_init_deassert		= default_wait_for_init_deassert,
-
+	.wait_for_init_deassert		= true,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 00146f9..b656128 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -532,8 +532,7 @@ static struct apic apic_summit = {
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 
-	.wait_for_init_deassert		= default_wait_for_init_deassert,
-
+	.wait_for_init_deassert		= true,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index cac85ee..e66766b 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -279,7 +279,7 @@ static struct apic apic_x2apic_cluster = {
 
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-	.wait_for_init_deassert		= NULL,
+	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index de231e3..6d600eb 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -133,7 +133,7 @@ static struct apic apic_x2apic_phys = {
 
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-	.wait_for_init_deassert		= NULL,
+	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index d263b13..7834389 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -396,7 +396,7 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.wakeup_secondary_cpu		= uv_wakeup_secondary,
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-	.wait_for_init_deassert		= NULL,
+	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a32da80..60179ec 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -122,8 +122,9 @@ static void smp_callin(void)
 	 * Since CPU0 is not wakened up by INIT, it doesn't wait for the IPI.
 	 */
 	cpuid = smp_processor_id();
-	if (apic->wait_for_init_deassert && cpuid != 0)
-		apic->wait_for_init_deassert(&init_deasserted);
+	if (apic->wait_for_init_deassert && cpuid)
+		while (!atomic_read(&init_deasserted))
+			cpu_relax();
 
 	/*
 	 * (This works even if the APIC is not enabled.)
@@ -701,11 +702,15 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid,
 	int id;
 	int boot_error;
 
+	preempt_disable();
+
 	/*
 	 * Wake up AP by INIT, INIT, STARTUP sequence.
 	 */
-	if (cpu)
-		return wakeup_secondary_cpu_via_init(apicid, start_ip);
+	if (cpu) {
+		boot_error = wakeup_secondary_cpu_via_init(apicid, start_ip);
+		goto out;
+	}
 
 	/*
 	 * Wake up BSP by nmi.
@@ -725,6 +730,9 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid,
 		boot_error = wakeup_secondary_cpu_via_nmi(id, start_ip);
 	}
 
+out:
+	preempt_enable();
+
 	return boot_error;
 }
 
