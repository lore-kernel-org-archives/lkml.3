Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaLSOC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:02:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45749 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaLSOCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:02:53 -0500
Date: Fri, 19 Dec 2014 06:02:29 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-250a1ac685f147d4f4b2f132cfaffcce1a6792c1@git.kernel.org>
Cc: hpa@zytor.com, tglx@linutronix.de, joro@8bytes.org, bp@alien8.de,
        jiang.liu@linux.intel.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org
Reply-To: jiang.liu@linux.intel.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, hpa@zytor.com
In-Reply-To: <20141205084147.153643952@linutronix.de>
References: <20141205084147.153643952@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, smpboot: Remove pointless preempt_disable()
  in native_smp_prepare_cpus()
Git-Commit-ID: 250a1ac685f147d4f4b2f132cfaffcce1a6792c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  250a1ac685f147d4f4b2f132cfaffcce1a6792c1
Gitweb:     http://git.kernel.org/tip/250a1ac685f147d4f4b2f132cfaffcce1a6792c1
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 5 Dec 2014 08:48:29 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:14 +0100

x86, smpboot: Remove pointless preempt_disable() in native_smp_prepare_cpus()

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

---
 arch/x86/kernel/smpboot.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7a8f584..6d7022c 100644
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
