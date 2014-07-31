Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbaGaGxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:53:40 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:65116 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaGaGxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:53:30 -0400
Date: Wed, 30 Jul 2014 23:53:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: Grant Likely <grant.likely@linaro.org>, Andi Kleen <ak@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: [patch 2/9] x86, apic: Replace trampoline physical addresses with
 defaults
In-Reply-To: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1407302348330.17503@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trampoline_phys_{high,low} members of struct apic are always
initialized to DEFAULT_TRAMPOLINE_PHYS_HIGH and TRAMPOLINE_PHYS_LOW,
respectively.  Hardwire the constants and remove the unneeded members.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/apic.h           |  9 +++------
 arch/x86/include/asm/smpboot_hooks.h  | 10 +++++-----
 arch/x86/kernel/apic/apic_flat_64.c   |  4 ----
 arch/x86/kernel/apic/apic_noop.c      |  4 ----
 arch/x86/kernel/apic/apic_numachip.c  |  2 --
 arch/x86/kernel/apic/bigsmp_32.c      |  3 ---
 arch/x86/kernel/apic/probe_32.c       |  3 ---
 arch/x86/kernel/apic/x2apic_cluster.c |  2 --
 arch/x86/kernel/apic/x2apic_phys.c    |  2 --
 arch/x86/kernel/apic/x2apic_uv_x.c    |  2 --
 10 files changed, 8 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -335,9 +335,6 @@ struct apic {
 	/* wakeup_secondary_cpu */
 	int (*wakeup_secondary_cpu)(int apicid, unsigned long start_eip);
 
-	int trampoline_phys_low;
-	int trampoline_phys_high;
-
 	bool wait_for_init_deassert;
 	void (*smp_callin_clear_local_apic)(void);
 	void (*inquire_remote_apic)(int apicid);
@@ -480,10 +477,10 @@ static inline unsigned default_get_apic_id(unsigned long x)
 }
 
 /*
- * Warm reset vector default position:
+ * Warm reset vector position:
  */
-#define DEFAULT_TRAMPOLINE_PHYS_LOW		0x467
-#define DEFAULT_TRAMPOLINE_PHYS_HIGH		0x469
+#define TRAMPOLINE_PHYS_LOW		0x467
+#define TRAMPOLINE_PHYS_HIGH		0x469
 
 #ifdef CONFIG_X86_64
 extern void apic_send_IPI_self(int vector);
diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ b/arch/x86/include/asm/smpboot_hooks.h
@@ -17,11 +17,11 @@ static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	local_flush_tlb();
 	pr_debug("1.\n");
-	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_high)) =
-								 start_eip >> 4;
+	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH)) =
+							start_eip >> 4;
 	pr_debug("2.\n");
-	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_low)) =
-							 start_eip & 0xf;
+	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) =
+							start_eip & 0xf;
 	pr_debug("3.\n");
 }
 
@@ -42,7 +42,7 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	CMOS_WRITE(0, 0xf);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
-	*((volatile u32 *)phys_to_virt(apic->trampoline_phys_low)) = 0;
+	*((volatile u32 *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) = 0;
 }
 
 static inline void __init smpboot_setup_io_apic(void)
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -196,8 +196,6 @@ static struct apic apic_flat =  {
 	.send_IPI_all			= flat_send_IPI_all,
 	.send_IPI_self			= apic_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
@@ -312,8 +310,6 @@ static struct apic apic_physflat =  {
 	.send_IPI_all			= physflat_send_IPI_all,
 	.send_IPI_self			= apic_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -168,10 +168,6 @@ struct apic apic_noop = {
 
 	.wakeup_secondary_cpu		= noop_wakeup_secondary_cpu,
 
-	/* should be safe */
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-
 	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -246,8 +246,6 @@ static const struct apic apic_numachip __refconst = {
 	.send_IPI_self			= numachip_send_IPI_self,
 
 	.wakeup_secondary_cpu		= numachip_wakeup_secondary,
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL, /* REMRD not supported */
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -196,9 +196,6 @@ static struct apic apic_bigsmp = {
 	.send_IPI_all			= bigsmp_send_IPI_all,
 	.send_IPI_self			= default_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-
 	.wait_for_init_deassert		= true,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -116,9 +116,6 @@ static struct apic apic_default = {
 	.send_IPI_all			= default_send_IPI_all,
 	.send_IPI_self			= default_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-
 	.wait_for_init_deassert		= true,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -277,8 +277,6 @@ static struct apic apic_x2apic_cluster = {
 	.send_IPI_all			= x2apic_send_IPI_all,
 	.send_IPI_self			= x2apic_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -131,8 +131,6 @@ static struct apic apic_x2apic_phys = {
 	.send_IPI_all			= x2apic_send_IPI_all,
 	.send_IPI_self			= x2apic_send_IPI_self,
 
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -394,8 +394,6 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.send_IPI_self			= uv_send_IPI_self,
 
 	.wakeup_secondary_cpu		= uv_wakeup_secondary,
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= false,
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
