Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaLQEcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 23:32:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:50101 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbaLQEcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 23:32:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="429971111"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Toshi Kani <toshi.kani@hp.com>,
        Igor Mammedov <imammedo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Jiang Liu <jiang.liu@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: [Patch v1 01/17] x86, smpboot: Remove pointless preempt_disable() in native_smp_prepare_cpus()
Date: Wed, 17 Dec 2014 12:35:32 +0800
Message-Id: <1418790948-22804-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1418790948-22804-1-git-send-email-jiang.liu@linux.intel.com>
References: <1418790948-22804-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

There is no reason to keep preemption disabled in this function.

We only have two other threads live: kthreadd and idle. Neither of
them is going to preempt. But that preempt_disable forces all the code
inside to do GFP_ATOMIC allocations which is just insane.

Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20141205084147.153643952@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/smpboot.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7a8f5845e8eb..6d7022c683e3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1084,7 +1084,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
 	unsigned int i;
 
-	preempt_disable();
 	smp_cpu_index_default();
 
 	/*
@@ -1102,22 +1101,19 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	}
 	set_cpu_sibling_map(0);
 
-
 	if (smp_sanity_check(max_cpus) < 0) {
 		pr_info("SMP disabled\n");
 		disable_smp();
-		goto out;
+		return;
 	}
 
 	default_setup_apic_routing();
 
-	preempt_disable();
 	if (read_apic_id() != boot_cpu_physical_apicid) {
 		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
 		     read_apic_id(), boot_cpu_physical_apicid);
 		/* Or can we switch back to PIC here? */
 	}
-	preempt_enable();
 
 	connect_bsp_APIC();
 
@@ -1151,8 +1147,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		uv_system_init();
 
 	set_mtrr_aps_delayed_init();
-out:
-	preempt_enable();
 }
 
 void arch_enable_nonboot_cpus_begin(void)
-- 
1.7.10.4

