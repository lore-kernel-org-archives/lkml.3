Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab3CZWtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:49:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab3CZWoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: [ 80/98] clockevents: Dont allow dummy broadcast timers
Date: Tue, 26 Mar 2013 15:43:09 -0700
Message-Id: <20130326224250.791482868@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-broadcast.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -66,7 +66,8 @@ static void tick_broadcast_start_periodi
  */
 int tick_check_broadcast_device(struct clock_event_device *dev)
 {
-	if ((tick_broadcast_device.evtdev &&
+	if ((dev->features & CLOCK_EVT_FEAT_DUMMY) ||
+	    (tick_broadcast_device.evtdev &&
 	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
 	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
 		return 0;


