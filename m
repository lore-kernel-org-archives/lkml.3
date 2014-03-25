Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaCYRTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:19:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55724 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbaCYRTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:19:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 65/81] PM / hibernate: Fix restore hang in freeze_processes()
Date: Tue, 25 Mar 2014 10:16:18 -0700
Message-Id: <1395767794-5012-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Capella <sebastian.capella@linaro.org>

commit f8d5b9e9e5372f0deb7bc1ab1088a9b60b0a793d upstream.

During restore, pm_notifier chain are called with
PM_RESTORE_PREPARE.  The firmware_class driver handler
fw_pm_notify does not have a handler for this.  As a result,
it keeps a reader on the kmod.c umhelper_sem.  During
freeze_processes, the call to __usermodehelper_disable tries to
take a write lock on this semaphore and hangs waiting.

Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Acked-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/firmware_class.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index b392b35..abb2054 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1413,6 +1413,7 @@ static int fw_pm_notify(struct notifier_block *notify_block,
 	switch (mode) {
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
+	case PM_RESTORE_PREPARE:
 		device_cache_fw_images();
 		break;
 
-- 
1.8.3.2

