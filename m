Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaBGNN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:13:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41592 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbaBGLsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Wang Nan <wangnan0@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 042/233] ARM: 7938/1: OMAP4/highbank: Flush L2 cache before disabling
Date: Fri,  7 Feb 2014 11:44:21 +0000
Message-Id: <1391773652-25214-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taras Kondratiuk <taras.kondratiuk@linaro.org>

commit b25f3e1c358434bf850220e04f28eebfc45eb634 upstream.

Kexec disables outer cache before jumping to reboot code, but it doesn't
flush it explicitly. Flush is done implicitly inside of l2x0_disable().
But some SoC's override default .disable handler and don't flush cache.
This may lead to a corrupted memory during Kexec reboot on these
platforms.

This patch adds cache flush inside of OMAP4 and Highbank outer_cache.disable()
handlers to make it consistent with default l2x0_disable().

Acked-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-highbank/highbank.c  | 1 +
 arch/arm/mach-omap2/omap4-common.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index d247cf2..4a929a2 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -71,6 +71,7 @@ void highbank_set_cpu_jump(int cpu, void *jump_addr)
 #ifdef CONFIG_CACHE_L2X0
 static void highbank_l2x0_disable(void)
 {
+	outer_flush_all();
 	/* Disable PL310 L2 Cache controller */
 	highbank_smc1(0x102, 0x0);
 }
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 5791143..3f44b16 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -163,6 +163,7 @@ void __iomem *omap4_get_l2cache_base(void)
 
 static void omap4_l2x0_disable(void)
 {
+	outer_flush_all();
 	/* Disable PL310 L2 Cache controller */
 	omap_smc1(0x102, 0x0);
 }
-- 
1.8.3.2

