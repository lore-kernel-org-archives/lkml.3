Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbbAVW65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:58:57 -0500
Received: from outbound-smtp06.blacknight.com ([81.17.249.39]:49552 "EHLO
	outbound-smtp06.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753761AbbAVW6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:58:54 -0500
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        andy.shevchenko@gmail.com
Cc: linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH] x86: Re-enable IO-APIC for non-SMP X86_32
Date: Thu, 22 Jan 2015 22:58:49 +0000
Message-Id: <1421967529-9037-1-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0dbc6078c06bc0 ('x86, build, pci: Fix PCI_MSI build on !SMP')
introduced the dependency that X86_UP_APIC should only be visible only when
PCI_MSI is false.

Conceptually this is invalid since any x86 system that supports MSIs must
have an LAPIC to receive those messages. An MSI is written directly to the
LAPIC of the CPU servicing the interrupt.

Making X86_UP_APIC depend on !PCI_MSI means that X86_UP_IOAPIC will be false
since X86_UP_IOAPIC depends on X86_UP_APIC. It also means that X86_IO_APIC
cannot be true.

In other words no 32 bit uniprocessor system that supports MSIs can have an
IO-APIC, which is an architectually invalid statement.

This patch removes the dependency on !PCI_MSI for X86_UP_APIC and as a
consequence re-enables support for IO-APIC on 32 bit uniprocessor X86
systems.

Since Intel CE, Intel MID and Intel Quark are all 32-bit uniprocessor
systems with an IO-APIC re-enabling IO-APIC for 32-bit x86 is required.

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 arch/x86/Kconfig | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ba397bd..0dc9d01 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -857,7 +857,7 @@ source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
-	depends on X86_32 && !SMP && !X86_32_NON_STANDARD && !PCI_MSI
+	depends on X86_32 && !SMP && !X86_32_NON_STANDARD
 	---help---
 	  A local APIC (Advanced Programmable Interrupt Controller) is an
 	  integrated interrupt controller in the CPU. If you have a single-CPU
@@ -868,6 +868,10 @@ config X86_UP_APIC
 	  performance counters), and the NMI watchdog which detects hard
 	  lockups.
 
+config X86_UP_APIC_MSI
+	def_bool y
+	select X86_UP_APIC if X86_32 && !SMP && !X86_32_NON_STANDARD && PCI_MSI
+
 config X86_UP_IOAPIC
 	bool "IO-APIC support on uniprocessors"
 	depends on X86_UP_APIC
-- 
1.9.1

