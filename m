Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3ILQvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:51:18 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:43664 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab3ILQvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:51:11 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] tick: broadcast: Deny per-cpu clockevents from being broadcast sources
Date: Thu, 12 Sep 2013 09:50:39 -0700
Message-Id: <1379004640-15117-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379004640-15117-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1379004640-15117-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

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

Reported-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/time/tick-broadcast.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 218bcb5..d3539e5 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -77,6 +77,9 @@ static bool tick_check_broadcast_device(struct clock_event_device *curdev,
 	    !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
 		return false;
 
+	if (cpumask_equal(newdev->cpumask, cpumask_of(smp_processor_id())))
+		return false;
+
 	return !curdev || newdev->rating > curdev->rating;
 }
 
-- 
1.8.4

