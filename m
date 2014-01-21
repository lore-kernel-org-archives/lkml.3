Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaAUKKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:10:46 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11849 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbaAUKKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:10:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 21 Jan 2014 02:10:00 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/5] ARM: trusted_foundations: fallback when TF support is missing
Date: Tue, 21 Jan 2014 19:10:13 +0900
Message-ID: <1390299016-14105-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390299016-14105-1-git-send-email-acourbot@nvidia.com>
References: <1390299016-14105-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When Trusted Foundations is detected as present on the system, but
Trusted Foundations support is not built into the kernel, the kernel
used to issue a panic very early during boot, leaving little clue to the
user as to what is going wrong.

It turns out that even without TF support built-in, the kernel can boot
on a TF-enabled system provided that SMP and cpuidle are disabled. This
patch does this and continue booting on one CPU, leaving the user with a
usable (however degraded) system.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/include/asm/trusted_foundations.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/trusted_foundations.h b/arch/arm/include/asm/trusted_foundations.h
index 997862fd5d77..b5f7705abcb0 100644
--- a/arch/arm/include/asm/trusted_foundations.h
+++ b/arch/arm/include/asm/trusted_foundations.h
@@ -30,6 +30,8 @@
 #include <linux/printk.h>
 #include <linux/bug.h>
 #include <linux/of.h>
+#include <linux/cpu.h>
+#include <linux/smp.h>
 
 struct trusted_foundations_platform_data {
 	unsigned int version_major;
@@ -47,10 +49,13 @@ static inline void register_trusted_foundations(
 				   struct trusted_foundations_platform_data *pd)
 {
 	/*
-	 * If we try to register TF, this means the system needs it to continue.
-	 * Its absence if thus a fatal error.
+	 * If the system requires TF and we cannot provide it, continue booting
+	 * but disable features that cannot be provided.
 	 */
-	panic("No support for Trusted Foundations, stopping...\n");
+	pr_err("No support for Trusted Foundations, continuing in degraded mode.\n");
+	pr_err("Secondary processors as well as CPU PM will be disabled.\n");
+	setup_max_cpus = 0;
+	cpu_idle_poll_ctrl(true);
 }
 
 static inline void of_register_trusted_foundations(void)
-- 
1.8.5.3

