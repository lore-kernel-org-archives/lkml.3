Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbaCKMjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:39:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbaCKMjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:39:41 -0400
Date: Tue, 11 Mar 2014 05:39:17 -0700
From: tip-bot for Jan Kiszka <tipbot@zytor.com>
Message-ID: <tip-ea7bdc65bca8cf837a63e0ff7b75daed83222511@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        imammedo@redhat.com, jan.kiszka@siemens.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        imammedo@redhat.com, tglx@linutronix.de, jan.kiszka@siemens.com
In-Reply-To: <52E6AFFE.3030004@siemens.com>
References: <52E6AFFE.3030004@siemens.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic:
  Plug racy xAPIC access of CPU hotplug code
Git-Commit-ID: ea7bdc65bca8cf837a63e0ff7b75daed83222511
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

Commit-ID:  ea7bdc65bca8cf837a63e0ff7b75daed83222511
Gitweb:     http://git.kernel.org/tip/ea7bdc65bca8cf837a63e0ff7b75daed83222511
Author:     Jan Kiszka <jan.kiszka@siemens.com>
AuthorDate: Mon, 27 Jan 2014 20:14:06 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 12:03:31 +0100

x86/apic: Plug racy xAPIC access of CPU hotplug code

apic_icr_write() and its users in smpboot.c were apparently
written under the assumption that this code would only run
during early boot. But nowadays we also execute it when onlining
a CPU later on while the system is fully running. That will make
wakeup_cpu_via_init_nmi and, thus, also native_apic_icr_write
run in plain process context. If we migrate the caller to a
different CPU at the wrong time or interrupt it and write to
ICR/ICR2 to send unrelated IPIs, we can end up sending INIT,
SIPI or NMIs to wrong CPUs.

Fix this by disabling interrupts during the write to the ICR
halves and disable preemption around waiting for ICR
availability and using it.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Tested-By: Igor Mammedov <imammedo@redhat.com>
Link: http://lkml.kernel.org/r/52E6AFFE.3030004@siemens.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/apic.c |  4 ++++
 arch/x86/kernel/smpboot.c   | 11 +++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f824d69..53e2053 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -286,8 +286,12 @@ u32 native_safe_apic_wait_icr_idle(void)
 
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
index c77acc6..60179ec 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -702,11 +702,15 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid,
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
@@ -726,6 +730,9 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid,
 		boot_error = wakeup_secondary_cpu_via_nmi(id, start_ip);
 	}
 
+out:
+	preempt_enable();
+
 	return boot_error;
 }
 
