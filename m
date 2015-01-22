Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbbAVOcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:32:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58071 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbAVOcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:32:33 -0500
Date: Thu, 22 Jan 2015 06:32:09 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-9c4d9c73dd380ecfe1893600174f96d0eb068997@git.kernel.org>
Cc: tony.luck@intel.com, mingo@kernel.org, bp@alien8.de,
        jiang.liu@linux.intel.com, hpa@zytor.com, tglx@linutronix.de,
        joro@8bytes.org, linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, joro@8bytes.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, mingo@kernel.org,
        tony.luck@intel.com, bp@alien8.de
In-Reply-To: <20150115211704.162567839@linutronix.de>
References: <20150115211704.162567839@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Consolidate boot cpu timer setup
Git-Commit-ID: 9c4d9c73dd380ecfe1893600174f96d0eb068997
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

Commit-ID:  9c4d9c73dd380ecfe1893600174f96d0eb068997
Gitweb:     http://git.kernel.org/tip/9c4d9c73dd380ecfe1893600174f96d0eb068997
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:45 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:56 +0100

x86: Consolidate boot cpu timer setup

Now that the APIC bringup is consolidated we can move the setup call
for the percpu clock event device to apic_bsp_setup().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/20150115211704.162567839@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 4 ++--
 arch/x86/kernel/smpboot.c   | 4 ----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 437c35b..b665d24 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2244,6 +2244,8 @@ int __init apic_bsp_setup(bool upmode)
 	end_local_APIC_setup();
 	irq_remap_enable_fault_handling();
 	setup_IO_APIC();
+	/* Setup local timer */
+	x86_init.timers.setup_percpu_clockev();
 	return id;
 }
 
@@ -2284,8 +2286,6 @@ int __init APIC_init_uniprocessor(void)
 	default_setup_apic_routing();
 	verify_local_APIC();
 	apic_bsp_setup(true);
-
-	x86_init.timers.setup_percpu_clockev();
 	return 0;
 }
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0a46e5e..febc6aa 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1163,12 +1163,8 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	cpu0_logical_apicid = apic_bsp_setup(false);
 
-	/*
-	 * Set up local APIC timer on boot CPU.
-	 */
 	pr_info("CPU%d: ", 0);
 	print_cpu_info(&cpu_data(0));
-	x86_init.timers.setup_percpu_clockev();
 
 	if (is_uv_system())
 		uv_system_init();
