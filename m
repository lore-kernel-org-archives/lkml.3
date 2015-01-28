Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbbA2JAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:00:04 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754798AbbA2JAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:00 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 161/176] x86/apic: Re-enable PCI_MSI support for non-SMP X86_32
Date: Wed, 28 Jan 2015 15:29:51 +0100
Message-Id: <cad99a3029284319310b17934cb54443f118f814.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan O'Donoghue <pure.logic@nexus-software.ie>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 38a1dfda8e77d7ba74c94d06d8bc41ba98a4bc8c upstream.

Commit 0dbc6078c06bc0 ('x86, build, pci: Fix PCI_MSI build on !SMP')
introduced the dependency that X86_UP_APIC is only available when
PCI_MSI is false. This effectively prevents PCI_MSI support on 32bit
UP systems because it disables both APIC and IO-APIC. But APIC support
is architecturally required for PCI_MSI.

The intention of the patch was to enforce APIC support when PCI_MSI is
enabled, but failed to do so.

Remove the !PCI_MSI dependency from X86_UP_APIC and enforce
X86_UP_APIC when PCI_MSI support is enabled on 32bit UP systems.

[ tglx: Massaged changelog ]

Fixes 0dbc6078c06bc0 'x86, build, pci: Fix PCI_MSI build on !SMP'
Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: http://lkml.kernel.org/r/1421967529-9037-1-git-send-email-pure.logic@nexus-software.ie
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/Kconfig | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f968d8527190..5b5c6ea1a76c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -861,7 +861,7 @@ source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
-	depends on X86_32 && !SMP && !X86_32_NON_STANDARD && !PCI_MSI
+	depends on X86_32 && !SMP && !X86_32_NON_STANDARD
 	---help---
 	  A local APIC (Advanced Programmable Interrupt Controller) is an
 	  integrated interrupt controller in the CPU. If you have a single-CPU
@@ -872,6 +872,10 @@ config X86_UP_APIC
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
2.2.2

