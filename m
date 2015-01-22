Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbbAVVmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:42:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:33650 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbbAVVmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:42:50 -0500
Date: Thu, 22 Jan 2015 22:42:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Re-enable IO-APIC for non-SMP X86_32
In-Reply-To: <1421960036-7019-1-git-send-email-pure.logic@nexus-software.ie>
Message-ID: <alpine.DEB.2.11.1501222230180.5526@nanos>
References: <1421960036-7019-1-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Bryan O'Donoghue wrote:

> Commit 0dbc6078c0 ('x86, build, pci: Fix PCI_MSI build on !SMP')
> introduced the dependency that X86_UP_APIC should only be visible only when
> PCI_MSI is false.

I think the intention of the patch was to NOT expose the option when
MSI is enabled, so you cannot turn it off, which makes sense.

But that went wrong.....

> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -857,7 +857,7 @@ source "kernel/Kconfig.preempt"
>  
>  config X86_UP_APIC
>  	bool "Local APIC support on uniprocessors"
> -	depends on X86_32 && !SMP && !X86_32_NON_STANDARD && !PCI_MSI
> +	depends on X86_32 && !SMP && !X86_32_NON_STANDARD

So the proper fix is below.

Thanks,

	tglx
---

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ffcc3ca5862a..a0dbc33690f0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -861,7 +861,7 @@ config UP_LATE_INIT
 
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

