Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab3LFWFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:05:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473Ab3LFVx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kim Phillips <kim.phillips@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3.10 48/58] clockevents: Prefer CPU local devices over global devices
Date: Fri,  6 Dec 2013 13:52:19 -0800
Message-Id: <20131206214849.344460410@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit 70e5975d3a04be5479a28eec4a2fb10f98ad2785 upstream.

On an SMP system with only one global clockevent and a dummy
clockevent per CPU we run into problems. We want the dummy
clockevents to be registered as the per CPU tick devices, but
we can only achieve that if we register the dummy clockevents
before the global clockevent or if we artificially inflate the
rating of the dummy clockevents to be higher than the rating
of the global clockevent. Failure to do so leads to boot
hangs when the dummy timers are registered on all other CPUs
besides the CPU that accepted the global clockevent as its tick
device and there is no broadcast timer to poke the dummy
devices.

If we're registering multiple clockevents and one clockevent is
global and the other is local to a particular CPU we should
choose to use the local clockevent regardless of the rating of
the device. This way, if the clockevent is a dummy it will take
the tick device duty as long as there isn't a higher rated tick
device and any global clockevent will be bumped out into
broadcast mode, fixing the problem described above.

Reported-and-tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Tested-by: soren.brinkmann@xilinx.com
Cc: John Stultz <john.stultz@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/20130613183950.GA32061@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kim Phillips <kim.phillips@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-common.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -234,8 +234,13 @@ static bool tick_check_preferred(struct
 			return false;
 	}
 
-	/* Use the higher rated one */
-	return !curdev || newdev->rating > curdev->rating;
+	/*
+	 * Use the higher rated one, but prefer a CPU local device with a lower
+	 * rating than a non-CPU local device
+	 */
+	return !curdev ||
+		newdev->rating > curdev->rating ||
+	       !cpumask_equal(curdev->cpumask, newdev->cpumask);
 }
 
 /*


