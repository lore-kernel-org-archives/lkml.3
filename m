Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab3GZV3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:29:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759993Ab3GZUsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liu ShuoX <shuox.liu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 72/79] PM / Sleep: avoid autosleep in shutdown progress
Date: Fri, 26 Jul 2013 13:48:02 -0700
Message-Id: <20130726204730.371992256@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu ShuoX <shuox.liu@intel.com>

commit e5248a111bf4048a9f3fab1a9c94c4630a10592a upstream.

Prevent automatic system suspend from happening during system
shutdown by making try_to_suspend() check system_state and return
immediately if it is not SYSTEM_RUNNING.

This prevents the following breakage from happening (scenario from
Zhang Yanmin):

 Kernel starts shutdown and calls all device driver's shutdown
 callback.  When a driver's shutdown is called, the last wakelock is
 released and suspend-to-ram starts.  However, as some driver's shut
 down callbacks already shut down devices and disabled runtime pm,
 the suspend-to-ram calls driver's suspend callback without noticing
 that device is already off and causes crash.

[rjw: Changelog]
Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/autosleep.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/power/autosleep.c
+++ b/kernel/power/autosleep.c
@@ -32,7 +32,8 @@ static void try_to_suspend(struct work_s
 
 	mutex_lock(&autosleep_lock);
 
-	if (!pm_save_wakeup_count(initial_count)) {
+	if (!pm_save_wakeup_count(initial_count) ||
+		system_state != SYSTEM_RUNNING) {
 		mutex_unlock(&autosleep_lock);
 		goto out;
 	}


