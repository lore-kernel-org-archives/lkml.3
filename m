Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbbAVOaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:30:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57994 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbbAVOaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:30:10 -0500
Date: Thu, 22 Jan 2015 06:29:47 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-35e4c6d30e6f69745d77afd5f63203ad440bed12@git.kernel.org>
Cc: hpa@zytor.com, joro@8bytes.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, bp@alien8.de,
        jiang.liu@linux.intel.com, tglx@linutronix.de
Reply-To: joro@8bytes.org, hpa@zytor.com, tony.luck@intel.com,
        jiang.liu@linux.intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de
In-Reply-To: <20150115211703.569830549@linutronix.de>
References: <20150115211703.569830549@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Sanitize ioapic handling
Git-Commit-ID: 35e4c6d30e6f69745d77afd5f63203ad440bed12
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

Commit-ID:  35e4c6d30e6f69745d77afd5f63203ad440bed12
Gitweb:     http://git.kernel.org/tip/35e4c6d30e6f69745d77afd5f63203ad440bed12
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:34 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:55 +0100

x86/apic: Sanitize ioapic handling

We have proper stubs for the IOAPIC=n case and the setup/enable
function have the required checks inside now. Remove the ifdeffery and
the copy&pasted conditionals.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>C
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20150115211703.569830549@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 0c554f5..3b4bdd5 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1905,24 +1905,13 @@ int __init APIC_init_uniprocessor(void)
 	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
 	setup_local_APIC();
 
-#ifdef CONFIG_X86_IO_APIC
-	/*
-	 * Now enable IO-APICs, actually call clear_IO_APIC
-	 * We need clear_IO_APIC before enabling error vector
-	 */
-	if (!skip_ioapic_setup && nr_ioapics)
-		enable_IO_APIC();
-#endif
+	/* Enable IO-APICs before enabling error vector */
+	enable_IO_APIC();
 
 	bsp_end_local_APIC_setup();
 
-#ifdef CONFIG_X86_IO_APIC
-	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
+	if (smp_found_config)
 		setup_IO_APIC();
-	else {
-		nr_ioapics = 0;
-	}
-#endif
 
 	x86_init.timers.setup_percpu_clockev();
 	return 0;
