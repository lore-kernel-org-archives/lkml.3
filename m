Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab3LJAfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:35:44 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:53478 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3LJAf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:35:26 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH 2/2] time: clockevents: Adjust timer interval when frequency changes
Date: Mon,  9 Dec 2013 16:34:46 -0800
Message-Id: <1386635686-15686-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386635686-15686-1-git-send-email-soren.brinkmann@xilinx.com>
References: <alpine.DEB.2.02.1312071151340.30673@ionos.tec.linutronix.de>
 <1386635686-15686-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To adjust the timer's interval in periodic mode, the clockevent device
is put into periodic mode during clockevents_update_freq() in case the
timer is in periodic mode.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 kernel/time/clockevents.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 641d91003a45..f85e5fda9c66 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -443,10 +443,13 @@ int __clockevents_update_freq(struct clock_event_device *dev, u32 freq)
 {
 	clockevents_config(dev, freq);
 
-	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
-		return 0;
+	if (dev->mode == CLOCK_EVT_MODE_ONESHOT)
+		return clockevents_program_event(dev, dev->next_event, false);
+
+	if (dev->mode == CLOCK_EVT_MODE_PERIODIC)
+		dev->set_mode(CLOCK_EVT_MODE_PERIODIC, dev);
 
-	return clockevents_program_event(dev, dev->next_event, false);
+	return 0;
 }
 
 /**
-- 
1.8.5.1

