Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbbAWJ2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:28:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35262 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAWJ15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:27:57 -0500
Date: Fri, 23 Jan 2015 01:27:32 -0800
From: "tip-bot for Bryan O'Donoghue" <tipbot@zytor.com>
Message-ID: <tip-38a1dfda8e77d7ba74c94d06d8bc41ba98a4bc8c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, thomas.petazzoni@free-electrons.com,
        tglx@linutronix.de, pure.logic@nexus-software.ie, hpa@zytor.com,
        andy.shevchenko@gmail.com, mingo@kernel.org
Reply-To: linux-kernel@vger.kernel.org, hpa@zytor.com,
        pure.logic@nexus-software.ie, tglx@linutronix.de, mingo@kernel.org,
        andy.shevchenko@gmail.com, thomas.petazzoni@free-electrons.com
In-Reply-To: <1421967529-9037-1-git-send-email-pure.logic@nexus-software.ie>
References: <1421967529-9037-1-git-send-email-pure.logic@nexus-software.ie>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/apic:
  Re-enable PCI_MSI support for non-SMP X86_32
Git-Commit-ID: 38a1dfda8e77d7ba74c94d06d8bc41ba98a4bc8c
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

Commit-ID:  38a1dfda8e77d7ba74c94d06d8bc41ba98a4bc8c
Gitweb:     http://git.kernel.org/tip/38a1dfda8e77d7ba74c94d06d8bc41ba98a4bc8c
Author:     Bryan O'Donoghue <pure.logic@nexus-software.ie>
AuthorDate: Thu, 22 Jan 2015 22:58:49 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 23 Jan 2015 10:20:30 +0100

x86/apic: Re-enable PCI_MSI support for non-SMP X86_32

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1421967529-9037-1-git-send-email-pure.logic@nexus-software.ie
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
