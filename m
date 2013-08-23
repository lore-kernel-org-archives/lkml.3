Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab3HWTqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:46:16 -0400
Received: from mail-qe0-f74.google.com ([209.85.128.74]:54553 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355Ab3HWTpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:45:16 -0400
From: Colin Cross <ccross@android.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Neil Zhang <zhangwm@marvell.com>,
        Joseph Lo <josephl@nvidia.com>, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 1/3] cpuidle: coupled: disable interrupts after entering safe state
Date: Fri, 23 Aug 2013 12:45:10 -0700
Message-Id: <1377287112-12018-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling cpuidle_enter_state is expected to return with interrupts
enabled, but interrupts must be disabled before starting the
ready loop synchronization stage.  Call local_irq_disable after
each call to cpuidle_enter_state for the safe state.

CC: stable@vger.kernel.org
Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/cpuidle/coupled.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index 2a297f8..db92bcb 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -460,6 +460,7 @@ int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
 		}
 		entered_state = cpuidle_enter_state(dev, drv,
 			dev->safe_state_index);
+		local_irq_disable();
 	}
 
 	/* Read barrier ensures online_count is read after prevent is cleared */
@@ -485,6 +486,7 @@ retry:
 
 		entered_state = cpuidle_enter_state(dev, drv,
 			dev->safe_state_index);
+		local_irq_disable();
 	}
 
 	if (cpuidle_coupled_clear_pokes(dev->cpu)) {
-- 
1.8.3

