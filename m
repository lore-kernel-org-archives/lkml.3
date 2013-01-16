Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab3APQLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:11:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36944 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab3APQL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:11:26 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 214/222] PM: Move disabling/enabling runtime PM to late suspend/early resume
Date: Wed, 16 Jan 2013 13:56:54 -0200
Message-Id: <1358351822-7675-215-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 9f6d8f6ab26b42620a914d67f29822f9bba90233 upstream.

Currently, the PM core disables runtime PM for all devices right
after executing subsystem/driver .suspend() callbacks for them
and re-enables it right before executing subsystem/driver .resume()
callbacks for them.  This may lead to problems when there are
two devices such that the .suspend() callback executed for one of
them depends on runtime PM working for the other.  In that case,
if runtime PM has already been disabled for the second device,
the first one's .suspend() won't work correctly (and analogously
for resume).

To make those issues go away, make the PM core disable runtime PM
for devices right before executing subsystem/driver .suspend_late()
callbacks for them and enable runtime PM for them right after
executing subsystem/driver .resume_early() callbacks for them.  This
way the potential conflitcs between .suspend_late()/.resume_early()
and their runtime PM counterparts are still prevented from happening,
but the subtle ordering issues related to disabling/enabling runtime
PM for devices during system suspend/resume are much easier to avoid.

Reported-and-tested-by: Jan-Matthias Braun <jan_braun@gmx.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Kevin Hilman <khilman@deeprootsystems.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 Documentation/power/runtime_pm.txt |    9 +++++----
 drivers/base/power/main.c          |    8 ++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
index 4abe83e..03591a7 100644
--- a/Documentation/power/runtime_pm.txt
+++ b/Documentation/power/runtime_pm.txt
@@ -642,12 +642,13 @@ out the following operations:
   * During system suspend it calls pm_runtime_get_noresume() and
     pm_runtime_barrier() for every device right before executing the
     subsystem-level .suspend() callback for it.  In addition to that it calls
-    pm_runtime_disable() for every device right after executing the
-    subsystem-level .suspend() callback for it.
+    __pm_runtime_disable() with 'false' as the second argument for every device
+    right before executing the subsystem-level .suspend_late() callback for it.
 
   * During system resume it calls pm_runtime_enable() and pm_runtime_put_sync()
-    for every device right before and right after executing the subsystem-level
-    .resume() callback for it, respectively.
+    for every device right after executing the subsystem-level .resume_early()
+    callback and right after executing the subsystem-level .resume() callback
+    for it, respectively.
 
 7. Generic subsystem callbacks
 
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 9d54dce..f6afeab 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -507,6 +507,8 @@ static int device_resume_early(struct device *dev, pm_message_t state)
 	error = dpm_run_callback(callback, dev, state, info);
 
 	TRACE_RESUME(error);
+
+	pm_runtime_enable(dev);
 	return error;
 }
 
@@ -581,7 +583,6 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
 	if (!dev->power.is_suspended)
 		goto Unlock;
 
-	pm_runtime_enable(dev);
 	put = true;
 
 	if (dev->pm_domain) {
@@ -915,6 +916,8 @@ static int device_suspend_late(struct device *dev, pm_message_t state)
 	pm_callback_t callback = NULL;
 	char *info = NULL;
 
+	__pm_runtime_disable(dev, false);
+
 	if (dev->pm_domain) {
 		info = "late power domain ";
 		callback = pm_late_early_op(&dev->pm_domain->ops, state);
@@ -1108,12 +1111,9 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 
  Complete:
 	complete_all(&dev->power.completion);
-
 	if (error) {
 		pm_runtime_put_sync(dev);
 		async_error = error;
-	} else if (dev->power.is_suspended) {
-		__pm_runtime_disable(dev, false);
 	}
 
 	return error;
-- 
1.7.9.5

