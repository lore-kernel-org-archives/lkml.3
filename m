Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967343Ab3DRJeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:34:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40069 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697Ab3DRJRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Fei <fei.li@intel.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 18/72] hwspinlock: fix __hwspin_lock_request error path
Date: Thu, 18 Apr 2013 10:16:03 +0100
Message-Id: <1366276617-3553-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Fei <fei.li@intel.com>

commit c10b90d85a5126d25c89cbaa50dc9fdd1c4d001a upstream.

Even in failed case of pm_runtime_get_sync, the usage_count
is incremented. In order to keep the usage_count with correct
value and runtime power management to behave correctly, call
pm_runtime_put_noidle in such case.

In __hwspin_lock_request, module_put is also called before
return in pm_runtime_get_sync failed case.

Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
[edit commit log]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwspinlock/hwspinlock_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index 1201a15..08e7e72 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -416,6 +416,8 @@ static int __hwspin_lock_request(struct hwspinlock *hwlock)
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
 		dev_err(dev, "%s: can't power on device\n", __func__);
+		pm_runtime_put_noidle(dev);
+		module_put(dev->driver->owner);
 		return ret;
 	}
 
-- 
1.8.1.2

