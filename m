Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751072Ab3FXUbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:31:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32934 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3FXUbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:31:03 -0400
Date: Mon, 24 Jun 2013 13:30:39 -0700
From: tip-bot for Stephen Boyd <tipbot@zytor.com>
Message-ID: <tip-70e5975d3a04be5479a28eec4a2fb10f98ad2785@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mark.rutland@arm.com, sboyd@codeaurora.org, john.stultz@linaro.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, sboyd@codeaurora.org, john.stultz@linaro.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <20130613183950.GA32061@codeaurora.org>
References: <20130613183950.GA32061@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents:
  Prefer CPU local devices over global devices
Git-Commit-ID: 70e5975d3a04be5479a28eec4a2fb10f98ad2785
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 24 Jun 2013 13:30:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70e5975d3a04be5479a28eec4a2fb10f98ad2785
Gitweb:     http://git.kernel.org/tip/70e5975d3a04be5479a28eec4a2fb10f98ad2785
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Thu, 13 Jun 2013 11:39:50 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 24 Jun 2013 22:27:36 +0200

clockevents: Prefer CPU local devices over global devices

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
---
 kernel/time/tick-common.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 5edfb48..edd45f6 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -243,8 +243,13 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
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
