Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaAUKLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:11:19 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11855 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbaAUKKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:10:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 21 Jan 2014 02:10:06 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 4/5] ARM: trusted_foundations: implement do_idle()
Date: Tue, 21 Jan 2014 19:10:15 +0900
Message-ID: <1390299016-14105-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390299016-14105-1-git-send-email-acourbot@nvidia.com>
References: <1390299016-14105-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support the do_idle() firmware call, which is necessary to properly
support cpuidle.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/firmware/trusted_foundations.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm/firmware/trusted_foundations.c b/arch/arm/firmware/trusted_foundations.c
index ef1e3d8f4af0..7c14af809995 100644
--- a/arch/arm/firmware/trusted_foundations.c
+++ b/arch/arm/firmware/trusted_foundations.c
@@ -22,6 +22,15 @@
 
 #define TF_SET_CPU_BOOT_ADDR_SMC 0xfffff200
 
+#define TF_CPU_PM		 0xfffffffc
+#define TF_CPU_PM_LP0		 0xffffffe3
+#define TF_CPU_PM_LP1		 0xffffffe6
+#define TF_CPU_PM_LP1_NO_MC_CLK	 0xffffffe5
+#define TF_CPU_PM_LP2		 0xffffffe4
+#define TF_CPU_PM_LP2_NOFLUSH_L2 0xffffffe7
+
+static unsigned long cpu_boot_addr;
+
 static void __naked tf_generic_smc(u32 type, u32 arg1, u32 arg2)
 {
 	asm volatile(
@@ -41,13 +50,22 @@ static void __naked tf_generic_smc(u32 type, u32 arg1, u32 arg2)
 
 static int tf_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 {
-	tf_generic_smc(TF_SET_CPU_BOOT_ADDR_SMC, boot_addr, 0);
+	cpu_boot_addr = boot_addr;
+	tf_generic_smc(TF_SET_CPU_BOOT_ADDR_SMC, cpu_boot_addr, 0);
+
+	return 0;
+}
+
+static int tf_do_idle(void)
+{
+	tf_generic_smc(TF_CPU_PM, TF_CPU_PM_LP2_NOFLUSH_L2, cpu_boot_addr);
 
 	return 0;
 }
 
 static const struct firmware_ops trusted_foundations_ops = {
 	.set_cpu_boot_addr = tf_set_cpu_boot_addr,
+	.do_idle = tf_do_idle,
 };
 
 void register_trusted_foundations(struct trusted_foundations_platform_data *pd)
-- 
1.8.5.3

