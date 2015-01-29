Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbbA2PT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:19:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:3407 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbbA2PT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:19:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="447040628"
From: "Ong, Boon Leong" <boon.leong.ong@intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86: Re-enable IO-APIC for non-SMP X86_32
Thread-Topic: [PATCH] x86: Re-enable IO-APIC for non-SMP X86_32
Thread-Index: AQHQNpcKxZXLo5cz5kezgSBnVA9ESpzXP9Bg
Date: Thu, 29 Jan 2015 15:19:20 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B732715AD0@PGSMSX105.gar.corp.intel.com>
References: <1421967529-9037-1-git-send-email-pure.logic@nexus-software.ie>
In-Reply-To: <1421967529-9037-1-git-send-email-pure.logic@nexus-software.ie>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested this patch together with following v6 patch for Quark IMR: 
  1) x86: Add Isolated Memory Regions for Quark X1000
  2) x86, quark: Add Intel Quark platform support 

Built and tested on Galileo Genv2. This patch looks good.
I will give you my tested-by below.  Thanks!

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>owner@vger.kernel.org] On Behalf Of Bryan O'Donoghue
>Sent: Friday, January 23, 2015 6:59 AM
>To: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; x86@kernel.org;
>andy.shevchenko@gmail.com
>Cc: linux-kernel@vger.kernel.org; Bryan O'Donoghue
>Subject: [PATCH] x86: Re-enable IO-APIC for non-SMP X86_32
>
>Commit 0dbc6078c06bc0 ('x86, build, pci: Fix PCI_MSI build on !SMP')
>introduced the dependency that X86_UP_APIC should only be visible only when
>PCI_MSI is false.
>
>Conceptually this is invalid since any x86 system that supports MSIs must
>have an LAPIC to receive those messages. An MSI is written directly to the
>LAPIC of the CPU servicing the interrupt.
>
>Making X86_UP_APIC depend on !PCI_MSI means that X86_UP_IOAPIC will be
>false
>since X86_UP_IOAPIC depends on X86_UP_APIC. It also means that
>X86_IO_APIC
>cannot be true.
>
>In other words no 32 bit uniprocessor system that supports MSIs can have an
>IO-APIC, which is an architectually invalid statement.
>
>This patch removes the dependency on !PCI_MSI for X86_UP_APIC and as a
>consequence re-enables support for IO-APIC on 32 bit uniprocessor X86
>systems.
>
>Since Intel CE, Intel MID and Intel Quark are all 32-bit uniprocessor
>systems with an IO-APIC re-enabling IO-APIC for 32-bit x86 is required.
>
>Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
>Suggested-by: Thomas Gleixner <tglx@linutronix.de>
>Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Tested-by: Ong Boon Leong <boon.leong.ong@intel.com>

>---
> arch/x86/Kconfig | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>index ba397bd..0dc9d01 100644
>--- a/arch/x86/Kconfig
>+++ b/arch/x86/Kconfig
>@@ -857,7 +857,7 @@ source "kernel/Kconfig.preempt"
>
> config X86_UP_APIC
> 	bool "Local APIC support on uniprocessors"
>-	depends on X86_32 && !SMP && !X86_32_NON_STANDARD &&
>!PCI_MSI
>+	depends on X86_32 && !SMP && !X86_32_NON_STANDARD
> 	---help---
> 	  A local APIC (Advanced Programmable Interrupt Controller) is an
> 	  integrated interrupt controller in the CPU. If you have a single-CPU
>@@ -868,6 +868,10 @@ config X86_UP_APIC
> 	  performance counters), and the NMI watchdog which detects hard
> 	  lockups.
>
>+config X86_UP_APIC_MSI
>+	def_bool y
>+	select X86_UP_APIC if X86_32 && !SMP && !X86_32_NON_STANDARD
>&& PCI_MSI
>+
> config X86_UP_IOAPIC
> 	bool "IO-APIC support on uniprocessors"
> 	depends on X86_UP_APIC
>--
>1.9.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
