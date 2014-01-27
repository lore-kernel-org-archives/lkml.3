Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaA0TOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:14:31 -0500
Received: from goliath.siemens.de ([192.35.17.28]:47151 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaA0TO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:14:29 -0500
Message-ID: <52E6AFFE.3030004@siemens.com>
Date: Mon, 27 Jan 2014 20:14:06 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Plug racy xAPIC access of CPU hotplug code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apic_icr_write and its users in smpboot.c were apparently written under
the assumption that this code would only run during early boot. But
nowadays we also execute it when onlining a CPU later on while the
system is fully running. That will make wakeup_cpu_via_init_nmi and,
thus, also native_apic_icr_write run in plain process context. If we
migrate the caller to a different CPU at the wrong time or interrupt it
and write to ICR/ICR2 to send unrelated IPIs, we can end up sending
INIT, SIPI or NMIs to wrong CPUs.

Fix this by disabling interrupts during the write to the ICR halves and
disable preemption around waiting for ICR availability and using it.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 arch/x86/kernel/apic/apic.c |  4 ++++
 arch/x86/kernel/smpboot.c   | 11 +++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7f26c9a..06f90b8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -283,8 +283,12 @@ u32 native_safe_apic_wait_icr_idle(void)
 
 void native_apic_icr_write(u32 low, u32 id)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
 	apic_write(APIC_ICR, low);
+	local_irq_restore(flags);
 }
 
 u64 native_apic_icr_read(void)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a32da80..37e11e5 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -701,11 +701,15 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid,
 	int id;
 	int boot_error;
 
+	preempt_disable();
+
 	/*
 	 * Wake up AP by INIT, INIT, STARTUP sequence.
 	 */
-	if (cpu)
-		return wakeup_secondary_cpu_via_init(apicid, start_ip);
+	if (cpu) {
+		boot_error = wakeup_secondary_cpu_via_init(apicid, start_ip);
+		goto out;
+	}
 
 	/*
 	 * Wake up BSP by nmi.
@@ -725,6 +729,9 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid,
 		boot_error = wakeup_secondary_cpu_via_nmi(id, start_ip);
 	}
 
+out:
+	preempt_enable();
+
 	return boot_error;
 }
 
-- 
1.8.1.1.298.ge7eed54
