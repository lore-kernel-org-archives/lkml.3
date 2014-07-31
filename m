Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaGaGzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:55:04 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:55074 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbaGaGxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:53:46 -0400
Date: Wed, 30 Jul 2014 23:53:43 -0700 (PDT)
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
Subject: [patch 7/9] x86, apic: Remove multi_timer_check callback
In-Reply-To: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1407302351120.17503@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit b5660ba76b41 ("x86, platforms: Remove NUMAQ") removed NUMAQ,
the multi_timer_check() apic callback has been obsolete.  Remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/apic.h           |  1 -
 arch/x86/kernel/apic/apic_flat_64.c   |  2 --
 arch/x86/kernel/apic/apic_noop.c      |  1 -
 arch/x86/kernel/apic/apic_numachip.c  |  1 -
 arch/x86/kernel/apic/bigsmp_32.c      |  1 -
 arch/x86/kernel/apic/io_apic.c        | 16 ----------------
 arch/x86/kernel/apic/probe_32.c       |  1 -
 arch/x86/kernel/apic/x2apic_cluster.c |  1 -
 arch/x86/kernel/apic/x2apic_phys.c    |  1 -
 arch/x86/kernel/apic/x2apic_uv_x.c    |  1 -
 10 files changed, 26 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -300,7 +300,6 @@ struct apic {
 	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
 
 	void (*setup_apic_routing)(void);
-	int (*multi_timer_check)(int apic, int irq);
 	int (*cpu_present_to_apicid)(int mps_cpu);
 	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *retmap);
 	void (*setup_portio_remap)(void);
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -174,7 +174,6 @@ static struct apic apic_flat =  {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
@@ -285,7 +284,6 @@ static struct apic apic_physflat =  {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -130,7 +130,6 @@ struct apic apic_noop = {
 
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -223,7 +223,6 @@ static const struct apic apic_numachip __refconst = {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -169,7 +169,6 @@ static struct apic apic_bigsmp = {
 
 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
 	.setup_apic_routing		= bigsmp_setup_apic_routing,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3882,14 +3882,6 @@ int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 	struct mp_pin_info *info = mp_pin_info(ioapic, hwirq);
 	struct io_apic_irq_attr attr;
 
-	/*
-	 * Skip the timer IRQ if there's a quirk handler installed and if it
-	 * returns 1:
-	 */
-	if (apic->multi_timer_check &&
-	    apic->multi_timer_check(ioapic, virq))
-		return 0;
-
 	/* Get default attribute if not set by caller yet */
 	if (!info->set) {
 		u32 gsi = mp_pin_to_gsi(ioapic, hwirq);
@@ -3919,14 +3911,6 @@ void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq)
 	int ioapic = (int)(long)domain->host_data;
 	int pin = (int)data->hwirq;
 
-	/*
-	 * Skip the timer IRQ if there's a quirk handler installed and if it
-	 * returns 1:
-	 */
-	if (apic->multi_timer_check &&
-	    apic->multi_timer_check(ioapic, virq))
-		return;
-
 	ioapic_mask_entry(ioapic, pin);
 	__remove_pin_from_irq(cfg, ioapic, pin);
 	WARN_ON(cfg->irq_2_pin != NULL);
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -94,7 +94,6 @@ static struct apic apic_default = {
 
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_flat_routing,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -255,7 +255,6 @@ static struct apic apic_x2apic_cluster = {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -109,7 +109,6 @@ static struct apic apic_x2apic_phys = {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -371,7 +371,6 @@ static struct apic __refdata apic_x2apic_uv_x = {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
