Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaDOFZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:25:07 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:47697 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaDOFZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:25:04 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V1 Resend 2/5] tick-common: don't check tick_oneshot_mode_active() from tick_check_preferred()
Date: Tue, 15 Apr 2014 10:54:38 +0530
Message-Id: <1af3a250749c7c103ef38b52d653559ac4ec899c.1397537987.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397537986.git.viresh.kumar@linaro.org>
References: <cover.1397537986.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397537986.git.viresh.kumar@linaro.org>
References: <cover.1397537986.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If 'curdev' passed to tick_check_preferred() is the current clock_event_device
then these two checks look exactly same, because td->mode is set to
TICKDEV_MODE_ONESHOT only when the event device has ONESHOT feature.

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
index 0a0608e..69cab28 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -256,8 +256,6 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
 	if (!(newdev->features & CLOCK_EVT_FEAT_ONESHOT)) {
 		if (curdev && (curdev->features & CLOCK_EVT_FEAT_ONESHOT))
 			return false;
-		if (tick_oneshot_mode_active())
-			return false;
 	}
 
 	/*
-- 
1.7.12.rc2.18.g61b472e

