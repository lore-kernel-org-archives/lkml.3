Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaBLCnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:43:52 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10613 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaBLCnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:43:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 11 Feb 2014 18:42:00 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>
CC: Tomasz Figa <t.figa@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3] ARM: tegra: cpuidle: use firmware for power down
Date: Wed, 12 Feb 2014 11:43:44 +0900
Message-ID: <1392173024-11567-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <52FAD4C2.80803@nvidia.com>
References: <52FAD4C2.80803@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempt to invoke the prepare_idle() and do_idle() firmware calls
to power down a CPU so an underlying firmware gets informed of
the idle operation and performs it by itself if designed in such a way.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
This is the only v3 patch in the series.

Changes since v2:
- Use an if statement instead of a switch to handle the single return
  code we need to care about.

 arch/arm/mach-tegra/cpuidle-tegra114.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-tegra/cpuidle-tegra114.c b/arch/arm/mach-tegra/cpuidle-tegra114.c
index e0b87300243d..b5fb7c110c64 100644
--- a/arch/arm/mach-tegra/cpuidle-tegra114.c
+++ b/arch/arm/mach-tegra/cpuidle-tegra114.c
@@ -19,6 +19,7 @@
 #include <linux/cpuidle.h>
 #include <linux/cpu_pm.h>
 #include <linux/clockchips.h>
+#include <asm/firmware.h>
 
 #include <asm/cpuidle.h>
 #include <asm/suspend.h>
@@ -45,7 +46,11 @@ static int tegra114_idle_power_down(struct cpuidle_device *dev,
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
 
-	cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
+	call_firmware_op(prepare_idle);
+
+	/* Do suspend by ourselves if the firmware does not implement it */
+	if (call_firmware_op(do_idle) == -ENOSYS)
+		cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
 
-- 
1.8.5.4

