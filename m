Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3CKFGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:06:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45364 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab3CKFGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:06:31 -0400
From: Lokesh Vutla <lokeshvutla@ti.com>
To: <linux-kernel@vger.kernel.org>, <santosh.shilimkar@ti.com>,
        <gregkh@linuxfoundation.org>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Nishanth Menon <nm@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 5/8] memory: emif: use restart if power_off not present when out of spec
Date: Mon, 11 Mar 2013 10:36:02 +0530
Message-ID: <1362978365-5593-6-git-send-email-lokeshvutla@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com>
References: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

Some machine or kernel variants might have missed implementation
of power off handlers. We DONOT want to let the system be in
"out of spec" state in this condition. So, WARN and attempt
a machine restart in the hopes of clearing the out-of-spec
temperature condition.

NOTE: This is not the safest option, but safer than leaving the
system in unstable conditions.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/memory/emif.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 927fb55..02a94fc 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/pm.h>
 #include <memory/jedec_ddr.h>
 #include "emif.h"
 #include "of_memory.h"
@@ -1011,7 +1012,13 @@ static irqreturn_t emif_threaded_isr(int irq, void *dev_id)
 
 	if (emif->temperature_level == SDRAM_TEMP_VERY_HIGH_SHUTDOWN) {
 		dev_emerg(emif->dev, "SDRAM temperature exceeds operating limit.. Needs shut down!!!\n");
-		kernel_power_off();
+		/* If we have Power OFF ability, use it, else try restarting */
+		if (pm_power_off) {
+			kernel_power_off();
+		} else {
+			WARN(1, "FIXME: NO pm_power_off!!! trying restart\n");
+			kernel_restart("SDRAM Over-temp Emergency restart");
+		}
 		return IRQ_HANDLED;
 	}
 
-- 
1.7.9.5

