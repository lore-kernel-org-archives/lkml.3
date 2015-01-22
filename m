Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbbAVUyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:54:07 -0500
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:44558 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147AbbAVUyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:54:02 -0500
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH] x86: Re-enable IO-APIC for non-SMP X86_32
Date: Thu, 22 Jan 2015 20:53:56 +0000
Message-Id: <1421960036-7019-1-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0dbc6078c0 ('x86, build, pci: Fix PCI_MSI build on !SMP')
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

Since Intel-CE, Intel-Mid and Intel-Quark are all 32-bit uniprocessor
systems with an IO-APIC re-enabling IO-APIC for 32-bit x86 is required.

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ba397bd..b36a7bd 100644
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
-- 
1.9.1

