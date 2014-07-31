Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaGaGxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:53:38 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:61572 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbaGaGxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:53:34 -0400
Date: Wed, 30 Jul 2014 23:53:30 -0700 (PDT)
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
Subject: [patch 3/9] x86, apic: Remove smp_callin_clear_local_apic callback
In-Reply-To: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1407302349040.17503@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit b5660ba76b41 ("x86, platforms: Remove NUMAQ") removed NUMAQ,
the smp_callin_clear_local_apic() apic callback has been obsolete.
Remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/apic.h           | 1 -
 arch/x86/kernel/apic/apic_flat_64.c   | 2 --
 arch/x86/kernel/apic/apic_noop.c      | 1 -
 arch/x86/kernel/apic/apic_numachip.c  | 1 -
 arch/x86/kernel/apic/bigsmp_32.c      | 1 -
 arch/x86/kernel/apic/probe_32.c       | 1 -
 arch/x86/kernel/apic/x2apic_cluster.c | 1 -
 arch/x86/kernel/apic/x2apic_phys.c    | 1 -
 arch/x86/kernel/apic/x2apic_uv_x.c    | 1 -
 arch/x86/kernel/smpboot.c             | 4 ----
 10 files changed, 14 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -336,7 +336,6 @@ struct apic {
 	int (*wakeup_secondary_cpu)(int apicid, unsigned long start_eip);
 
 	bool wait_for_init_deassert;
-	void (*smp_callin_clear_local_apic)(void);
 	void (*inquire_remote_apic)(int apicid);
 
 	/* apic ops */
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -197,7 +197,6 @@ static struct apic apic_flat =  {
 	.send_IPI_self			= apic_send_IPI_self,
 
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
@@ -311,7 +310,6 @@ static struct apic apic_physflat =  {
 	.send_IPI_self			= apic_send_IPI_self,
 
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -169,7 +169,6 @@ struct apic apic_noop = {
 	.wakeup_secondary_cpu		= noop_wakeup_secondary_cpu,
 
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
 	.read				= noop_apic_read,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -247,7 +247,6 @@ static const struct apic apic_numachip __refconst = {
 
 	.wakeup_secondary_cpu		= numachip_wakeup_secondary,
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL, /* REMRD not supported */
 
 	.read				= native_apic_mem_read,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -197,7 +197,6 @@ static struct apic apic_bigsmp = {
 	.send_IPI_self			= default_send_IPI_self,
 
 	.wait_for_init_deassert		= true,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -117,7 +117,6 @@ static struct apic apic_default = {
 	.send_IPI_self			= default_send_IPI_self,
 
 	.wait_for_init_deassert		= true,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -278,7 +278,6 @@ static struct apic apic_x2apic_cluster = {
 	.send_IPI_self			= x2apic_send_IPI_self,
 
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
 	.read				= native_apic_msr_read,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -132,7 +132,6 @@ static struct apic apic_x2apic_phys = {
 	.send_IPI_self			= x2apic_send_IPI_self,
 
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
 	.read				= native_apic_msr_read,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -395,7 +395,6 @@ static struct apic __refdata apic_x2apic_uv_x = {
 
 	.wakeup_secondary_cpu		= uv_wakeup_secondary,
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
 	.read				= native_apic_msr_read,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -168,10 +168,6 @@ static void smp_callin(void)
 	 * CPU, first the APIC. (this is probably redundant on most
 	 * boards)
 	 */
-
-	pr_debug("CALLIN, before setup_local_APIC()\n");
-	if (apic->smp_callin_clear_local_apic)
-		apic->smp_callin_clear_local_apic();
 	setup_local_APIC();
 	end_local_APIC_setup();
 
