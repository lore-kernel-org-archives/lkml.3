Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab3IKI0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:26:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26716 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3IKI0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:26:45 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=iB92Dndv-1kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ijuO9SoHCKkA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042904.220856540@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Liu ShuoX <shuox.liu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [071/251] PM / Sleep: avoid autosleep in shutdown progress
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0071-PM-Sleep-avoid-autosleep-in-shutdown-progress.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Liu ShuoX <shuox.liu@intel.com>

[ Upstream commit e5248a111bf4048a9f3fab1a9c94c4630a10592a ]

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
Cc: 3.5+ <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/power/autosleep.c |    3 ++-
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
1.7.10.4


