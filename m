Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbaGaGzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:55:51 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62273 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbaGaGxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:53:37 -0400
Date: Wed, 30 Jul 2014 23:53:34 -0700 (PDT)
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
Subject: [patch 4/9] x86, apic: Remove mps_oem_check callback
In-Reply-To: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1407302349390.17503@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit b5660ba76b41 ("x86, platforms: Remove NUMAQ") removed NUMAQ,
the mps_oem_check() apic callback has been obsolete.  Remove it.

This allows generic_mps_oem_check() to be removed as well.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/apic.h           |  7 -------
 arch/x86/include/asm/mpspec.h         |  2 --
 arch/x86/kernel/apic/apic_flat_64.c   |  2 --
 arch/x86/kernel/apic/apic_noop.c      |  2 --
 arch/x86/kernel/apic/apic_numachip.c  |  1 -
 arch/x86/kernel/apic/bigsmp_32.c      |  1 -
 arch/x86/kernel/apic/probe_32.c       | 25 +------------------------
 arch/x86/kernel/apic/x2apic_cluster.c |  1 -
 arch/x86/kernel/apic/x2apic_phys.c    |  1 -
 arch/x86/kernel/apic/x2apic_uv_x.c    |  1 -
 arch/x86/kernel/mpparse.c             |  3 ---
 11 files changed, 1 insertion(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -309,13 +309,6 @@ struct apic {
 	void (*enable_apic_mode)(void);
 	int (*phys_pkg_id)(int cpuid_apic, int index_msb);
 
-	/*
-	 * When one of the next two hooks returns 1 the apic
-	 * is switched to this. Essentially they are additional
-	 * probe functions:
-	 */
-	int (*mps_oem_check)(struct mpc_table *mpc, char *oem, char *productid);
-
 	unsigned int (*get_apic_id)(unsigned long x);
 	unsigned long (*set_apic_id)(unsigned int id);
 	unsigned long apic_id_mask;
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -150,6 +150,4 @@ static inline void physid_set_mask_of_physid(int physid, physid_mask_t *map)
 
 extern physid_mask_t phys_cpu_present_map;
 
-extern int generic_mps_oem_check(struct mpc_table *, char *, char *);
-
 #endif /* _ASM_X86_MPSPEC_H */
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -182,7 +182,6 @@ static struct apic apic_flat =  {
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= flat_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= flat_get_apic_id,
 	.set_apic_id			= set_apic_id,
@@ -295,7 +294,6 @@ static struct apic apic_physflat =  {
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= flat_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= flat_get_apic_id,
 	.set_apic_id			= set_apic_id,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -152,8 +152,6 @@ struct apic apic_noop = {
 
 	.phys_pkg_id			= noop_phys_pkg_id,
 
-	.mps_oem_check			= NULL,
-
 	.get_apic_id			= noop_get_apic_id,
 	.set_apic_id			= NULL,
 	.apic_id_mask			= 0x0F << 24,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -231,7 +231,6 @@ static const struct apic apic_numachip __refconst = {
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= numachip_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= get_apic_id,
 	.set_apic_id			= set_apic_id,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -182,7 +182,6 @@ static struct apic apic_bigsmp = {
 	.check_phys_apicid_present	= bigsmp_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= bigsmp_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= bigsmp_get_apic_id,
 	.set_apic_id			= NULL,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -102,7 +102,6 @@ static struct apic apic_default = {
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= default_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= default_get_apic_id,
 	.set_apic_id			= NULL,
@@ -210,29 +209,7 @@ void __init generic_apic_probe(void)
 	printk(KERN_INFO "Using APIC driver %s\n", apic->name);
 }
 
-/* These functions can switch the APIC even after the initial ->probe() */
-
-int __init
-generic_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
-{
-	struct apic **drv;
-
-	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
-		if (!((*drv)->mps_oem_check))
-			continue;
-		if (!(*drv)->mps_oem_check(mpc, oem, productid))
-			continue;
-
-		if (!cmdline_apic) {
-			apic = *drv;
-			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
-			       apic->name);
-		}
-		return 1;
-	}
-	return 0;
-}
-
+/* This function can switch the APIC even after the initial ->probe() */
 int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	struct apic **drv;
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -263,7 +263,6 @@ static struct apic apic_x2apic_cluster = {
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= x2apic_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= x2apic_get_apic_id,
 	.set_apic_id			= x2apic_set_apic_id,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -117,7 +117,6 @@ static struct apic apic_x2apic_phys = {
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= x2apic_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= x2apic_get_apic_id,
 	.set_apic_id			= x2apic_set_apic_id,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -379,7 +379,6 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= uv_phys_pkg_id,
-	.mps_oem_check			= NULL,
 
 	.get_apic_id			= x2apic_get_apic_id,
 	.set_apic_id			= set_apic_id,
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -216,9 +216,6 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 	if (!smp_check_mpc(mpc, oem, str))
 		return 0;
 
-#ifdef CONFIG_X86_32
-	generic_mps_oem_check(mpc, oem, str);
-#endif
 	/* Initialize the lapic mapping */
 	if (!acpi_lapic)
 		register_lapic_address(mpc->lapic);
