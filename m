Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaBEHzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 02:55:03 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64724 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaBEHzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 02:55:01 -0500
Date: Tue, 4 Feb 2014 23:54:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [patch 1/4] x86, apic: Only use default_wait_for_init_deassert
Message-ID: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

es7000_wait_for_init_deassert() is functionally equivalent to 
default_wait_for_init_deassert(), so remove the duplicate code and use
only a single function.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/apic.h      | 1 -
 arch/x86/kernel/apic/es7000_32.c | 8 +-------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -521,7 +521,6 @@ static inline void default_wait_for_init_deassert(atomic_t *deassert)
 {
 	while (!atomic_read(deassert))
 		cpu_relax();
-	return;
 }
 
 extern void generic_bigsmp_probe(void);
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -394,12 +394,6 @@ static void es7000_enable_apic_mode(void)
 		WARN(1, "Command failed, status = %x\n", mip_status);
 }
 
-static void es7000_wait_for_init_deassert(atomic_t *deassert)
-{
-	while (!atomic_read(deassert))
-		cpu_relax();
-}
-
 static unsigned int es7000_get_apic_id(unsigned long x)
 {
 	return (x >> 24) & 0xFF;
@@ -722,7 +716,7 @@ static struct apic __refdata apic_es7000 = {
 	.trampoline_phys_low		= 0x467,
 	.trampoline_phys_high		= 0x469,
 
-	.wait_for_init_deassert		= es7000_wait_for_init_deassert,
+	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
 	/* Nothing to do for most platforms, since cleared by the INIT cycle: */
 	.smp_callin_clear_local_apic	= NULL,
