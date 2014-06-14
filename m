Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaFNJ6p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 05:58:45 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19879 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaFNJ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 05:58:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 14 Jun 2014 02:49:37 -0700
From: Allen Yu <alleny@nvidia.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        "Len Brown" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-pm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Allen Yu <alleny@nvidia.com>
Subject: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled and device suspended.
Date: Sat, 14 Jun 2014 18:03:29 +0800
Message-ID: <1402740209-16432-1-git-send-email-alleny@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev->power.is_suspended is set after core suspends device during system suspend.
This flag mostly means device is not operational (all I/O been quiesced, no more
data read or write acceptible, etc.), hence it's dangerous to access hardware if
device is suspended even though runtime PM status is RPM_ACTIVE.

In turn, we should allow device to be accessed in case device is *not* suspended
and runtime PM status is RPM_ACTIVE, even if runtime PM disabled. This corner case
can happen to a device in a generic PM domain if the domain is not powered off while
preparing for a system-wide power transition. In this case, runtime PM status will
be set to RPM_ACTIVE and then runtime PM is disabled. After that, device driver may
call pm_runtime_get_sync() and rpm_resume() should return 1, because the device is
still active as long as not been suspended.

Signed-off-by: Allen Yu <alleny@nvidia.com>
---
 drivers/base/power/runtime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 67c7938..39885f1 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -608,7 +608,7 @@ static int rpm_resume(struct device *dev, int rpmflags)
  repeat:
 	if (dev->power.runtime_error)
 		retval = -EINVAL;
-	else if (dev->power.disable_depth == 1 && dev->power.is_suspended
+	else if (dev->power.disable_depth == 1 && !dev->power.is_suspended
 	    && dev->power.runtime_status == RPM_ACTIVE)
 		retval = 1;
 	else if (dev->power.disable_depth > 0)
-- 
1.8.1.5

