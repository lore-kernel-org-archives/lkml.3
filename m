Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbbAOVZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:25:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:58377 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbbAOVWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:48 -0500
Message-Id: <20150115211703.490719938@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 15/23] x86/ioapic: Add proper checks to setp/enable_IO_APIC()
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-ioapic-add-proper-checks.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point to have the same checks at every call site. Add them to the
functions, so they can be called unconditionally.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -1507,7 +1507,10 @@ void __init enable_IO_APIC(void)
 	int i8259_apic, i8259_pin;
 	int apic, pin;
 
-	if (!nr_legacy_irqs())
+	if (skip_ioapic_setup)
+		nr_ioapics = 0;
+
+	if (!nr_legacy_irqs() || !nr_ioapics)
 		return;
 
 	for_each_ioapic_pin(apic, pin) {
@@ -2373,9 +2376,9 @@ void __init setup_IO_APIC(void)
 {
 	int ioapic;
 
-	/*
-	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
-	 */
+	if (skip_ioapic_setup || !nr_ioapics)
+		return;
+
 	io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");


