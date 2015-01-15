Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbbAOVWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:22:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:58346 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbbAOVWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:43 -0500
Message-Id: <20150115211703.209387598@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 12/23] x86/x2apic: Use state information for disable
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=x86-x2apic-use-state-information-for-disable.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the state information to simplify the disable logic further.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1545,26 +1545,21 @@ void x2apic_setup(void)
 
 static __init void x2apic_disable(void)
 {
-	u64 msr;
+	u32 x2apic_id;
 
-	if (!cpu_has_x2apic)
-		return;
+	if (x2apic_state != X2APIC_ON)
+		goto out;
 
-	rdmsrl(MSR_IA32_APICBASE, msr);
-	if (msr & X2APIC_ENABLE) {
-		u32 x2apic_id = read_apic_id();
+	x2apic_id = read_apic_id();
+	if (x2apic_id >= 255)
+		panic("Cannot disable x2apic, id: %08x\n", x2apic_id);
 
-		if (x2apic_id >= 255)
-			panic("Cannot disable x2apic, id: %08x\n", x2apic_id);
-
-		disable_x2apic();
-
-		x2apic_mode = 0;
-
-		register_lapic_address(mp_lapic_addr);
-	}
+	disable_x2apic();
+	register_lapic_address(mp_lapic_addr);
 
+out:
 	x2apic_state = X2APIC_DISABLED;
+	x2apic_mode = 0;
 }
 
 static __init void x2apic_enable(void)


