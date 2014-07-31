Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbaGaGxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:53:44 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:63341 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbaGaGxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:53:40 -0400
Date: Wed, 30 Jul 2014 23:53:37 -0700 (PDT)
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
Subject: [patch 5/9] x86, apic: Remove check_apicid_present callback
In-Reply-To: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1407302350160.17503@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check_apicid_present() apic callback is never called, so remove it
and functions that implement it.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/apic.h           | 6 ------
 arch/x86/kernel/apic/apic_flat_64.c   | 2 --
 arch/x86/kernel/apic/apic_noop.c      | 6 ------
 arch/x86/kernel/apic/apic_numachip.c  | 1 -
 arch/x86/kernel/apic/bigsmp_32.c      | 6 ------
 arch/x86/kernel/apic/probe_32.c       | 1 -
 arch/x86/kernel/apic/x2apic_cluster.c | 1 -
 arch/x86/kernel/apic/x2apic_phys.c    | 1 -
 arch/x86/kernel/apic/x2apic_uv_x.c    | 1 -
 9 files changed, 25 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -292,7 +292,6 @@ struct apic {
 
 	int dest_logical;
 	unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
-	unsigned long (*check_apicid_present)(int apicid);
 
 	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask,
 					 const struct cpumask *mask);
@@ -608,11 +607,6 @@ static inline unsigned long default_check_apicid_used(physid_mask_t *map, int ap
 	return physid_isset(apicid, *map);
 }
 
-static inline unsigned long default_check_apicid_present(int bit)
-{
-	return physid_isset(bit, phys_cpu_present_map);
-}
-
 static inline void default_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
 	*retmap = *phys_map;
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -168,7 +168,6 @@ static struct apic apic_flat =  {
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
-	.check_apicid_present		= NULL,
 
 	.vector_allocation_domain	= flat_vector_allocation_domain,
 	.init_apic_ldr			= flat_init_apic_ldr,
@@ -279,7 +278,6 @@ static struct apic apic_physflat =  {
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
-	.check_apicid_present		= NULL,
 
 	.vector_allocation_domain	= default_vector_allocation_domain,
 	/* not needed, but shouldn't hurt: */
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -94,11 +94,6 @@ static unsigned long noop_check_apicid_used(physid_mask_t *map, int apicid)
 	return physid_isset(apicid, *map);
 }
 
-static unsigned long noop_check_apicid_present(int bit)
-{
-	return physid_isset(bit, phys_cpu_present_map);
-}
-
 static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask,
 					  const struct cpumask *mask)
 {
@@ -134,7 +129,6 @@ struct apic apic_noop = {
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= noop_check_apicid_used,
-	.check_apicid_present		= noop_check_apicid_present,
 
 	.vector_allocation_domain	= noop_vector_allocation_domain,
 	.init_apic_ldr			= noop_init_apic_ldr,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -217,7 +217,6 @@ static const struct apic apic_numachip __refconst = {
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
-	.check_apicid_present		= NULL,
 
 	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= flat_init_apic_ldr,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -31,11 +31,6 @@ static unsigned long bigsmp_check_apicid_used(physid_mask_t *map, int apicid)
 	return 0;
 }
 
-static unsigned long bigsmp_check_apicid_present(int bit)
-{
-	return 1;
-}
-
 static int bigsmp_early_logical_apicid(int cpu)
 {
 	/* on bigsmp, logical apicid is the same as physical */
@@ -168,7 +163,6 @@ static struct apic apic_bigsmp = {
 	.disable_esr			= 1,
 	.dest_logical			= 0,
 	.check_apicid_used		= bigsmp_check_apicid_used,
-	.check_apicid_present		= bigsmp_check_apicid_present,
 
 	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= bigsmp_init_apic_ldr,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -88,7 +88,6 @@ static struct apic apic_default = {
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= default_check_apicid_used,
-	.check_apicid_present		= default_check_apicid_present,
 
 	.vector_allocation_domain	= flat_vector_allocation_domain,
 	.init_apic_ldr			= default_init_apic_ldr,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -249,7 +249,6 @@ static struct apic apic_x2apic_cluster = {
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
-	.check_apicid_present		= NULL,
 
 	.vector_allocation_domain	= cluster_vector_allocation_domain,
 	.init_apic_ldr			= init_x2apic_ldr,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -103,7 +103,6 @@ static struct apic apic_x2apic_phys = {
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
-	.check_apicid_present		= NULL,
 
 	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= init_x2apic_ldr,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -365,7 +365,6 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
-	.check_apicid_present		= NULL,
 
 	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= uv_init_apic_ldr,
