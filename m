Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3IRSuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:50:03 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53442 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3IRStN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:49:13 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Preeti Murthy <preeti.lkml@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 3/4] tick: broadcast: Deny per-cpu clockevents from being broadcast sources
Date: Wed, 18 Sep 2013 11:48:37 -0700
Message-Id: <1379530118-22813-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379530118-22813-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1379530118-22813-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On most ARM systems the per-cpu clockevents are truly per-cpu in
the sense that they can't be controlled on any other CPU besides
the CPU that they interrupt. If one of these clockevents were to
become a broadcast source we will run into a lot of trouble
because the broadcast source is enabled on the first CPU to go
into deep idle (if that CPU suffers from FEAT_C3_STOP) and that
could be a different CPU than what the clockevent is interrupting
(or even worse the CPU that the clockevent interrupts could be
offline).

Theoretically it's possible to support per-cpu clockevents as the
broadcast source but so far we haven't needed this and supporting
it is rather complicated. Let's just deny the possibility for now
until this becomes a reality (let's hope it never does!).

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 kernel/time/tick-broadcast.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 218bcb5..9532690 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -70,6 +70,7 @@ static bool tick_check_broadcast_device(struct clock_event_device *curdev,
 					struct clock_event_device *newdev)
 {
 	if ((newdev->features & CLOCK_EVT_FEAT_DUMMY) ||
+	    (newdev->features & CLOCK_EVT_FEAT_PERCPU) ||
 	    (newdev->features & CLOCK_EVT_FEAT_C3STOP))
 		return false;
 
-- 
1.8.4

