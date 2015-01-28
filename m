Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661AbbA1BnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:43:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383AbbA1Bij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bryan ODonoghue <pure.logic@nexus-software.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH 3.14 29/77] x86/apic: Re-enable PCI_MSI support for non-SMP X86_32
Date: Tue, 27 Jan 2015 17:27:07 -0800
Message-Id: <20150128012746.847114092@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <pure.logic@nexus-software.ie>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/Kconfig |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -854,7 +854,7 @@ source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
-	depends on X86_32 && !SMP && !X86_32_NON_STANDARD && !PCI_MSI
+	depends on X86_32 && !SMP && !X86_32_NON_STANDARD
 	---help---
 	  A local APIC (Advanced Programmable Interrupt Controller) is an
 	  integrated interrupt controller in the CPU. If you have a single-CPU
@@ -865,6 +865,10 @@ config X86_UP_APIC
 	  performance counters), and the NMI watchdog which detects hard
 	  lockups.
 
+config X86_UP_APIC_MSI
+	def_bool y
+	select X86_UP_APIC if X86_32 && !SMP && !X86_32_NON_STANDARD && PCI_MSI
+
 config X86_UP_IOAPIC
 	bool "IO-APIC support on uniprocessors"
 	depends on X86_UP_APIC


