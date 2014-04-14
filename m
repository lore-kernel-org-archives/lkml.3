Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbaDNQy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:54:57 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34086 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbaDNQZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:25:32 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 13/38] tick-common: don't check tick_oneshot_mode_active() from tick_check_preferred()
Date: Mon, 14 Apr 2014 21:53:35 +0530
Message-Id: <f215073aaaafedbae6c5b31d218f5d6e48bb681f.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If 'curdev' passed to tick_check_preferred() is the current clock_event_device
then these two checks look exactly same, because td->mode = TICKDEV_MODE_ONESHOT
is only called when the event device had ONESHOT feature.

	if (curdev && (curdev->features & CLOCK_EVT_FEAT_ONESHOT))
		return false;

	if (tick_oneshot_mode_active())
		return false;

Now left the case where 'curdev' is not the current clock_event_device. This can
happen from the sequence started from clockevents_replace(). Here we are trying
to find the best possible device that we should choose. And so even in this case
we don't need the above check as we aren't really worried about the current
device.

So, the second check can be removed.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 6868d6a..3dc31f5 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -240,8 +240,6 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
 	if (!(newdev->features & CLOCK_EVT_FEAT_ONESHOT)) {
 		if (curdev && (curdev->features & CLOCK_EVT_FEAT_ONESHOT))
 			return false;
-		if (tick_oneshot_mode_active())
-			return false;
 	}
 
 	/*
-- 
1.7.12.rc2.18.g61b472e

