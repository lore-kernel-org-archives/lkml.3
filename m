Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaBJNbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:31:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaBJNbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:31:38 -0500
Date: Mon, 10 Feb 2014 05:31:24 -0800
From: tip-bot for David Rientjes <tipbot@zytor.com>
Message-ID: <tip-465822cfc8cb850ba76046965cc7b6fd1f8c3d73@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com
In-Reply-To: <alpine.DEB.2.02.1402042354010.7839@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1402042354010.7839@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Switch wait_for_init_deassert()
  to a bool flag
Git-Commit-ID: 465822cfc8cb850ba76046965cc7b6fd1f8c3d73
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:31:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  465822cfc8cb850ba76046965cc7b6fd1f8c3d73
Gitweb:     http://git.kernel.org/tip/465822cfc8cb850ba76046965cc7b6fd1f8c3d73
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Tue, 4 Feb 2014 23:55:01 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 15:15:08 +0100

x86/apic: Switch wait_for_init_deassert() to a bool flag

Now that there is only a single wait_for_init_deassert()
function, just convert the member of struct apic to a bool to
determine whether we need to wait for init_deassert to become
non-zero.

There are no more callers of default_wait_for_init_deassert(),
so fold it into the caller.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1402042354010.7839@chino.kir.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/apic.h           | 8 +-------
 arch/x86/kernel/apic/apic_flat_64.c   | 4 ++--
 arch/x86/kernel/apic/apic_noop.c      | 3 +--
 arch/x86/kernel/apic/apic_numachip.c  | 2 +-
 arch/x86/kernel/apic/bigsmp_32.c      | 3 +--
 arch/x86/kernel/apic/es7000_32.c      | 6 ++----
 arch/x86/kernel/apic/numaq_32.c       | 3 +--
 arch/x86/kernel/apic/probe_32.c       | 3 +--
 arch/x86/kernel/apic/summit_32.c      | 3 +--
 arch/x86/kernel/apic/x2apic_cluster.c | 2 +-
 arch/x86/kernel/apic/x2apic_phys.c    | 2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    | 2 +-
 arch/x86/kernel/smpboot.c             | 5 +++--
 13 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 2ef7013..c1d3074 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -351,7 +351,7 @@ struct apic {
 	int trampoline_phys_low;
 	int trampoline_phys_high;
 
-	void (*wait_for_init_deassert)(atomic_t *deassert);
+	bool wait_for_init_deassert;
 	void (*smp_callin_clear_local_apic)(void);
 	void (*inquire_remote_apic)(int apicid);
 
@@ -517,12 +517,6 @@ extern int default_cpu_present_to_apicid(int mps_cpu);
 extern int default_check_phys_apicid_present(int phys_apicid);
 #endif
 
-static inline void default_wait_for_init_deassert(atomic_t *deassert)
-{
-	while (!atomic_read(deassert))
-		cpu_relax();
-}
-
 extern void generic_bigsmp_probe(void);
 
 
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
index d03d57e..6f8f8b3 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -652,8 +652,7 @@ static struct apic __refdata apic_es7000_cluster = {
 	.trampoline_phys_low		= 0x467,
 	.trampoline_phys_high		= 0x469,
 
-	.wait_for_init_deassert		= NULL,
-
+	.wait_for_init_deassert		= false,
 	/* Nothing to do for most platforms, since cleared by the INIT cycle: */
 	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
@@ -716,8 +715,7 @@ static struct apic __refdata apic_es7000 = {
 	.trampoline_phys_low		= 0x467,
 	.trampoline_phys_high		= 0x469,
 
-	.wait_for_init_deassert		= default_wait_for_init_deassert,
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
index a32da80..c77acc6 100644
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
