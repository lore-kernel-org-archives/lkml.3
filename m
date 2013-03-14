Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3CNWLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:11:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18851 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3CNWLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:11:41 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: bp@alien.de
Cc: chegger@amazon.de, xen-devel@lists.xen.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        stable@vger.kernel.org, boris.ostrovsky@oracle.com
Subject: [PATCH v2 2/2] x86/mce: Use MCG_CAP MSR to find out number of banks on AMD
Date: Thu, 14 Mar 2013 17:10:41 -0400
Message-Id: <1363295441-1859-3-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363295441-1859-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1363295441-1859-1-git-send-email-boris.ostrovsky@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently number of error reporting register banks is hardcoded to
6 on AMD processors. This may break in virtualized scenarios when
a hypervisor prefers to report fewer banks than what the physical
HW provides.

Since number of supported banks is reported in MSR_IA32_MCG_CAP[7:0]
that's what we should use.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 654a155..13a22e2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -33,7 +33,6 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 
-#define NR_BANKS          6
 #define NR_BLOCKS         9
 #define THRESHOLD_MAX     0xFFF
 #define INT_TYPE_APIC     0x00020000
@@ -57,7 +56,7 @@ static const char * const th_names[] = {
 	"execution_unit",
 };
 
-static DEFINE_PER_CPU(struct threshold_bank * [NR_BANKS], threshold_banks);
+static DEFINE_PER_CPU(struct threshold_bank **, threshold_banks);
 static DEFINE_PER_CPU(unsigned char, bank_map);	/* see which banks are on */
 
 static void amd_threshold_interrupt(void);
@@ -215,7 +214,7 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 	unsigned int bank, block;
 	int offset = -1;
 
-	for (bank = 0; bank < NR_BANKS; ++bank) {
+	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		for (block = 0; block < NR_BLOCKS; ++block) {
 			if (block == 0)
 				address = MSR_IA32_MC0_MISC + bank * 4;
@@ -277,7 +276,7 @@ static void amd_threshold_interrupt(void)
 	mce_setup(&m);
 
 	/* assume first bank caused it */
-	for (bank = 0; bank < NR_BANKS; ++bank) {
+	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		if (!(per_cpu(bank_map, m.cpu) & (1 << bank)))
 			continue;
 		for (block = 0; block < NR_BLOCKS; ++block) {
@@ -468,7 +467,7 @@ static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
 	u32 low, high;
 	int err;
 
-	if ((bank >= NR_BANKS) || (block >= NR_BLOCKS))
+	if ((bank >= mca_cfg.banks) || (block >= NR_BLOCKS))
 		return 0;
 
 	if (rdmsr_safe_on_cpu(cpu, address, &low, &high))
@@ -636,9 +635,16 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 static __cpuinit int threshold_create_device(unsigned int cpu)
 {
 	unsigned int bank;
+	struct threshold_bank **bp;
 	int err = 0;
 
-	for (bank = 0; bank < NR_BANKS; ++bank) {
+	bp = kzalloc(sizeof(struct threshold_bank *) * mca_cfg.banks,
+		     GFP_KERNEL);
+	if (bp == NULL)
+		return -ENOMEM;
+	per_cpu(threshold_banks, cpu) = bp;
+
+	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		if (!(per_cpu(bank_map, cpu) & (1 << bank)))
 			continue;
 		err = threshold_create_bank(cpu, bank);
@@ -720,11 +726,12 @@ static void threshold_remove_device(unsigned int cpu)
 {
 	unsigned int bank;
 
-	for (bank = 0; bank < NR_BANKS; ++bank) {
+	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		if (!(per_cpu(bank_map, cpu) & (1 << bank)))
 			continue;
 		threshold_remove_bank(cpu, bank);
 	}
+	kfree(per_cpu(threshold_banks, cpu));
 }
 
 /* get notified when a cpu comes on/off */
-- 
1.8.1.2

