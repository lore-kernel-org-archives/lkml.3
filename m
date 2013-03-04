Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab3CDEHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:07:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32823 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756234Ab3CDDn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:29 -0500
Message-Id: <20130304033717.087885897@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:43 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Phileas Fogg <phileas-fogg@mail.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 096/153] powerpc/kexec: Disable hard IRQ before kexec
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phileas Fogg <phileas-fogg@mail.ru>

commit 8520e443aa56cc157b015205ea53e7b9fc831291 upstream.

Disable hard IRQ before kexec a new kernel image.
Not doing it can result in corrupted data in the memory segments
reserved for the new kernel.

Signed-off-by: Phileas Fogg <phileas-fogg@mail.ru>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/machine_kexec_64.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -162,6 +162,8 @@ static int kexec_all_irq_disabled = 0;
 static void kexec_smp_down(void *arg)
 {
 	local_irq_disable();
+	hard_irq_disable();
+
 	mb(); /* make sure our irqs are disabled before we say they are */
 	get_paca()->kexec_state = KEXEC_STATE_IRQS_OFF;
 	while(kexec_all_irq_disabled == 0)
@@ -244,6 +246,8 @@ static void kexec_prepare_cpus(void)
 	wake_offline_cpus();
 	smp_call_function(kexec_smp_down, NULL, /* wait */0);
 	local_irq_disable();
+	hard_irq_disable();
+
 	mb(); /* make sure IRQs are disabled before we say they are */
 	get_paca()->kexec_state = KEXEC_STATE_IRQS_OFF;
 
@@ -281,6 +285,7 @@ static void kexec_prepare_cpus(void)
 	if (ppc_md.kexec_cpu_down)
 		ppc_md.kexec_cpu_down(0, 0);
 	local_irq_disable();
+	hard_irq_disable();
 }
 
 #endif /* SMP */


