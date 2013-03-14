Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965027Ab3CNRMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:12:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37056 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964840Ab3CNRMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:12:33 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: bp@alien8.de
Cc: JBeulich@suse.com, chegger@amazon.de, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xen.org,
        boris.ostrovsky@oracle.com
Subject: [PATCH] x86/mce: Use MCG_CAP MSR to find out number of banks on AMD
Date: Thu, 14 Mar 2013 12:11:18 -0400
Message-Id: <1363277478-1941-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.2
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently number of error reporting register banks is hardcoded to
6 on AMD processors. This may break in virtualized scenarios when
a hypervisor prefers to report fewer banks that the physical HW
provides.

Since number of supported banks is reported in MSR_IA32_MCG_CAP[7:0]
that's what we should use.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 1ac581f..cb7c739 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -33,7 +33,6 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 
-#define NR_BANKS          6
 #define NR_BLOCKS         9
 #define THRESHOLD_MAX     0xFFF
 #define INT_TYPE_APIC     0x00020000
@@ -57,9 +56,9 @@ static const char * const th_names[] = {
 	"execution_unit",
 };
 
-static DEFINE_PER_CPU(struct threshold_bank * [NR_BANKS], threshold_banks);
+static DEFINE_PER_CPU(struct threshold_bank **, threshold_banks);
 
-static unsigned char shared_bank[NR_BANKS] = {
+static unsigned char shared_bank[MAX_NR_BANKS] = {
 	0, 0, 0, 0, 1
 };
 
@@ -214,7 +213,7 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 	unsigned int bank, block;
 	int offset = -1;
 
-	for (bank = 0; bank < NR_BANKS; ++bank) {
+	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		for (block = 0; block < NR_BLOCKS; ++block) {
 			if (block == 0)
 				address = MSR_IA32_MC0_MISC + bank * 4;
@@ -276,7 +275,7 @@ static void amd_threshold_interrupt(void)
 	mce_setup(&m);
 
 	/* assume first bank caused it */
-	for (bank = 0; bank < NR_BANKS; ++bank) {
+	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		if (!(per_cpu(bank_map, m.cpu) & (1 << bank)))
 			continue;
 		for (block = 0; block < NR_BLOCKS; ++block) {
@@ -467,7 +466,7 @@ static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
 	u32 low, high;
 	int err;
 
-	if ((bank >= NR_BANKS) || (block >= NR_BLOCKS))
+	if ((bank >= mca_cfg.banks) || (block >= NR_BLOCKS))
 		return 0;
 
 	if (rdmsr_safe_on_cpu(cpu, address, &low, &high))
@@ -637,7 +636,12 @@ static __cpuinit int threshold_create_device(unsigned int cpu)
 	unsigned int bank;
 	int err = 0;
 
-	for (bank = 0; bank < NR_BANKS; ++bank) {
+	per_cpu(threshold_banks, cpu) = kzalloc(sizeof(struct threshold_bank *)
+		* mca_cfg.banks, GFP_KERNEL);
+	if (per_cpu(threshold_banks, cpu) == NULL)
+		return -ENOMEM;
+
+	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		if (!(per_cpu(bank_map, cpu) & (1 << bank)))
 			continue;
 		err = threshold_create_bank(cpu, bank);
@@ -719,11 +723,12 @@ static void threshold_remove_device(unsigned int cpu)
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

