Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab3B0AQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:16:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760426Ab3B0AJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Phileas Fogg <phileas-fogg@mail.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 61/86] powerpc/kexec: Disable hard IRQ before kexec
Date: Tue, 26 Feb 2013 16:08:09 -0800
Message-Id: <20130226235919.234881382@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phileas Fogg <phileas-fogg@mail.ru>

commit 8520e443aa56cc157b015205ea53e7b9fc831291 upstream.

Disable hard IRQ before kexec a new kernel image.
Not doing it can result in corrupted data in the memory segments
reserved for the new kernel.

Signed-off-by: Phileas Fogg <phileas-fogg@mail.ru>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


