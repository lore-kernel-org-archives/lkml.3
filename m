Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097Ab3B1PHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:07:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42255 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758615Ab3B1Osy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Phileas Fogg <phileas-fogg@mail.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 075/139] powerpc/kexec: Disable hard IRQ before kexec
Date: Thu, 28 Feb 2013 14:43:45 +0000
Message-Id: <1362062689-2567-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phileas Fogg <phileas-fogg@mail.ru>

commit 8520e443aa56cc157b015205ea53e7b9fc831291 upstream.

Disable hard IRQ before kexec a new kernel image.
Not doing it can result in corrupted data in the memory segments
reserved for the new kernel.

Signed-off-by: Phileas Fogg <phileas-fogg@mail.ru>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/machine_kexec_64.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index d7f6090..39833e0 100644
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
-- 
1.8.1.2

