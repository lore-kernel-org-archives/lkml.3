Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbaDNQ2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:28:15 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53598 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaDNQ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:28:11 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 36/38] tick-broadcast: get rid of extra comparison in tick_do_broadcast_on_off()
Date: Mon, 14 Apr 2014 21:53:58 +0530
Message-Id: <c20bfe318b69821078bcd8d0d55126dc6b6f0d26.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are doing an extra comparison in tick_do_broadcast_on_off():

               if (*reason == CLOCK_EVT_NOTIFY_BROADCAST_FORCE)
                       tick_broadcast_force = 1;

Whereas it can be handled easily in the switch block only.

It doesn't look like there is any strict ordering of instructions required here
and so move setting 'tick_broadcast_force' at the beginning.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-broadcast.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 3b07569..ec86227 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -348,15 +348,14 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 	bc_stopped = cpumask_empty(tick_broadcast_mask);
 
 	switch (*reason) {
-	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
+		tick_broadcast_force = 1;
+	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 		cpumask_set_cpu(cpu, tick_broadcast_on);
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_mask)) {
 			if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
 				clockevents_shutdown(dev);
 		}
-		if (*reason == CLOCK_EVT_NOTIFY_BROADCAST_FORCE)
-			tick_broadcast_force = 1;
 		break;
 	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
 		if (tick_broadcast_force)
-- 
1.7.12.rc2.18.g61b472e

