Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab3G3PSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:18:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55312 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab3G3PSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liu ShuoX <shuox.liu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 18/75] PM / Sleep: avoid 'autosleep' in shutdown progress
Date: Tue, 30 Jul 2013 08:16:47 -0700
Message-Id: <1375197464-27962-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.1.2

