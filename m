Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab3DWQcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:32:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54618 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199Ab3DWQbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:31:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Joseph Lo <josephl@nvidia.com>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 06/21] ARM: tegra: call cpu_do_idle from C code
Date: Tue, 23 Apr 2013 18:30:38 +0200
Message-Id: <1366734653-488286-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:KuSeNoc3P0TXsiYsJLBjf50vVOYVZtYMP2ehABaqIn2
 aV85/VSVWen7TN71tKLJRRScoJM3th3Qfh04R4HusangEOvz+m
 LY6DGYSeOcApaoDEFB87XFTbMhM/vNBlrggFL28J+wFeTgVucw
 cjwBOi3ntsBoQcixz40DYViqvod1vqpmKmj4zlvpee4AAAcF3V
 39CiBIBeftsxmp9pE5ltahaXozW6slzbBgiQrHy8KfGZWGRwAl
 vysHlK5vDkZMSAOhrdB1PfBUz6XKn++F/UIaHmhvFiAe4fETMm
 5u0ujj3qp+Al+OAkHeAdb8yZL20z5da+gfTUaZd7dCzo/nxreO
 WCwfKT7VQNSCyhCecFwnKgMn/5pjaQLSn+BgWM15R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building a kernel for multiple CPU architecture levels,
cpu_do_idle() is a macro for an indirect function call, which
cannot be called from assembly code as Tegra does.

Adding a trivial C wrapper for this function lets us build
a tegra kernel with ARMv6 support enabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Joseph Lo <josephl@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/pm.c            | 5 +++++
 arch/arm/mach-tegra/sleep-tegra20.S | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-tegra/pm.c b/arch/arm/mach-tegra/pm.c
index 523604d..398e932 100644
--- a/arch/arm/mach-tegra/pm.c
+++ b/arch/arm/mach-tegra/pm.c
@@ -181,6 +181,11 @@ bool tegra_set_cpu_in_lp2(int phy_cpu_id)
 	return last_cpu;
 }
 
+int tegra_cpu_do_idle(void)
+{
+	return cpu_do_idle();
+}
+
 static int tegra_sleep_cpu(unsigned long v2p)
 {
 	/* Switch to the identity mapping. */
diff --git a/arch/arm/mach-tegra/sleep-tegra20.S b/arch/arm/mach-tegra/sleep-tegra20.S
index 9f6bfafd..e3f2417 100644
--- a/arch/arm/mach-tegra/sleep-tegra20.S
+++ b/arch/arm/mach-tegra/sleep-tegra20.S
@@ -197,7 +197,7 @@ ENTRY(tegra20_sleep_cpu_secondary_finish)
 	mov	r3, #CPU_RESETTABLE
 	str	r3, [r0]
 
-	bl	cpu_do_idle
+	bl	tegra_cpu_do_idle
 
 	/*
 	 * cpu may be reset while in wfi, which will return through
-- 
1.8.1.2

