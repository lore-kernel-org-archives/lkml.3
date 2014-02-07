Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaBGEgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:36:03 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14046 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaBGEf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:35:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 06 Feb 2014 20:34:23 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>
CC: Olof Johansson <olof@lixom.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 6/6] ARM: tegra: cpuidle: use firmware for power down
Date: Fri, 7 Feb 2014 13:35:06 +0900
Message-ID: <1391747706-1847-7-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
References: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
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
 arch/arm/mach-tegra/cpuidle-tegra114.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-tegra/cpuidle-tegra114.c b/arch/arm/mach-tegra/cpuidle-tegra114.c
index e0b87300243d..558067ddc186 100644
--- a/arch/arm/mach-tegra/cpuidle-tegra114.c
+++ b/arch/arm/mach-tegra/cpuidle-tegra114.c
@@ -19,6 +19,7 @@
 #include <linux/cpuidle.h>
 #include <linux/cpu_pm.h>
 #include <linux/clockchips.h>
+#include <asm/firmware.h>
 
 #include <asm/cpuidle.h>
 #include <asm/suspend.h>
@@ -45,7 +46,15 @@ static int tegra114_idle_power_down(struct cpuidle_device *dev,
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
 
-	cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
+	call_firmware_op(prepare_idle);
+
+	switch (call_firmware_op(do_idle)) {
+	case -ENOSYS:
+		cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
+		break;
+	default:
+		break;
+	}
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
 
-- 
1.8.5.3

