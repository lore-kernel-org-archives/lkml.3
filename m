Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaBGOkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:40:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55945 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbaBGOkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:40:51 -0500
Date: Fri, 7 Feb 2014 06:40:39 -0800
From: tip-bot for Soren Brinkmann <tipbot@zytor.com>
Message-ID: <tip-fe79a9ba11962a603fb6af68fcb476e64031e46c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, soren.brinkmann@xilinx.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, michal.simek@xilinx.com,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, soren.brinkmann@xilinx.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org, michal.simek@xilinx.com
In-Reply-To: <1391466877-28908-3-git-send-email-soren.brinkmann@xilinx.com>
References: <1391466877-28908-3-git-send-email-soren.brinkmann@xilinx.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents:
  Adjust timer interval when frequency changes
Git-Commit-ID: fe79a9ba11962a603fb6af68fcb476e64031e46c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 07 Feb 2014 06:40:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe79a9ba11962a603fb6af68fcb476e64031e46c
Gitweb:     http://git.kernel.org/tip/fe79a9ba11962a603fb6af68fcb476e64031e46c
Author:     Soren Brinkmann <soren.brinkmann@xilinx.com>
AuthorDate: Mon, 3 Feb 2014 14:34:32 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 7 Feb 2014 15:34:29 +0100

clockevents: Adjust timer interval when frequency changes

clockevent devices in periodic mode are not updated when the frequency
of the device changes. Issue a dev->set_mode() callback which forces
the device to reevaluate the timer settings.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Michal Simek <michal.simek@xilinx.com>
Link: http://lkml.kernel.org/r/1391466877-28908-3-git-send-email-soren.brinkmann@xilinx.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clockevents.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 641d910..f85e5fd 100644
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
