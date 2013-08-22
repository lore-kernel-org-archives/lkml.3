Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3HVRGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:06:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34417 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3HVRGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:06:45 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, srinivas.kandagatla@st.com,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH 2/2] clockevents: Prefer clockevents that don't suffer from FEAT_C3_STOP
Date: Thu, 22 Aug 2013 10:06:41 -0700
Message-Id: <1377191201-14696-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc3.2.g2c2b664
In-Reply-To: <1377191201-14696-1-git-send-email-sboyd@codeaurora.org>
References: <52138784.7050703@linaro.org>
 <1377191201-14696-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some ARM systems there are two sets of per-cpu timers: the TWD
timers and the global timers. The TWD timers are rated at 350 and
the global timers are rated at 300 but the TWD timers suffer from
FEAT_C3_STOP while the arm global timers don't. The tick device
selection logic doesn't consider the FEAT_C3_STOP flag so we'll
always end up with the TWD as the tick device although we don't
want that.

Extend the preference logic to take the FEAT_C3_STOP flag into
account and always prefer tick devices that don't suffer from
FEAT_C3_STOP even if their rating is lower than tick devices that
do suffer from FEAT_C3_STOP. This will remove the need to do any
broadcasting on such ARM systems.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/time/tick-common.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 64522ec..3ae437d 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -244,12 +244,22 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
 			return false;
 	}
 
+	if (!curdev)
+		return true;
+
+	/* Always prefer a tick device that doesn't suffer from FEAT_C3STOP */
+	if (!(newdev->features & CLOCK_EVT_FEAT_C3STOP) &&
+			(curdev->features & CLOCK_EVT_FEAT_C3STOP))
+		return true;
+	if ((newdev->features & CLOCK_EVT_FEAT_C3STOP) &&
+			!(curdev->features & CLOCK_EVT_FEAT_C3STOP))
+		return false;
+
 	/*
 	 * Use the higher rated one, but prefer a CPU local device with a lower
 	 * rating than a non-CPU local device
 	 */
-	return !curdev ||
-		newdev->rating > curdev->rating ||
+       return newdev->rating > curdev->rating ||
 	       !cpumask_equal(curdev->cpumask, newdev->cpumask);
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

