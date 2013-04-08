Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935412Ab3DHJvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:51:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42595 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935377Ab3DHJvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 001/102] clockevents: Don't allow dummy broadcast timers
Date: Mon,  8 Apr 2013 10:49:16 +0100
Message-Id: <1365414657-29191-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit a7dc19b8652c862d5b7c4d2339bd3c428bd29c4a upstream.

Currently tick_check_broadcast_device doesn't reject clock_event_devices
with CLOCK_EVT_FEAT_DUMMY, and may select them in preference to real
hardware if they have a higher rating value. In this situation, the
dummy timer is responsible for broadcasting to itself, and the core
clockevents code may attempt to call non-existent callbacks for
programming the dummy, eventually leading to a panic.

This patch makes tick_check_broadcast_device always reject dummy timers,
preventing this problem.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Jon Medhurst (Tixy) <tixy@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/tick-broadcast.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f113755..a13987a 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -66,7 +66,8 @@ static void tick_broadcast_start_periodic(struct clock_event_device *bc)
  */
 int tick_check_broadcast_device(struct clock_event_device *dev)
 {
-	if ((tick_broadcast_device.evtdev &&
+	if ((dev->features & CLOCK_EVT_FEAT_DUMMY) ||
+	    (tick_broadcast_device.evtdev &&
 	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
 	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
 		return 0;
-- 
1.8.1.2

