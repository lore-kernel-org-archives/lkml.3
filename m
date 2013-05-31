Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3EaJy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:54:27 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:37319 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203Ab3EaJyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:54:13 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: Barry Song <baohua.song@csr.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH v1 1/2] ARM:prima2: move sirfsoc_of_rstc_init to .init_early
Date: Fri, 31 May 2013 10:45:01 +0100
Message-Id: <1369993501-24309-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1369993439-24216-1-git-send-email-srinivas.kandagatla@st.com>
References: <1369993439-24216-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch moves sirfsoc_of_rstc_init from early_initcall to .init_early
in machine descriptor, doing this way a multi_v7 kernel will not crash
on non-prima2 SOCs.

Without this patch the multi_v7 kernel panics if we boot it on any non
prima2 parts with below log:

Kernel panic - not syncing: unable to find compatible rstc node in dtb

CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00535-gc3cc4ac #62
[<c001387c>] (unwind_backtrace+0x0/0xf8) from [<c00111cc>]
(show_stack+0x10/0x14)
[<c00111cc>] (show_stack+0x10/0x14) from [<c03417f4>] (panic+0x90/0x1e4)
[<c03417f4>] (panic+0x90/0x1e4) from [<c04256d0>]
(sirfsoc_of_rstc_init+0x24/0x5c)
[<c04256d0>] (sirfsoc_of_rstc_init+0x24/0x5c) from [<c041f854>]
(do_one_initcall+0x90/0x150)
[<c041f854>] (do_one_initcall+0x90/0x150) from [<c041f978>]
(kernel_init_freeable+0x64/0x1c4)
[<c041f978>] (kernel_init_freeable+0x64/0x1c4) from [<c033d344>]
(kernel_init+0x8/0xe4)
[<c033d344>] (kernel_init+0x8/0xe4) from [<c000ded8>]
(ret_from_fork+0x14/0x3c)

Initially detected when booting Stih415 SOC with multi_v7_defconfig.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 arch/arm/mach-prima2/common.c |    3 +++
 arch/arm/mach-prima2/common.h |    1 +
 arch/arm/mach-prima2/rstc.c   |    5 +----
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-prima2/common.c b/arch/arm/mach-prima2/common.c
index 4f94cd8..9aefcd6 100644
--- a/arch/arm/mach-prima2/common.c
+++ b/arch/arm/mach-prima2/common.c
@@ -61,6 +61,7 @@ DT_MACHINE_START(ATLAS6_DT, "Generic ATLAS6 (Flattened Device Tree)")
 	.init_late	= sirfsoc_init_late,
 	.dt_compat      = atlas6_dt_match,
 	.restart	= sirfsoc_restart,
+	.init_early	= sirfsoc_of_rstc_init,
 MACHINE_END
 #endif
 
@@ -81,6 +82,7 @@ DT_MACHINE_START(PRIMA2_DT, "Generic PRIMA2 (Flattened Device Tree)")
 	.init_late	= sirfsoc_init_late,
 	.dt_compat      = prima2_dt_match,
 	.restart	= sirfsoc_restart,
+	.init_early	= sirfsoc_of_rstc_init,
 MACHINE_END
 #endif
 
@@ -100,5 +102,6 @@ DT_MACHINE_START(MARCO_DT, "Generic MARCO (Flattened Device Tree)")
 	.init_late	= sirfsoc_init_late,
 	.dt_compat      = marco_dt_match,
 	.restart	= sirfsoc_restart,
+	.init_early	= sirfsoc_of_rstc_init,
 MACHINE_END
 #endif
diff --git a/arch/arm/mach-prima2/common.h b/arch/arm/mach-prima2/common.h
index 81135cd..65703a4 100644
--- a/arch/arm/mach-prima2/common.h
+++ b/arch/arm/mach-prima2/common.h
@@ -20,6 +20,7 @@ extern struct smp_operations   sirfsoc_smp_ops;
 extern void sirfsoc_secondary_startup(void);
 extern void sirfsoc_cpu_die(unsigned int cpu);
 
+extern void sirfsoc_of_rstc_init(void);
 extern void __init sirfsoc_of_irq_init(void);
 extern void __init sirfsoc_of_clk_init(void);
 extern void sirfsoc_restart(char, const char *);
diff --git a/arch/arm/mach-prima2/rstc.c b/arch/arm/mach-prima2/rstc.c
index 435019c..5506425 100644
--- a/arch/arm/mach-prima2/rstc.c
+++ b/arch/arm/mach-prima2/rstc.c
@@ -23,7 +23,7 @@ static struct of_device_id rstc_ids[]  = {
 	{},
 };
 
-static int __init sirfsoc_of_rstc_init(void)
+void sirfsoc_of_rstc_init(void)
 {
 	struct device_node *np;
 
@@ -36,10 +36,7 @@ static int __init sirfsoc_of_rstc_init(void)
 		panic("unable to map rstc cpu registers\n");
 
 	of_node_put(np);
-
-	return 0;
 }
-early_initcall(sirfsoc_of_rstc_init);
 
 int sirfsoc_reset_device(struct device *dev)
 {
-- 
1.7.6.5

