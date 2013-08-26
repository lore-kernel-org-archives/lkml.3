Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab3HZDAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 23:00:46 -0400
Received: from mail7.windriver.com ([128.224.252.3]:55641 "EHLO
	mail7.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab3HZDAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 23:00:44 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [v4][PATCH 6/8] book3e/kexec/kdump: implement ppc64 kexec specfic
Date: Mon, 26 Aug 2013 11:00:56 +0800
Message-ID: <1377486058-30379-7-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377486058-30379-1-git-send-email-tiejun.chen@windriver.com>
References: <1377486058-30379-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ppc64 kexec mechanism has a different implementation with ppc32.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/platforms/85xx/smp.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
index 549948a..137ad10 100644
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -277,6 +277,7 @@ struct smp_ops_t smp_85xx_ops = {
 };
 
 #ifdef CONFIG_KEXEC
+#ifdef CONFIG_PPC32
 atomic_t kexec_down_cpus = ATOMIC_INIT(0);
 
 void mpc85xx_smp_kexec_cpu_down(int crash_shutdown, int secondary)
@@ -295,6 +296,14 @@ static void mpc85xx_smp_kexec_down(void *arg)
 	if (ppc_md.kexec_cpu_down)
 		ppc_md.kexec_cpu_down(0,1);
 }
+#else
+void mpc85xx_smp_kexec_cpu_down(int crash_shutdown, int secondary)
+{
+	local_irq_disable();
+	hard_irq_disable();
+	mpic_teardown_this_cpu(secondary);
+}
+#endif
 
 static void map_and_flush(unsigned long paddr)
 {
@@ -346,11 +355,14 @@ static void mpc85xx_smp_flush_dcache_kexec(struct kimage *image)
 
 static void mpc85xx_smp_machine_kexec(struct kimage *image)
 {
+#ifdef CONFIG_PPC32
 	int timeout = INT_MAX;
 	int i, num_cpus = num_present_cpus();
+#endif
 
 	mpc85xx_smp_flush_dcache_kexec(image);
 
+#ifdef CONFIG_PPC32
 	if (image->type == KEXEC_TYPE_DEFAULT)
 		smp_call_function(mpc85xx_smp_kexec_down, NULL, 0);
 
@@ -368,6 +380,7 @@ static void mpc85xx_smp_machine_kexec(struct kimage *image)
 		if ( i == smp_processor_id() ) continue;
 		mpic_reset_core(i);
 	}
+#endif
 
 	default_machine_kexec(image);
 }
-- 
1.7.9.5

