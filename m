Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaBKAoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:44:46 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:58639 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaBKAop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:44:45 -0500
From: Stefan Agner <stefan@agner.ch>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, josephl@nvidia.com
Cc: dev@lynxeye.de, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH] ARM: tegra: don't timeout if CPU is powergated
Date: Tue, 11 Feb 2014 01:44:13 +0100
Message-Id: <1d5ea6b7df4573d866779857922ac650fe59af60.1392078805.git.stefan@agner.ch>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting secondary CPU(s) which are not yet powergated, a wrong
check lead to a timeout after 100 jiffies. With this patch, we only
delay powergating if CPUs are still not powered yet.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
I happend to come accross this while working on Colibri T30 support.
Obviously, the downstream U-Boot doesn't powergate all CPUs, so
the Linux kernel always timed out when booting CPU 1 through 3...

 arch/arm/mach-tegra/platsmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index eb72ae7..929d104 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -114,7 +114,7 @@ static int tegra30_boot_secondary(unsigned int cpu, struct task_struct *idle)
 
 		/* Wait for the power to come up. */
 		timeout = jiffies + msecs_to_jiffies(100);
-		while (tegra_pmc_cpu_is_powered(cpu)) {
+		while (!tegra_pmc_cpu_is_powered(cpu)) {
 			if (time_after(jiffies, timeout))
 				return -ETIMEDOUT;
 			udelay(10);
-- 
1.8.5.4

