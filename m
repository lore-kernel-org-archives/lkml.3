Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab3G3J56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:57:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53002 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab3G3Jcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liu ShuoX <shuox.liu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 022/106] PM / Sleep: avoid 'autosleep' in shutdown progress
Date: Tue, 30 Jul 2013 10:30:41 +0100
Message-Id: <1375176725-5825-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/power/autosleep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/power/autosleep.c b/kernel/power/autosleep.c
index ca304046..ab79ecb 100644
--- a/kernel/power/autosleep.c
+++ b/kernel/power/autosleep.c
@@ -32,7 +32,8 @@ static void try_to_suspend(struct work_struct *work)
 
 	mutex_lock(&autosleep_lock);
 
-	if (!pm_save_wakeup_count(initial_count)) {
+	if (!pm_save_wakeup_count(initial_count) ||
+		system_state != SYSTEM_RUNNING) {
 		mutex_unlock(&autosleep_lock);
 		goto out;
 	}
-- 
1.8.3.2

